package org.psybnc.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.IBinder;
import android.os.PowerManager;
import android.system.Os;
import android.system.OsConstants;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.RandomAccessFile;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class PsybncService extends Service {
    public static final String ACTION_START = "org.psybnc.app.action.START";
    public static final String ACTION_STOP = "org.psybnc.app.action.STOP";
    public static final String ACTION_RESET = "org.psybnc.app.action.RESET";
    public static final String ACTION_STATUS_UPDATE = "org.psybnc.app.action.STATUS";
    public static final String PREFS_NAME = "psybnc_prefs";
    public static final String KEY_PORT = "port";
    public static final String KEY_BIND_HOST = "bind_host";
    public static final String KEY_DOWNLOAD_NOTIFICATIONS_ENABLED = "download_notifications_enabled";
    public static final String KEY_DOWNLOAD_PATH = "download_path";
    public static final String KEY_DOWNLOAD_URI = "download_uri";
    public static final String KEY_STATUS = "status";
    public static final String KEY_LAST_LOG = "last_log";
    public static final String STATUS_RUNNING = "running";
    public static final String STATUS_STOPPED = "stopped";
    public static final String STATUS_ERROR = "error";

    private static final String CHANNEL_ID = "psybnc_channel";
    private static final String DOWNLOAD_CHANNEL_ID = "psybnc_downloads";
    private static final int NOTIFICATION_ID = 10010;

    private static Process process;
    private static Thread processThread;
    private static Thread downloadMonitorThread;
    private static volatile boolean stoppingProcess;

    private final Object processLock = new Object();
    private PowerManager.WakeLock wakeLock;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String action = intent != null ? intent.getAction() : ACTION_START;
        if (ACTION_STOP.equals(action)) {
            stopServer();
            return START_NOT_STICKY;
        } else if (ACTION_RESET.equals(action)) {
            resetConfig();
            return START_NOT_STICKY;
        }
        createChannel();
        startForeground(NOTIFICATION_ID, buildNotification(getString(R.string.service_notification_text)));
        startServer();
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        releaseWakeLock();
        super.onDestroy();
    }

    private void startServer() {
        synchronized (processLock) {
            if (process != null && process.isAlive()) {
                updateState(STATUS_RUNNING, "psyBNC già attivo");
                return;
            }
            stoppingProcess = false;
            acquireWakeLock();
            Thread starter = new Thread(() -> {
                try {
                    File runtimeRoot = prepareRuntime();
                    File binary = extractBinary(runtimeRoot);
                    File configFile = new File(runtimeRoot, "psybnc.conf");
                    int port = getPreferences().getInt(KEY_PORT, 31337);
                    String bindHost = getPreferences().getString(KEY_BIND_HOST, "0.0.0.0");
                    String downloadPath = resolveDownloadPath();
                    
                    if (!configFile.exists()) {
                        writeConfig(configFile, port, bindHost);
                    }
                    
                    ProcessBuilder builder = new ProcessBuilder(binary.getAbsolutePath(), configFile.getAbsolutePath());
                    builder.directory(runtimeRoot);
                    builder.redirectErrorStream(true);
                    builder.environment().put("PSYBNC_NOFORK", "1");
                    builder.environment().put("PSYBNC_BASE_DIR", runtimeRoot.getAbsolutePath());
                    builder.environment().put("PSYBNC_CONFIG_FILE", configFile.getAbsolutePath());
                    builder.environment().put("PSYBNC_DOWNLOAD_DIR", downloadPath);
                    builder.environment().put("PSYBNC_LOG_FILE", new File(runtimeRoot, "log/psybnc.log").getAbsolutePath());
                    builder.environment().put("PSYBNC_PID_FILE", "");
                    builder.environment().put("HOME", runtimeRoot.getAbsolutePath());
                    process = builder.start();
                    startDownloadMonitor(new File(runtimeRoot, "log/psybnc.log"), downloadPath);
                    updateState(STATUS_RUNNING, "psyBNC avviato su " + bindHost + ":" + port);
                    startProcessReader(process);
                    startProcessWatcher(process);
                } catch (Exception exception) {
                    updateState(STATUS_ERROR, exception.getMessage());
                    stopForeground(STOP_FOREGROUND_REMOVE);
                    stopSelf();
                }
            });
            starter.setDaemon(true);
            starter.start();
        }
    }

    private void stopServer() {
        synchronized (processLock) {
            stoppingProcess = true;
            if (processThread != null) {
                processThread.interrupt();
                processThread = null;
            }
            if (downloadMonitorThread != null) {
                downloadMonitorThread.interrupt();
                downloadMonitorThread = null;
            }
            if (process != null) {
                Process currentProcess = process;
                process = null;
                currentProcess.destroy();
                try {
                    if (!currentProcess.waitFor(1500, TimeUnit.MILLISECONDS)) {
                        currentProcess.destroyForcibly();
                        currentProcess.waitFor(1500, TimeUnit.MILLISECONDS);
                    }
                } catch (InterruptedException ignored) {
                    Thread.currentThread().interrupt();
                }
            }
            killLingeringPsybncProcesses();
            updateState(STATUS_STOPPED, "psyBNC fermato");
            releaseWakeLock();
            stopForeground(STOP_FOREGROUND_REMOVE);
            stopSelf();
        }
    }

    private void resetConfig() {
        stopServer();
        getPreferences().edit().clear().apply();
        File runtimeRoot = new File(getFilesDir(), "runtime");
        deleteRecursively(runtimeRoot);
        updateState(STATUS_STOPPED, "Configurazione resettata");
    }

    private void deleteRecursively(File fileOrDirectory) {
        if (fileOrDirectory.isDirectory()) {
            File[] children = fileOrDirectory.listFiles();
            if (children != null) {
                for (File child : children) {
                    deleteRecursively(child);
                }
            }
        }
        fileOrDirectory.delete();
    }

    private void startProcessReader(Process currentProcess) {
        Thread readerThread = new Thread(() -> {
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(currentProcess.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    updateState(STATUS_RUNNING, line);
                }
            } catch (IOException exception) {
                updateState(STATUS_ERROR, exception.getMessage());
            }
        });
        readerThread.setDaemon(true);
        readerThread.start();
    }

    private void startProcessWatcher(Process currentProcess) {
        processThread = new Thread(() -> {
            try {
                int exitCode = currentProcess.waitFor();
                synchronized (processLock) {
                    if (process == currentProcess) {
                        process = null;
                    }
                }
                if (stoppingProcess) {
                    updateState(STATUS_STOPPED, "psyBNC fermato");
                } else if (exitCode == 0) {
                    updateState(STATUS_STOPPED, "psyBNC terminato");
                } else {
                    updateState(STATUS_ERROR, "psyBNC terminato con codice " + exitCode);
                }
            } catch (InterruptedException ignored) {
                Thread.currentThread().interrupt();
            } finally {
                if (downloadMonitorThread != null) {
                    downloadMonitorThread.interrupt();
                    downloadMonitorThread = null;
                }
                releaseWakeLock();
                stopForeground(STOP_FOREGROUND_REMOVE);
                stopSelf();
            }
        });
        processThread.setDaemon(true);
        processThread.start();
    }

    private File prepareRuntime() throws IOException {
        File runtimeRoot = new File(getFilesDir(), "runtime");
        File logDir = new File(runtimeRoot, "log");
        File langDir = new File(runtimeRoot, "lang");
        File scriptsDir = new File(runtimeRoot, "scripts");
        File binDir = new File(runtimeRoot, "bin");
        logDir.mkdirs();
        langDir.mkdirs();
        scriptsDir.mkdirs();
        binDir.mkdirs();
        copyAsset("lang/english.lng", new File(langDir, "english.lng"));
        copyAsset("lang/italiano.lng", new File(langDir, "italiano.lng"));
        copyAsset("scripts/DEFAULT.SCRIPT", new File(scriptsDir, "DEFAULT.SCRIPT"));
        return runtimeRoot;
    }

    private File extractBinary(File runtimeRoot) throws IOException {
        File packagedBinary = new File(getApplicationInfo().nativeLibraryDir, "libpsybnc.so");
        if (packagedBinary.exists()) {
            return packagedBinary;
        }
        AssetManager assetManager = getAssets();
        String[] abis = Build.SUPPORTED_ABIS;
        for (String abi : abis) {
            String assetPath = "bin/" + abi + "/psybnc";
            try (InputStream ignored = assetManager.open(assetPath)) {
                File target = new File(new File(runtimeRoot, "bin"), "psybnc");
                copyAsset(assetPath, target);
                target.setExecutable(true, true);
                return target;
            } catch (IOException ignored) {
            }
        }
        throw new IOException("Binario psyBNC non trovato nell'APK");
    }

    private void writeConfig(File configFile, int port, String bindHost) throws IOException {
        String safeBindHost = bindHost == null || bindHost.trim().isEmpty() ? "*" : bindHost.trim();
        String config = ""
                + "PSYBNC.SYSTEM.PORT1=" + port + "\n"
                + "PSYBNC.SYSTEM.HOST1=" + safeBindHost + "\n"
                + "PSYBNC.SYSTEM.ME=android-psybnc\n"
                + "PSYBNC.SYSTEM.LOGFILE=log/psybnc.log\n"
                + "PSYBNC.SYSTEM.LANGUAGE=english\n"
                + "PSYBNC.HOSTALLOWS.ENTRY0=127.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY1=10.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY2=192.168.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY3=172.16.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY4=172.17.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY5=172.18.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY6=172.19.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY7=172.20.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY8=172.21.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY9=172.22.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY10=172.23.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY11=172.24.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY12=172.25.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY13=172.26.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY14=172.27.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY15=172.28.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY16=172.29.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY17=172.30.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY18=172.31.*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY19=fc*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY20=fd*;*\n"
                + "PSYBNC.HOSTALLOWS.ENTRY21=fe80*;*\n";
        try (FileOutputStream outputStream = new FileOutputStream(configFile, false)) {
            outputStream.write(config.getBytes(StandardCharsets.UTF_8));
        }
    }

    private void copyAsset(String assetPath, File destination) throws IOException {
        destination.getParentFile().mkdirs();
        try (InputStream inputStream = getAssets().open(assetPath);
             FileOutputStream outputStream = new FileOutputStream(destination, false)) {
            byte[] buffer = new byte[8192];
            int read;
            while ((read = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, read);
            }
        }
    }

    private void startDownloadMonitor(File logFile, String downloadRoot) {
        if (downloadMonitorThread != null) {
            downloadMonitorThread.interrupt();
            downloadMonitorThread = null;
        }
        downloadMonitorThread = new Thread(() -> monitorDownloadLog(logFile, downloadRoot));
        downloadMonitorThread.setDaemon(true);
        downloadMonitorThread.start();
    }

    private void monitorDownloadLog(File logFile, String downloadRoot) {
        long pointer = 0;
        while (!Thread.currentThread().isInterrupted() && !logFile.exists()) {
            try {
                Thread.sleep(500);
            } catch (InterruptedException exception) {
                Thread.currentThread().interrupt();
                return;
            }
        }
        if (logFile.exists()) {
            pointer = logFile.length();
        }
        while (!Thread.currentThread().isInterrupted()) {
            try (RandomAccessFile reader = new RandomAccessFile(logFile, "r")) {
                if (pointer > reader.length()) {
                    pointer = 0;
                }
                reader.seek(pointer);
                String line;
                while ((line = reader.readLine()) != null) {
                    String decodedLine = new String(line.getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
                    pointer = reader.getFilePointer();
                    maybeNotifyDownloadCompleted(decodedLine, downloadRoot);
                }
            } catch (IOException ignored) {
            }
            try {
                Thread.sleep(1200);
            } catch (InterruptedException exception) {
                Thread.currentThread().interrupt();
                return;
            }
        }
    }

    private void maybeNotifyDownloadCompleted(String line, String downloadRoot) {
        if (!getPreferences().getBoolean(KEY_DOWNLOAD_NOTIFICATIONS_ENABLED, false)) {
            return;
        }
        if (line == null || !line.contains("File ") || !line.contains(" received.")) {
            return;
        }
        int fileStart = line.indexOf("File ");
        int fileEnd = line.indexOf(" from ", fileStart);
        if (fileStart < 0 || fileEnd <= fileStart + 5) {
            return;
        }
        String fileName = line.substring(fileStart + 5, fileEnd).trim();
        if (fileName.isEmpty()) {
            return;
        }
        showDownloadCompletedNotification(fileName, downloadRoot);
    }

    private void killLingeringPsybncProcesses() {
        for (int pid : findPsybncProcessIds()) {
            try {
                Os.kill(pid, OsConstants.SIGKILL);
            } catch (Exception ignored) {
            }
        }
    }

    private List<Integer> findPsybncProcessIds() {
        List<Integer> pids = new ArrayList<>();
        Process pidofProcess = null;
        try {
            pidofProcess = new ProcessBuilder("/system/bin/sh", "-c", "pidof libpsybnc.so").start();
            if (!pidofProcess.waitFor(1, TimeUnit.SECONDS)) {
                pidofProcess.destroyForcibly();
                return pids;
            }
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(pidofProcess.getInputStream(), StandardCharsets.UTF_8))) {
                String line = reader.readLine();
                if (line == null) {
                    return pids;
                }
                for (String token : line.trim().split("\\s+")) {
                    if (token.trim().isEmpty()) {
                        continue;
                    }
                    try {
                        pids.add(Integer.parseInt(token.trim()));
                    } catch (NumberFormatException ignored) {
                    }
                }
            }
        } catch (Exception ignored) {
        } finally {
            if (pidofProcess != null) {
                pidofProcess.destroy();
            }
        }
        return pids;
    }

    private String resolveDownloadPath() {
        SharedPreferences preferences = getPreferences();
        String saved = preferences.getString(KEY_DOWNLOAD_PATH, null);
        if (saved != null && !saved.trim().isEmpty()) {
            File file = new File(saved);
            file.mkdirs();
            return file.getAbsolutePath();
        }
        File fallback = getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS);
        if (fallback == null) {
            fallback = new File(getFilesDir(), "downloads");
        }
        fallback.mkdirs();
        preferences.edit().putString(KEY_DOWNLOAD_PATH, fallback.getAbsolutePath()).apply();
        return fallback.getAbsolutePath();
    }

    public static String treeUriToPath(Context context, Uri treeUri) {
        if (treeUri == null) {
            return null;
        }
        String documentId = android.provider.DocumentsContract.getTreeDocumentId(treeUri);
        if (documentId == null || documentId.trim().isEmpty()) {
            return null;
        }
        String[] parts = documentId.split(":", 2);
        String volume = parts[0];
        String relativePath = parts.length > 1 ? parts[1] : "";
        String basePath;
        if ("primary".equalsIgnoreCase(volume)) {
            basePath = Environment.getExternalStorageDirectory().getAbsolutePath();
        } else if ("home".equalsIgnoreCase(volume)) {
            basePath = new File(Environment.getExternalStorageDirectory(), "Documents").getAbsolutePath();
        } else {
            basePath = new File("/storage", volume).getAbsolutePath();
        }
        if (relativePath == null || relativePath.trim().isEmpty()) {
            return basePath;
        }
        return new File(basePath, relativePath).getAbsolutePath();
    }

    private SharedPreferences getPreferences() {
        return getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
    }

    private void updateState(String status, String logLine) {
        getPreferences()
                .edit()
                .putString(KEY_STATUS, status)
                .putString(KEY_LAST_LOG, logLine == null || logLine.trim().isEmpty() ? getString(R.string.default_log) : logLine)
                .apply();
        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        if (notificationManager != null && STATUS_RUNNING.equals(status)) {
            notificationManager.notify(NOTIFICATION_ID, buildNotification(logLine));
        }
        sendBroadcast(new Intent(ACTION_STATUS_UPDATE));
    }

    private void createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, "psyBNC", NotificationManager.IMPORTANCE_LOW);
            NotificationChannel downloadChannel = new NotificationChannel(
                    DOWNLOAD_CHANNEL_ID,
                    getString(R.string.download_notification_channel),
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            if (notificationManager != null) {
                notificationManager.createNotificationChannel(channel);
                notificationManager.createNotificationChannel(downloadChannel);
            }
        }
    }

    private void showDownloadCompletedNotification(String fileName, String downloadRoot) {
        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        if (notificationManager == null) {
            return;
        }
        Intent intent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(
                this,
                (int) System.currentTimeMillis(),
                intent,
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.M ? PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT : PendingIntent.FLAG_UPDATE_CURRENT
        );
        Notification.Builder builder = Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
                ? new Notification.Builder(this, DOWNLOAD_CHANNEL_ID)
                : new Notification.Builder(this);
        Notification notification = builder
                .setContentTitle(getString(R.string.download_notification_title))
                .setContentText(getString(R.string.download_notification_text, fileName, downloadRoot))
                .setSmallIcon(android.R.drawable.stat_sys_download_done)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                .build();
        notificationManager.notify(Math.abs(fileName.hashCode()), notification);
    }

    private Notification buildNotification(String text) {
        Intent intent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(
                this,
                1,
                intent,
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.M ? PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT : PendingIntent.FLAG_UPDATE_CURRENT
        );
        Notification.Builder builder = Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
                ? new Notification.Builder(this, CHANNEL_ID)
                : new Notification.Builder(this);
        return builder
                .setContentTitle(getString(R.string.service_notification_title))
                .setContentText(text == null || text.trim().isEmpty() ? getString(R.string.service_notification_text) : text)
                .setSmallIcon(android.R.drawable.stat_notify_sync)
                .setContentIntent(pendingIntent)
                .setOngoing(true)
                .build();
    }

    private void acquireWakeLock() {
        if (wakeLock != null && wakeLock.isHeld()) {
            return;
        }
        PowerManager powerManager = (PowerManager) getSystemService(POWER_SERVICE);
        if (powerManager != null) {
            wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "psybnc:server");
            wakeLock.setReferenceCounted(false);
            wakeLock.acquire();
        }
    }

    private void releaseWakeLock() {
        if (wakeLock != null && wakeLock.isHeld()) {
            wakeLock.release();
        }
        wakeLock = null;
    }
}
