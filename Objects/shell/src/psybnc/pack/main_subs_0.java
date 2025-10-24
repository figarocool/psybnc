package psybnc.pack;

import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.pc.*;

public class main_subs_0 {


public static RemoteObject  _activity_create(RemoteObject _firsttime) throws Exception{
try {
		Debug.PushSubsStack("Activity_Create (main) ","main",0,main.mostCurrent.activityBA,main.mostCurrent,31);
if (RapidSub.canDelegate("activity_create")) return main.remoteMe.runUserSub(false, "main","activity_create", _firsttime);
Debug.locals.put("FirstTime", _firsttime);
 BA.debugLineNum = 31;BA.debugLine="Sub Activity_Create(FirstTime As Boolean)";
Debug.ShouldStop(1073741824);
 BA.debugLineNum = 32;BA.debugLine="Activity.LoadLayout(\"frmprincipale\")";
Debug.ShouldStop(-2147483648);
main.mostCurrent._activity.runMethodAndSync(false,"LoadLayout",(Object)(RemoteObject.createImmutable("frmprincipale")),main.mostCurrent.activityBA);
 BA.debugLineNum = 33;BA.debugLine="End Sub";
Debug.ShouldStop(1);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _button1_click() throws Exception{
try {
		Debug.PushSubsStack("Button1_Click (main) ","main",0,main.mostCurrent.activityBA,main.mostCurrent,44);
if (RapidSub.canDelegate("button1_click")) return main.remoteMe.runUserSub(false, "main","button1_click");
RemoteObject _wifi = RemoteObject.declareNull("de.joehil.b4a.jhwifi.JHwifi");
 BA.debugLineNum = 44;BA.debugLine="Sub Button1_Click";
Debug.ShouldStop(2048);
 BA.debugLineNum = 45;BA.debugLine="If psy.statesocket == False Then";
Debug.ShouldStop(4096);
if (RemoteObject.solveBoolean("=",main.mostCurrent._psy._statesocket,main.mostCurrent.__c.getField(true,"False"))) { 
 BA.debugLineNum = 48;BA.debugLine="Dim Wifi As JhWifi";
Debug.ShouldStop(32768);
_wifi = RemoteObject.createNew ("de.joehil.b4a.jhwifi.JHwifi");Debug.locals.put("Wifi", _wifi);
 BA.debugLineNum = 49;BA.debugLine="Wifi.Initialize";
Debug.ShouldStop(65536);
_wifi.runVoidMethod ("Initialize",main.processBA);
 BA.debugLineNum = 50;BA.debugLine="If Wifi.Enabled = True Then";
Debug.ShouldStop(131072);
if (RemoteObject.solveBoolean("=",_wifi.runMethod(true,"getEnabled"),main.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 51;BA.debugLine="If Wifi.Wifi_Sleep_Policy < 2 Then";
Debug.ShouldStop(262144);
if (RemoteObject.solveBoolean("<",_wifi.runMethod(true,"getWifi_Sleep_Policy"),BA.numberCast(double.class, 2))) { 
 BA.debugLineNum = 53;BA.debugLine="Wifi.Wifi_Sleep_Policy = Wifi.WIFI_SLEEP_POLI";
Debug.ShouldStop(1048576);
_wifi.runMethod(true,"setWifi_Sleep_Policy",_wifi.getField(true,"WIFI_SLEEP_POLICY_NEVER"));
 };
 };
 BA.debugLineNum = 57;BA.debugLine="psy.serverPort = EditText1.text";
Debug.ShouldStop(16777216);
main.mostCurrent._psy._serverport = main.mostCurrent._edittext1.runMethod(true,"getText");
 BA.debugLineNum = 58;BA.debugLine="StartService(psy)";
Debug.ShouldStop(33554432);
main.mostCurrent.__c.runVoidMethod ("StartService",main.mostCurrent.activityBA,(Object)((main.mostCurrent._psy.getObject())));
 BA.debugLineNum = 59;BA.debugLine="TimerIP.Initialize(\"TimerIP\", 100)";
Debug.ShouldStop(67108864);
main.mostCurrent._timerip.runVoidMethod ("Initialize",main.processBA,(Object)(BA.ObjectToString("TimerIP")),(Object)(BA.numberCast(long.class, 100)));
 BA.debugLineNum = 60;BA.debugLine="TimerIP.Enabled = True";
Debug.ShouldStop(134217728);
main.mostCurrent._timerip.runMethod(true,"setEnabled",main.mostCurrent.__c.getField(true,"True"));
 BA.debugLineNum = 61;BA.debugLine="EditText2.Text = psy.MyIP";
Debug.ShouldStop(268435456);
main.mostCurrent._edittext2.runMethodAndSync(true,"setText",(main.mostCurrent._psy._myip));
 };
 BA.debugLineNum = 63;BA.debugLine="End Sub";
Debug.ShouldStop(1073741824);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _button2_click() throws Exception{
try {
		Debug.PushSubsStack("Button2_Click (main) ","main",0,main.mostCurrent.activityBA,main.mostCurrent,71);
if (RapidSub.canDelegate("button2_click")) return main.remoteMe.runUserSub(false, "main","button2_click");
 BA.debugLineNum = 71;BA.debugLine="Sub Button2_Click";
Debug.ShouldStop(64);
 BA.debugLineNum = 72;BA.debugLine="EditText2.Text = psy.MyIP";
Debug.ShouldStop(128);
main.mostCurrent._edittext2.runMethodAndSync(true,"setText",(main.mostCurrent._psy._myip));
 BA.debugLineNum = 73;BA.debugLine="End Sub";
Debug.ShouldStop(256);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _button3_click() throws Exception{
try {
		Debug.PushSubsStack("Button3_Click (main) ","main",0,main.mostCurrent.activityBA,main.mostCurrent,76);
if (RapidSub.canDelegate("button3_click")) return main.remoteMe.runUserSub(false, "main","button3_click");
 BA.debugLineNum = 76;BA.debugLine="Sub Button3_Click";
Debug.ShouldStop(2048);
 BA.debugLineNum = 79;BA.debugLine="End Sub";
Debug.ShouldStop(16384);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _globals() throws Exception{
 //BA.debugLineNum = 18;BA.debugLine="Sub Globals";
 //BA.debugLineNum = 22;BA.debugLine="Dim Button1 As Button";
main.mostCurrent._button1 = RemoteObject.createNew ("anywheresoftware.b4a.objects.ButtonWrapper");
 //BA.debugLineNum = 23;BA.debugLine="Dim Button2 As Button";
main.mostCurrent._button2 = RemoteObject.createNew ("anywheresoftware.b4a.objects.ButtonWrapper");
 //BA.debugLineNum = 25;BA.debugLine="Dim EditText1 As EditText";
main.mostCurrent._edittext1 = RemoteObject.createNew ("anywheresoftware.b4a.objects.EditTextWrapper");
 //BA.debugLineNum = 26;BA.debugLine="Dim EditText2 As EditText";
main.mostCurrent._edittext2 = RemoteObject.createNew ("anywheresoftware.b4a.objects.EditTextWrapper");
 //BA.debugLineNum = 27;BA.debugLine="Dim TimerIP As Timer";
main.mostCurrent._timerip = RemoteObject.createNew ("anywheresoftware.b4a.objects.Timer");
 //BA.debugLineNum = 29;BA.debugLine="End Sub";
return RemoteObject.createImmutable("");
}

public static void initializeProcessGlobals() {
    
    if (main.processGlobalsRun == false) {
	    main.processGlobalsRun = true;
		try {
		        main_subs_0._process_globals();
psy_subs_0._process_globals();
main.myClass = BA.getDeviceClass ("psybnc.pack.main");
psy.myClass = BA.getDeviceClass ("psybnc.pack.psy");
		
        } catch (Exception e) {
			throw new RuntimeException(e);
		}
    }
}public static RemoteObject  _process_globals() throws Exception{
 //BA.debugLineNum = 12;BA.debugLine="Sub Process_Globals";
 //BA.debugLineNum = 16;BA.debugLine="End Sub";
return RemoteObject.createImmutable("");
}
public static RemoteObject  _timerip_tick() throws Exception{
try {
		Debug.PushSubsStack("TimerIP_Tick (main) ","main",0,main.mostCurrent.activityBA,main.mostCurrent,65);
if (RapidSub.canDelegate("timerip_tick")) return main.remoteMe.runUserSub(false, "main","timerip_tick");
 BA.debugLineNum = 65;BA.debugLine="Sub TimerIP_Tick";
Debug.ShouldStop(1);
 BA.debugLineNum = 66;BA.debugLine="If EditText2.Text ==\"\" Then";
Debug.ShouldStop(2);
if (RemoteObject.solveBoolean("=",main.mostCurrent._edittext2.runMethod(true,"getText"),BA.ObjectToString(""))) { 
 BA.debugLineNum = 67;BA.debugLine="EditText2.Text = psy.MyIP";
Debug.ShouldStop(4);
main.mostCurrent._edittext2.runMethodAndSync(true,"setText",(main.mostCurrent._psy._myip));
 BA.debugLineNum = 68;BA.debugLine="TimerIP.Enabled = False";
Debug.ShouldStop(8);
main.mostCurrent._timerip.runMethod(true,"setEnabled",main.mostCurrent.__c.getField(true,"False"));
 };
 BA.debugLineNum = 70;BA.debugLine="End Sub";
Debug.ShouldStop(32);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
}