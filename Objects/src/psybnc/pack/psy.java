package psybnc.pack;


import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.objects.ServiceHelper;
import anywheresoftware.b4a.debug.*;

public class psy extends  android.app.Service{
	public static class psy_BR extends android.content.BroadcastReceiver {

		@Override
		public void onReceive(android.content.Context context, android.content.Intent intent) {
			android.content.Intent in = new android.content.Intent(context, psy.class);
			if (intent != null)
				in.putExtra("b4a_internal_intent", intent);
			context.startService(in);
		}

	}
    static psy mostCurrent;
	public static BA processBA;
    private ServiceHelper _service;
    public static Class<?> getObject() {
		return psy.class;
	}
	@Override
	public void onCreate() {
        super.onCreate();
        mostCurrent = this;
        if (processBA == null) {
		    processBA = new anywheresoftware.b4a.ShellBA(this, null, null, "psybnc.pack", "psybnc.pack.psy");
            if (BA.isShellModeRuntimeCheck(processBA)) {
                processBA.raiseEvent2(null, true, "SHELL", false);
		    }
            try {
                Class.forName(BA.applicationContext.getPackageName() + ".main").getMethod("initializeProcessGlobals").invoke(null, null);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            processBA.loadHtSubs(this.getClass());
            ServiceHelper.init();
        }
        _service = new ServiceHelper(this);
        processBA.service = this;
        
        if (BA.isShellModeRuntimeCheck(processBA)) {
			processBA.raiseEvent2(null, true, "CREATE", true, "psybnc.pack.psy", processBA, _service, anywheresoftware.b4a.keywords.Common.Density);
		}
        if (!false && ServiceHelper.StarterHelper.startFromServiceCreate(processBA, true) == false) {
				
		}
		else {
            processBA.setActivityPaused(false);
            BA.LogInfo("** Service (psy) Create **");
            processBA.raiseEvent(null, "service_create");
        }
        processBA.runHook("oncreate", this, null);
        if (false) {
			if (ServiceHelper.StarterHelper.waitForLayout != null)
				BA.handler.post(ServiceHelper.StarterHelper.waitForLayout);
		}
    }
		@Override
	public void onStart(android.content.Intent intent, int startId) {
		onStartCommand(intent, 0, 0);
    }
    @Override
    public int onStartCommand(final android.content.Intent intent, int flags, int startId) {
    	if (ServiceHelper.StarterHelper.onStartCommand(processBA))
			handleStart(intent);
		else {
			ServiceHelper.StarterHelper.waitForLayout = new Runnable() {
				public void run() {
                    processBA.setActivityPaused(false);
                    BA.LogInfo("** Service (psy) Create **");
                    processBA.raiseEvent(null, "service_create");
					handleStart(intent);
				}
			};
		}
        processBA.runHook("onstartcommand", this, new Object[] {intent, flags, startId});
		return android.app.Service.START_NOT_STICKY;
    }
    public void onTaskRemoved(android.content.Intent rootIntent) {
        super.onTaskRemoved(rootIntent);
        if (false)
            processBA.raiseEvent(null, "service_taskremoved");
            
    }
    private void handleStart(android.content.Intent intent) {
    	BA.LogInfo("** Service (psy) Start **");
    	java.lang.reflect.Method startEvent = processBA.htSubs.get("service_start");
    	if (startEvent != null) {
    		if (startEvent.getParameterTypes().length > 0) {
    			anywheresoftware.b4a.objects.IntentWrapper iw = new anywheresoftware.b4a.objects.IntentWrapper();
    			if (intent != null) {
    				if (intent.hasExtra("b4a_internal_intent"))
    					iw.setObject((android.content.Intent) intent.getParcelableExtra("b4a_internal_intent"));
    				else
    					iw.setObject(intent);
    			}
    			processBA.raiseEvent(null, "service_start", iw);
    		}
    		else {
    			processBA.raiseEvent(null, "service_start");
    		}
    	}
    }
	
	@Override
	public void onDestroy() {
        super.onDestroy();
        BA.LogInfo("** Service (psy) Destroy **");
		processBA.raiseEvent(null, "service_destroy");
        processBA.service = null;
		mostCurrent = null;
		processBA.setActivityPaused(true);
        processBA.runHook("ondestroy", this, null);
	}

@Override
	public android.os.IBinder onBind(android.content.Intent intent) {
		return null;
	}
public anywheresoftware.b4a.keywords.Common __c = null;
public static anywheresoftware.b4a.objects.SocketWrapper.ServerSocketWrapper _server = null;
public static String _serverport = "";
public static boolean _statesocket = false;
public static anywheresoftware.b4a.objects.SocketWrapper _socket_ricezione_dati = null;
public static anywheresoftware.b4a.objects.SocketWrapper _socket_invio_dati = null;
public static anywheresoftware.b4a.randomaccessfile.AsyncStreams _datisocket_ricezione = null;
public static anywheresoftware.b4a.randomaccessfile.AsyncStreams _datisocket_ricezione_irc = null;
public static boolean _irclient = false;
public static String _myip = "";
public static anywheresoftware.b4a.objects.Timer _timerserver = null;
public static boolean _joinpasswd = false;
public static anywheresoftware.b4a.objects.collections.List _joinchannel = null;
public static anywheresoftware.b4a.objects.collections.List _topichannel = null;
public static anywheresoftware.b4a.objects.collections.List _messagequery = null;
public static String _identirc = "";
public static String _nickconnessione = "";
public static String _savemoth = "";
public static boolean _stopmoth = false;
public static String _awaynick = "";
public static String _normalnick = "";
public static anywheresoftware.b4a.objects.Timer _pingtimer = null;
public static boolean _autoping = false;
public psybnc.pack.main _main = null;
public static String  _bhelp() throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "bhelp"))
	return (String) Debug.delegate(processBA, "bhelp", null);
anywheresoftware.b4a.objects.streams.File.TextReaderWrapper _tr = null;
anywheresoftware.b4a.objects.streams.File.TextWriterWrapper _tw = null;
RDebugUtils.currentLine=1900544;
 //BA.debugLineNum = 1900544;BA.debugLine="Sub Bhelp()";
RDebugUtils.currentLine=1900545;
 //BA.debugLineNum = 1900545;BA.debugLine="Dim tr As TextReader";
_tr = new anywheresoftware.b4a.objects.streams.File.TextReaderWrapper();
RDebugUtils.currentLine=1900546;
 //BA.debugLineNum = 1900546;BA.debugLine="Dim tw As TextWriter";
_tw = new anywheresoftware.b4a.objects.streams.File.TextWriterWrapper();
RDebugUtils.currentLine=1900547;
 //BA.debugLineNum = 1900547;BA.debugLine="tr.Initialize( socket_ricezione_dati.InputStream)";
_tr.Initialize(_socket_ricezione_dati.getInputStream());
RDebugUtils.currentLine=1900548;
 //BA.debugLineNum = 1900548;BA.debugLine="tw.Initialize( socket_ricezione_dati.OutputStream";
_tw.Initialize(_socket_ricezione_dati.getOutputStream());
RDebugUtils.currentLine=1900549;
 //BA.debugLineNum = 1900549;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC Welcome \"&S";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC Welcome "+_solouser(_identirc)+" !");
RDebugUtils.currentLine=1900550;
 //BA.debugLineNum = 1900550;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC You are the";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC You are the first To connect To this new proxy server.");
RDebugUtils.currentLine=1900551;
 //BA.debugLineNum = 1900551;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC You are the";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC You are the proxy-admin. Use ADDSERVER To add a server so the bouncer may connect.");
RDebugUtils.currentLine=1900552;
 //BA.debugLineNum = 1900552;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC psyBNC0.1";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC psyBNC0.1 Help (* = BounceAdmin only)");
RDebugUtils.currentLine=1900553;
 //BA.debugLineNum = 1900553;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC -----------";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC -------------------------------------");
RDebugUtils.currentLine=1900554;
 //BA.debugLineNum = 1900554;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   ADD";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDSERVER       - Adds an IRC-server To your Serverlist");
RDebugUtils.currentLine=1900555;
 //BA.debugLineNum = 1900555;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   DEL";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DELSERVER       - Deletes an IRC-Server by number");
RDebugUtils.currentLine=1900556;
 //BA.debugLineNum = 1900556;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   LIS";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTSERVERS     - Lists all IRC-Servers added");
RDebugUtils.currentLine=1900557;
 //BA.debugLineNum = 1900557;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   SET";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SETAWAYNICK     - Sets your nick when you are offline");
RDebugUtils.currentLine=1900558;
 //BA.debugLineNum = 1900558;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   PLA";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   PLAYPRIVATELOG  - Plays your Message Log");
RDebugUtils.currentLine=1900559;
 //BA.debugLineNum = 1900559;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   ERA";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ERASEPRIVATELOG - Erases your Message Log");
RDebugUtils.currentLine=1900560;
 //BA.debugLineNum = 1900560;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   BHE";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   BHELP           - Lists this help OR help on a topic");
RDebugUtils.currentLine=1900561;
 //BA.debugLineNum = 1900561;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP Use /";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP Use /QUOTE bhelp <command> For details.");
RDebugUtils.currentLine=1900562;
 //BA.debugLineNum = 1900562;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP - End";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP - End of help");
RDebugUtils.currentLine=1900563;
 //BA.debugLineNum = 1900563;BA.debugLine="tw.Flush";
_tw.Flush();
RDebugUtils.currentLine=1900564;
 //BA.debugLineNum = 1900564;BA.debugLine="End Sub";
return "";
}
public static String  _solouser(String _identread) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "solouser"))
	return (String) Debug.delegate(processBA, "solouser", new Object[] {_identread});
String[] _user = null;
String[] _space = null;
RDebugUtils.currentLine=1835008;
 //BA.debugLineNum = 1835008;BA.debugLine="Sub Solouser(IdentRead As String)";
RDebugUtils.currentLine=1835009;
 //BA.debugLineNum = 1835009;BA.debugLine="If IdentRead.Length > 0 Then";
if (_identread.length()>0) { 
RDebugUtils.currentLine=1835010;
 //BA.debugLineNum = 1835010;BA.debugLine="Dim User() As String";
_user = new String[(int) (0)];
java.util.Arrays.fill(_user,"");
RDebugUtils.currentLine=1835011;
 //BA.debugLineNum = 1835011;BA.debugLine="Dim Space() As String";
_space = new String[(int) (0)];
java.util.Arrays.fill(_space,"");
RDebugUtils.currentLine=1835012;
 //BA.debugLineNum = 1835012;BA.debugLine="User = Regex.Split(\"USER\",IdentRead)";
_user = anywheresoftware.b4a.keywords.Common.Regex.Split("USER",_identread);
RDebugUtils.currentLine=1835013;
 //BA.debugLineNum = 1835013;BA.debugLine="Space = Regex.Split(\" \",User(1))";
_space = anywheresoftware.b4a.keywords.Common.Regex.Split(" ",_user[(int) (1)]);
RDebugUtils.currentLine=1835014;
 //BA.debugLineNum = 1835014;BA.debugLine="Return Space(1)";
if (true) return _space[(int) (1)];
 };
RDebugUtils.currentLine=1835017;
 //BA.debugLineNum = 1835017;BA.debugLine="End Sub";
return "";
}
public static String  _clientinvio(String _read) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "clientinvio"))
	return (String) Debug.delegate(processBA, "clientinvio", new Object[] {_read});
anywheresoftware.b4a.objects.streams.File.TextReaderWrapper _tr = null;
anywheresoftware.b4a.objects.streams.File.TextWriterWrapper _tw = null;
String _fileconf = "";
boolean _beginlogin = false;
String _readpasswd = "";
String[] _spacenick = null;
String[] _solonick = null;
String[] _linefile = null;
String[] _onlypass = null;
String[] _soloserver = null;
String _soloporta = "";
String[] _spazioriga = null;
String[] _porta = null;
String[] _stringconnection = null;
String _realdata = "";
String _numero = "";
int _i = 0;
RDebugUtils.currentLine=1966080;
 //BA.debugLineNum = 1966080;BA.debugLine="Sub ClientInvio(Read As String)";
RDebugUtils.currentLine=1966082;
 //BA.debugLineNum = 1966082;BA.debugLine="Dim tr As TextReader";
_tr = new anywheresoftware.b4a.objects.streams.File.TextReaderWrapper();
RDebugUtils.currentLine=1966083;
 //BA.debugLineNum = 1966083;BA.debugLine="Dim tw As TextWriter";
_tw = new anywheresoftware.b4a.objects.streams.File.TextWriterWrapper();
RDebugUtils.currentLine=1966086;
 //BA.debugLineNum = 1966086;BA.debugLine="If Read.Contains(\"CAP LS\") = True Then";
if (_read.contains("CAP LS")==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966087;
 //BA.debugLineNum = 1966087;BA.debugLine="IRClient = True";
_irclient = anywheresoftware.b4a.keywords.Common.True;
 };
RDebugUtils.currentLine=1966093;
 //BA.debugLineNum = 1966093;BA.debugLine="If Read.Contains(\"NICK\") AND IRClient == True AN";
if (_read.contains("NICK") && _irclient==anywheresoftware.b4a.keywords.Common.True && _joinpasswd==anywheresoftware.b4a.keywords.Common.False) { 
RDebugUtils.currentLine=1966094;
 //BA.debugLineNum = 1966094;BA.debugLine="tr.Initialize( socket_ricezione_dati.InputStrea";
_tr.Initialize(_socket_ricezione_dati.getInputStream());
RDebugUtils.currentLine=1966095;
 //BA.debugLineNum = 1966095;BA.debugLine="tw.Initialize( socket_ricezione_dati.OutputStre";
_tw.Initialize(_socket_ricezione_dati.getOutputStream());
RDebugUtils.currentLine=1966096;
 //BA.debugLineNum = 1966096;BA.debugLine="tw.WriteLine(\": Welcome NOTICE :psyBNC 0.1\")";
_tw.WriteLine(": Welcome NOTICE :psyBNC 0.1");
RDebugUtils.currentLine=1966097;
 //BA.debugLineNum = 1966097;BA.debugLine="tw.WriteLine(\": -psyBNC NOTICE :Your IRC Client";
_tw.WriteLine(": -psyBNC NOTICE :Your IRC Client did not support a password. Please type /QUOTE PASS yourpassword to connect.");
RDebugUtils.currentLine=1966098;
 //BA.debugLineNum = 1966098;BA.debugLine="identIRC = Read.Replace(\"CAP LS\",\"\")";
_identirc = _read.replace("CAP LS","");
RDebugUtils.currentLine=1966099;
 //BA.debugLineNum = 1966099;BA.debugLine="tw.Flush";
_tw.Flush();
 };
RDebugUtils.currentLine=1966105;
 //BA.debugLineNum = 1966105;BA.debugLine="If Read.ToUpperCase.Contains(\"PASSWORD\") OR Read";
if (_read.toUpperCase().contains("PASSWORD") || _read.toUpperCase().contains("PASS") && _irclient==anywheresoftware.b4a.keywords.Common.True && _identirc.length()>0) { 
RDebugUtils.currentLine=1966107;
 //BA.debugLineNum = 1966107;BA.debugLine="Dim fileconf As String";
_fileconf = "";
RDebugUtils.currentLine=1966108;
 //BA.debugLineNum = 1966108;BA.debugLine="Dim BeginLogin As Boolean";
_beginlogin = false;
RDebugUtils.currentLine=1966110;
 //BA.debugLineNum = 1966110;BA.debugLine="Dim readpasswd As String";
_readpasswd = "";
RDebugUtils.currentLine=1966111;
 //BA.debugLineNum = 1966111;BA.debugLine="readpasswd = TogliPrimoComando(Read)";
_readpasswd = _togliprimocomando(_read);
RDebugUtils.currentLine=1966113;
 //BA.debugLineNum = 1966113;BA.debugLine="fileconf = ReadFile(\"psybnc.conf\")";
_fileconf = _readfile("psybnc.conf");
RDebugUtils.currentLine=1966115;
 //BA.debugLineNum = 1966115;BA.debugLine="If (fileconf.Length == 0)Then";
if ((_fileconf.length()==0)) { 
RDebugUtils.currentLine=1966118;
 //BA.debugLineNum = 1966118;BA.debugLine="WriteFile(\"psybnc.conf\", identIRC.Replace(Chr(";
_writefile("psybnc.conf",_identirc.replace(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (13))),""));
RDebugUtils.currentLine=1966119;
 //BA.debugLineNum = 1966119;BA.debugLine="WriteFile(\"psybnc.conf\", \"PASSWD \"&readpasswd)";
_writefile("psybnc.conf","PASSWD "+_readpasswd);
RDebugUtils.currentLine=1966120;
 //BA.debugLineNum = 1966120;BA.debugLine="Dim Spacenick() As String";
_spacenick = new String[(int) (0)];
java.util.Arrays.fill(_spacenick,"");
RDebugUtils.currentLine=1966121;
 //BA.debugLineNum = 1966121;BA.debugLine="Dim Solonick() As String";
_solonick = new String[(int) (0)];
java.util.Arrays.fill(_solonick,"");
RDebugUtils.currentLine=1966122;
 //BA.debugLineNum = 1966122;BA.debugLine="Spacenick = Regex.Split(Chr(32),identIRC)";
_spacenick = anywheresoftware.b4a.keywords.Common.Regex.Split(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (32))),_identirc);
RDebugUtils.currentLine=1966123;
 //BA.debugLineNum = 1966123;BA.debugLine="Solonick = Regex.Split(Chr(10),Spacenick(1))";
_solonick = anywheresoftware.b4a.keywords.Common.Regex.Split(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (10))),_spacenick[(int) (1)]);
RDebugUtils.currentLine=1966124;
 //BA.debugLineNum = 1966124;BA.debugLine="Nickconnessione = Solonick(0)";
_nickconnessione = _solonick[(int) (0)];
RDebugUtils.currentLine=1966126;
 //BA.debugLineNum = 1966126;BA.debugLine="Bhelp";
_bhelp();
RDebugUtils.currentLine=1966127;
 //BA.debugLineNum = 1966127;BA.debugLine="joinpasswd = True";
_joinpasswd = anywheresoftware.b4a.keywords.Common.True;
RDebugUtils.currentLine=1966128;
 //BA.debugLineNum = 1966128;BA.debugLine="Return \"\"";
if (true) return "";
 }else {
RDebugUtils.currentLine=1966131;
 //BA.debugLineNum = 1966131;BA.debugLine="Dim Linefile() As String";
_linefile = new String[(int) (0)];
java.util.Arrays.fill(_linefile,"");
RDebugUtils.currentLine=1966132;
 //BA.debugLineNum = 1966132;BA.debugLine="Dim onlypass() As String";
_onlypass = new String[(int) (0)];
java.util.Arrays.fill(_onlypass,"");
RDebugUtils.currentLine=1966133;
 //BA.debugLineNum = 1966133;BA.debugLine="Linefile = Regex.split(Chr(13),fileconf)";
_linefile = anywheresoftware.b4a.keywords.Common.Regex.Split(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (13))),_fileconf);
RDebugUtils.currentLine=1966134;
 //BA.debugLineNum = 1966134;BA.debugLine="onlypass = Regex.split(Chr(32),Linefile(2))";
_onlypass = anywheresoftware.b4a.keywords.Common.Regex.Split(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (32))),_linefile[(int) (2)]);
RDebugUtils.currentLine=1966136;
 //BA.debugLineNum = 1966136;BA.debugLine="If onlypass(1) == readpasswd.SubString2(0,rea";
if ((_onlypass[(int) (1)]).equals(_readpasswd.substring((int) (0),(int) (_readpasswd.length()-1)))) { 
RDebugUtils.currentLine=1966137;
 //BA.debugLineNum = 1966137;BA.debugLine="joinpasswd = True";
_joinpasswd = anywheresoftware.b4a.keywords.Common.True;
RDebugUtils.currentLine=1966138;
 //BA.debugLineNum = 1966138;BA.debugLine="QueryMSG";
_querymsg();
RDebugUtils.currentLine=1966139;
 //BA.debugLineNum = 1966139;BA.debugLine="If Linefile.Length > 3 Then";
if (_linefile.length>3) { 
RDebugUtils.currentLine=1966141;
 //BA.debugLineNum = 1966141;BA.debugLine="If socket_invio_dati.Connected = False Then";
if (_socket_invio_dati.getConnected()==anywheresoftware.b4a.keywords.Common.False) { 
RDebugUtils.currentLine=1966142;
 //BA.debugLineNum = 1966142;BA.debugLine="Bhelp";
_bhelp();
 }else {
RDebugUtils.currentLine=1966144;
 //BA.debugLineNum = 1966144;BA.debugLine="RejoinChannel";
_rejoinchannel();
 };
 };
RDebugUtils.currentLine=1966147;
 //BA.debugLineNum = 1966147;BA.debugLine="Return \"\"";
if (true) return "";
 };
 };
 };
RDebugUtils.currentLine=1966154;
 //BA.debugLineNum = 1966154;BA.debugLine="If Read.ToUpperCase.Contains(\"ADDSERVER\") AND IR";
if (_read.toUpperCase().contains("ADDSERVER") && _irclient==anywheresoftware.b4a.keywords.Common.True && _joinpasswd==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966155;
 //BA.debugLineNum = 1966155;BA.debugLine="Dim soloserver() As String";
_soloserver = new String[(int) (0)];
java.util.Arrays.fill(_soloserver,"");
RDebugUtils.currentLine=1966156;
 //BA.debugLineNum = 1966156;BA.debugLine="Dim soloporta As String";
_soloporta = "";
RDebugUtils.currentLine=1966157;
 //BA.debugLineNum = 1966157;BA.debugLine="Read = TogliPrimoComando(Read.ToUpperCase)";
_read = _togliprimocomando(_read.toUpperCase());
RDebugUtils.currentLine=1966158;
 //BA.debugLineNum = 1966158;BA.debugLine="soloserver  = Regex.split(\":\",Read.ToUpperCas";
_soloserver = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_read.toUpperCase());
RDebugUtils.currentLine=1966159;
 //BA.debugLineNum = 1966159;BA.debugLine="If soloserver.Length -1 > 0 Then";
if (_soloserver.length-1>0) { 
RDebugUtils.currentLine=1966160;
 //BA.debugLineNum = 1966160;BA.debugLine="soloporta = soloserver(1)";
_soloporta = _soloserver[(int) (1)];
RDebugUtils.currentLine=1966161;
 //BA.debugLineNum = 1966161;BA.debugLine="WriteFileRiga(\"psybnc.conf\",\"server \"&solos";
_writefileriga("psybnc.conf","server "+_soloserver[(int) (0)]+":"+_soloporta,(long) (4));
RDebugUtils.currentLine=1966162;
 //BA.debugLineNum = 1966162;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC Server";
_writesocket(":-psyBNC PRIVMSG psyBNC Server "+_soloserver[(int) (0)]+" port "+_soloporta+" (password: None) added.");
 }else {
RDebugUtils.currentLine=1966165;
 //BA.debugLineNum = 1966165;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC No ser";
_writesocket(":-psyBNC PRIVMSG psyBNC No server given. Syntax Is ADDSERVER hostname ::port");
 };
RDebugUtils.currentLine=1966167;
 //BA.debugLineNum = 1966167;BA.debugLine="Return \"\"";
if (true) return "";
 };
RDebugUtils.currentLine=1966172;
 //BA.debugLineNum = 1966172;BA.debugLine="If Read.ToUpperCase.Contains(\"LISTSERVERS\") AND";
if (_read.toUpperCase().contains("LISTSERVERS") && _irclient==anywheresoftware.b4a.keywords.Common.True && _joinpasswd==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966173;
 //BA.debugLineNum = 1966173;BA.debugLine="Dim SpazioRiga() As String";
_spazioriga = new String[(int) (0)];
java.util.Arrays.fill(_spazioriga,"");
RDebugUtils.currentLine=1966174;
 //BA.debugLineNum = 1966174;BA.debugLine="Dim porta()  As String";
_porta = new String[(int) (0)];
java.util.Arrays.fill(_porta,"");
RDebugUtils.currentLine=1966175;
 //BA.debugLineNum = 1966175;BA.debugLine="SpazioRiga = Regex.Split(\" \",LeggiFileRiga(\"psy";
_spazioriga = anywheresoftware.b4a.keywords.Common.Regex.Split(" ",_leggifileriga("psybnc.conf",(long) (3)));
RDebugUtils.currentLine=1966176;
 //BA.debugLineNum = 1966176;BA.debugLine="If SpazioRiga.Length > 1 Then";
if (_spazioriga.length>1) { 
RDebugUtils.currentLine=1966177;
 //BA.debugLineNum = 1966177;BA.debugLine="porta = Regex.Split(\":\",SpazioRiga(1))";
_porta = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_spazioriga[(int) (1)]);
RDebugUtils.currentLine=1966178;
 //BA.debugLineNum = 1966178;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC Server #1";
_writesocket(":-psyBNC PRIVMSG psyBNC Server #1:"+_spazioriga[(int) (1)]+" port "+_porta[(int) (1)]);
 };
RDebugUtils.currentLine=1966180;
 //BA.debugLineNum = 1966180;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC End of Ser";
_writesocket(":-psyBNC PRIVMSG psyBNC End of Servers.");
RDebugUtils.currentLine=1966181;
 //BA.debugLineNum = 1966181;BA.debugLine="Return \"\"";
if (true) return "";
 };
RDebugUtils.currentLine=1966186;
 //BA.debugLineNum = 1966186;BA.debugLine="If Read.ToUpperCase.Contains(\"JUMP\") AND IRClien";
if (_read.toUpperCase().contains("JUMP") && _irclient==anywheresoftware.b4a.keywords.Common.True && _joinpasswd==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966187;
 //BA.debugLineNum = 1966187;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC Jump New S";
_writesocket(":-psyBNC PRIVMSG psyBNC Jump New Server.");
RDebugUtils.currentLine=1966188;
 //BA.debugLineNum = 1966188;BA.debugLine="socket_invio_dati.close";
_socket_invio_dati.Close();
RDebugUtils.currentLine=1966189;
 //BA.debugLineNum = 1966189;BA.debugLine="Dim SpazioRiga() As String";
_spazioriga = new String[(int) (0)];
java.util.Arrays.fill(_spazioriga,"");
RDebugUtils.currentLine=1966190;
 //BA.debugLineNum = 1966190;BA.debugLine="Dim StringConnection()  As String";
_stringconnection = new String[(int) (0)];
java.util.Arrays.fill(_stringconnection,"");
RDebugUtils.currentLine=1966191;
 //BA.debugLineNum = 1966191;BA.debugLine="SpazioRiga = Regex.Split(\" \",LeggiFileRiga(\"psy";
_spazioriga = anywheresoftware.b4a.keywords.Common.Regex.Split(" ",_leggifileriga("psybnc.conf",(long) (3)));
RDebugUtils.currentLine=1966192;
 //BA.debugLineNum = 1966192;BA.debugLine="Dim RealData As String";
_realdata = "";
RDebugUtils.currentLine=1966193;
 //BA.debugLineNum = 1966193;BA.debugLine="RealData = GeneraDAtaUnix";
_realdata = _generadataunix();
RDebugUtils.currentLine=1966194;
 //BA.debugLineNum = 1966194;BA.debugLine="If SpazioRiga.Length > 1 Then";
if (_spazioriga.length>1) { 
RDebugUtils.currentLine=1966195;
 //BA.debugLineNum = 1966195;BA.debugLine="StringConnection = Regex.Split(\":\",SpazioRiga(";
_stringconnection = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_spazioriga[(int) (1)]);
RDebugUtils.currentLine=1966196;
 //BA.debugLineNum = 1966196;BA.debugLine="If StringConnection.Length = 2 Then";
if (_stringconnection.length==2) { 
RDebugUtils.currentLine=1966197;
 //BA.debugLineNum = 1966197;BA.debugLine="Topichannel.Clear";
_topichannel.Clear();
RDebugUtils.currentLine=1966198;
 //BA.debugLineNum = 1966198;BA.debugLine="socket_invio_dati.Close";
_socket_invio_dati.Close();
RDebugUtils.currentLine=1966199;
 //BA.debugLineNum = 1966199;BA.debugLine="socket_invio_dati.Initialize(\"socket_invio_da";
_socket_invio_dati.Initialize("socket_invio_dati");
RDebugUtils.currentLine=1966200;
 //BA.debugLineNum = 1966200;BA.debugLine="socket_invio_dati.Connect(StringConnection(0)";
_socket_invio_dati.Connect(processBA,_stringconnection[(int) (0)],(int)(Double.parseDouble(_stringconnection[(int) (1)])),(int) (1000));
RDebugUtils.currentLine=1966201;
 //BA.debugLineNum = 1966201;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC \"&RealDa";
_writesocket(":-psyBNC PRIVMSG psyBNC "+_realdata+" :User "+_solouser(_identirc)+" () trying "+_stringconnection[(int) (0)]+" port "+_stringconnection[(int) (1)]+" ().");
 };
 };
 };
RDebugUtils.currentLine=1966206;
 //BA.debugLineNum = 1966206;BA.debugLine="If Read.ToUpperCase.Contains(\"BHELP\") AND IRClie";
if (_read.toUpperCase().contains("BHELP") && _irclient==anywheresoftware.b4a.keywords.Common.True && _joinpasswd==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966207;
 //BA.debugLineNum = 1966207;BA.debugLine="Bhelp";
_bhelp();
 };
RDebugUtils.currentLine=1966212;
 //BA.debugLineNum = 1966212;BA.debugLine="If Read.ToUpperCase.Contains(\"DELSERVER\") AND IR";
if (_read.toUpperCase().contains("DELSERVER") && _irclient==anywheresoftware.b4a.keywords.Common.True && _joinpasswd==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966213;
 //BA.debugLineNum = 1966213;BA.debugLine="Dim numero As String";
_numero = "";
RDebugUtils.currentLine=1966214;
 //BA.debugLineNum = 1966214;BA.debugLine="numero = TogliPrimoComando(Read).Replace(Chr(";
_numero = _togliprimocomando(_read).replace(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (10))),"");
RDebugUtils.currentLine=1966215;
 //BA.debugLineNum = 1966215;BA.debugLine="If numero = \"1\" Then";
if ((_numero).equals("1")) { 
RDebugUtils.currentLine=1966216;
 //BA.debugLineNum = 1966216;BA.debugLine="WriteFileRiga(\"psybnc.conf\",\"server\",4)";
_writefileriga("psybnc.conf","server",(long) (4));
RDebugUtils.currentLine=1966217;
 //BA.debugLineNum = 1966217;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC Server";
_writesocket(":-psyBNC PRIVMSG psyBNC Server 1 deleted.");
 };
RDebugUtils.currentLine=1966219;
 //BA.debugLineNum = 1966219;BA.debugLine="Return \"\"";
if (true) return "";
 };
RDebugUtils.currentLine=1966224;
 //BA.debugLineNum = 1966224;BA.debugLine="If Read.ToUpperCase.Contains(\"PLAYPRIVATELOG\") A";
if (_read.toUpperCase().contains("PLAYPRIVATELOG") && _irclient==anywheresoftware.b4a.keywords.Common.True && _joinpasswd==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966225;
 //BA.debugLineNum = 1966225;BA.debugLine="If MessageQuery.IsInitialized = True Then";
if (_messagequery.IsInitialized()==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966226;
 //BA.debugLineNum = 1966226;BA.debugLine="If MessageQuery.size-1 >= 0 Then";
if (_messagequery.getSize()-1>=0) { 
RDebugUtils.currentLine=1966227;
 //BA.debugLineNum = 1966227;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psybnc Starting";
_writesocket(":-psyBNC PRIVMSG psybnc Starting playing Log");
RDebugUtils.currentLine=1966228;
 //BA.debugLineNum = 1966228;BA.debugLine="For i = 0 To MessageQuery.size -1";
{
final int step110 = 1;
final int limit110 = (int) (_messagequery.getSize()-1);
for (_i = (int) (0) ; (step110 > 0 && _i <= limit110) || (step110 < 0 && _i >= limit110); _i = ((int)(0 + _i + step110)) ) {
RDebugUtils.currentLine=1966229;
 //BA.debugLineNum = 1966229;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC \"& Mes";
_writesocket(":-psyBNC PRIVMSG psyBNC "+BA.ObjectToString(_messagequery.Get(_i)));
 }
};
RDebugUtils.currentLine=1966231;
 //BA.debugLineNum = 1966231;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC Use ERAS";
_writesocket(":-psyBNC PRIVMSG psyBNC Use ERASEPRIVATELOG to kill the log");
 };
 };
RDebugUtils.currentLine=1966234;
 //BA.debugLineNum = 1966234;BA.debugLine="Return \"\"";
if (true) return "";
 };
RDebugUtils.currentLine=1966239;
 //BA.debugLineNum = 1966239;BA.debugLine="If Read.ToUpperCase.Contains(\"ERASEPRIVATELOG\")";
if (_read.toUpperCase().contains("ERASEPRIVATELOG") && _irclient==anywheresoftware.b4a.keywords.Common.True && _joinpasswd==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966240;
 //BA.debugLineNum = 1966240;BA.debugLine="If MessageQuery.IsInitialized = True Then";
if (_messagequery.IsInitialized()==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966241;
 //BA.debugLineNum = 1966241;BA.debugLine="MessageQuery.Clear";
_messagequery.Clear();
RDebugUtils.currentLine=1966242;
 //BA.debugLineNum = 1966242;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC Log erase";
_writesocket(":-psyBNC PRIVMSG psyBNC Log erased");
 };
RDebugUtils.currentLine=1966244;
 //BA.debugLineNum = 1966244;BA.debugLine="Return \"\"";
if (true) return "";
 };
RDebugUtils.currentLine=1966249;
 //BA.debugLineNum = 1966249;BA.debugLine="If Read.ToUpperCase.Contains(\"SETAWAYNICK\") AND";
if (_read.toUpperCase().contains("SETAWAYNICK") && _irclient==anywheresoftware.b4a.keywords.Common.True && _joinpasswd==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966250;
 //BA.debugLineNum = 1966250;BA.debugLine="AwayNick = TogliPrimoComando(Read).Replace(Chr";
_awaynick = _togliprimocomando(_read).replace(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (10))),"");
RDebugUtils.currentLine=1966251;
 //BA.debugLineNum = 1966251;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC AWAY-Nick";
_writesocket(":-psyBNC PRIVMSG psyBNC AWAY-Nick changed to '"+_awaynick+"'.");
RDebugUtils.currentLine=1966252;
 //BA.debugLineNum = 1966252;BA.debugLine="Return \"\"";
if (true) return "";
 };
RDebugUtils.currentLine=1966258;
 //BA.debugLineNum = 1966258;BA.debugLine="If Read.ToUpperCase.Contains(\"QUIT :\") == False";
if (_read.toUpperCase().contains("QUIT :")==anywheresoftware.b4a.keywords.Common.False && _irclient==anywheresoftware.b4a.keywords.Common.True && _joinpasswd==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966259;
 //BA.debugLineNum = 1966259;BA.debugLine="WriteSocketIrc(Read)";
_writesocketirc(_read);
 }else {
RDebugUtils.currentLine=1966262;
 //BA.debugLineNum = 1966262;BA.debugLine="If Read.ToUpperCase.Contains(\"QUIT :\") == True";
if (_read.toUpperCase().contains("QUIT :")==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1966264;
 //BA.debugLineNum = 1966264;BA.debugLine="NormalNick = Nickconnessione";
_normalnick = _nickconnessione;
RDebugUtils.currentLine=1966265;
 //BA.debugLineNum = 1966265;BA.debugLine="WriteSocketIrc(\"nick \"&AwayNick)";
_writesocketirc("nick "+_awaynick);
RDebugUtils.currentLine=1966266;
 //BA.debugLineNum = 1966266;BA.debugLine="IRClient = False";
_irclient = anywheresoftware.b4a.keywords.Common.False;
RDebugUtils.currentLine=1966267;
 //BA.debugLineNum = 1966267;BA.debugLine="joinpasswd = False";
_joinpasswd = anywheresoftware.b4a.keywords.Common.False;
 };
 };
RDebugUtils.currentLine=1966272;
 //BA.debugLineNum = 1966272;BA.debugLine="End Sub";
return "";
}
public static String  _togliprimocomando(String _read) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "togliprimocomando"))
	return (String) Debug.delegate(processBA, "togliprimocomando", new Object[] {_read});
String[] _spazio = null;
String _nuovocomando = "";
int _start = 0;
RDebugUtils.currentLine=1703936;
 //BA.debugLineNum = 1703936;BA.debugLine="Sub TogliPrimoComando(Read As String) As String";
RDebugUtils.currentLine=1703937;
 //BA.debugLineNum = 1703937;BA.debugLine="Dim spazio() As String";
_spazio = new String[(int) (0)];
java.util.Arrays.fill(_spazio,"");
RDebugUtils.currentLine=1703938;
 //BA.debugLineNum = 1703938;BA.debugLine="Dim nuovocomando As String";
_nuovocomando = "";
RDebugUtils.currentLine=1703939;
 //BA.debugLineNum = 1703939;BA.debugLine="spazio = Regex.Split(Chr(32),Read)";
_spazio = anywheresoftware.b4a.keywords.Common.Regex.Split(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (32))),_read);
RDebugUtils.currentLine=1703940;
 //BA.debugLineNum = 1703940;BA.debugLine="For start = 1 To spazio.Length -1";
{
final int step4 = 1;
final int limit4 = (int) (_spazio.length-1);
for (_start = (int) (1) ; (step4 > 0 && _start <= limit4) || (step4 < 0 && _start >= limit4); _start = ((int)(0 + _start + step4)) ) {
RDebugUtils.currentLine=1703941;
 //BA.debugLineNum = 1703941;BA.debugLine="If start == 1 Then";
if (_start==1) { 
RDebugUtils.currentLine=1703942;
 //BA.debugLineNum = 1703942;BA.debugLine="nuovocomando = spazio(start)";
_nuovocomando = _spazio[_start];
 }else {
RDebugUtils.currentLine=1703944;
 //BA.debugLineNum = 1703944;BA.debugLine="nuovocomando = nuovocomando & \" \" & spazio(sta";
_nuovocomando = _nuovocomando+" "+_spazio[_start];
 };
 }
};
RDebugUtils.currentLine=1703947;
 //BA.debugLineNum = 1703947;BA.debugLine="Return nuovocomando";
if (true) return _nuovocomando;
RDebugUtils.currentLine=1703948;
 //BA.debugLineNum = 1703948;BA.debugLine="End Sub";
return "";
}
public static String  _readfile(String _nomefile) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "readfile"))
	return (String) Debug.delegate(processBA, "readfile", new Object[] {_nomefile});
anywheresoftware.b4a.objects.streams.File.TextReaderWrapper _reader = null;
String _bufferfile = "";
String _line = "";
RDebugUtils.currentLine=786432;
 //BA.debugLineNum = 786432;BA.debugLine="Sub ReadFile(NomeFile As String)  As String";
RDebugUtils.currentLine=786433;
 //BA.debugLineNum = 786433;BA.debugLine="Dim Reader As TextReader";
_reader = new anywheresoftware.b4a.objects.streams.File.TextReaderWrapper();
RDebugUtils.currentLine=786434;
 //BA.debugLineNum = 786434;BA.debugLine="Dim BufferFile As String";
_bufferfile = "";
RDebugUtils.currentLine=786435;
 //BA.debugLineNum = 786435;BA.debugLine="If  File.Exists(File.DirInternal, NomeFile) == T";
if (anywheresoftware.b4a.keywords.Common.File.Exists(anywheresoftware.b4a.keywords.Common.File.getDirInternal(),_nomefile)==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=786436;
 //BA.debugLineNum = 786436;BA.debugLine="Reader.Initialize(File.OpenInput(File.DirInte";
_reader.Initialize((java.io.InputStream)(anywheresoftware.b4a.keywords.Common.File.OpenInput(anywheresoftware.b4a.keywords.Common.File.getDirInternal(),_nomefile).getObject()));
RDebugUtils.currentLine=786437;
 //BA.debugLineNum = 786437;BA.debugLine="Dim line As String";
_line = "";
RDebugUtils.currentLine=786438;
 //BA.debugLineNum = 786438;BA.debugLine="line = Reader.ReadLine";
_line = _reader.ReadLine();
RDebugUtils.currentLine=786439;
 //BA.debugLineNum = 786439;BA.debugLine="Do While line <> Null";
while (_line!= null) {
RDebugUtils.currentLine=786441;
 //BA.debugLineNum = 786441;BA.debugLine="If BufferFile.Length > 0 Then";
if (_bufferfile.length()>0) { 
RDebugUtils.currentLine=786442;
 //BA.debugLineNum = 786442;BA.debugLine="BufferFile = BufferFile & Chr(13) & line";
_bufferfile = _bufferfile+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (13)))+_line;
 }else {
RDebugUtils.currentLine=786444;
 //BA.debugLineNum = 786444;BA.debugLine="BufferFile = line";
_bufferfile = _line;
 };
RDebugUtils.currentLine=786446;
 //BA.debugLineNum = 786446;BA.debugLine="line = Reader.ReadLine";
_line = _reader.ReadLine();
 }
;
RDebugUtils.currentLine=786448;
 //BA.debugLineNum = 786448;BA.debugLine="Reader.Close";
_reader.Close();
 };
RDebugUtils.currentLine=786450;
 //BA.debugLineNum = 786450;BA.debugLine="Return BufferFile";
if (true) return _bufferfile;
RDebugUtils.currentLine=786451;
 //BA.debugLineNum = 786451;BA.debugLine="End Sub";
return "";
}
public static String  _writefile(String _nomefile,String _write) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "writefile"))
	return (String) Debug.delegate(processBA, "writefile", new Object[] {_nomefile,_write});
anywheresoftware.b4a.objects.streams.File.TextWriterWrapper _writer = null;
RDebugUtils.currentLine=851968;
 //BA.debugLineNum = 851968;BA.debugLine="Sub WriteFile(NOmeFile As String,Write As String )";
RDebugUtils.currentLine=851969;
 //BA.debugLineNum = 851969;BA.debugLine="Dim Writer As TextWriter";
_writer = new anywheresoftware.b4a.objects.streams.File.TextWriterWrapper();
RDebugUtils.currentLine=851970;
 //BA.debugLineNum = 851970;BA.debugLine="Writer.Initialize(File.OpenOutput(File.DirInternal";
_writer.Initialize((java.io.OutputStream)(anywheresoftware.b4a.keywords.Common.File.OpenOutput(anywheresoftware.b4a.keywords.Common.File.getDirInternal(),_nomefile,anywheresoftware.b4a.keywords.Common.True).getObject()));
RDebugUtils.currentLine=851971;
 //BA.debugLineNum = 851971;BA.debugLine="Writer.Write(Write)";
_writer.Write(_write);
RDebugUtils.currentLine=851972;
 //BA.debugLineNum = 851972;BA.debugLine="Writer.Close";
_writer.Close();
RDebugUtils.currentLine=851973;
 //BA.debugLineNum = 851973;BA.debugLine="End Sub";
return "";
}
public static String  _querymsg() throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "querymsg"))
	return (String) Debug.delegate(processBA, "querymsg", null);
anywheresoftware.b4a.objects.streams.File.TextReaderWrapper _tr = null;
anywheresoftware.b4a.objects.streams.File.TextWriterWrapper _tw = null;
RDebugUtils.currentLine=1441792;
 //BA.debugLineNum = 1441792;BA.debugLine="Sub QueryMSG()";
RDebugUtils.currentLine=1441793;
 //BA.debugLineNum = 1441793;BA.debugLine="If MessageQuery.IsInitialized = True Then";
if (_messagequery.IsInitialized()==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1441794;
 //BA.debugLineNum = 1441794;BA.debugLine="Dim tr As TextReader";
_tr = new anywheresoftware.b4a.objects.streams.File.TextReaderWrapper();
RDebugUtils.currentLine=1441795;
 //BA.debugLineNum = 1441795;BA.debugLine="Dim tw As TextWriter";
_tw = new anywheresoftware.b4a.objects.streams.File.TextWriterWrapper();
RDebugUtils.currentLine=1441796;
 //BA.debugLineNum = 1441796;BA.debugLine="tr.Initialize( socket_ricezione_dati.InputStream";
_tr.Initialize(_socket_ricezione_dati.getInputStream());
RDebugUtils.currentLine=1441797;
 //BA.debugLineNum = 1441797;BA.debugLine="tw.Initialize( socket_ricezione_dati.OutputStrea";
_tw.Initialize(_socket_ricezione_dati.getOutputStream());
RDebugUtils.currentLine=1441798;
 //BA.debugLineNum = 1441798;BA.debugLine="If MessageQuery.Size = 0 Then";
if (_messagequery.getSize()==0) { 
RDebugUtils.currentLine=1441799;
 //BA.debugLineNum = 1441799;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC You have";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC You have no new Messages.");
 }else {
RDebugUtils.currentLine=1441801;
 //BA.debugLineNum = 1441801;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC You have";
_tw.WriteLine(":-psyBNC PRIVMSG psyBNC You have Messages. Type /QUOTE PLAYPRIVATELOG To read your messages.");
 };
RDebugUtils.currentLine=1441803;
 //BA.debugLineNum = 1441803;BA.debugLine="tw.Flush";
_tw.Flush();
 };
RDebugUtils.currentLine=1441805;
 //BA.debugLineNum = 1441805;BA.debugLine="End Sub";
return "";
}
public static String  _rejoinchannel() throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "rejoinchannel"))
	return (String) Debug.delegate(processBA, "rejoinchannel", null);
long _i = 0L;
RDebugUtils.currentLine=1769472;
 //BA.debugLineNum = 1769472;BA.debugLine="Sub RejoinChannel() As String";
RDebugUtils.currentLine=1769473;
 //BA.debugLineNum = 1769473;BA.debugLine="If SaveMoth.Length > 0 Then";
if (_savemoth.length()>0) { 
RDebugUtils.currentLine=1769474;
 //BA.debugLineNum = 1769474;BA.debugLine="Dim I As Long";
_i = 0L;
RDebugUtils.currentLine=1769475;
 //BA.debugLineNum = 1769475;BA.debugLine="WriteSocketIrc(\"nick \"&NormalNick)";
_writesocketirc("nick "+_normalnick);
RDebugUtils.currentLine=1769476;
 //BA.debugLineNum = 1769476;BA.debugLine="WriteSocket(SaveMoth.Replace(\"$nick :\",Nickconnes";
_writesocket(_savemoth.replace("$nick :",_nickconnessione+" :").replace("$nick!",_nickconnessione+"!"));
RDebugUtils.currentLine=1769477;
 //BA.debugLineNum = 1769477;BA.debugLine="For I = 0 To joinchannel.Size - 1";
{
final long step5 = 1;
final long limit5 = (long) (_joinchannel.getSize()-1);
for (_i = (long) (0) ; (step5 > 0 && _i <= limit5) || (step5 < 0 && _i >= limit5); _i = ((long)(0 + _i + step5)) ) {
RDebugUtils.currentLine=1769479;
 //BA.debugLineNum = 1769479;BA.debugLine="WriteSocket(\":\"&Nickconnessione &\"!psybnc@localh";
_writesocket(":"+_nickconnessione+"!psybnc@localhost.psybnc-arkosoft.com JOIN :"+BA.ObjectToString(_joinchannel.Get((int) (_i)))+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (13))));
RDebugUtils.currentLine=1769480;
 //BA.debugLineNum = 1769480;BA.debugLine="Try";
try {RDebugUtils.currentLine=1769481;
 //BA.debugLineNum = 1769481;BA.debugLine="WriteSocket(\":server.psybnc.com 332 \"&Nickcon";
_writesocket(":server.psybnc.com 332 "+_nickconnessione+" "+BA.ObjectToString(_joinchannel.Get((int) (_i)))+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (13)))+" :"+BA.ObjectToString(_topichannel.Get((int) (_i)))+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (13))));
 } 
       catch (Exception e10) {
			processBA.setLastException(e10); };
RDebugUtils.currentLine=1769484;
 //BA.debugLineNum = 1769484;BA.debugLine="WriteSocketIrc(\"join \"&joinchannel.Get(I))";
_writesocketirc("join "+BA.ObjectToString(_joinchannel.Get((int) (_i))));
RDebugUtils.currentLine=1769485;
 //BA.debugLineNum = 1769485;BA.debugLine="WriteSocketIrc(\"names \"&joinchannel.Get(I))";
_writesocketirc("names "+BA.ObjectToString(_joinchannel.Get((int) (_i))));
 }
};
 };
RDebugUtils.currentLine=1769489;
 //BA.debugLineNum = 1769489;BA.debugLine="End Sub";
return "";
}
public static String  _writefileriga(String _nomefile,String _buffer,long _riga) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "writefileriga"))
	return (String) Debug.delegate(processBA, "writefileriga", new Object[] {_nomefile,_buffer,_riga});
String[] _iline = null;
String _nuovobuffer = "";
anywheresoftware.b4a.objects.streams.File.TextWriterWrapper _writer = null;
int _start = 0;
RDebugUtils.currentLine=983040;
 //BA.debugLineNum = 983040;BA.debugLine="Sub WriteFileRiga(NomeFile As String,Buffer As Str";
RDebugUtils.currentLine=983041;
 //BA.debugLineNum = 983041;BA.debugLine="Dim iLine() As String";
_iline = new String[(int) (0)];
java.util.Arrays.fill(_iline,"");
RDebugUtils.currentLine=983042;
 //BA.debugLineNum = 983042;BA.debugLine="Dim NuovoBuffer As String";
_nuovobuffer = "";
RDebugUtils.currentLine=983043;
 //BA.debugLineNum = 983043;BA.debugLine="Dim Writer As TextWriter";
_writer = new anywheresoftware.b4a.objects.streams.File.TextWriterWrapper();
RDebugUtils.currentLine=983044;
 //BA.debugLineNum = 983044;BA.debugLine="Riga = Riga-1";
_riga = (long) (_riga-1);
RDebugUtils.currentLine=983045;
 //BA.debugLineNum = 983045;BA.debugLine="iLine = Regex.Split(Chr(13),ReadFile(NomeFile))";
_iline = anywheresoftware.b4a.keywords.Common.Regex.Split(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (13))),_readfile(_nomefile));
RDebugUtils.currentLine=983046;
 //BA.debugLineNum = 983046;BA.debugLine="If iLine.Length -1 < Riga  Then";
if (_iline.length-1<_riga) { 
RDebugUtils.currentLine=983047;
 //BA.debugLineNum = 983047;BA.debugLine="WriteFile(NomeFile,Buffer)";
_writefile(_nomefile,_buffer);
RDebugUtils.currentLine=983048;
 //BA.debugLineNum = 983048;BA.debugLine="Return \"\"";
if (true) return "";
 }else {
RDebugUtils.currentLine=983050;
 //BA.debugLineNum = 983050;BA.debugLine="For start = 0 To iLine.Length -1";
{
final int step10 = 1;
final int limit10 = (int) (_iline.length-1);
for (_start = (int) (0) ; (step10 > 0 && _start <= limit10) || (step10 < 0 && _start >= limit10); _start = ((int)(0 + _start + step10)) ) {
RDebugUtils.currentLine=983051;
 //BA.debugLineNum = 983051;BA.debugLine="If start = 0 Then";
if (_start==0) { 
RDebugUtils.currentLine=983052;
 //BA.debugLineNum = 983052;BA.debugLine="NuovoBuffer = iLine(start) & Chr(10)";
_nuovobuffer = _iline[_start]+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (10)));
 }else {
RDebugUtils.currentLine=983054;
 //BA.debugLineNum = 983054;BA.debugLine="If start = Riga Then";
if (_start==_riga) { 
RDebugUtils.currentLine=983055;
 //BA.debugLineNum = 983055;BA.debugLine="NuovoBuffer = NuovoBuffer & Buffer & Chr(10)";
_nuovobuffer = _nuovobuffer+_buffer+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (10)));
 }else {
RDebugUtils.currentLine=983057;
 //BA.debugLineNum = 983057;BA.debugLine="NuovoBuffer = NuovoBuffer & iLine(start) & Chr";
_nuovobuffer = _nuovobuffer+_iline[_start]+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (10)));
 };
 };
 }
};
 };
RDebugUtils.currentLine=983064;
 //BA.debugLineNum = 983064;BA.debugLine="Writer.Initialize(File.OpenOutput(File.DirInternal";
_writer.Initialize((java.io.OutputStream)(anywheresoftware.b4a.keywords.Common.File.OpenOutput(anywheresoftware.b4a.keywords.Common.File.getDirInternal(),_nomefile,anywheresoftware.b4a.keywords.Common.False).getObject()));
RDebugUtils.currentLine=983065;
 //BA.debugLineNum = 983065;BA.debugLine="Writer.Write(NuovoBuffer)";
_writer.Write(_nuovobuffer);
RDebugUtils.currentLine=983066;
 //BA.debugLineNum = 983066;BA.debugLine="Writer.Close";
_writer.Close();
RDebugUtils.currentLine=983068;
 //BA.debugLineNum = 983068;BA.debugLine="End Sub";
return "";
}
public static String  _writesocket(String _read) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "writesocket"))
	return (String) Debug.delegate(processBA, "writesocket", new Object[] {_read});
anywheresoftware.b4a.objects.streams.File.TextReaderWrapper _tr = null;
anywheresoftware.b4a.objects.streams.File.TextWriterWrapper _tw = null;
RDebugUtils.currentLine=1310720;
 //BA.debugLineNum = 1310720;BA.debugLine="Sub WriteSocket(Read As String)";
RDebugUtils.currentLine=1310721;
 //BA.debugLineNum = 1310721;BA.debugLine="Try";
try {RDebugUtils.currentLine=1310722;
 //BA.debugLineNum = 1310722;BA.debugLine="If socket_ricezione_dati.Connected == True AND jo";
if (_socket_ricezione_dati.getConnected()==anywheresoftware.b4a.keywords.Common.True && _joinpasswd==anywheresoftware.b4a.keywords.Common.True && _read.length()>0) { 
RDebugUtils.currentLine=1310724;
 //BA.debugLineNum = 1310724;BA.debugLine="Dim tr As TextReader";
_tr = new anywheresoftware.b4a.objects.streams.File.TextReaderWrapper();
RDebugUtils.currentLine=1310725;
 //BA.debugLineNum = 1310725;BA.debugLine="Dim tw As TextWriter";
_tw = new anywheresoftware.b4a.objects.streams.File.TextWriterWrapper();
RDebugUtils.currentLine=1310726;
 //BA.debugLineNum = 1310726;BA.debugLine="tr.Initialize( socket_ricezione_dati.InputStrea";
_tr.Initialize(_socket_ricezione_dati.getInputStream());
RDebugUtils.currentLine=1310727;
 //BA.debugLineNum = 1310727;BA.debugLine="tw.Initialize( socket_ricezione_dati.OutputStre";
_tw.Initialize(_socket_ricezione_dati.getOutputStream());
RDebugUtils.currentLine=1310728;
 //BA.debugLineNum = 1310728;BA.debugLine="tw.WriteLine(Read)";
_tw.WriteLine(_read);
RDebugUtils.currentLine=1310729;
 //BA.debugLineNum = 1310729;BA.debugLine="tw.Flush";
_tw.Flush();
RDebugUtils.currentLine=1310730;
 //BA.debugLineNum = 1310730;BA.debugLine="Return Read";
if (true) return _read;
 };
 } 
       catch (Exception e12) {
			processBA.setLastException(e12);RDebugUtils.currentLine=1310733;
 //BA.debugLineNum = 1310733;BA.debugLine="socket_ricezione_dati.Close";
_socket_ricezione_dati.Close();
 };
RDebugUtils.currentLine=1310735;
 //BA.debugLineNum = 1310735;BA.debugLine="End Sub";
return "";
}
public static String  _leggifileriga(String _nomefile,long _riga) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "leggifileriga"))
	return (String) Debug.delegate(processBA, "leggifileriga", new Object[] {_nomefile,_riga});
String[] _iline = null;
RDebugUtils.currentLine=917504;
 //BA.debugLineNum = 917504;BA.debugLine="Sub LeggiFileRiga(NomeFile As String,Riga As Long)";
RDebugUtils.currentLine=917505;
 //BA.debugLineNum = 917505;BA.debugLine="Dim iLine() As String";
_iline = new String[(int) (0)];
java.util.Arrays.fill(_iline,"");
RDebugUtils.currentLine=917506;
 //BA.debugLineNum = 917506;BA.debugLine="iLine = Regex.Split(Chr(13),ReadFile(NomeFile))";
_iline = anywheresoftware.b4a.keywords.Common.Regex.Split(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (13))),_readfile(_nomefile));
RDebugUtils.currentLine=917508;
 //BA.debugLineNum = 917508;BA.debugLine="If  iLine.Length > 0 Then";
if (_iline.length>0) { 
RDebugUtils.currentLine=917509;
 //BA.debugLineNum = 917509;BA.debugLine="If  Riga < iLine.Length Then";
if (_riga<_iline.length) { 
RDebugUtils.currentLine=917510;
 //BA.debugLineNum = 917510;BA.debugLine="Return iLine(Riga)";
if (true) return _iline[(int) (_riga)];
 }else {
RDebugUtils.currentLine=917512;
 //BA.debugLineNum = 917512;BA.debugLine="Return \"\"";
if (true) return "";
 };
 }else {
RDebugUtils.currentLine=917515;
 //BA.debugLineNum = 917515;BA.debugLine="Return \"\"";
if (true) return "";
 };
RDebugUtils.currentLine=917517;
 //BA.debugLineNum = 917517;BA.debugLine="End Sub";
return "";
}
public static String  _generadataunix() throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "generadataunix"))
	return (String) Debug.delegate(processBA, "generadataunix", null);
long _now = 0L;
String _realdate = "";
String[] _weekdaysstr = null;
String[] _mouth = null;
RDebugUtils.currentLine=1114112;
 //BA.debugLineNum = 1114112;BA.debugLine="Sub GeneraDAtaUnix()";
RDebugUtils.currentLine=1114113;
 //BA.debugLineNum = 1114113;BA.debugLine="Dim now As Long";
_now = 0L;
RDebugUtils.currentLine=1114114;
 //BA.debugLineNum = 1114114;BA.debugLine="Dim RealDate As String";
_realdate = "";
RDebugUtils.currentLine=1114115;
 //BA.debugLineNum = 1114115;BA.debugLine="now = DateTime.now";
_now = anywheresoftware.b4a.keywords.Common.DateTime.getNow();
RDebugUtils.currentLine=1114116;
 //BA.debugLineNum = 1114116;BA.debugLine="Dim WeekDaysStr() As String";
_weekdaysstr = new String[(int) (0)];
java.util.Arrays.fill(_weekdaysstr,"");
RDebugUtils.currentLine=1114117;
 //BA.debugLineNum = 1114117;BA.debugLine="Dim Mouth() As String";
_mouth = new String[(int) (0)];
java.util.Arrays.fill(_mouth,"");
RDebugUtils.currentLine=1114118;
 //BA.debugLineNum = 1114118;BA.debugLine="WeekDaysStr = Array As String (\"Sun\", \"Mon\", \"Tue";
_weekdaysstr = new String[]{"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
RDebugUtils.currentLine=1114119;
 //BA.debugLineNum = 1114119;BA.debugLine="Mouth = Array As String (\"Jan\", \"Feb\",\"Mar\", \"Apr";
_mouth = new String[]{"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec"};
RDebugUtils.currentLine=1114120;
 //BA.debugLineNum = 1114120;BA.debugLine="RealDate = WeekDaysStr(DateTime.GetDayOfWeek(now)";
_realdate = _weekdaysstr[(int) (anywheresoftware.b4a.keywords.Common.DateTime.GetDayOfWeek(_now)-1)]+" "+_mouth[(int) (anywheresoftware.b4a.keywords.Common.DateTime.GetMonth(_now)-1)]+" "+BA.NumberToString(anywheresoftware.b4a.keywords.Common.DateTime.GetDayOfMonth(_now))+" "+BA.NumberToString(anywheresoftware.b4a.keywords.Common.DateTime.GetHour(_now))+":"+BA.NumberToString(anywheresoftware.b4a.keywords.Common.DateTime.GetMinute(_now))+":"+BA.NumberToString(anywheresoftware.b4a.keywords.Common.DateTime.GetSecond(_now));
RDebugUtils.currentLine=1114121;
 //BA.debugLineNum = 1114121;BA.debugLine="Return RealDate";
if (true) return _realdate;
RDebugUtils.currentLine=1114122;
 //BA.debugLineNum = 1114122;BA.debugLine="End Sub";
return "";
}
public static String  _writesocketirc(String _read) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "writesocketirc"))
	return (String) Debug.delegate(processBA, "writesocketirc", new Object[] {_read});
anywheresoftware.b4a.objects.streams.File.TextReaderWrapper _tr = null;
anywheresoftware.b4a.objects.streams.File.TextWriterWrapper _tw = null;
String _realdata = "";
int _i = 0;
RDebugUtils.currentLine=1376256;
 //BA.debugLineNum = 1376256;BA.debugLine="Sub WriteSocketIrc(Read As String)";
RDebugUtils.currentLine=1376257;
 //BA.debugLineNum = 1376257;BA.debugLine="Try";
try {RDebugUtils.currentLine=1376258;
 //BA.debugLineNum = 1376258;BA.debugLine="If socket_invio_dati.Connected = True Then";
if (_socket_invio_dati.getConnected()==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1376259;
 //BA.debugLineNum = 1376259;BA.debugLine="Dim tr As TextReader";
_tr = new anywheresoftware.b4a.objects.streams.File.TextReaderWrapper();
RDebugUtils.currentLine=1376260;
 //BA.debugLineNum = 1376260;BA.debugLine="Dim tw As TextWriter";
_tw = new anywheresoftware.b4a.objects.streams.File.TextWriterWrapper();
RDebugUtils.currentLine=1376261;
 //BA.debugLineNum = 1376261;BA.debugLine="tr.Initialize(socket_invio_dati.InputStream)";
_tr.Initialize(_socket_invio_dati.getInputStream());
RDebugUtils.currentLine=1376262;
 //BA.debugLineNum = 1376262;BA.debugLine="tw.Initialize(socket_invio_dati.OutputStream)";
_tw.Initialize(_socket_invio_dati.getOutputStream());
RDebugUtils.currentLine=1376263;
 //BA.debugLineNum = 1376263;BA.debugLine="tw.WriteLine(Read)";
_tw.WriteLine(_read);
RDebugUtils.currentLine=1376264;
 //BA.debugLineNum = 1376264;BA.debugLine="tw.Flush";
_tw.Flush();
RDebugUtils.currentLine=1376265;
 //BA.debugLineNum = 1376265;BA.debugLine="Return Read";
if (true) return _read;
 };
 } 
       catch (Exception e12) {
			processBA.setLastException(e12);RDebugUtils.currentLine=1376268;
 //BA.debugLineNum = 1376268;BA.debugLine="If IRClient == True AND joinpasswd = True Then";
if (_irclient==anywheresoftware.b4a.keywords.Common.True && _joinpasswd==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1376270;
 //BA.debugLineNum = 1376270;BA.debugLine="Dim RealData As String";
_realdata = "";
RDebugUtils.currentLine=1376271;
 //BA.debugLineNum = 1376271;BA.debugLine="RealData = GeneraDAtaUnix";
_realdata = _generadataunix();
RDebugUtils.currentLine=1376272;
 //BA.debugLineNum = 1376272;BA.debugLine="For I = 0 To joinchannel.Size - 1";
{
final int step15 = 1;
final int limit15 = (int) (_joinchannel.getSize()-1);
for (_i = (int) (0) ; (step15 > 0 && _i <= limit15) || (step15 < 0 && _i >= limit15); _i = ((int)(0 + _i + step15)) ) {
RDebugUtils.currentLine=1376273;
 //BA.debugLineNum = 1376273;BA.debugLine="WriteSocket(\":\"&Nickconnessione&\" PART \"&joinc";
_writesocket(":"+_nickconnessione+" PART "+BA.ObjectToString(_joinchannel.Get(_i)));
 }
};
RDebugUtils.currentLine=1376275;
 //BA.debugLineNum = 1376275;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC \"&RealData";
_writesocket(":-psyBNC PRIVMSG psyBNC "+_realdata+" User "+_solouser(_identirc)+" got disconnected from server.");
 };
RDebugUtils.currentLine=1376277;
 //BA.debugLineNum = 1376277;BA.debugLine="socket_invio_dati.close";
_socket_invio_dati.Close();
 };
RDebugUtils.currentLine=1376281;
 //BA.debugLineNum = 1376281;BA.debugLine="End Sub";
return "";
}
public static String  _datisocket_ricezione_irc_newdata(byte[] _buffer) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "datisocket_ricezione_irc_newdata"))
	return (String) Debug.delegate(processBA, "datisocket_ricezione_irc_newdata", new Object[] {_buffer});
RDebugUtils.currentLine=2097152;
 //BA.debugLineNum = 2097152;BA.debugLine="Sub datisocket_ricezione_irc_NewData (buffer() As";
RDebugUtils.currentLine=2097153;
 //BA.debugLineNum = 2097153;BA.debugLine="WriteSocket(Ricezione_Server((BytesToString(buffer";
_writesocket(_ricezione_server((anywheresoftware.b4a.keywords.Common.BytesToString(_buffer,(int) (0),_buffer.length,"UTF8"))));
RDebugUtils.currentLine=2097154;
 //BA.debugLineNum = 2097154;BA.debugLine="End Sub";
return "";
}
public static String  _ricezione_server(String _read) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "ricezione_server"))
	return (String) Debug.delegate(processBA, "ricezione_server", new Object[] {_read});
String[] _pingstring = null;
String[] _rigaread = null;
String[] _numeroraw = null;
long _start = 0L;
String _changemoth = "";
int _nmrandom = 0;
String _f = "";
String _tildechan = "";
String[] _solovhost = null;
String _realdate = "";
String _messagetext = "";
String[] _solomsg = null;
String[] _solonick = null;
String[] _senzaduepunti = null;
String[] _realchan = null;
int _i = 0;
String _nomecanale = "";
String[] _toglipunti = null;
String[] _nuovonick = null;
RDebugUtils.currentLine=1245184;
 //BA.debugLineNum = 1245184;BA.debugLine="Sub Ricezione_Server(Read As String )";
RDebugUtils.currentLine=1245190;
 //BA.debugLineNum = 1245190;BA.debugLine="Dim PingString() As String";
_pingstring = new String[(int) (0)];
java.util.Arrays.fill(_pingstring,"");
RDebugUtils.currentLine=1245191;
 //BA.debugLineNum = 1245191;BA.debugLine="PingString = Regex.Split(\":\",Read)";
_pingstring = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_read);
RDebugUtils.currentLine=1245192;
 //BA.debugLineNum = 1245192;BA.debugLine="If PingString(0) = \"PING \" Then";
if ((_pingstring[(int) (0)]).equals("PING ")) { 
RDebugUtils.currentLine=1245193;
 //BA.debugLineNum = 1245193;BA.debugLine="WriteSocketIrc(\"PONG \"&PingString(1)&Chr(13))";
_writesocketirc("PONG "+_pingstring[(int) (1)]+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (13))));
RDebugUtils.currentLine=1245194;
 //BA.debugLineNum = 1245194;BA.debugLine="AutoPing = True";
_autoping = anywheresoftware.b4a.keywords.Common.True;
RDebugUtils.currentLine=1245195;
 //BA.debugLineNum = 1245195;BA.debugLine="Return \"\"";
if (true) return "";
 };
RDebugUtils.currentLine=1245203;
 //BA.debugLineNum = 1245203;BA.debugLine="Dim RigaRead() As String";
_rigaread = new String[(int) (0)];
java.util.Arrays.fill(_rigaread,"");
RDebugUtils.currentLine=1245204;
 //BA.debugLineNum = 1245204;BA.debugLine="Dim NumeroRaw() As String";
_numeroraw = new String[(int) (0)];
java.util.Arrays.fill(_numeroraw,"");
RDebugUtils.currentLine=1245205;
 //BA.debugLineNum = 1245205;BA.debugLine="Dim Start As Long";
_start = 0L;
RDebugUtils.currentLine=1245206;
 //BA.debugLineNum = 1245206;BA.debugLine="RigaRead = Regex.Split(Chr(13),Read)";
_rigaread = anywheresoftware.b4a.keywords.Common.Regex.Split(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (13))),_read);
RDebugUtils.currentLine=1245207;
 //BA.debugLineNum = 1245207;BA.debugLine="For Start = 0 To RigaRead.Length -1";
{
final long step12 = 1;
final long limit12 = (long) (_rigaread.length-1);
for (_start = (long) (0) ; (step12 > 0 && _start <= limit12) || (step12 < 0 && _start >= limit12); _start = ((long)(0 + _start + step12)) ) {
RDebugUtils.currentLine=1245208;
 //BA.debugLineNum = 1245208;BA.debugLine="If RigaRead(Start).Contains(Chr(32)) == True The";
if (_rigaread[(int) (_start)].contains(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (32))))==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1245209;
 //BA.debugLineNum = 1245209;BA.debugLine="NumeroRaw = Regex.Split(Chr(32),RigaRead(Star";
_numeroraw = anywheresoftware.b4a.keywords.Common.Regex.Split(BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (32))),_rigaread[(int) (_start)]);
RDebugUtils.currentLine=1245211;
 //BA.debugLineNum = 1245211;BA.debugLine="If NumeroRaw.Length = 1 Then Return \"\"";
if (_numeroraw.length==1) { 
if (true) return "";};
RDebugUtils.currentLine=1245213;
 //BA.debugLineNum = 1245213;BA.debugLine="If NumeroRaw(1) = \"376\" Then";
if ((_numeroraw[(int) (1)]).equals("376")) { 
RDebugUtils.currentLine=1245214;
 //BA.debugLineNum = 1245214;BA.debugLine="SaveMoth =  SaveMoth & RigaRead(Start) & Chr(";
_savemoth = _savemoth+_rigaread[(int) (_start)]+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (32)));
RDebugUtils.currentLine=1245215;
 //BA.debugLineNum = 1245215;BA.debugLine="StopMoth = False";
_stopmoth = anywheresoftware.b4a.keywords.Common.False;
RDebugUtils.currentLine=1245216;
 //BA.debugLineNum = 1245216;BA.debugLine="RejoinChannel";
_rejoinchannel();
 };
RDebugUtils.currentLine=1245219;
 //BA.debugLineNum = 1245219;BA.debugLine="If StopMoth = True Then";
if (_stopmoth==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1245220;
 //BA.debugLineNum = 1245220;BA.debugLine="SaveMoth =  SaveMoth & RigaRead(Start) & Chr(";
_savemoth = _savemoth+_rigaread[(int) (_start)]+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (32)));
 };
RDebugUtils.currentLine=1245227;
 //BA.debugLineNum = 1245227;BA.debugLine="If NumeroRaw(1) = \"001\" Then";
if ((_numeroraw[(int) (1)]).equals("001")) { 
RDebugUtils.currentLine=1245228;
 //BA.debugLineNum = 1245228;BA.debugLine="StopMoth = True";
_stopmoth = anywheresoftware.b4a.keywords.Common.True;
RDebugUtils.currentLine=1245229;
 //BA.debugLineNum = 1245229;BA.debugLine="Nickconnessione = NumeroRaw(2)";
_nickconnessione = _numeroraw[(int) (2)];
RDebugUtils.currentLine=1245230;
 //BA.debugLineNum = 1245230;BA.debugLine="changemoth = RigaRead(Start).Replace(Nickconn";
_changemoth = _rigaread[(int) (_start)].replace(_nickconnessione+" :","$nick :").replace(_nickconnessione+"!","$nick!");
RDebugUtils.currentLine=1245231;
 //BA.debugLineNum = 1245231;BA.debugLine="SaveMoth =  changemoth & Chr(32)";
_savemoth = _changemoth+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (32)));
 };
RDebugUtils.currentLine=1245237;
 //BA.debugLineNum = 1245237;BA.debugLine="If NumeroRaw(1)=\"433\" AND Nickconnessione.Leng";
if ((_numeroraw[(int) (1)]).equals("433") && _nickconnessione.length()>0 && _joinpasswd==anywheresoftware.b4a.keywords.Common.False) { 
RDebugUtils.currentLine=1245238;
 //BA.debugLineNum = 1245238;BA.debugLine="Dim nmrandom As Int";
_nmrandom = 0;
RDebugUtils.currentLine=1245239;
 //BA.debugLineNum = 1245239;BA.debugLine="Dim f As String";
_f = "";
RDebugUtils.currentLine=1245240;
 //BA.debugLineNum = 1245240;BA.debugLine="nmrandom = Rnd(1,10)";
_nmrandom = anywheresoftware.b4a.keywords.Common.Rnd((int) (1),(int) (10));
RDebugUtils.currentLine=1245241;
 //BA.debugLineNum = 1245241;BA.debugLine="f= nmrandom";
_f = BA.NumberToString(_nmrandom);
RDebugUtils.currentLine=1245242;
 //BA.debugLineNum = 1245242;BA.debugLine="WriteSocketIrc(\"nick \"&Nickconnessione&f)";
_writesocketirc("nick "+_nickconnessione+_f);
 };
RDebugUtils.currentLine=1245248;
 //BA.debugLineNum = 1245248;BA.debugLine="If NumeroRaw(1) = \"PRIVMSG\" AND joinpasswd = F";
if ((_numeroraw[(int) (1)]).equals("PRIVMSG") && _joinpasswd==anywheresoftware.b4a.keywords.Common.False) { 
RDebugUtils.currentLine=1245249;
 //BA.debugLineNum = 1245249;BA.debugLine="Dim TildeChan As String";
_tildechan = "";
RDebugUtils.currentLine=1245250;
 //BA.debugLineNum = 1245250;BA.debugLine="TildeChan = NumeroRaw(2).SubString2(0,1)";
_tildechan = _numeroraw[(int) (2)].substring((int) (0),(int) (1));
RDebugUtils.currentLine=1245251;
 //BA.debugLineNum = 1245251;BA.debugLine="If TildeChan <> \"#\" AND TildeChan <> \"&\" Then";
if ((_tildechan).equals("#") == false && (_tildechan).equals("&") == false) { 
RDebugUtils.currentLine=1245253;
 //BA.debugLineNum = 1245253;BA.debugLine="Dim SoloVhost() As String";
_solovhost = new String[(int) (0)];
java.util.Arrays.fill(_solovhost,"");
RDebugUtils.currentLine=1245255;
 //BA.debugLineNum = 1245255;BA.debugLine="Dim RealDate As String";
_realdate = "";
RDebugUtils.currentLine=1245256;
 //BA.debugLineNum = 1245256;BA.debugLine="SoloVhost = Regex.Split(\":\",NumeroRaw(0))";
_solovhost = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_numeroraw[(int) (0)]);
RDebugUtils.currentLine=1245257;
 //BA.debugLineNum = 1245257;BA.debugLine="RealDate = GeneraDAtaUnix";
_realdate = _generadataunix();
RDebugUtils.currentLine=1245258;
 //BA.debugLineNum = 1245258;BA.debugLine="Dim Start As Long";
_start = 0L;
RDebugUtils.currentLine=1245259;
 //BA.debugLineNum = 1245259;BA.debugLine="Dim MessageText As String";
_messagetext = "";
RDebugUtils.currentLine=1245260;
 //BA.debugLineNum = 1245260;BA.debugLine="For Start = 3 To NumeroRaw.Length -1";
{
final long step47 = 1;
final long limit47 = (long) (_numeroraw.length-1);
for (_start = (long) (3) ; (step47 > 0 && _start <= limit47) || (step47 < 0 && _start >= limit47); _start = ((long)(0 + _start + step47)) ) {
RDebugUtils.currentLine=1245261;
 //BA.debugLineNum = 1245261;BA.debugLine="If Start = 3 Then";
if (_start==3) { 
RDebugUtils.currentLine=1245262;
 //BA.debugLineNum = 1245262;BA.debugLine="Dim SoloMSG() As String";
_solomsg = new String[(int) (0)];
java.util.Arrays.fill(_solomsg,"");
RDebugUtils.currentLine=1245263;
 //BA.debugLineNum = 1245263;BA.debugLine="SoloMSG = Regex.Split(\":\",NumeroRaw(3))";
_solomsg = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_numeroraw[(int) (3)]);
RDebugUtils.currentLine=1245264;
 //BA.debugLineNum = 1245264;BA.debugLine="MessageText = SoloMSG(1)";
_messagetext = _solomsg[(int) (1)];
 }else {
RDebugUtils.currentLine=1245266;
 //BA.debugLineNum = 1245266;BA.debugLine="MessageText = MessageText & \" \" & NumeroRa";
_messagetext = _messagetext+" "+_numeroraw[(int) (_start)];
 };
 }
};
RDebugUtils.currentLine=1245269;
 //BA.debugLineNum = 1245269;BA.debugLine="MessageQuery.AddAll(Array As String(RealDate";
_messagequery.AddAll(anywheresoftware.b4a.keywords.Common.ArrayToList(new String[]{_realdate+" :("+_solovhost[(int) (1)]+")"+" "+_messagetext}));
 };
 };
RDebugUtils.currentLine=1245275;
 //BA.debugLineNum = 1245275;BA.debugLine="If NumeroRaw(1) = \"JOIN\" Then";
if ((_numeroraw[(int) (1)]).equals("JOIN")) { 
RDebugUtils.currentLine=1245276;
 //BA.debugLineNum = 1245276;BA.debugLine="Dim SolOnick() As String";
_solonick = new String[(int) (0)];
java.util.Arrays.fill(_solonick,"");
RDebugUtils.currentLine=1245277;
 //BA.debugLineNum = 1245277;BA.debugLine="Dim SenzaDuePunti() As  String";
_senzaduepunti = new String[(int) (0)];
java.util.Arrays.fill(_senzaduepunti,"");
RDebugUtils.currentLine=1245278;
 //BA.debugLineNum = 1245278;BA.debugLine="SolOnick = Regex.Split(\"!\",NumeroRaw(0))";
_solonick = anywheresoftware.b4a.keywords.Common.Regex.Split("!",_numeroraw[(int) (0)]);
RDebugUtils.currentLine=1245279;
 //BA.debugLineNum = 1245279;BA.debugLine="SenzaDuePunti = Regex.Split(\":\",SolOnick(0))";
_senzaduepunti = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_solonick[(int) (0)]);
RDebugUtils.currentLine=1245280;
 //BA.debugLineNum = 1245280;BA.debugLine="If SenzaDuePunti(1) = Nickconnessione Then";
if ((_senzaduepunti[(int) (1)]).equals(_nickconnessione)) { 
RDebugUtils.currentLine=1245281;
 //BA.debugLineNum = 1245281;BA.debugLine="Dim RealChan() As String";
_realchan = new String[(int) (0)];
java.util.Arrays.fill(_realchan,"");
RDebugUtils.currentLine=1245282;
 //BA.debugLineNum = 1245282;BA.debugLine="RealChan = Regex.Split(\":\",NumeroRaw(2))";
_realchan = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_numeroraw[(int) (2)]);
RDebugUtils.currentLine=1245283;
 //BA.debugLineNum = 1245283;BA.debugLine="joinchannel.AddAll(Array As String(RealChan(";
_joinchannel.AddAll(anywheresoftware.b4a.keywords.Common.ArrayToList(new String[]{_realchan[(int) (1)]}));
RDebugUtils.currentLine=1245284;
 //BA.debugLineNum = 1245284;BA.debugLine="Topichannel.addAll(Array As String(\"\"))";
_topichannel.AddAll(anywheresoftware.b4a.keywords.Common.ArrayToList(new String[]{""}));
 };
 };
RDebugUtils.currentLine=1245288;
 //BA.debugLineNum = 1245288;BA.debugLine="If NumeroRaw(1) =\"332\" Then";
if ((_numeroraw[(int) (1)]).equals("332")) { 
RDebugUtils.currentLine=1245289;
 //BA.debugLineNum = 1245289;BA.debugLine="For i = 0 To joinchannel.Size - 1";
{
final int step72 = 1;
final int limit72 = (int) (_joinchannel.getSize()-1);
for (_i = (int) (0) ; (step72 > 0 && _i <= limit72) || (step72 < 0 && _i >= limit72); _i = ((int)(0 + _i + step72)) ) {
RDebugUtils.currentLine=1245290;
 //BA.debugLineNum = 1245290;BA.debugLine="If NumeroRaw(3) = joinchannel.Get(i) Then";
if ((_numeroraw[(int) (3)]).equals(BA.ObjectToString(_joinchannel.Get(_i)))) { 
RDebugUtils.currentLine=1245291;
 //BA.debugLineNum = 1245291;BA.debugLine="SaveTopic(i,NumeroRaw)";
_savetopic((long) (_i),_numeroraw);
 };
 }
};
 };
RDebugUtils.currentLine=1245300;
 //BA.debugLineNum = 1245300;BA.debugLine="If NumeroRaw(1) = \"PART\" Then";
if ((_numeroraw[(int) (1)]).equals("PART")) { 
RDebugUtils.currentLine=1245301;
 //BA.debugLineNum = 1245301;BA.debugLine="Dim SolOnick() As String";
_solonick = new String[(int) (0)];
java.util.Arrays.fill(_solonick,"");
RDebugUtils.currentLine=1245302;
 //BA.debugLineNum = 1245302;BA.debugLine="Dim SenzaDuePunti() As  String";
_senzaduepunti = new String[(int) (0)];
java.util.Arrays.fill(_senzaduepunti,"");
RDebugUtils.currentLine=1245303;
 //BA.debugLineNum = 1245303;BA.debugLine="Dim nomecanale As String";
_nomecanale = "";
RDebugUtils.currentLine=1245304;
 //BA.debugLineNum = 1245304;BA.debugLine="SolOnick = Regex.Split(\"!\",NumeroRaw(0))";
_solonick = anywheresoftware.b4a.keywords.Common.Regex.Split("!",_numeroraw[(int) (0)]);
RDebugUtils.currentLine=1245305;
 //BA.debugLineNum = 1245305;BA.debugLine="SenzaDuePunti = Regex.Split(\":\",SolOnick(0))";
_senzaduepunti = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_solonick[(int) (0)]);
RDebugUtils.currentLine=1245306;
 //BA.debugLineNum = 1245306;BA.debugLine="If SenzaDuePunti(1) = Nickconnessione Then";
if ((_senzaduepunti[(int) (1)]).equals(_nickconnessione)) { 
RDebugUtils.currentLine=1245307;
 //BA.debugLineNum = 1245307;BA.debugLine="For i = 0 To joinchannel.Size - 1";
{
final int step85 = 1;
final int limit85 = (int) (_joinchannel.getSize()-1);
for (_i = (int) (0) ; (step85 > 0 && _i <= limit85) || (step85 < 0 && _i >= limit85); _i = ((int)(0 + _i + step85)) ) {
RDebugUtils.currentLine=1245308;
 //BA.debugLineNum = 1245308;BA.debugLine="If i <= joinchannel.Size -1 Then";
if (_i<=_joinchannel.getSize()-1) { 
RDebugUtils.currentLine=1245309;
 //BA.debugLineNum = 1245309;BA.debugLine="nomecanale = joinchannel.Get(i)";
_nomecanale = BA.ObjectToString(_joinchannel.Get(_i));
RDebugUtils.currentLine=1245310;
 //BA.debugLineNum = 1245310;BA.debugLine="If NumeroRaw(2) = nomecanale Then";
if ((_numeroraw[(int) (2)]).equals(_nomecanale)) { 
RDebugUtils.currentLine=1245311;
 //BA.debugLineNum = 1245311;BA.debugLine="If joinchannel.get(i) <> Null Then joinc";
if (_joinchannel.Get(_i)!= null) { 
_joinchannel.RemoveAt(_i);};
RDebugUtils.currentLine=1245312;
 //BA.debugLineNum = 1245312;BA.debugLine="If Topichannel.get(i) <> Null Then Topic";
if (_topichannel.Get(_i)!= null) { 
_topichannel.RemoveAt(_i);};
 };
 };
 }
};
 };
RDebugUtils.currentLine=1245317;
 //BA.debugLineNum = 1245317;BA.debugLine="Return Read";
if (true) return _read;
 };
RDebugUtils.currentLine=1245322;
 //BA.debugLineNum = 1245322;BA.debugLine="If NumeroRaw(1) = \"TOPIC\" Then";
if ((_numeroraw[(int) (1)]).equals("TOPIC")) { 
RDebugUtils.currentLine=1245323;
 //BA.debugLineNum = 1245323;BA.debugLine="For i = 0 To joinchannel.Size - 1";
{
final int step98 = 1;
final int limit98 = (int) (_joinchannel.getSize()-1);
for (_i = (int) (0) ; (step98 > 0 && _i <= limit98) || (step98 < 0 && _i >= limit98); _i = ((int)(0 + _i + step98)) ) {
RDebugUtils.currentLine=1245324;
 //BA.debugLineNum = 1245324;BA.debugLine="If NumeroRaw(2) = joinchannel.Get(i) Then";
if ((_numeroraw[(int) (2)]).equals(BA.ObjectToString(_joinchannel.Get(_i)))) { 
RDebugUtils.currentLine=1245325;
 //BA.debugLineNum = 1245325;BA.debugLine="SaveTopic(i,NumeroRaw)";
_savetopic((long) (_i),_numeroraw);
 };
 }
};
RDebugUtils.currentLine=1245328;
 //BA.debugLineNum = 1245328;BA.debugLine="Return Read";
if (true) return _read;
 };
RDebugUtils.currentLine=1245333;
 //BA.debugLineNum = 1245333;BA.debugLine="If NumeroRaw(1) = \"NICK\" Then";
if ((_numeroraw[(int) (1)]).equals("NICK")) { 
RDebugUtils.currentLine=1245334;
 //BA.debugLineNum = 1245334;BA.debugLine="Dim SolOnick() As String";
_solonick = new String[(int) (0)];
java.util.Arrays.fill(_solonick,"");
RDebugUtils.currentLine=1245335;
 //BA.debugLineNum = 1245335;BA.debugLine="Dim TogliPunti() As String";
_toglipunti = new String[(int) (0)];
java.util.Arrays.fill(_toglipunti,"");
RDebugUtils.currentLine=1245336;
 //BA.debugLineNum = 1245336;BA.debugLine="SolOnick = Regex.Split(\"!\",NumeroRaw(0))";
_solonick = anywheresoftware.b4a.keywords.Common.Regex.Split("!",_numeroraw[(int) (0)]);
RDebugUtils.currentLine=1245337;
 //BA.debugLineNum = 1245337;BA.debugLine="TogliPunti = Regex.Split(\":\",SolOnick(0))";
_toglipunti = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_solonick[(int) (0)]);
RDebugUtils.currentLine=1245338;
 //BA.debugLineNum = 1245338;BA.debugLine="If TogliPunti(1) = Nickconnessione Then";
if ((_toglipunti[(int) (1)]).equals(_nickconnessione)) { 
RDebugUtils.currentLine=1245339;
 //BA.debugLineNum = 1245339;BA.debugLine="Dim NuovoNick() As String";
_nuovonick = new String[(int) (0)];
java.util.Arrays.fill(_nuovonick,"");
RDebugUtils.currentLine=1245340;
 //BA.debugLineNum = 1245340;BA.debugLine="NuovoNick = Regex.Split(\":\",NumeroRaw(2))";
_nuovonick = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_numeroraw[(int) (2)]);
RDebugUtils.currentLine=1245341;
 //BA.debugLineNum = 1245341;BA.debugLine="Nickconnessione =NuovoNick(1)";
_nickconnessione = _nuovonick[(int) (1)];
 };
RDebugUtils.currentLine=1245343;
 //BA.debugLineNum = 1245343;BA.debugLine="Return Read";
if (true) return _read;
 };
RDebugUtils.currentLine=1245348;
 //BA.debugLineNum = 1245348;BA.debugLine="If NumeroRaw(1) = \"KICK\" Then";
if ((_numeroraw[(int) (1)]).equals("KICK")) { 
RDebugUtils.currentLine=1245349;
 //BA.debugLineNum = 1245349;BA.debugLine="If NumeroRaw(3) = Nickconnessione Then";
if ((_numeroraw[(int) (3)]).equals(_nickconnessione)) { 
RDebugUtils.currentLine=1245350;
 //BA.debugLineNum = 1245350;BA.debugLine="For i = 0 To joinchannel.Size - 1";
{
final int step119 = 1;
final int limit119 = (int) (_joinchannel.getSize()-1);
for (_i = (int) (0) ; (step119 > 0 && _i <= limit119) || (step119 < 0 && _i >= limit119); _i = ((int)(0 + _i + step119)) ) {
RDebugUtils.currentLine=1245351;
 //BA.debugLineNum = 1245351;BA.debugLine="If NumeroRaw(2) = joinchannel.Get(i) Then";
if ((_numeroraw[(int) (2)]).equals(BA.ObjectToString(_joinchannel.Get(_i)))) { 
RDebugUtils.currentLine=1245352;
 //BA.debugLineNum = 1245352;BA.debugLine="joinchannel.RemoveAt(i)";
_joinchannel.RemoveAt(_i);
RDebugUtils.currentLine=1245353;
 //BA.debugLineNum = 1245353;BA.debugLine="Topichannel.removeAt(i)";
_topichannel.RemoveAt(_i);
 };
 }
};
 };
RDebugUtils.currentLine=1245357;
 //BA.debugLineNum = 1245357;BA.debugLine="Return Read";
if (true) return _read;
 };
 };
 }
};
RDebugUtils.currentLine=1245365;
 //BA.debugLineNum = 1245365;BA.debugLine="Return Read";
if (true) return _read;
RDebugUtils.currentLine=1245367;
 //BA.debugLineNum = 1245367;BA.debugLine="End Sub";
return "";
}
public static String  _datisocket_ricezione_newdata(byte[] _buffer) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "datisocket_ricezione_newdata"))
	return (String) Debug.delegate(processBA, "datisocket_ricezione_newdata", new Object[] {_buffer});
RDebugUtils.currentLine=2031616;
 //BA.debugLineNum = 2031616;BA.debugLine="Sub datisocket_ricezione_NewData (buffer() As Byte";
RDebugUtils.currentLine=2031617;
 //BA.debugLineNum = 2031617;BA.debugLine="ClientInvio(BytesToString(buffer, 0, buffer.Length";
_clientinvio(anywheresoftware.b4a.keywords.Common.BytesToString(_buffer,(int) (0),_buffer.length,"UTF8"));
RDebugUtils.currentLine=2031618;
 //BA.debugLineNum = 2031618;BA.debugLine="End Sub";
return "";
}
public static String  _pingtimer_tick() throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "pingtimer_tick"))
	return (String) Debug.delegate(processBA, "pingtimer_tick", null);
RDebugUtils.currentLine=1179648;
 //BA.debugLineNum = 1179648;BA.debugLine="Sub PingTimer_Tick";
RDebugUtils.currentLine=1179649;
 //BA.debugLineNum = 1179649;BA.debugLine="If AutoPing = True Then";
if (_autoping==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1179650;
 //BA.debugLineNum = 1179650;BA.debugLine="WriteSocketIrc(\"PING :TIMEOUTCHECK\"&Chr(10))";
_writesocketirc("PING :TIMEOUTCHECK"+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (10))));
RDebugUtils.currentLine=1179651;
 //BA.debugLineNum = 1179651;BA.debugLine="AutoPing=False";
_autoping = anywheresoftware.b4a.keywords.Common.False;
 };
RDebugUtils.currentLine=1179653;
 //BA.debugLineNum = 1179653;BA.debugLine="End Sub";
return "";
}
public static String  _savetopic(long _i,String[] _numeroraw) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "savetopic"))
	return (String) Debug.delegate(processBA, "savetopic", new Object[] {_i,_numeroraw});
long _p = 0L;
String _totaletopic = "";
String[] _senzapunti = null;
RDebugUtils.currentLine=1048576;
 //BA.debugLineNum = 1048576;BA.debugLine="Sub SaveTopic(i As Long,NumeroRaw() As String)";
RDebugUtils.currentLine=1048581;
 //BA.debugLineNum = 1048581;BA.debugLine="If NumeroRaw(1) = \"TOPIC\" Then";
if ((_numeroraw[(int) (1)]).equals("TOPIC")) { 
RDebugUtils.currentLine=1048582;
 //BA.debugLineNum = 1048582;BA.debugLine="Dim p As Long";
_p = 0L;
RDebugUtils.currentLine=1048583;
 //BA.debugLineNum = 1048583;BA.debugLine="Dim TotaleTopic As String";
_totaletopic = "";
RDebugUtils.currentLine=1048584;
 //BA.debugLineNum = 1048584;BA.debugLine="TotaleTopic = \"\"";
_totaletopic = "";
RDebugUtils.currentLine=1048585;
 //BA.debugLineNum = 1048585;BA.debugLine="For p = 3 To NumeroRaw.Length -1";
{
final long step5 = 1;
final long limit5 = (long) (_numeroraw.length-1);
for (_p = (long) (3) ; (step5 > 0 && _p <= limit5) || (step5 < 0 && _p >= limit5); _p = ((long)(0 + _p + step5)) ) {
RDebugUtils.currentLine=1048586;
 //BA.debugLineNum = 1048586;BA.debugLine="If p = 3 Then";
if (_p==3) { 
RDebugUtils.currentLine=1048587;
 //BA.debugLineNum = 1048587;BA.debugLine="Dim TotaleTopic As String";
_totaletopic = "";
RDebugUtils.currentLine=1048588;
 //BA.debugLineNum = 1048588;BA.debugLine="Dim SenzaPunti() As String";
_senzapunti = new String[(int) (0)];
java.util.Arrays.fill(_senzapunti,"");
RDebugUtils.currentLine=1048589;
 //BA.debugLineNum = 1048589;BA.debugLine="SenzaPunti =  Regex.Split(\":\",NumeroRaw(p))";
_senzapunti = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_numeroraw[(int) (_p)]);
RDebugUtils.currentLine=1048590;
 //BA.debugLineNum = 1048590;BA.debugLine="TotaleTopic = SenzaPunti(1) & Chr(32)";
_totaletopic = _senzapunti[(int) (1)]+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (32)));
 }else {
RDebugUtils.currentLine=1048592;
 //BA.debugLineNum = 1048592;BA.debugLine="If p = NumeroRaw.Length -1 Then";
if (_p==_numeroraw.length-1) { 
RDebugUtils.currentLine=1048593;
 //BA.debugLineNum = 1048593;BA.debugLine="TotaleTopic = TotaleTopic  & NumeroRaw(p)";
_totaletopic = _totaletopic+_numeroraw[(int) (_p)];
 }else {
RDebugUtils.currentLine=1048595;
 //BA.debugLineNum = 1048595;BA.debugLine="TotaleTopic = TotaleTopic  & NumeroRaw(p) & Ch";
_totaletopic = _totaletopic+_numeroraw[(int) (_p)]+BA.ObjectToString(anywheresoftware.b4a.keywords.Common.Chr((int) (32)));
 };
 };
 }
};
 }else {
RDebugUtils.currentLine=1048600;
 //BA.debugLineNum = 1048600;BA.debugLine="Dim p As Long";
_p = 0L;
RDebugUtils.currentLine=1048601;
 //BA.debugLineNum = 1048601;BA.debugLine="For p = 4 To NumeroRaw.Length -1";
{
final long step21 = 1;
final long limit21 = (long) (_numeroraw.length-1);
for (_p = (long) (4) ; (step21 > 0 && _p <= limit21) || (step21 < 0 && _p >= limit21); _p = ((long)(0 + _p + step21)) ) {
RDebugUtils.currentLine=1048602;
 //BA.debugLineNum = 1048602;BA.debugLine="If p = 4 Then";
if (_p==4) { 
RDebugUtils.currentLine=1048603;
 //BA.debugLineNum = 1048603;BA.debugLine="Dim TotaleTopic As String";
_totaletopic = "";
RDebugUtils.currentLine=1048604;
 //BA.debugLineNum = 1048604;BA.debugLine="Dim SenzaPunti() As String";
_senzapunti = new String[(int) (0)];
java.util.Arrays.fill(_senzapunti,"");
RDebugUtils.currentLine=1048605;
 //BA.debugLineNum = 1048605;BA.debugLine="SenzaPunti =  Regex.Split(\":\",NumeroRaw(p))";
_senzapunti = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_numeroraw[(int) (_p)]);
RDebugUtils.currentLine=1048606;
 //BA.debugLineNum = 1048606;BA.debugLine="TotaleTopic = SenzaPunti(1)";
_totaletopic = _senzapunti[(int) (1)];
 }else {
RDebugUtils.currentLine=1048608;
 //BA.debugLineNum = 1048608;BA.debugLine="TotaleTopic = TotaleTopic  & \" \"& NumeroRaw(p)";
_totaletopic = _totaletopic+" "+_numeroraw[(int) (_p)];
 };
 }
};
 };
RDebugUtils.currentLine=1048612;
 //BA.debugLineNum = 1048612;BA.debugLine="If i < Topichannel.Size Then";
if (_i<_topichannel.getSize()) { 
RDebugUtils.currentLine=1048613;
 //BA.debugLineNum = 1048613;BA.debugLine="Topichannel.Set(i, TotaleTopic)";
_topichannel.Set((int) (_i),(Object)(_totaletopic));
 };
RDebugUtils.currentLine=1048616;
 //BA.debugLineNum = 1048616;BA.debugLine="End Sub";
return "";
}
public static String  _server_newconnection(boolean _successful,anywheresoftware.b4a.objects.SocketWrapper _newsocket) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "server_newconnection"))
	return (String) Debug.delegate(processBA, "server_newconnection", new Object[] {_successful,_newsocket});
RDebugUtils.currentLine=655360;
 //BA.debugLineNum = 655360;BA.debugLine="Sub Server_NewConnection (Successful As Boolean, N";
RDebugUtils.currentLine=655361;
 //BA.debugLineNum = 655361;BA.debugLine="If Successful = True AND datisocket_ricezione.Is";
if (_successful==anywheresoftware.b4a.keywords.Common.True && _datisocket_ricezione.IsInitialized()==anywheresoftware.b4a.keywords.Common.False) { 
RDebugUtils.currentLine=655362;
 //BA.debugLineNum = 655362;BA.debugLine="socket_ricezione_dati = NewSocket";
_socket_ricezione_dati = _newsocket;
RDebugUtils.currentLine=655363;
 //BA.debugLineNum = 655363;BA.debugLine="datisocket_ricezione.Initialize(socket_ricezione";
_datisocket_ricezione.Initialize(processBA,_socket_ricezione_dati.getInputStream(),_socket_ricezione_dati.getOutputStream(),"datisocket_ricezione");
RDebugUtils.currentLine=655364;
 //BA.debugLineNum = 655364;BA.debugLine="server.Listen";
_server.Listen();
 };
RDebugUtils.currentLine=655366;
 //BA.debugLineNum = 655366;BA.debugLine="End Sub";
return "";
}
public static String  _service_create() throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "service_create"))
	return (String) Debug.delegate(processBA, "service_create", null);
RDebugUtils.currentLine=524288;
 //BA.debugLineNum = 524288;BA.debugLine="Sub Service_Create";
RDebugUtils.currentLine=524292;
 //BA.debugLineNum = 524292;BA.debugLine="End Sub";
return "";
}
public static String  _service_destroy() throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "service_destroy"))
	return (String) Debug.delegate(processBA, "service_destroy", null);
RDebugUtils.currentLine=720896;
 //BA.debugLineNum = 720896;BA.debugLine="Sub Service_Destroy";
RDebugUtils.currentLine=720898;
 //BA.debugLineNum = 720898;BA.debugLine="End Sub";
return "";
}
public static String  _service_start(anywheresoftware.b4a.objects.IntentWrapper _startingintent) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "service_start"))
	return (String) Debug.delegate(processBA, "service_start", new Object[] {_startingintent});
RDebugUtils.currentLine=589824;
 //BA.debugLineNum = 589824;BA.debugLine="Sub Service_Start (StartingIntent As Intent)";
RDebugUtils.currentLine=589825;
 //BA.debugLineNum = 589825;BA.debugLine="joinpasswd = False";
_joinpasswd = anywheresoftware.b4a.keywords.Common.False;
RDebugUtils.currentLine=589826;
 //BA.debugLineNum = 589826;BA.debugLine="server.Initialize(serverPort, \"Server\")";
_server.Initialize(processBA,(int)(Double.parseDouble(_serverport)),"Server");
RDebugUtils.currentLine=589827;
 //BA.debugLineNum = 589827;BA.debugLine="MyIP = server.GetMyIP";
_myip = _server.GetMyIP();
RDebugUtils.currentLine=589828;
 //BA.debugLineNum = 589828;BA.debugLine="server.listen";
_server.Listen();
RDebugUtils.currentLine=589829;
 //BA.debugLineNum = 589829;BA.debugLine="statesocket = True";
_statesocket = anywheresoftware.b4a.keywords.Common.True;
RDebugUtils.currentLine=589831;
 //BA.debugLineNum = 589831;BA.debugLine="Timerserver.Initialize(\"TimerServer\",100000)";
_timerserver.Initialize(processBA,"TimerServer",(long) (100000));
RDebugUtils.currentLine=589832;
 //BA.debugLineNum = 589832;BA.debugLine="Timerserver.Enabled = True";
_timerserver.setEnabled(anywheresoftware.b4a.keywords.Common.True);
RDebugUtils.currentLine=589834;
 //BA.debugLineNum = 589834;BA.debugLine="PingTimer.Initialize(\"pingTimer\",10000)";
_pingtimer.Initialize(processBA,"pingTimer",(long) (10000));
RDebugUtils.currentLine=589835;
 //BA.debugLineNum = 589835;BA.debugLine="PingTimer.Enabled = True";
_pingtimer.setEnabled(anywheresoftware.b4a.keywords.Common.True);
RDebugUtils.currentLine=589837;
 //BA.debugLineNum = 589837;BA.debugLine="joinchannel.initialize";
_joinchannel.Initialize();
RDebugUtils.currentLine=589838;
 //BA.debugLineNum = 589838;BA.debugLine="Topichannel.initialize";
_topichannel.Initialize();
RDebugUtils.currentLine=589839;
 //BA.debugLineNum = 589839;BA.debugLine="MessageQuery.Initialize";
_messagequery.Initialize();
RDebugUtils.currentLine=589841;
 //BA.debugLineNum = 589841;BA.debugLine="End Sub";
return "";
}
public static String  _socket_invio_dati_close() throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "socket_invio_dati_close"))
	return (String) Debug.delegate(processBA, "socket_invio_dati_close", null);
RDebugUtils.currentLine=1572864;
 //BA.debugLineNum = 1572864;BA.debugLine="Sub socket_invio_dati_close()";
RDebugUtils.currentLine=1572867;
 //BA.debugLineNum = 1572867;BA.debugLine="End Sub";
return "";
}
public static String  _socket_invio_dati_connected(boolean _successful) throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "socket_invio_dati_connected"))
	return (String) Debug.delegate(processBA, "socket_invio_dati_connected", new Object[] {_successful});
anywheresoftware.b4a.objects.streams.File.TextReaderWrapper _tr = null;
anywheresoftware.b4a.objects.streams.File.TextWriterWrapper _tw = null;
RDebugUtils.currentLine=1507328;
 //BA.debugLineNum = 1507328;BA.debugLine="Sub socket_invio_dati_Connected (Successful As Boo";
RDebugUtils.currentLine=1507329;
 //BA.debugLineNum = 1507329;BA.debugLine="If Successful = True Then";
if (_successful==anywheresoftware.b4a.keywords.Common.True) { 
RDebugUtils.currentLine=1507330;
 //BA.debugLineNum = 1507330;BA.debugLine="Dim tr As TextReader";
_tr = new anywheresoftware.b4a.objects.streams.File.TextReaderWrapper();
RDebugUtils.currentLine=1507331;
 //BA.debugLineNum = 1507331;BA.debugLine="Dim tw As TextWriter";
_tw = new anywheresoftware.b4a.objects.streams.File.TextWriterWrapper();
RDebugUtils.currentLine=1507332;
 //BA.debugLineNum = 1507332;BA.debugLine="tr.Initialize(socket_invio_dati.InputStream)";
_tr.Initialize(_socket_invio_dati.getInputStream());
RDebugUtils.currentLine=1507333;
 //BA.debugLineNum = 1507333;BA.debugLine="tw.Initialize(socket_invio_dati.OutputStream)";
_tw.Initialize(_socket_invio_dati.getOutputStream());
RDebugUtils.currentLine=1507334;
 //BA.debugLineNum = 1507334;BA.debugLine="tw.WriteLine(\"CAP LS\")";
_tw.WriteLine("CAP LS");
RDebugUtils.currentLine=1507335;
 //BA.debugLineNum = 1507335;BA.debugLine="tw.Flush";
_tw.Flush();
RDebugUtils.currentLine=1507336;
 //BA.debugLineNum = 1507336;BA.debugLine="tw.WriteLine(identIRC)";
_tw.WriteLine(_identirc);
RDebugUtils.currentLine=1507337;
 //BA.debugLineNum = 1507337;BA.debugLine="tw.Flush";
_tw.Flush();
RDebugUtils.currentLine=1507338;
 //BA.debugLineNum = 1507338;BA.debugLine="datisocket_ricezione_irc.Initialize(socket_invio";
_datisocket_ricezione_irc.Initialize(processBA,_socket_invio_dati.getInputStream(),_socket_invio_dati.getOutputStream(),"datisocket_ricezione_irc");
 };
RDebugUtils.currentLine=1507340;
 //BA.debugLineNum = 1507340;BA.debugLine="End Sub";
return "";
}
public static String  _timerserver_tick() throws Exception{
RDebugUtils.currentModule="psy";
if (Debug.shouldDelegate(processBA, "timerserver_tick"))
	return (String) Debug.delegate(processBA, "timerserver_tick", null);
boolean _valuesocket = false;
String[] _spazioriga = null;
String[] _stringconnection = null;
String _realdata = "";
RDebugUtils.currentLine=1638400;
 //BA.debugLineNum = 1638400;BA.debugLine="Sub TimerServer_Tick";
RDebugUtils.currentLine=1638403;
 //BA.debugLineNum = 1638403;BA.debugLine="If server.IsInitialized = False Then";
if (_server.IsInitialized()==anywheresoftware.b4a.keywords.Common.False) { 
RDebugUtils.currentLine=1638404;
 //BA.debugLineNum = 1638404;BA.debugLine="server.Initialize(serverPort, \"Server\")";
_server.Initialize(processBA,(int)(Double.parseDouble(_serverport)),"Server");
RDebugUtils.currentLine=1638405;
 //BA.debugLineNum = 1638405;BA.debugLine="MyIP = server.GetMyIP";
_myip = _server.GetMyIP();
RDebugUtils.currentLine=1638406;
 //BA.debugLineNum = 1638406;BA.debugLine="server.listen";
_server.Listen();
 };
RDebugUtils.currentLine=1638411;
 //BA.debugLineNum = 1638411;BA.debugLine="Dim ValueSocket As Boolean";
_valuesocket = false;
RDebugUtils.currentLine=1638412;
 //BA.debugLineNum = 1638412;BA.debugLine="ValueSocket = socket_invio_dati.Connected";
_valuesocket = _socket_invio_dati.getConnected();
RDebugUtils.currentLine=1638413;
 //BA.debugLineNum = 1638413;BA.debugLine="If ValueSocket = False Then";
if (_valuesocket==anywheresoftware.b4a.keywords.Common.False) { 
RDebugUtils.currentLine=1638414;
 //BA.debugLineNum = 1638414;BA.debugLine="Dim SpazioRiga() As String";
_spazioriga = new String[(int) (0)];
java.util.Arrays.fill(_spazioriga,"");
RDebugUtils.currentLine=1638415;
 //BA.debugLineNum = 1638415;BA.debugLine="Dim StringConnection()  As String";
_stringconnection = new String[(int) (0)];
java.util.Arrays.fill(_stringconnection,"");
RDebugUtils.currentLine=1638416;
 //BA.debugLineNum = 1638416;BA.debugLine="SpazioRiga = Regex.Split(\" \",LeggiFileRiga(\"psybn";
_spazioriga = anywheresoftware.b4a.keywords.Common.Regex.Split(" ",_leggifileriga("psybnc.conf",(long) (3)));
RDebugUtils.currentLine=1638417;
 //BA.debugLineNum = 1638417;BA.debugLine="Dim RealData As String";
_realdata = "";
RDebugUtils.currentLine=1638418;
 //BA.debugLineNum = 1638418;BA.debugLine="RealData = GeneraDAtaUnix";
_realdata = _generadataunix();
RDebugUtils.currentLine=1638419;
 //BA.debugLineNum = 1638419;BA.debugLine="If SpazioRiga.Length > 1 Then";
if (_spazioriga.length>1) { 
RDebugUtils.currentLine=1638420;
 //BA.debugLineNum = 1638420;BA.debugLine="StringConnection = Regex.Split(\":\",SpazioRiga(1)";
_stringconnection = anywheresoftware.b4a.keywords.Common.Regex.Split(":",_spazioriga[(int) (1)]);
RDebugUtils.currentLine=1638421;
 //BA.debugLineNum = 1638421;BA.debugLine="If StringConnection.Length = 2 Then";
if (_stringconnection.length==2) { 
RDebugUtils.currentLine=1638422;
 //BA.debugLineNum = 1638422;BA.debugLine="Topichannel.Clear";
_topichannel.Clear();
RDebugUtils.currentLine=1638423;
 //BA.debugLineNum = 1638423;BA.debugLine="socket_invio_dati.Close";
_socket_invio_dati.Close();
RDebugUtils.currentLine=1638424;
 //BA.debugLineNum = 1638424;BA.debugLine="socket_invio_dati.Initialize(\"socket_invio_dati";
_socket_invio_dati.Initialize("socket_invio_dati");
RDebugUtils.currentLine=1638425;
 //BA.debugLineNum = 1638425;BA.debugLine="socket_invio_dati.Connect(StringConnection(0),S";
_socket_invio_dati.Connect(processBA,_stringconnection[(int) (0)],(int)(Double.parseDouble(_stringconnection[(int) (1)])),(int) (1000));
RDebugUtils.currentLine=1638426;
 //BA.debugLineNum = 1638426;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC \"&RealData";
_writesocket(":-psyBNC PRIVMSG psyBNC "+_realdata+" :User "+_solouser(_identirc)+" () trying "+_stringconnection[(int) (0)]+" port "+_stringconnection[(int) (1)]+" ().");
 };
 }else {
RDebugUtils.currentLine=1638429;
 //BA.debugLineNum = 1638429;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC \"&RealData&";
_writesocket(":-psyBNC PRIVMSG psyBNC "+_realdata+" :User "+_solouser(_identirc)+" has no server added");
 };
 };
RDebugUtils.currentLine=1638434;
 //BA.debugLineNum = 1638434;BA.debugLine="End Sub";
return "";
}
}