package org.psybnc.app;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.net.InetAddresses;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.Settings;
import android.text.TextUtils;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Enumeration;
import java.util.List;
import java.util.Set;

public class MainActivity extends Activity {
    private static final int REQUEST_NOTIFICATIONS = 1001;
    private static final int REQUEST_STORAGE_PERMISSION = 1002;
    private static final int REQUEST_OPEN_TREE = 1003;
    private static final int REQUEST_MANAGE_ALL_FILES = 1004;
    private static final String KEY_BIND_DEFAULT_MIGRATED = "bind_default_migrated";

    private EditText portInput;
    private CheckBox downloadNotificationsCheck;
    private TextView statusValue;
    private TextView bindValue;
    private TextView downloadPathValue;
    private TextView ipValue;
    private TextView logValue;

    private final BroadcastReceiver statusReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            refreshUi();
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        portInput = findViewById(R.id.portInput);
        downloadNotificationsCheck = findViewById(R.id.downloadNotificationsCheck);
        statusValue = findViewById(R.id.statusValue);
        bindValue = findViewById(R.id.bindValue);
        downloadPathValue = findViewById(R.id.downloadPathValue);
        ipValue = findViewById(R.id.ipValue);
        logValue = findViewById(R.id.logValue);

        Button startButton = findViewById(R.id.startButton);
        Button stopButton = findViewById(R.id.stopButton);
        Button selectFolderButton = findViewById(R.id.selectFolderButton);
        Button resetConfigButton = findViewById(R.id.resetConfigButton);
        Button aboutButton = findViewById(R.id.aboutButton);

        ensureDefaults();
        downloadNotificationsCheck.setOnCheckedChangeListener((buttonView, isChecked) ->
                getSharedPreferences(PsybncService.PREFS_NAME, MODE_PRIVATE)
                        .edit()
                        .putBoolean(PsybncService.KEY_DOWNLOAD_NOTIFICATIONS_ENABLED, isChecked)
                        .apply()
        );

        startButton.setOnClickListener(view -> {
            if (!persistSettings()) {
                return;
            }
            showBindChooserAndStart();
        });

        stopButton.setOnClickListener(view -> {
            Intent intent = new Intent(this, PsybncService.class);
            intent.setAction(PsybncService.ACTION_STOP);
            startService(intent);
            refreshUi();
        });

        resetConfigButton.setOnClickListener(view -> {
            new AlertDialog.Builder(this)
                    .setTitle(R.string.reset_config_confirm_title)
                    .setMessage(R.string.reset_config_confirm_message)
                    .setPositiveButton(R.string.reset, (dialog, which) -> {
                        Intent intent = new Intent(this, PsybncService.class);
                        intent.setAction(PsybncService.ACTION_RESET);
                        startService(intent);
                    })
                    .setNegativeButton(android.R.string.cancel, null)
                    .show();
        });

        aboutButton.setOnClickListener(view -> {
            android.widget.TextView messageView = new android.widget.TextView(this);
            messageView.setText(R.string.about_message);
            messageView.setPadding(64, 32, 64, 32);
            messageView.setTextSize(14);
            messageView.setTextColor(messageView.getTextColors().getDefaultColor());
            android.text.util.Linkify.addLinks(messageView, android.text.util.Linkify.ALL);
            
            new AlertDialog.Builder(this)
                    .setTitle(R.string.about_title)
                    .setView(messageView)
                    .setPositiveButton(android.R.string.ok, null)
                    .show();
        });

        selectFolderButton.setOnClickListener(view -> showFolderChooser());
    }

    @Override
    protected void onResume() {
        super.onResume();
        IntentFilter filter = new IntentFilter(PsybncService.ACTION_STATUS_UPDATE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(statusReceiver, filter, RECEIVER_NOT_EXPORTED);
        } else {
            registerReceiver(statusReceiver, filter);
        }
        refreshUi();
    }

    @Override
    protected void onPause() {
        super.onPause();
        unregisterReceiver(statusReceiver);
    }

    private void ensureDefaults() {
        SharedPreferences preferences = getSharedPreferences(PsybncService.PREFS_NAME, MODE_PRIVATE);
        if (!preferences.contains(PsybncService.KEY_PORT)) {
            preferences.edit().putInt(PsybncService.KEY_PORT, 31337).apply();
        }
        if (!preferences.contains(PsybncService.KEY_BIND_HOST)) {
            preferences.edit().putString(PsybncService.KEY_BIND_HOST, "0.0.0.0").apply();
        }
        if (!preferences.getBoolean(KEY_BIND_DEFAULT_MIGRATED, false)) {
            String bindHost = preferences.getString(PsybncService.KEY_BIND_HOST, "0.0.0.0");
            if ("*".equals(bindHost) || bindHost == null || bindHost.trim().isEmpty() || !"0.0.0.0".equals(bindHost)) {
                preferences.edit().putString(PsybncService.KEY_BIND_HOST, "0.0.0.0").apply();
            }
            preferences.edit().putBoolean(KEY_BIND_DEFAULT_MIGRATED, true).apply();
        }
        if (!preferences.contains(PsybncService.KEY_DOWNLOAD_NOTIFICATIONS_ENABLED)) {
            preferences.edit().putBoolean(PsybncService.KEY_DOWNLOAD_NOTIFICATIONS_ENABLED, false).apply();
        }
        if (!preferences.contains(PsybncService.KEY_DOWNLOAD_PATH)) {
            preferences.edit().putString(PsybncService.KEY_DOWNLOAD_PATH, buildDefaultDownloadChoices().get(0)).apply();
        }
        portInput.setText(String.valueOf(preferences.getInt(PsybncService.KEY_PORT, 31337)));
        downloadNotificationsCheck.setChecked(preferences.getBoolean(PsybncService.KEY_DOWNLOAD_NOTIFICATIONS_ENABLED, false));
    }

    private boolean persistSettings() {
        String portText = portInput.getText().toString().trim();
        if (TextUtils.isEmpty(portText)) {
            portText = "31337";
        }
        int port;
        try {
            port = Integer.parseInt(portText);
        } catch (NumberFormatException exception) {
            Toast.makeText(this, R.string.port_invalid, Toast.LENGTH_SHORT).show();
            return false;
        }
        if (port < 1024 || port > 65535) {
            Toast.makeText(this, R.string.port_invalid, Toast.LENGTH_SHORT).show();
            return false;
        }
        SharedPreferences preferences = getSharedPreferences(PsybncService.PREFS_NAME, MODE_PRIVATE);
        preferences.edit()
                .putInt(PsybncService.KEY_PORT, port)
                .putBoolean(PsybncService.KEY_DOWNLOAD_NOTIFICATIONS_ENABLED, downloadNotificationsCheck.isChecked())
                .apply();
        return true;
    }

    private void requestNotificationsIfNeeded() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(new String[]{Manifest.permission.POST_NOTIFICATIONS}, REQUEST_NOTIFICATIONS);
            }
        }
    }

    private void refreshUi() {
        SharedPreferences preferences = getSharedPreferences(PsybncService.PREFS_NAME, MODE_PRIVATE);
        int port = preferences.getInt(PsybncService.KEY_PORT, 31337);
        String status = preferences.getString(PsybncService.KEY_STATUS, PsybncService.STATUS_STOPPED);
        String bindHost = preferences.getString(PsybncService.KEY_BIND_HOST, "0.0.0.0");
        String downloadPath = preferences.getString(PsybncService.KEY_DOWNLOAD_PATH, buildDefaultDownloadChoices().get(0));
        String lastLog = preferences.getString(PsybncService.KEY_LAST_LOG, getString(R.string.default_log));

        portInput.setText(String.valueOf(port));
        downloadNotificationsCheck.setChecked(preferences.getBoolean(PsybncService.KEY_DOWNLOAD_NOTIFICATIONS_ENABLED, false));
        bindValue.setText(describeBindSelection(bindHost));
        downloadPathValue.setText(downloadPath);
        logValue.setText(lastLog);

        if (PsybncService.STATUS_RUNNING.equals(status)) {
            statusValue.setText(getString(R.string.status_running));
        } else if (PsybncService.STATUS_ERROR.equals(status)) {
            statusValue.setText(getString(R.string.status_error));
        } else {
            statusValue.setText(getString(R.string.status_stopped));
        }

        ipValue.setText(buildIpSummary(collectBindableAddresses(), port));
    }

    private String buildIpSummary(List<BindChoice> choices, int port) {
        List<String> values = new ArrayList<>();
        for (BindChoice choice : choices) {
            if ("*".equals(choice.value) || "::".equals(choice.value) || "0.0.0.0".equals(choice.value)) {
                continue;
            }
            if (choice.ipv6) {
                values.add(getString(R.string.bind_ipv6_format, choice.value, port));
            } else {
                values.add(getString(R.string.bind_ipv4_format, choice.value, port));
            }
        }
        if (values.isEmpty()) {
            values.add(getString(R.string.bind_ipv4_format, "127.0.0.1", port));
        }
        return TextUtils.join("\n", values);
    }

    private void showBindChooserAndStart() {
        List<BindChoice> choices = collectBindableAddresses();
        SharedPreferences preferences = getSharedPreferences(PsybncService.PREFS_NAME, MODE_PRIVATE);
        CharSequence[] labels = new CharSequence[choices.size()];
        int checkedItem = 0;
        for (int i = 0; i < choices.size(); i++) {
            labels[i] = choices.get(i).label;
        }
        final int[] selectedItem = {checkedItem};
        new AlertDialog.Builder(this)
                .setTitle(R.string.choose_bind_ip)
                .setSingleChoiceItems(labels, checkedItem, (dialog, which) -> selectedItem[0] = which)
                .setPositiveButton(R.string.start_after_bind, (dialog, which) -> {
                    BindChoice choice = choices.get(selectedItem[0]);
                    preferences.edit().putString(PsybncService.KEY_BIND_HOST, choice.value).apply();
                    requestNotificationsIfNeeded();
                    Intent intent = new Intent(this, PsybncService.class);
                    intent.setAction(PsybncService.ACTION_START);
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent);
                    } else {
                        startService(intent);
                    }
                    refreshUi();
                })
                .setNegativeButton(android.R.string.cancel, null)
                .show();
    }

    private String describeBindSelection(String bindHost) {
        for (BindChoice choice : collectBindableAddresses()) {
            if (choice.value.equals(bindHost)) {
                return choice.label;
            }
        }
        return bindHost;
    }

    private List<BindChoice> collectBindableAddresses() {
        List<BindChoice> values = new ArrayList<>();
        Set<String> seen = new LinkedHashSet<>();
        values.add(new BindChoice("0.0.0.0", getString(R.string.bind_all_ipv4), false));
        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
            for (NetworkInterface networkInterface : Collections.list(interfaces)) {
                if (!networkInterface.isUp() || networkInterface.isLoopback()) {
                    continue;
                }
                for (InetAddress address : Collections.list(networkInterface.getInetAddresses())) {
                    if (address.isLoopbackAddress() || address.isAnyLocalAddress() || address.isMulticastAddress()) {
                        continue;
                    }
                    if (address instanceof Inet6Address && (address.isLinkLocalAddress() || address.isSiteLocalAddress())) {
                        continue;
                    }
                    String hostAddress = address.getHostAddress();
                    if (TextUtils.isEmpty(hostAddress)) {
                        continue;
                    }
                    if (hostAddress.contains("%")) {
                        hostAddress = hostAddress.substring(0, hostAddress.indexOf('%'));
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q && !InetAddresses.isNumericAddress(hostAddress)) {
                        continue;
                    }
                    if (!seen.add(hostAddress)) {
                        continue;
                    }
                    String label = getString(R.string.bind_interface_format, hostAddress, networkInterface.getDisplayName());
                    if (address instanceof Inet4Address) {
                        values.add(new BindChoice(hostAddress, label, false));
                    } else if (address instanceof Inet6Address) {
                        values.add(new BindChoice(hostAddress, label, true));
                    }
                }
            }
        } catch (Exception exception) {
            if (seen.add("127.0.0.1")) {
                values.add(new BindChoice("127.0.0.1", "127.0.0.1", false));
            }
        }
        values.add(new BindChoice("*", getString(R.string.bind_all_auto), false));
        if (!seen.contains("::")) {
            values.add(new BindChoice("::", getString(R.string.bind_all_ipv6), true));
        }
        if (values.size() == 1) {
            values.add(new BindChoice("127.0.0.1", "127.0.0.1", false));
        }
        return values;
    }

    private void showFolderChooser() {
        List<String> folders = buildDefaultDownloadChoices();
        CharSequence[] labels = new CharSequence[folders.size() + 1];
        labels[0] = getString(R.string.system_folder_picker);
        for (int i = 0; i < folders.size(); i++) {
            labels[i + 1] = folders.get(i);
        }
        new AlertDialog.Builder(this)
                .setTitle(R.string.select_folder)
                .setItems(labels, (dialogInterface, which) -> {
                    if (which == 0) {
                        ensureStorageAccessAndOpenPicker();
                        return;
                    }
                    String selected = folders.get(which - 1);
                    new File(selected).mkdirs();
                    getSharedPreferences(PsybncService.PREFS_NAME, MODE_PRIVATE)
                            .edit()
                            .putString(PsybncService.KEY_DOWNLOAD_PATH, selected)
                            .remove(PsybncService.KEY_DOWNLOAD_URI)
                            .apply();
                    refreshUi();
                })
                .show();
    }

    private void ensureStorageAccessAndOpenPicker() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            if (!Environment.isExternalStorageManager()) {
                new AlertDialog.Builder(this)
                        .setTitle(R.string.storage_permission_title)
                        .setMessage(R.string.storage_permission_message)
                        .setPositiveButton(R.string.open_settings, (dialog, which) -> requestManageAllFilesPermission())
                        .setNegativeButton(android.R.string.cancel, null)
                        .show();
                return;
            }
            openSystemFolderPicker();
            return;
        }
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            openSystemFolderPicker();
            return;
        }
        if (checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, REQUEST_STORAGE_PERMISSION);
            return;
        }
        openSystemFolderPicker();
    }

    private void requestManageAllFilesPermission() {
        try {
            Intent intent = new Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION);
            intent.setData(Uri.parse("package:" + getPackageName()));
            startActivityForResult(intent, REQUEST_MANAGE_ALL_FILES);
        } catch (Exception exception) {
            Intent intent = new Intent(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION);
            startActivityForResult(intent, REQUEST_MANAGE_ALL_FILES);
        }
    }

    private void openSystemFolderPicker() {
        try {
            Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
            intent.addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
            intent.addFlags(Intent.FLAG_GRANT_PREFIX_URI_PERMISSION);
            startActivityForResult(intent, REQUEST_OPEN_TREE);
        } catch (Exception exception) {
            Toast.makeText(this, R.string.folder_picker_failed, Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_MANAGE_ALL_FILES) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R || Environment.isExternalStorageManager()) {
                openSystemFolderPicker();
            } else {
                Toast.makeText(this, R.string.grant_storage_first, Toast.LENGTH_SHORT).show();
            }
            return;
        }
        if (requestCode == REQUEST_OPEN_TREE && resultCode == RESULT_OK && data != null) {
            Uri treeUri = data.getData();
            if (treeUri == null) {
                Toast.makeText(this, R.string.folder_unavailable, Toast.LENGTH_SHORT).show();
                return;
            }
            final int flags = data.getFlags() & (Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
            getContentResolver().takePersistableUriPermission(treeUri, flags);
            String selectedPath = PsybncService.treeUriToPath(this, treeUri);
            if (TextUtils.isEmpty(selectedPath)) {
                Toast.makeText(this, R.string.folder_unavailable, Toast.LENGTH_SHORT).show();
                return;
            }
            File selectedDirectory = new File(selectedPath);
            selectedDirectory.mkdirs();
            getSharedPreferences(PsybncService.PREFS_NAME, MODE_PRIVATE)
                    .edit()
                    .putString(PsybncService.KEY_DOWNLOAD_PATH, selectedDirectory.getAbsolutePath())
                    .putString(PsybncService.KEY_DOWNLOAD_URI, treeUri.toString())
                    .apply();
            Toast.makeText(this, R.string.folder_selected, Toast.LENGTH_SHORT).show();
            refreshUi();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_STORAGE_PERMISSION) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                openSystemFolderPicker();
            } else {
                Toast.makeText(this, R.string.grant_storage_first, Toast.LENGTH_SHORT).show();
            }
        }
    }

    private List<String> buildDefaultDownloadChoices() {
        List<String> values = new ArrayList<>();
        File internal = new File(getFilesDir(), "downloads");
        values.add(internal.getAbsolutePath());
        File external = getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS);
        if (external != null) {
            values.add(external.getAbsolutePath());
        }
        File externalRoot = getExternalFilesDir(null);
        if (externalRoot != null) {
            values.add(new File(externalRoot, "psybnc-downloads").getAbsolutePath());
        }
        File publicDownloads = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
        if (publicDownloads != null) {
            values.add(publicDownloads.getAbsolutePath());
        }
        return values;
    }

    private static final class BindChoice {
        final String value;
        final String label;
        final boolean ipv6;

        BindChoice(String value, String label, boolean ipv6) {
            this.value = value;
            this.label = label;
            this.ipv6 = ipv6;
        }
    }
}
