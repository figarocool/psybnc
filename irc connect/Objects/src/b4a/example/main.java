package b4a.example;

import anywheresoftware.b4a.B4AMenuItem;
import android.app.Activity;
import android.os.Bundle;
import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.BALayout;
import anywheresoftware.b4a.B4AActivity;
import anywheresoftware.b4a.ObjectWrapper;
import anywheresoftware.b4a.objects.ActivityWrapper;
import java.lang.reflect.InvocationTargetException;
import anywheresoftware.b4a.B4AUncaughtException;
import anywheresoftware.b4a.debug.*;
import java.lang.ref.WeakReference;

public class main extends Activity implements B4AActivity{
	public static main mostCurrent;
	static boolean afterFirstLayout;
	static boolean isFirst = true;
    private static boolean processGlobalsRun = false;
	BALayout layout;
	public static BA processBA;
	BA activityBA;
    ActivityWrapper _activity;
    java.util.ArrayList<B4AMenuItem> menuItems;
	private static final boolean fullScreen = false;
	private static final boolean includeTitle = true;
    public static WeakReference<Activity> previousOne;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if (isFirst) {
			processBA = new BA(this.getApplicationContext(), null, null, "b4a.example", "main");
			processBA.loadHtSubs(this.getClass());
	        float deviceScale = getApplicationContext().getResources().getDisplayMetrics().density;
	        BALayout.setDeviceScale(deviceScale);
		}
		else if (previousOne != null) {
			Activity p = previousOne.get();
			if (p != null && p != this) {
                anywheresoftware.b4a.keywords.Common.Log("Killing previous instance (main).");
				p.finish();
			}
		}
		if (!includeTitle) {
        	this.getWindow().requestFeature(android.view.Window.FEATURE_NO_TITLE);
        }
        if (fullScreen) {
        	getWindow().setFlags(android.view.WindowManager.LayoutParams.FLAG_FULLSCREEN,   
        			android.view.WindowManager.LayoutParams.FLAG_FULLSCREEN);
        }
		mostCurrent = this;
        processBA.sharedProcessBA.activityBA = null;
		layout = new BALayout(this);
		setContentView(layout);
		afterFirstLayout = false;
		BA.handler.postDelayed(new WaitForLayout(), 5);

	}
	private static class WaitForLayout implements Runnable {
		public void run() {
			if (afterFirstLayout)
				return;
			if (mostCurrent.layout.getWidth() == 0) {
				BA.handler.postDelayed(this, 5);
				return;
			}
			mostCurrent.layout.getLayoutParams().height = mostCurrent.layout.getHeight();
			mostCurrent.layout.getLayoutParams().width = mostCurrent.layout.getWidth();
			afterFirstLayout = true;
			mostCurrent.afterFirstLayout();
		}
	}
	private void afterFirstLayout() {
		activityBA = new BA(this, layout, processBA, "b4a.example", "main");
        processBA.sharedProcessBA.activityBA = new java.lang.ref.WeakReference<BA>(activityBA);
        _activity = new ActivityWrapper(activityBA, "activity");
        anywheresoftware.b4a.Msgbox.isDismissing = false;
        initializeProcessGlobals();		
        initializeGlobals();
        anywheresoftware.b4a.objects.ViewWrapper.lastId = 0;
        anywheresoftware.b4a.keywords.Common.Log("** Activity (main) Create, isFirst = " + isFirst + " **");
        processBA.raiseEvent2(null, true, "activity_create", false, isFirst);
		isFirst = false;
		if (mostCurrent == null || mostCurrent != this)
			return;
        processBA.setActivityPaused(false);
        anywheresoftware.b4a.keywords.Common.Log("** Activity (main) Resume **");
        processBA.raiseEvent(null, "activity_resume");
        if (android.os.Build.VERSION.SDK_INT >= 11) {
			try {
				android.app.Activity.class.getMethod("invalidateOptionsMenu").invoke(this,(Object[]) null);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

	}
	public void addMenuItem(B4AMenuItem item) {
		if (menuItems == null)
			menuItems = new java.util.ArrayList<B4AMenuItem>();
		menuItems.add(item);
	}
	@Override
	public boolean onCreateOptionsMenu(android.view.Menu menu) {
		super.onCreateOptionsMenu(menu);
		if (menuItems == null)
			return false;
		for (B4AMenuItem bmi : menuItems) {
			android.view.MenuItem mi = menu.add(bmi.title);
			if (bmi.drawable != null)
				mi.setIcon(bmi.drawable);
            if (android.os.Build.VERSION.SDK_INT >= 11) {
				try {
                    if (bmi.addToBar) {
				        android.view.MenuItem.class.getMethod("setShowAsAction", int.class).invoke(mi, 1);
                    }
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			mi.setOnMenuItemClickListener(new B4AMenuItemsClickListener(bmi.eventName.toLowerCase(BA.cul)));
		}
		return true;
	}
	private class B4AMenuItemsClickListener implements android.view.MenuItem.OnMenuItemClickListener {
		private final String eventName;
		public B4AMenuItemsClickListener(String eventName) {
			this.eventName = eventName;
		}
		public boolean onMenuItemClick(android.view.MenuItem item) {
			processBA.raiseEvent(item.getTitle(), eventName + "_click");
			return true;
		}
	}
    public static Class<?> getObject() {
		return main.class;
	}
    private Boolean onKeySubExist = null;
    private Boolean onKeyUpSubExist = null;
	@Override
	public boolean onKeyDown(int keyCode, android.view.KeyEvent event) {
		if (onKeySubExist == null)
			onKeySubExist = processBA.subExists("activity_keypress");
		if (onKeySubExist) {
			Boolean res =  (Boolean)processBA.raiseEvent2(_activity, false, "activity_keypress", false, keyCode);
			if (res == null || res == true)
				return true;
            else if (keyCode == anywheresoftware.b4a.keywords.constants.KeyCodes.KEYCODE_BACK) {
				finish();
				return true;
			}
		}
		return super.onKeyDown(keyCode, event);
	}
    @Override
	public boolean onKeyUp(int keyCode, android.view.KeyEvent event) {
		if (onKeyUpSubExist == null)
			onKeyUpSubExist = processBA.subExists("activity_keyup");
		if (onKeyUpSubExist) {
			Boolean res =  (Boolean)processBA.raiseEvent2(_activity, false, "activity_keyup", false, keyCode);
			if (res == null || res == true)
				return true;
		}
		return super.onKeyUp(keyCode, event);
	}
	@Override
	public void onNewIntent(android.content.Intent intent) {
		this.setIntent(intent);
	}
    @Override 
	public void onPause() {
		super.onPause();
        if (_activity == null) //workaround for emulator bug (Issue 2423)
            return;
		anywheresoftware.b4a.Msgbox.dismiss(true);
        anywheresoftware.b4a.keywords.Common.Log("** Activity (main) Pause, UserClosed = " + activityBA.activity.isFinishing() + " **");
        processBA.raiseEvent2(_activity, true, "activity_pause", false, activityBA.activity.isFinishing());		
        processBA.setActivityPaused(true);
        mostCurrent = null;
        if (!activityBA.activity.isFinishing())
			previousOne = new WeakReference<Activity>(this);
        anywheresoftware.b4a.Msgbox.isDismissing = false;
	}

	@Override
	public void onDestroy() {
        super.onDestroy();
		previousOne = null;
	}
    @Override 
	public void onResume() {
		super.onResume();
        mostCurrent = this;
        anywheresoftware.b4a.Msgbox.isDismissing = false;
        if (activityBA != null) { //will be null during activity create (which waits for AfterLayout).
        	ResumeMessage rm = new ResumeMessage(mostCurrent);
        	BA.handler.post(rm);
        }
	}
    private static class ResumeMessage implements Runnable {
    	private final WeakReference<Activity> activity;
    	public ResumeMessage(Activity activity) {
    		this.activity = new WeakReference<Activity>(activity);
    	}
		public void run() {
			if (mostCurrent == null || mostCurrent != activity.get())
				return;
			processBA.setActivityPaused(false);
            anywheresoftware.b4a.keywords.Common.Log("** Activity (main) Resume **");
		    processBA.raiseEvent(mostCurrent._activity, "activity_resume", (Object[])null);
		}
    }
	@Override
	protected void onActivityResult(int requestCode, int resultCode,
	      android.content.Intent data) {
		processBA.onActivityResult(requestCode, resultCode, data);
	}
	private static void initializeGlobals() {
		processBA.raiseEvent2(null, true, "globals", false, (Object[])null);
	}

public anywheresoftware.b4a.keywords.Common __c = null;
public static anywheresoftware.b4a.objects.SocketWrapper _socket_invio_dati = null;
public static anywheresoftware.b4a.randomaccessfile.AsyncStreams _datisocket_ricezione_irc = null;
public anywheresoftware.b4a.objects.EditTextWrapper _edittext1 = null;
public anywheresoftware.b4a.objects.ButtonWrapper _connetti = null;
public static String  _activity_close() throws Exception{
		Debug.PushSubsStack("Activity_Close (main) ","main",0,mostCurrent.activityBA,mostCurrent);
try {
 BA.debugLineNum = 35;BA.debugLine="Sub Activity_Close";
Debug.ShouldStop(4);
 BA.debugLineNum = 37;BA.debugLine="End Sub";
Debug.ShouldStop(16);
return "";
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static String  _activity_create(boolean _firsttime) throws Exception{
		Debug.PushSubsStack("Activity_Create (main) ","main",0,mostCurrent.activityBA,mostCurrent);
try {
de.joehil.b4a.jhwifi.JHwifi _wifi = null;
Debug.locals.put("FirstTime", _firsttime);
 BA.debugLineNum = 18;BA.debugLine="Sub Activity_Create(FirstTime As Boolean)";
Debug.ShouldStop(131072);
 BA.debugLineNum = 20;BA.debugLine="Activity.LoadLayout(\"Main\")";
Debug.ShouldStop(524288);
mostCurrent._activity.LoadLayout("Main",mostCurrent.activityBA);
 BA.debugLineNum = 21;BA.debugLine="Dim Wifi As JhWifi";
Debug.ShouldStop(1048576);
_wifi = new de.joehil.b4a.jhwifi.JHwifi();Debug.locals.put("Wifi", _wifi);
 BA.debugLineNum = 22;BA.debugLine="Wifi.Initialize";
Debug.ShouldStop(2097152);
_wifi.Initialize(processBA);
 BA.debugLineNum = 24;BA.debugLine="If Wifi.Enabled = True Then";
Debug.ShouldStop(8388608);
if (_wifi.getEnabled()==anywheresoftware.b4a.keywords.Common.True) { 
 BA.debugLineNum = 25;BA.debugLine="If Wifi.Wifi_Sleep_Policy < 2 Then";
Debug.ShouldStop(16777216);
if (_wifi.getWifi_Sleep_Policy()<2) { 
 BA.debugLineNum = 26;BA.debugLine="Msgbox(\"psybnc\",\"Disattiva lo Sleep Wifi\")";
Debug.ShouldStop(33554432);
anywheresoftware.b4a.keywords.Common.Msgbox("psybnc","Disattiva lo Sleep Wifi",mostCurrent.activityBA);
 BA.debugLineNum = 28;BA.debugLine="Wifi.Wifi_Sleep_Policy = Wifi.WIFI_SLEEP_POLICY_NEVER";
Debug.ShouldStop(134217728);
_wifi.setWifi_Sleep_Policy(_wifi.WIFI_SLEEP_POLICY_NEVER);
 };
 };
 BA.debugLineNum = 34;BA.debugLine="End Sub";
Debug.ShouldStop(2);
return "";
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static String  _activity_pause(boolean _userclosed) throws Exception{
		Debug.PushSubsStack("Activity_Pause (main) ","main",0,mostCurrent.activityBA,mostCurrent);
try {
Debug.locals.put("UserClosed", _userclosed);
 BA.debugLineNum = 42;BA.debugLine="Sub Activity_Pause (UserClosed As Boolean)";
Debug.ShouldStop(512);
 BA.debugLineNum = 43;BA.debugLine="If UserClosed Then";
Debug.ShouldStop(1024);
if (_userclosed) { 
 BA.debugLineNum = 44;BA.debugLine="Msgbox(\"ok\",\"ok\")";
Debug.ShouldStop(2048);
anywheresoftware.b4a.keywords.Common.Msgbox("ok","ok",mostCurrent.activityBA);
 };
 BA.debugLineNum = 46;BA.debugLine="End Sub";
Debug.ShouldStop(8192);
return "";
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static String  _activity_resume() throws Exception{
		Debug.PushSubsStack("Activity_Resume (main) ","main",0,mostCurrent.activityBA,mostCurrent);
try {
 BA.debugLineNum = 39;BA.debugLine="Sub Activity_Resume";
Debug.ShouldStop(64);
 BA.debugLineNum = 41;BA.debugLine="End Sub";
Debug.ShouldStop(256);
return "";
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static String  _button_click() throws Exception{
		Debug.PushSubsStack("Button_Click (main) ","main",0,mostCurrent.activityBA,mostCurrent);
try {
 BA.debugLineNum = 89;BA.debugLine="Sub Button_Click";
Debug.ShouldStop(16777216);
 BA.debugLineNum = 90;BA.debugLine="socket_invio_dati.Initialize(\"socket_invio_dati\")";
Debug.ShouldStop(33554432);
_socket_invio_dati.Initialize("socket_invio_dati");
 BA.debugLineNum = 91;BA.debugLine="socket_invio_dati.Connect(\"irc.azzurra.org\",\"6667\",0)";
Debug.ShouldStop(67108864);
_socket_invio_dati.Connect(processBA,"irc.azzurra.org",(int)(Double.parseDouble("6667")),(int)(0));
 BA.debugLineNum = 92;BA.debugLine="End Sub";
Debug.ShouldStop(134217728);
return "";
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static String  _button1_click() throws Exception{
		Debug.PushSubsStack("Button1_Click (main) ","main",0,mostCurrent.activityBA,mostCurrent);
try {
anywheresoftware.b4a.objects.streams.File.TextWriterWrapper _tw = null;
 BA.debugLineNum = 93;BA.debugLine="Sub Button1_Click";
Debug.ShouldStop(268435456);
 BA.debugLineNum = 94;BA.debugLine="Dim tw As TextWriter";
Debug.ShouldStop(536870912);
_tw = new anywheresoftware.b4a.objects.streams.File.TextWriterWrapper();Debug.locals.put("tw", _tw);
 BA.debugLineNum = 95;BA.debugLine="tw.Initialize(socket_invio_dati.OutputStream)";
Debug.ShouldStop(1073741824);
_tw.Initialize(_socket_invio_dati.getOutputStream());
 BA.debugLineNum = 96;BA.debugLine="tw.WriteLine(\"JOIN #Arkosoft\"&Chr(13))";
Debug.ShouldStop(-2147483648);
_tw.WriteLine("JOIN #Arkosoft"+String.valueOf(anywheresoftware.b4a.keywords.Common.Chr((int)(13))));
 BA.debugLineNum = 97;BA.debugLine="tw.Flush";
Debug.ShouldStop(1);
_tw.Flush();
 BA.debugLineNum = 98;BA.debugLine="End Sub";
Debug.ShouldStop(2);
return "";
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static String  _button2_click() throws Exception{
		Debug.PushSubsStack("Button2_Click (main) ","main",0,mostCurrent.activityBA,mostCurrent);
try {
 BA.debugLineNum = 99;BA.debugLine="Sub Button2_Click";
Debug.ShouldStop(4);
 BA.debugLineNum = 100;BA.debugLine="EditText1.Text =\"\"";
Debug.ShouldStop(8);
mostCurrent._edittext1.setText((Object)(""));
 BA.debugLineNum = 102;BA.debugLine="End Sub";
Debug.ShouldStop(32);
return "";
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static String  _datisocket_ricezione_irc_newdata(byte[] _buffer) throws Exception{
		Debug.PushSubsStack("datisocket_ricezione_irc_NewData (main) ","main",0,mostCurrent.activityBA,mostCurrent);
try {
String _buffertext = "";
anywheresoftware.b4a.objects.streams.File.TextWriterWrapper _tw = null;
String[] _pingstring = null;
Debug.locals.put("buffer", _buffer);
 BA.debugLineNum = 67;BA.debugLine="Sub datisocket_ricezione_irc_NewData (buffer() As Byte)";
Debug.ShouldStop(4);
 BA.debugLineNum = 70;BA.debugLine="Dim BufferTExt As String";
Debug.ShouldStop(32);
_buffertext = "";Debug.locals.put("BufferTExt", _buffertext);
 BA.debugLineNum = 71;BA.debugLine="Dim tw As TextWriter";
Debug.ShouldStop(64);
_tw = new anywheresoftware.b4a.objects.streams.File.TextWriterWrapper();Debug.locals.put("tw", _tw);
 BA.debugLineNum = 73;BA.debugLine="BufferTExt = BytesToString(buffer, 0, buffer.Length, \"UTF8\") & Chr(13)";
Debug.ShouldStop(256);
_buffertext = anywheresoftware.b4a.keywords.Common.BytesToString(_buffer,(int)(0),_buffer.length,"UTF8")+String.valueOf(anywheresoftware.b4a.keywords.Common.Chr((int)(13)));Debug.locals.put("BufferTExt", _buffertext);
 BA.debugLineNum = 76;BA.debugLine="Dim PingString() As String";
Debug.ShouldStop(2048);
_pingstring = new String[(int)(0)];
java.util.Arrays.fill(_pingstring,"");Debug.locals.put("PingString", _pingstring);
 BA.debugLineNum = 77;BA.debugLine="PingString = Regex.Split(\":\",BufferTExt)";
Debug.ShouldStop(4096);
_pingstring = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_buffertext);Debug.locals.put("PingString", _pingstring);
 BA.debugLineNum = 78;BA.debugLine="If PingString(0) = \"PING \" Then";
Debug.ShouldStop(8192);
if ((_pingstring[(int)(0)]).equals("PING ")) { 
 BA.debugLineNum = 79;BA.debugLine="tw.Initialize(socket_invio_dati.OutputStream)";
Debug.ShouldStop(16384);
_tw.Initialize(_socket_invio_dati.getOutputStream());
 BA.debugLineNum = 80;BA.debugLine="tw.WriteLine(\"PONG \"&PingString(1)&Chr(13))";
Debug.ShouldStop(32768);
_tw.WriteLine("PONG "+_pingstring[(int)(1)]+String.valueOf(anywheresoftware.b4a.keywords.Common.Chr((int)(13))));
 BA.debugLineNum = 81;BA.debugLine="tw.Flush";
Debug.ShouldStop(65536);
_tw.Flush();
 };
 BA.debugLineNum = 85;BA.debugLine="EditText1.Text = EditText1.Text & BufferTExt";
Debug.ShouldStop(1048576);
mostCurrent._edittext1.setText((Object)(mostCurrent._edittext1.getText()+_buffertext));
 BA.debugLineNum = 86;BA.debugLine="End Sub";
Debug.ShouldStop(2097152);
return "";
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}

public static void initializeProcessGlobals() {
    if (mostCurrent != null && mostCurrent.activityBA != null) {
Debug.StartDebugging(mostCurrent.activityBA, 41304, new int[] {4}, "4acbe9dc-ba63-45fa-bfa0-97b9626de4dc");}

    if (processGlobalsRun == false) {
	    processGlobalsRun = true;
		try {
		        main._process_globals();
		
        } catch (Exception e) {
			throw new RuntimeException(e);
		}
    }
}

public static boolean isAnyActivityVisible() {
    boolean vis = false;
vis = vis | (main.mostCurrent != null);
return vis;}

public static void killProgram() {
    
            if (main.previousOne != null) {
				Activity a = main.previousOne.get();
				if (a != null)
					a.finish();
			}

}
public static String  _globals() throws Exception{
 //BA.debugLineNum = 10;BA.debugLine="Sub Globals";
 //BA.debugLineNum = 13;BA.debugLine="Dim EditText1 As EditText";
mostCurrent._edittext1 = new anywheresoftware.b4a.objects.EditTextWrapper();
 //BA.debugLineNum = 15;BA.debugLine="Dim Connetti As Button";
mostCurrent._connetti = new anywheresoftware.b4a.objects.ButtonWrapper();
 //BA.debugLineNum = 16;BA.debugLine="End Sub";
return "";
}
public static String  _process_globals() throws Exception{
 //BA.debugLineNum = 2;BA.debugLine="Sub Process_Globals";
 //BA.debugLineNum = 5;BA.debugLine="Dim socket_invio_dati As Socket";
_socket_invio_dati = new anywheresoftware.b4a.objects.SocketWrapper();
 //BA.debugLineNum = 6;BA.debugLine="Dim datisocket_ricezione_irc As AsyncStreams";
_datisocket_ricezione_irc = new anywheresoftware.b4a.randomaccessfile.AsyncStreams();
 //BA.debugLineNum = 8;BA.debugLine="End Sub";
return "";
}
public static String  _socket_invio_dati_connected(boolean _successful) throws Exception{
		Debug.PushSubsStack("socket_invio_dati_Connected (main) ","main",0,mostCurrent.activityBA,mostCurrent);
try {
anywheresoftware.b4a.objects.streams.File.TextWriterWrapper _tw = null;
Debug.locals.put("Successful", _successful);
 BA.debugLineNum = 53;BA.debugLine="Sub socket_invio_dati_Connected (Successful As Boolean)";
Debug.ShouldStop(1048576);
 BA.debugLineNum = 54;BA.debugLine="If Successful = True Then";
Debug.ShouldStop(2097152);
if (_successful==anywheresoftware.b4a.keywords.Common.True) { 
 BA.debugLineNum = 55;BA.debugLine="Dim tw As TextWriter";
Debug.ShouldStop(4194304);
_tw = new anywheresoftware.b4a.objects.streams.File.TextWriterWrapper();Debug.locals.put("tw", _tw);
 BA.debugLineNum = 56;BA.debugLine="tw.Initialize(socket_invio_dati.OutputStream)";
Debug.ShouldStop(8388608);
_tw.Initialize(_socket_invio_dati.getOutputStream());
 BA.debugLineNum = 57;BA.debugLine="tw.WriteLine(\"CAP LS\")";
Debug.ShouldStop(16777216);
_tw.WriteLine("CAP LS");
 BA.debugLineNum = 58;BA.debugLine="tw.Flush";
Debug.ShouldStop(33554432);
_tw.Flush();
 BA.debugLineNum = 59;BA.debugLine="tw.WriteLine(\"NICK TestXXNick\"&Chr(13))";
Debug.ShouldStop(67108864);
_tw.WriteLine("NICK TestXXNick"+String.valueOf(anywheresoftware.b4a.keywords.Common.Chr((int)(13))));
 BA.debugLineNum = 60;BA.debugLine="tw.Flush";
Debug.ShouldStop(134217728);
_tw.Flush();
 BA.debugLineNum = 61;BA.debugLine="tw.WriteLine(\"USER Sberla 0 * :...\"&Chr(13))";
Debug.ShouldStop(268435456);
_tw.WriteLine("USER Sberla 0 * :..."+String.valueOf(anywheresoftware.b4a.keywords.Common.Chr((int)(13))));
 BA.debugLineNum = 62;BA.debugLine="tw.Flush";
Debug.ShouldStop(536870912);
_tw.Flush();
 BA.debugLineNum = 63;BA.debugLine="datisocket_ricezione_irc.Initialize(socket_invio_dati.InputStream, socket_invio_dati.OutputStream, \"datisocket_ricezione_irc\")";
Debug.ShouldStop(1073741824);
_datisocket_ricezione_irc.Initialize(processBA,_socket_invio_dati.getInputStream(),_socket_invio_dati.getOutputStream(),"datisocket_ricezione_irc");
 };
 BA.debugLineNum = 65;BA.debugLine="End Sub";
Debug.ShouldStop(1);
return "";
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
  public Object[] GetGlobals() {
		return new Object[] {"Activity",_activity,"socket_invio_dati",_socket_invio_dati,"datisocket_ricezione_irc",_datisocket_ricezione_irc,"EditText1",_edittext1,"Connetti",_connetti};
}
}
