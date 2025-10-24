package psybnc.pack;

import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.pc.*;

public class psy_subs_0 {


public static RemoteObject  _bhelp() throws Exception{
try {
		Debug.PushSubsStack("Bhelp (psy) ","psy",1,psy.processBA,psy.mostCurrent,577);
if (RapidSub.canDelegate("bhelp")) return psy.remoteMe.runUserSub(false, "psy","bhelp");
RemoteObject _tr = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");
RemoteObject _tw = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");
 BA.debugLineNum = 577;BA.debugLine="Sub Bhelp()";
Debug.ShouldStop(1);
 BA.debugLineNum = 578;BA.debugLine="Dim tr As TextReader";
Debug.ShouldStop(2);
_tr = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");Debug.locals.put("tr", _tr);
 BA.debugLineNum = 579;BA.debugLine="Dim tw As TextWriter";
Debug.ShouldStop(4);
_tw = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");Debug.locals.put("tw", _tw);
 BA.debugLineNum = 580;BA.debugLine="tr.Initialize( socket_ricezione_dati.InputStream)";
Debug.ShouldStop(8);
_tr.runVoidMethod ("Initialize",(Object)(psy._socket_ricezione_dati.runMethod(false,"getInputStream")));
 BA.debugLineNum = 581;BA.debugLine="tw.Initialize( socket_ricezione_dati.OutputStream";
Debug.ShouldStop(16);
_tw.runVoidMethod ("Initialize",(Object)(psy._socket_ricezione_dati.runMethod(false,"getOutputStream")));
 BA.debugLineNum = 582;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC Welcome \"&S";
Debug.ShouldStop(32);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.concat(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC Welcome "),_solouser(psy._identirc),RemoteObject.createImmutable(" !"))));
 BA.debugLineNum = 583;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC You are the";
Debug.ShouldStop(64);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC You are the first To connect To this new proxy server.")));
 BA.debugLineNum = 584;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC You are the";
Debug.ShouldStop(128);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC You are the proxy-admin. Use ADDSERVER To add a server so the bouncer may connect.")));
 BA.debugLineNum = 585;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC psyBNC0.1";
Debug.ShouldStop(256);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC psyBNC0.1 Help (* = BounceAdmin only)")));
 BA.debugLineNum = 586;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC -----------";
Debug.ShouldStop(512);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC -------------------------------------")));
 BA.debugLineNum = 587;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   ADD";
Debug.ShouldStop(1024);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC BHELP   ADDSERVER       - Adds an IRC-server To your Serverlist")));
 BA.debugLineNum = 588;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   DEL";
Debug.ShouldStop(2048);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC BHELP   DELSERVER       - Deletes an IRC-Server by number")));
 BA.debugLineNum = 589;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   LIS";
Debug.ShouldStop(4096);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC BHELP   LISTSERVERS     - Lists all IRC-Servers added")));
 BA.debugLineNum = 590;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   SET";
Debug.ShouldStop(8192);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC BHELP   SETAWAYNICK     - Sets your nick when you are offline")));
 BA.debugLineNum = 591;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   PLA";
Debug.ShouldStop(16384);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC BHELP   PLAYPRIVATELOG  - Plays your Message Log")));
 BA.debugLineNum = 592;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   ERA";
Debug.ShouldStop(32768);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC BHELP   ERASEPRIVATELOG - Erases your Message Log")));
 BA.debugLineNum = 593;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP   BHE";
Debug.ShouldStop(65536);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC BHELP   BHELP           - Lists this help OR help on a topic")));
 BA.debugLineNum = 594;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP Use /";
Debug.ShouldStop(131072);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC BHELP Use /QUOTE bhelp <command> For details.")));
 BA.debugLineNum = 595;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC BHELP - End";
Debug.ShouldStop(262144);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC BHELP - End of help")));
 BA.debugLineNum = 596;BA.debugLine="tw.Flush";
Debug.ShouldStop(524288);
_tw.runVoidMethod ("Flush");
 BA.debugLineNum = 597;BA.debugLine="End Sub";
Debug.ShouldStop(1048576);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _clientinvio(RemoteObject _read) throws Exception{
try {
		Debug.PushSubsStack("ClientInvio (psy) ","psy",1,psy.processBA,psy.mostCurrent,600);
if (RapidSub.canDelegate("clientinvio")) return psy.remoteMe.runUserSub(false, "psy","clientinvio", _read);
RemoteObject _tr = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");
RemoteObject _tw = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");
RemoteObject _fileconf = RemoteObject.createImmutable("");
RemoteObject _beginlogin = RemoteObject.createImmutable(false);
RemoteObject _readpasswd = RemoteObject.createImmutable("");
RemoteObject _spacenick = null;
RemoteObject _solonick = null;
RemoteObject _linefile = null;
RemoteObject _onlypass = null;
RemoteObject _soloserver = null;
RemoteObject _soloporta = RemoteObject.createImmutable("");
RemoteObject _spazioriga = null;
RemoteObject _porta = null;
RemoteObject _stringconnection = null;
RemoteObject _realdata = RemoteObject.createImmutable("");
RemoteObject _numero = RemoteObject.createImmutable("");
int _i = 0;
Debug.locals.put("Read", _read);
 BA.debugLineNum = 600;BA.debugLine="Sub ClientInvio(Read As String)";
Debug.ShouldStop(8388608);
 BA.debugLineNum = 602;BA.debugLine="Dim tr As TextReader";
Debug.ShouldStop(33554432);
_tr = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");Debug.locals.put("tr", _tr);
 BA.debugLineNum = 603;BA.debugLine="Dim tw As TextWriter";
Debug.ShouldStop(67108864);
_tw = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");Debug.locals.put("tw", _tw);
 BA.debugLineNum = 606;BA.debugLine="If Read.Contains(\"CAP LS\") = True Then";
Debug.ShouldStop(536870912);
if (RemoteObject.solveBoolean("=",_read.runMethod(true,"contains",(Object)(RemoteObject.createImmutable("CAP LS"))),psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 607;BA.debugLine="IRClient = True";
Debug.ShouldStop(1073741824);
psy._irclient = psy.mostCurrent.__c.getField(true,"True");
 };
 BA.debugLineNum = 613;BA.debugLine="If Read.Contains(\"NICK\") AND IRClient == True AN";
Debug.ShouldStop(16);
if (RemoteObject.solveBoolean(".",_read.runMethod(true,"contains",(Object)(RemoteObject.createImmutable("NICK")))) && RemoteObject.solveBoolean("=",psy._irclient,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"False"))) { 
 BA.debugLineNum = 614;BA.debugLine="tr.Initialize( socket_ricezione_dati.InputStrea";
Debug.ShouldStop(32);
_tr.runVoidMethod ("Initialize",(Object)(psy._socket_ricezione_dati.runMethod(false,"getInputStream")));
 BA.debugLineNum = 615;BA.debugLine="tw.Initialize( socket_ricezione_dati.OutputStre";
Debug.ShouldStop(64);
_tw.runVoidMethod ("Initialize",(Object)(psy._socket_ricezione_dati.runMethod(false,"getOutputStream")));
 BA.debugLineNum = 616;BA.debugLine="tw.WriteLine(\": Welcome NOTICE :psyBNC 0.1\")";
Debug.ShouldStop(128);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(": Welcome NOTICE :psyBNC 0.1")));
 BA.debugLineNum = 617;BA.debugLine="tw.WriteLine(\": -psyBNC NOTICE :Your IRC Client";
Debug.ShouldStop(256);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(": -psyBNC NOTICE :Your IRC Client did not support a password. Please type /QUOTE PASS yourpassword to connect.")));
 BA.debugLineNum = 618;BA.debugLine="identIRC = Read.Replace(\"CAP LS\",\"\")";
Debug.ShouldStop(512);
psy._identirc = _read.runMethod(true,"replace",(Object)(BA.ObjectToString("CAP LS")),(Object)(RemoteObject.createImmutable("")));
 BA.debugLineNum = 619;BA.debugLine="tw.Flush";
Debug.ShouldStop(1024);
_tw.runVoidMethod ("Flush");
 };
 BA.debugLineNum = 625;BA.debugLine="If Read.ToUpperCase.Contains(\"PASSWORD\") OR Read";
Debug.ShouldStop(65536);
if (RemoteObject.solveBoolean(".",_read.runMethod(true,"toUpperCase").runMethod(true,"contains",(Object)(RemoteObject.createImmutable("PASSWORD")))) || RemoteObject.solveBoolean(".",_read.runMethod(true,"toUpperCase").runMethod(true,"contains",(Object)(RemoteObject.createImmutable("PASS")))) && RemoteObject.solveBoolean("=",psy._irclient,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean(">",psy._identirc.runMethod(true,"length"),BA.numberCast(double.class, 0))) { 
 BA.debugLineNum = 627;BA.debugLine="Dim fileconf As String";
Debug.ShouldStop(262144);
_fileconf = RemoteObject.createImmutable("");Debug.locals.put("fileconf", _fileconf);
 BA.debugLineNum = 628;BA.debugLine="Dim BeginLogin As Boolean";
Debug.ShouldStop(524288);
_beginlogin = RemoteObject.createImmutable(false);Debug.locals.put("BeginLogin", _beginlogin);
 BA.debugLineNum = 630;BA.debugLine="Dim readpasswd As String";
Debug.ShouldStop(2097152);
_readpasswd = RemoteObject.createImmutable("");Debug.locals.put("readpasswd", _readpasswd);
 BA.debugLineNum = 631;BA.debugLine="readpasswd = TogliPrimoComando(Read)";
Debug.ShouldStop(4194304);
_readpasswd = _togliprimocomando(_read);Debug.locals.put("readpasswd", _readpasswd);
 BA.debugLineNum = 633;BA.debugLine="fileconf = ReadFile(\"psybnc.conf\")";
Debug.ShouldStop(16777216);
_fileconf = _readfile(RemoteObject.createImmutable("psybnc.conf"));Debug.locals.put("fileconf", _fileconf);
 BA.debugLineNum = 635;BA.debugLine="If (fileconf.Length == 0)Then";
Debug.ShouldStop(67108864);
if ((RemoteObject.solveBoolean("=",_fileconf.runMethod(true,"length"),BA.numberCast(double.class, 0)))) { 
 BA.debugLineNum = 638;BA.debugLine="WriteFile(\"psybnc.conf\", identIRC.Replace(Chr(";
Debug.ShouldStop(536870912);
_writefile(BA.ObjectToString("psybnc.conf"),psy._identirc.runMethod(true,"replace",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 13))))),(Object)(RemoteObject.createImmutable(""))));
 BA.debugLineNum = 639;BA.debugLine="WriteFile(\"psybnc.conf\", \"PASSWD \"&readpasswd)";
Debug.ShouldStop(1073741824);
_writefile(BA.ObjectToString("psybnc.conf"),RemoteObject.concat(RemoteObject.createImmutable("PASSWD "),_readpasswd));
 BA.debugLineNum = 640;BA.debugLine="Dim Spacenick() As String";
Debug.ShouldStop(-2147483648);
_spacenick = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("Spacenick", _spacenick);
 BA.debugLineNum = 641;BA.debugLine="Dim Solonick() As String";
Debug.ShouldStop(1);
_solonick = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("Solonick", _solonick);
 BA.debugLineNum = 642;BA.debugLine="Spacenick = Regex.Split(Chr(32),identIRC)";
Debug.ShouldStop(2);
_spacenick = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 32))))),(Object)(psy._identirc));Debug.locals.put("Spacenick", _spacenick);
 BA.debugLineNum = 643;BA.debugLine="Solonick = Regex.Split(Chr(10),Spacenick(1))";
Debug.ShouldStop(4);
_solonick = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 10))))),(Object)(_spacenick.getArrayElement(true,BA.numberCast(int.class, 1))));Debug.locals.put("Solonick", _solonick);
 BA.debugLineNum = 644;BA.debugLine="Nickconnessione = Solonick(0)";
Debug.ShouldStop(8);
psy._nickconnessione = _solonick.getArrayElement(true,BA.numberCast(int.class, 0));
 BA.debugLineNum = 646;BA.debugLine="Bhelp";
Debug.ShouldStop(32);
_bhelp();
 BA.debugLineNum = 647;BA.debugLine="joinpasswd = True";
Debug.ShouldStop(64);
psy._joinpasswd = psy.mostCurrent.__c.getField(true,"True");
 BA.debugLineNum = 648;BA.debugLine="Return \"\"";
Debug.ShouldStop(128);
if (true) return BA.ObjectToString("");
 }else {
 BA.debugLineNum = 651;BA.debugLine="Dim Linefile() As String";
Debug.ShouldStop(1024);
_linefile = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("Linefile", _linefile);
 BA.debugLineNum = 652;BA.debugLine="Dim onlypass() As String";
Debug.ShouldStop(2048);
_onlypass = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("onlypass", _onlypass);
 BA.debugLineNum = 653;BA.debugLine="Linefile = Regex.split(Chr(13),fileconf)";
Debug.ShouldStop(4096);
_linefile = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 13))))),(Object)(_fileconf));Debug.locals.put("Linefile", _linefile);
 BA.debugLineNum = 654;BA.debugLine="onlypass = Regex.split(Chr(32),Linefile(2))";
Debug.ShouldStop(8192);
_onlypass = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 32))))),(Object)(_linefile.getArrayElement(true,BA.numberCast(int.class, 2))));Debug.locals.put("onlypass", _onlypass);
 BA.debugLineNum = 656;BA.debugLine="If onlypass(1) == readpasswd.SubString2(0,rea";
Debug.ShouldStop(32768);
if (RemoteObject.solveBoolean("=",_onlypass.getArrayElement(true,BA.numberCast(int.class, 1)),_readpasswd.runMethod(true,"substring",(Object)(BA.numberCast(int.class, 0)),(Object)(RemoteObject.solve(new RemoteObject[] {_readpasswd.runMethod(true,"length"),RemoteObject.createImmutable(1)}, "-",1, 1))))) { 
 BA.debugLineNum = 657;BA.debugLine="joinpasswd = True";
Debug.ShouldStop(65536);
psy._joinpasswd = psy.mostCurrent.__c.getField(true,"True");
 BA.debugLineNum = 658;BA.debugLine="QueryMSG";
Debug.ShouldStop(131072);
_querymsg();
 BA.debugLineNum = 659;BA.debugLine="If Linefile.Length > 3 Then";
Debug.ShouldStop(262144);
if (RemoteObject.solveBoolean(">",_linefile.getField(true,"length"),BA.numberCast(double.class, 3))) { 
 BA.debugLineNum = 661;BA.debugLine="If socket_invio_dati.Connected = False Then";
Debug.ShouldStop(1048576);
if (RemoteObject.solveBoolean("=",psy._socket_invio_dati.runMethod(true,"getConnected"),psy.mostCurrent.__c.getField(true,"False"))) { 
 BA.debugLineNum = 662;BA.debugLine="Bhelp";
Debug.ShouldStop(2097152);
_bhelp();
 }else {
 BA.debugLineNum = 664;BA.debugLine="RejoinChannel";
Debug.ShouldStop(8388608);
_rejoinchannel();
 };
 };
 BA.debugLineNum = 667;BA.debugLine="Return \"\"";
Debug.ShouldStop(67108864);
if (true) return BA.ObjectToString("");
 };
 };
 };
 BA.debugLineNum = 674;BA.debugLine="If Read.ToUpperCase.Contains(\"ADDSERVER\") AND IR";
Debug.ShouldStop(2);
if (RemoteObject.solveBoolean(".",_read.runMethod(true,"toUpperCase").runMethod(true,"contains",(Object)(RemoteObject.createImmutable("ADDSERVER")))) && RemoteObject.solveBoolean("=",psy._irclient,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 675;BA.debugLine="Dim soloserver() As String";
Debug.ShouldStop(4);
_soloserver = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("soloserver", _soloserver);
 BA.debugLineNum = 676;BA.debugLine="Dim soloporta As String";
Debug.ShouldStop(8);
_soloporta = RemoteObject.createImmutable("");Debug.locals.put("soloporta", _soloporta);
 BA.debugLineNum = 677;BA.debugLine="Read = TogliPrimoComando(Read.ToUpperCase)";
Debug.ShouldStop(16);
_read = _togliprimocomando(_read.runMethod(true,"toUpperCase"));Debug.locals.put("Read", _read);
 BA.debugLineNum = 678;BA.debugLine="soloserver  = Regex.split(\":\",Read.ToUpperCas";
Debug.ShouldStop(32);
_soloserver = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_read.runMethod(true,"toUpperCase")));Debug.locals.put("soloserver", _soloserver);
 BA.debugLineNum = 679;BA.debugLine="If soloserver.Length -1 > 0 Then";
Debug.ShouldStop(64);
if (RemoteObject.solveBoolean(">",RemoteObject.solve(new RemoteObject[] {_soloserver.getField(true,"length"),RemoteObject.createImmutable(1)}, "-",1, 1),BA.numberCast(double.class, 0))) { 
 BA.debugLineNum = 680;BA.debugLine="soloporta = soloserver(1)";
Debug.ShouldStop(128);
_soloporta = _soloserver.getArrayElement(true,BA.numberCast(int.class, 1));Debug.locals.put("soloporta", _soloporta);
 BA.debugLineNum = 681;BA.debugLine="WriteFileRiga(\"psybnc.conf\",\"server \"&solos";
Debug.ShouldStop(256);
_writefileriga(BA.ObjectToString("psybnc.conf"),RemoteObject.concat(RemoteObject.createImmutable("server "),_soloserver.getArrayElement(true,BA.numberCast(int.class, 0)),RemoteObject.createImmutable(":"),_soloporta),BA.numberCast(long.class, 4));
 BA.debugLineNum = 682;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC Server";
Debug.ShouldStop(512);
_writesocket(RemoteObject.concat(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC Server "),_soloserver.getArrayElement(true,BA.numberCast(int.class, 0)),RemoteObject.createImmutable(" port "),_soloporta,RemoteObject.createImmutable(" (password: None) added.")));
 }else {
 BA.debugLineNum = 685;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC No ser";
Debug.ShouldStop(4096);
_writesocket(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC No server given. Syntax Is ADDSERVER hostname ::port"));
 };
 BA.debugLineNum = 687;BA.debugLine="Return \"\"";
Debug.ShouldStop(16384);
if (true) return BA.ObjectToString("");
 };
 BA.debugLineNum = 692;BA.debugLine="If Read.ToUpperCase.Contains(\"LISTSERVERS\") AND";
Debug.ShouldStop(524288);
if (RemoteObject.solveBoolean(".",_read.runMethod(true,"toUpperCase").runMethod(true,"contains",(Object)(RemoteObject.createImmutable("LISTSERVERS")))) && RemoteObject.solveBoolean("=",psy._irclient,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 693;BA.debugLine="Dim SpazioRiga() As String";
Debug.ShouldStop(1048576);
_spazioriga = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("SpazioRiga", _spazioriga);
 BA.debugLineNum = 694;BA.debugLine="Dim porta()  As String";
Debug.ShouldStop(2097152);
_porta = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("porta", _porta);
 BA.debugLineNum = 695;BA.debugLine="SpazioRiga = Regex.Split(\" \",LeggiFileRiga(\"psy";
Debug.ShouldStop(4194304);
_spazioriga = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(" ")),(Object)(_leggifileriga(BA.ObjectToString("psybnc.conf"),BA.numberCast(long.class, 3))));Debug.locals.put("SpazioRiga", _spazioriga);
 BA.debugLineNum = 696;BA.debugLine="If SpazioRiga.Length > 1 Then";
Debug.ShouldStop(8388608);
if (RemoteObject.solveBoolean(">",_spazioriga.getField(true,"length"),BA.numberCast(double.class, 1))) { 
 BA.debugLineNum = 697;BA.debugLine="porta = Regex.Split(\":\",SpazioRiga(1))";
Debug.ShouldStop(16777216);
_porta = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_spazioriga.getArrayElement(true,BA.numberCast(int.class, 1))));Debug.locals.put("porta", _porta);
 BA.debugLineNum = 698;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC Server #1";
Debug.ShouldStop(33554432);
_writesocket(RemoteObject.concat(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC Server #1:"),_spazioriga.getArrayElement(true,BA.numberCast(int.class, 1)),RemoteObject.createImmutable(" port "),_porta.getArrayElement(true,BA.numberCast(int.class, 1))));
 };
 BA.debugLineNum = 700;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC End of Ser";
Debug.ShouldStop(134217728);
_writesocket(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC End of Servers."));
 BA.debugLineNum = 701;BA.debugLine="Return \"\"";
Debug.ShouldStop(268435456);
if (true) return BA.ObjectToString("");
 };
 BA.debugLineNum = 706;BA.debugLine="If Read.ToUpperCase.Contains(\"JUMP\") AND IRClien";
Debug.ShouldStop(2);
if (RemoteObject.solveBoolean(".",_read.runMethod(true,"toUpperCase").runMethod(true,"contains",(Object)(RemoteObject.createImmutable("JUMP")))) && RemoteObject.solveBoolean("=",psy._irclient,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 707;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC Jump New S";
Debug.ShouldStop(4);
_writesocket(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC Jump New Server."));
 BA.debugLineNum = 708;BA.debugLine="socket_invio_dati.close";
Debug.ShouldStop(8);
psy._socket_invio_dati.runVoidMethod ("Close");
 BA.debugLineNum = 709;BA.debugLine="Dim SpazioRiga() As String";
Debug.ShouldStop(16);
_spazioriga = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("SpazioRiga", _spazioriga);
 BA.debugLineNum = 710;BA.debugLine="Dim StringConnection()  As String";
Debug.ShouldStop(32);
_stringconnection = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("StringConnection", _stringconnection);
 BA.debugLineNum = 711;BA.debugLine="SpazioRiga = Regex.Split(\" \",LeggiFileRiga(\"psy";
Debug.ShouldStop(64);
_spazioriga = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(" ")),(Object)(_leggifileriga(BA.ObjectToString("psybnc.conf"),BA.numberCast(long.class, 3))));Debug.locals.put("SpazioRiga", _spazioriga);
 BA.debugLineNum = 712;BA.debugLine="Dim RealData As String";
Debug.ShouldStop(128);
_realdata = RemoteObject.createImmutable("");Debug.locals.put("RealData", _realdata);
 BA.debugLineNum = 713;BA.debugLine="RealData = GeneraDAtaUnix";
Debug.ShouldStop(256);
_realdata = _generadataunix();Debug.locals.put("RealData", _realdata);
 BA.debugLineNum = 714;BA.debugLine="If SpazioRiga.Length > 1 Then";
Debug.ShouldStop(512);
if (RemoteObject.solveBoolean(">",_spazioriga.getField(true,"length"),BA.numberCast(double.class, 1))) { 
 BA.debugLineNum = 715;BA.debugLine="StringConnection = Regex.Split(\":\",SpazioRiga(";
Debug.ShouldStop(1024);
_stringconnection = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_spazioriga.getArrayElement(true,BA.numberCast(int.class, 1))));Debug.locals.put("StringConnection", _stringconnection);
 BA.debugLineNum = 716;BA.debugLine="If StringConnection.Length = 2 Then";
Debug.ShouldStop(2048);
if (RemoteObject.solveBoolean("=",_stringconnection.getField(true,"length"),BA.numberCast(double.class, 2))) { 
 BA.debugLineNum = 717;BA.debugLine="Topichannel.Clear";
Debug.ShouldStop(4096);
psy._topichannel.runVoidMethod ("Clear");
 BA.debugLineNum = 718;BA.debugLine="socket_invio_dati.Close";
Debug.ShouldStop(8192);
psy._socket_invio_dati.runVoidMethod ("Close");
 BA.debugLineNum = 719;BA.debugLine="socket_invio_dati.Initialize(\"socket_invio_da";
Debug.ShouldStop(16384);
psy._socket_invio_dati.runVoidMethod ("Initialize",(Object)(RemoteObject.createImmutable("socket_invio_dati")));
 BA.debugLineNum = 720;BA.debugLine="socket_invio_dati.Connect(StringConnection(0)";
Debug.ShouldStop(32768);
psy._socket_invio_dati.runVoidMethod ("Connect",psy.processBA,(Object)(_stringconnection.getArrayElement(true,BA.numberCast(int.class, 0))),(Object)(BA.numberCast(int.class, _stringconnection.getArrayElement(true,BA.numberCast(int.class, 1)))),(Object)(BA.numberCast(int.class, 1000)));
 BA.debugLineNum = 721;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC \"&RealDa";
Debug.ShouldStop(65536);
_writesocket(RemoteObject.concat(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC "),_realdata,RemoteObject.createImmutable(" :User "),_solouser(psy._identirc),RemoteObject.createImmutable(" () trying "),_stringconnection.getArrayElement(true,BA.numberCast(int.class, 0)),RemoteObject.createImmutable(" port "),_stringconnection.getArrayElement(true,BA.numberCast(int.class, 1)),RemoteObject.createImmutable(" ().")));
 };
 };
 };
 BA.debugLineNum = 726;BA.debugLine="If Read.ToUpperCase.Contains(\"BHELP\") AND IRClie";
Debug.ShouldStop(2097152);
if (RemoteObject.solveBoolean(".",_read.runMethod(true,"toUpperCase").runMethod(true,"contains",(Object)(RemoteObject.createImmutable("BHELP")))) && RemoteObject.solveBoolean("=",psy._irclient,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 727;BA.debugLine="Bhelp";
Debug.ShouldStop(4194304);
_bhelp();
 };
 BA.debugLineNum = 732;BA.debugLine="If Read.ToUpperCase.Contains(\"DELSERVER\") AND IR";
Debug.ShouldStop(134217728);
if (RemoteObject.solveBoolean(".",_read.runMethod(true,"toUpperCase").runMethod(true,"contains",(Object)(RemoteObject.createImmutable("DELSERVER")))) && RemoteObject.solveBoolean("=",psy._irclient,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 733;BA.debugLine="Dim numero As String";
Debug.ShouldStop(268435456);
_numero = RemoteObject.createImmutable("");Debug.locals.put("numero", _numero);
 BA.debugLineNum = 734;BA.debugLine="numero = TogliPrimoComando(Read).Replace(Chr(";
Debug.ShouldStop(536870912);
_numero = _togliprimocomando(_read).runMethod(true,"replace",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 10))))),(Object)(RemoteObject.createImmutable("")));Debug.locals.put("numero", _numero);
 BA.debugLineNum = 735;BA.debugLine="If numero = \"1\" Then";
Debug.ShouldStop(1073741824);
if (RemoteObject.solveBoolean("=",_numero,BA.ObjectToString("1"))) { 
 BA.debugLineNum = 736;BA.debugLine="WriteFileRiga(\"psybnc.conf\",\"server\",4)";
Debug.ShouldStop(-2147483648);
_writefileriga(BA.ObjectToString("psybnc.conf"),BA.ObjectToString("server"),BA.numberCast(long.class, 4));
 BA.debugLineNum = 737;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC Server";
Debug.ShouldStop(1);
_writesocket(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC Server 1 deleted."));
 };
 BA.debugLineNum = 739;BA.debugLine="Return \"\"";
Debug.ShouldStop(4);
if (true) return BA.ObjectToString("");
 };
 BA.debugLineNum = 744;BA.debugLine="If Read.ToUpperCase.Contains(\"PLAYPRIVATELOG\") A";
Debug.ShouldStop(128);
if (RemoteObject.solveBoolean(".",_read.runMethod(true,"toUpperCase").runMethod(true,"contains",(Object)(RemoteObject.createImmutable("PLAYPRIVATELOG")))) && RemoteObject.solveBoolean("=",psy._irclient,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 745;BA.debugLine="If MessageQuery.IsInitialized = True Then";
Debug.ShouldStop(256);
if (RemoteObject.solveBoolean("=",psy._messagequery.runMethod(true,"IsInitialized"),psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 746;BA.debugLine="If MessageQuery.size-1 >= 0 Then";
Debug.ShouldStop(512);
if (RemoteObject.solveBoolean("g",RemoteObject.solve(new RemoteObject[] {psy._messagequery.runMethod(true,"getSize"),RemoteObject.createImmutable(1)}, "-",1, 1),BA.numberCast(double.class, 0))) { 
 BA.debugLineNum = 747;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psybnc Starting";
Debug.ShouldStop(1024);
_writesocket(RemoteObject.createImmutable(":-psyBNC PRIVMSG psybnc Starting playing Log"));
 BA.debugLineNum = 748;BA.debugLine="For i = 0 To MessageQuery.size -1";
Debug.ShouldStop(2048);
{
final int step110 = 1;
final int limit110 = RemoteObject.solve(new RemoteObject[] {psy._messagequery.runMethod(true,"getSize"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue();
for (_i = 0 ; (step110 > 0 && _i <= limit110) || (step110 < 0 && _i >= limit110); _i = ((int)(0 + _i + step110)) ) {
Debug.locals.put("i", _i);
 BA.debugLineNum = 749;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC \"& Mes";
Debug.ShouldStop(4096);
_writesocket(RemoteObject.concat(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC "),psy._messagequery.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i)))));
 }
}Debug.locals.put("i", _i);
;
 BA.debugLineNum = 751;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC Use ERAS";
Debug.ShouldStop(16384);
_writesocket(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC Use ERASEPRIVATELOG to kill the log"));
 };
 };
 BA.debugLineNum = 754;BA.debugLine="Return \"\"";
Debug.ShouldStop(131072);
if (true) return BA.ObjectToString("");
 };
 BA.debugLineNum = 759;BA.debugLine="If Read.ToUpperCase.Contains(\"ERASEPRIVATELOG\")";
Debug.ShouldStop(4194304);
if (RemoteObject.solveBoolean(".",_read.runMethod(true,"toUpperCase").runMethod(true,"contains",(Object)(RemoteObject.createImmutable("ERASEPRIVATELOG")))) && RemoteObject.solveBoolean("=",psy._irclient,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 760;BA.debugLine="If MessageQuery.IsInitialized = True Then";
Debug.ShouldStop(8388608);
if (RemoteObject.solveBoolean("=",psy._messagequery.runMethod(true,"IsInitialized"),psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 761;BA.debugLine="MessageQuery.Clear";
Debug.ShouldStop(16777216);
psy._messagequery.runVoidMethod ("Clear");
 BA.debugLineNum = 762;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC Log erase";
Debug.ShouldStop(33554432);
_writesocket(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC Log erased"));
 };
 BA.debugLineNum = 764;BA.debugLine="Return \"\"";
Debug.ShouldStop(134217728);
if (true) return BA.ObjectToString("");
 };
 BA.debugLineNum = 769;BA.debugLine="If Read.ToUpperCase.Contains(\"SETAWAYNICK\") AND";
Debug.ShouldStop(1);
if (RemoteObject.solveBoolean(".",_read.runMethod(true,"toUpperCase").runMethod(true,"contains",(Object)(RemoteObject.createImmutable("SETAWAYNICK")))) && RemoteObject.solveBoolean("=",psy._irclient,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 770;BA.debugLine="AwayNick = TogliPrimoComando(Read).Replace(Chr";
Debug.ShouldStop(2);
psy._awaynick = _togliprimocomando(_read).runMethod(true,"replace",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 10))))),(Object)(RemoteObject.createImmutable("")));
 BA.debugLineNum = 771;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC AWAY-Nick";
Debug.ShouldStop(4);
_writesocket(RemoteObject.concat(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC AWAY-Nick changed to '"),psy._awaynick,RemoteObject.createImmutable("'.")));
 BA.debugLineNum = 772;BA.debugLine="Return \"\"";
Debug.ShouldStop(8);
if (true) return BA.ObjectToString("");
 };
 BA.debugLineNum = 778;BA.debugLine="If Read.ToUpperCase.Contains(\"QUIT :\") == False";
Debug.ShouldStop(512);
if (RemoteObject.solveBoolean("=",_read.runMethod(true,"toUpperCase").runMethod(true,"contains",(Object)(RemoteObject.createImmutable("QUIT :"))),psy.mostCurrent.__c.getField(true,"False")) && RemoteObject.solveBoolean("=",psy._irclient,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 779;BA.debugLine="WriteSocketIrc(Read)";
Debug.ShouldStop(1024);
_writesocketirc(_read);
 }else {
 BA.debugLineNum = 782;BA.debugLine="If Read.ToUpperCase.Contains(\"QUIT :\") == True";
Debug.ShouldStop(8192);
if (RemoteObject.solveBoolean("=",_read.runMethod(true,"toUpperCase").runMethod(true,"contains",(Object)(RemoteObject.createImmutable("QUIT :"))),psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 784;BA.debugLine="NormalNick = Nickconnessione";
Debug.ShouldStop(32768);
psy._normalnick = psy._nickconnessione;
 BA.debugLineNum = 785;BA.debugLine="WriteSocketIrc(\"nick \"&AwayNick)";
Debug.ShouldStop(65536);
_writesocketirc(RemoteObject.concat(RemoteObject.createImmutable("nick "),psy._awaynick));
 BA.debugLineNum = 786;BA.debugLine="IRClient = False";
Debug.ShouldStop(131072);
psy._irclient = psy.mostCurrent.__c.getField(true,"False");
 BA.debugLineNum = 787;BA.debugLine="joinpasswd = False";
Debug.ShouldStop(262144);
psy._joinpasswd = psy.mostCurrent.__c.getField(true,"False");
 };
 };
 BA.debugLineNum = 792;BA.debugLine="End Sub";
Debug.ShouldStop(8388608);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _datisocket_ricezione_irc_newdata(RemoteObject _buffer) throws Exception{
try {
		Debug.PushSubsStack("datisocket_ricezione_irc_NewData (psy) ","psy",1,psy.processBA,psy.mostCurrent,798);
if (RapidSub.canDelegate("datisocket_ricezione_irc_newdata")) return psy.remoteMe.runUserSub(false, "psy","datisocket_ricezione_irc_newdata", _buffer);
Debug.locals.put("buffer", _buffer);
 BA.debugLineNum = 798;BA.debugLine="Sub datisocket_ricezione_irc_NewData (buffer() As";
Debug.ShouldStop(536870912);
 BA.debugLineNum = 799;BA.debugLine="WriteSocket(Ricezione_Server((BytesToString(buffer";
Debug.ShouldStop(1073741824);
_writesocket(_ricezione_server((psy.mostCurrent.__c.runMethod(true,"BytesToString",(Object)(_buffer),(Object)(BA.numberCast(int.class, 0)),(Object)(_buffer.getField(true,"length")),(Object)(RemoteObject.createImmutable("UTF8"))))));
 BA.debugLineNum = 800;BA.debugLine="End Sub";
Debug.ShouldStop(-2147483648);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _datisocket_ricezione_newdata(RemoteObject _buffer) throws Exception{
try {
		Debug.PushSubsStack("datisocket_ricezione_NewData (psy) ","psy",1,psy.processBA,psy.mostCurrent,795);
if (RapidSub.canDelegate("datisocket_ricezione_newdata")) return psy.remoteMe.runUserSub(false, "psy","datisocket_ricezione_newdata", _buffer);
Debug.locals.put("buffer", _buffer);
 BA.debugLineNum = 795;BA.debugLine="Sub datisocket_ricezione_NewData (buffer() As Byte";
Debug.ShouldStop(67108864);
 BA.debugLineNum = 796;BA.debugLine="ClientInvio(BytesToString(buffer, 0, buffer.Length";
Debug.ShouldStop(134217728);
_clientinvio(psy.mostCurrent.__c.runMethod(true,"BytesToString",(Object)(_buffer),(Object)(BA.numberCast(int.class, 0)),(Object)(_buffer.getField(true,"length")),(Object)(RemoteObject.createImmutable("UTF8"))));
 BA.debugLineNum = 797;BA.debugLine="End Sub";
Debug.ShouldStop(268435456);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _generadataunix() throws Exception{
try {
		Debug.PushSubsStack("GeneraDAtaUnix (psy) ","psy",1,psy.processBA,psy.mostCurrent,216);
if (RapidSub.canDelegate("generadataunix")) return psy.remoteMe.runUserSub(false, "psy","generadataunix");
RemoteObject _now = RemoteObject.createImmutable(0L);
RemoteObject _realdate = RemoteObject.createImmutable("");
RemoteObject _weekdaysstr = null;
RemoteObject _mouth = null;
 BA.debugLineNum = 216;BA.debugLine="Sub GeneraDAtaUnix()";
Debug.ShouldStop(8388608);
 BA.debugLineNum = 217;BA.debugLine="Dim now As Long";
Debug.ShouldStop(16777216);
_now = RemoteObject.createImmutable(0L);Debug.locals.put("now", _now);
 BA.debugLineNum = 218;BA.debugLine="Dim RealDate As String";
Debug.ShouldStop(33554432);
_realdate = RemoteObject.createImmutable("");Debug.locals.put("RealDate", _realdate);
 BA.debugLineNum = 219;BA.debugLine="now = DateTime.now";
Debug.ShouldStop(67108864);
_now = psy.mostCurrent.__c.getField(false,"DateTime").runMethod(true,"getNow");Debug.locals.put("now", _now);
 BA.debugLineNum = 220;BA.debugLine="Dim WeekDaysStr() As String";
Debug.ShouldStop(134217728);
_weekdaysstr = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("WeekDaysStr", _weekdaysstr);
 BA.debugLineNum = 221;BA.debugLine="Dim Mouth() As String";
Debug.ShouldStop(268435456);
_mouth = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("Mouth", _mouth);
 BA.debugLineNum = 222;BA.debugLine="WeekDaysStr = Array As String (\"Sun\", \"Mon\", \"Tue";
Debug.ShouldStop(536870912);
_weekdaysstr = RemoteObject.createNewArray("String",new int[] {7},new Object[] {BA.ObjectToString("Sun"),BA.ObjectToString("Mon"),BA.ObjectToString("Tue"),BA.ObjectToString("Wed"),BA.ObjectToString("Thu"),BA.ObjectToString("Fri"),RemoteObject.createImmutable("Sat")});Debug.locals.put("WeekDaysStr", _weekdaysstr);
 BA.debugLineNum = 223;BA.debugLine="Mouth = Array As String (\"Jan\", \"Feb\",\"Mar\", \"Apr";
Debug.ShouldStop(1073741824);
_mouth = RemoteObject.createNewArray("String",new int[] {12},new Object[] {BA.ObjectToString("Jan"),BA.ObjectToString("Feb"),BA.ObjectToString("Mar"),BA.ObjectToString("Apr"),BA.ObjectToString("May"),BA.ObjectToString("Jun"),BA.ObjectToString("Jul"),BA.ObjectToString("Aug"),BA.ObjectToString("Sept"),BA.ObjectToString("Oct"),BA.ObjectToString("Nov"),RemoteObject.createImmutable("Dec")});Debug.locals.put("Mouth", _mouth);
 BA.debugLineNum = 224;BA.debugLine="RealDate = WeekDaysStr(DateTime.GetDayOfWeek(now)";
Debug.ShouldStop(-2147483648);
_realdate = RemoteObject.concat(_weekdaysstr.getArrayElement(true,RemoteObject.solve(new RemoteObject[] {psy.mostCurrent.__c.getField(false,"DateTime").runMethod(true,"GetDayOfWeek",(Object)(_now)),RemoteObject.createImmutable(1)}, "-",1, 1)),RemoteObject.createImmutable(" "),_mouth.getArrayElement(true,RemoteObject.solve(new RemoteObject[] {psy.mostCurrent.__c.getField(false,"DateTime").runMethod(true,"GetMonth",(Object)(_now)),RemoteObject.createImmutable(1)}, "-",1, 1)),RemoteObject.createImmutable(" "),psy.mostCurrent.__c.getField(false,"DateTime").runMethod(true,"GetDayOfMonth",(Object)(_now)),RemoteObject.createImmutable(" "),psy.mostCurrent.__c.getField(false,"DateTime").runMethod(true,"GetHour",(Object)(_now)),RemoteObject.createImmutable(":"),psy.mostCurrent.__c.getField(false,"DateTime").runMethod(true,"GetMinute",(Object)(_now)),RemoteObject.createImmutable(":"),psy.mostCurrent.__c.getField(false,"DateTime").runMethod(true,"GetSecond",(Object)(_now)));Debug.locals.put("RealDate", _realdate);
 BA.debugLineNum = 225;BA.debugLine="Return RealDate";
Debug.ShouldStop(1);
if (true) return _realdate;
 BA.debugLineNum = 226;BA.debugLine="End Sub";
Debug.ShouldStop(2);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _leggifileriga(RemoteObject _nomefile,RemoteObject _riga) throws Exception{
try {
		Debug.PushSubsStack("LeggiFileRiga (psy) ","psy",1,psy.processBA,psy.mostCurrent,130);
if (RapidSub.canDelegate("leggifileriga")) return psy.remoteMe.runUserSub(false, "psy","leggifileriga", _nomefile, _riga);
RemoteObject _iline = null;
Debug.locals.put("NomeFile", _nomefile);
Debug.locals.put("Riga", _riga);
 BA.debugLineNum = 130;BA.debugLine="Sub LeggiFileRiga(NomeFile As String,Riga As Long)";
Debug.ShouldStop(2);
 BA.debugLineNum = 131;BA.debugLine="Dim iLine() As String";
Debug.ShouldStop(4);
_iline = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("iLine", _iline);
 BA.debugLineNum = 132;BA.debugLine="iLine = Regex.Split(Chr(13),ReadFile(NomeFile))";
Debug.ShouldStop(8);
_iline = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 13))))),(Object)(_readfile(_nomefile)));Debug.locals.put("iLine", _iline);
 BA.debugLineNum = 134;BA.debugLine="If  iLine.Length > 0 Then";
Debug.ShouldStop(32);
if (RemoteObject.solveBoolean(">",_iline.getField(true,"length"),BA.numberCast(double.class, 0))) { 
 BA.debugLineNum = 135;BA.debugLine="If  Riga < iLine.Length Then";
Debug.ShouldStop(64);
if (RemoteObject.solveBoolean("<",_riga,BA.numberCast(double.class, _iline.getField(true,"length")))) { 
 BA.debugLineNum = 136;BA.debugLine="Return iLine(Riga)";
Debug.ShouldStop(128);
if (true) return _iline.getArrayElement(true,BA.numberCast(int.class, _riga));
 }else {
 BA.debugLineNum = 138;BA.debugLine="Return \"\"";
Debug.ShouldStop(512);
if (true) return BA.ObjectToString("");
 };
 }else {
 BA.debugLineNum = 141;BA.debugLine="Return \"\"";
Debug.ShouldStop(4096);
if (true) return BA.ObjectToString("");
 };
 BA.debugLineNum = 143;BA.debugLine="End Sub";
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
public static RemoteObject  _pingtimer_tick() throws Exception{
try {
		Debug.PushSubsStack("PingTimer_Tick (psy) ","psy",1,psy.processBA,psy.mostCurrent,228);
if (RapidSub.canDelegate("pingtimer_tick")) return psy.remoteMe.runUserSub(false, "psy","pingtimer_tick");
 BA.debugLineNum = 228;BA.debugLine="Sub PingTimer_Tick";
Debug.ShouldStop(8);
 BA.debugLineNum = 229;BA.debugLine="If AutoPing = True Then";
Debug.ShouldStop(16);
if (RemoteObject.solveBoolean("=",psy._autoping,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 230;BA.debugLine="WriteSocketIrc(\"PING :TIMEOUTCHECK\"&Chr(10))";
Debug.ShouldStop(32);
_writesocketirc(RemoteObject.concat(RemoteObject.createImmutable("PING :TIMEOUTCHECK"),psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 10)))));
 BA.debugLineNum = 231;BA.debugLine="AutoPing=False";
Debug.ShouldStop(64);
psy._autoping = psy.mostCurrent.__c.getField(true,"False");
 };
 BA.debugLineNum = 233;BA.debugLine="End Sub";
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
public static RemoteObject  _process_globals() throws Exception{
 //BA.debugLineNum = 6;BA.debugLine="Sub Process_Globals";
 //BA.debugLineNum = 8;BA.debugLine="Dim server As ServerSocket";
psy._server = RemoteObject.createNew ("anywheresoftware.b4a.objects.SocketWrapper.ServerSocketWrapper");
 //BA.debugLineNum = 9;BA.debugLine="Dim serverPort As String";
psy._serverport = RemoteObject.createImmutable("");
 //BA.debugLineNum = 15;BA.debugLine="Dim statesocket As Boolean";
psy._statesocket = RemoteObject.createImmutable(false);
 //BA.debugLineNum = 18;BA.debugLine="Dim socket_ricezione_dati As Socket";
psy._socket_ricezione_dati = RemoteObject.createNew ("anywheresoftware.b4a.objects.SocketWrapper");
 //BA.debugLineNum = 19;BA.debugLine="Dim socket_invio_dati As Socket";
psy._socket_invio_dati = RemoteObject.createNew ("anywheresoftware.b4a.objects.SocketWrapper");
 //BA.debugLineNum = 21;BA.debugLine="Dim datisocket_ricezione As AsyncStreams";
psy._datisocket_ricezione = RemoteObject.createNew ("anywheresoftware.b4a.randomaccessfile.AsyncStreams");
 //BA.debugLineNum = 22;BA.debugLine="Dim datisocket_ricezione_irc As AsyncStreams";
psy._datisocket_ricezione_irc = RemoteObject.createNew ("anywheresoftware.b4a.randomaccessfile.AsyncStreams");
 //BA.debugLineNum = 26;BA.debugLine="Dim IRClient As Boolean";
psy._irclient = RemoteObject.createImmutable(false);
 //BA.debugLineNum = 30;BA.debugLine="Dim MyIP As String";
psy._myip = RemoteObject.createImmutable("");
 //BA.debugLineNum = 33;BA.debugLine="Dim Timerserver As Timer";
psy._timerserver = RemoteObject.createNew ("anywheresoftware.b4a.objects.Timer");
 //BA.debugLineNum = 36;BA.debugLine="Dim joinpasswd As Boolean";
psy._joinpasswd = RemoteObject.createImmutable(false);
 //BA.debugLineNum = 40;BA.debugLine="Dim joinchannel As List";
psy._joinchannel = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");
 //BA.debugLineNum = 44;BA.debugLine="Dim Topichannel As List";
psy._topichannel = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");
 //BA.debugLineNum = 48;BA.debugLine="Dim MessageQuery As List";
psy._messagequery = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");
 //BA.debugLineNum = 51;BA.debugLine="Dim identIRC As String";
psy._identirc = RemoteObject.createImmutable("");
 //BA.debugLineNum = 52;BA.debugLine="Dim Nickconnessione As String";
psy._nickconnessione = RemoteObject.createImmutable("");
 //BA.debugLineNum = 54;BA.debugLine="Dim SaveMoth As String";
psy._savemoth = RemoteObject.createImmutable("");
 //BA.debugLineNum = 55;BA.debugLine="Dim StopMoth As Boolean";
psy._stopmoth = RemoteObject.createImmutable(false);
 //BA.debugLineNum = 57;BA.debugLine="Dim AwayNick As String";
psy._awaynick = RemoteObject.createImmutable("");
 //BA.debugLineNum = 58;BA.debugLine="Dim NormalNick As String";
psy._normalnick = RemoteObject.createImmutable("");
 //BA.debugLineNum = 60;BA.debugLine="Dim PingTimer As Timer";
psy._pingtimer = RemoteObject.createNew ("anywheresoftware.b4a.objects.Timer");
 //BA.debugLineNum = 61;BA.debugLine="Dim AutoPing As Boolean";
psy._autoping = RemoteObject.createImmutable(false);
 //BA.debugLineNum = 64;BA.debugLine="End Sub";
return RemoteObject.createImmutable("");
}
public static RemoteObject  _querymsg() throws Exception{
try {
		Debug.PushSubsStack("QueryMSG (psy) ","psy",1,psy.processBA,psy.mostCurrent,461);
if (RapidSub.canDelegate("querymsg")) return psy.remoteMe.runUserSub(false, "psy","querymsg");
RemoteObject _tr = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");
RemoteObject _tw = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");
 BA.debugLineNum = 461;BA.debugLine="Sub QueryMSG()";
Debug.ShouldStop(4096);
 BA.debugLineNum = 462;BA.debugLine="If MessageQuery.IsInitialized = True Then";
Debug.ShouldStop(8192);
if (RemoteObject.solveBoolean("=",psy._messagequery.runMethod(true,"IsInitialized"),psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 463;BA.debugLine="Dim tr As TextReader";
Debug.ShouldStop(16384);
_tr = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");Debug.locals.put("tr", _tr);
 BA.debugLineNum = 464;BA.debugLine="Dim tw As TextWriter";
Debug.ShouldStop(32768);
_tw = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");Debug.locals.put("tw", _tw);
 BA.debugLineNum = 465;BA.debugLine="tr.Initialize( socket_ricezione_dati.InputStream";
Debug.ShouldStop(65536);
_tr.runVoidMethod ("Initialize",(Object)(psy._socket_ricezione_dati.runMethod(false,"getInputStream")));
 BA.debugLineNum = 466;BA.debugLine="tw.Initialize( socket_ricezione_dati.OutputStrea";
Debug.ShouldStop(131072);
_tw.runVoidMethod ("Initialize",(Object)(psy._socket_ricezione_dati.runMethod(false,"getOutputStream")));
 BA.debugLineNum = 467;BA.debugLine="If MessageQuery.Size = 0 Then";
Debug.ShouldStop(262144);
if (RemoteObject.solveBoolean("=",psy._messagequery.runMethod(true,"getSize"),BA.numberCast(double.class, 0))) { 
 BA.debugLineNum = 468;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC You have";
Debug.ShouldStop(524288);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC You have no new Messages.")));
 }else {
 BA.debugLineNum = 470;BA.debugLine="tw.WriteLine(\":-psyBNC PRIVMSG psyBNC You have";
Debug.ShouldStop(2097152);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC You have Messages. Type /QUOTE PLAYPRIVATELOG To read your messages.")));
 };
 BA.debugLineNum = 472;BA.debugLine="tw.Flush";
Debug.ShouldStop(8388608);
_tw.runVoidMethod ("Flush");
 };
 BA.debugLineNum = 474;BA.debugLine="End Sub";
Debug.ShouldStop(33554432);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _readfile(RemoteObject _nomefile) throws Exception{
try {
		Debug.PushSubsStack("ReadFile (psy) ","psy",1,psy.processBA,psy.mostCurrent,104);
if (RapidSub.canDelegate("readfile")) return psy.remoteMe.runUserSub(false, "psy","readfile", _nomefile);
RemoteObject _reader = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");
RemoteObject _bufferfile = RemoteObject.createImmutable("");
RemoteObject _line = RemoteObject.createImmutable("");
Debug.locals.put("NomeFile", _nomefile);
 BA.debugLineNum = 104;BA.debugLine="Sub ReadFile(NomeFile As String)  As String";
Debug.ShouldStop(128);
 BA.debugLineNum = 105;BA.debugLine="Dim Reader As TextReader";
Debug.ShouldStop(256);
_reader = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");Debug.locals.put("Reader", _reader);
 BA.debugLineNum = 106;BA.debugLine="Dim BufferFile As String";
Debug.ShouldStop(512);
_bufferfile = RemoteObject.createImmutable("");Debug.locals.put("BufferFile", _bufferfile);
 BA.debugLineNum = 107;BA.debugLine="If  File.Exists(File.DirInternal, NomeFile) == T";
Debug.ShouldStop(1024);
if (RemoteObject.solveBoolean("=",psy.mostCurrent.__c.getField(false,"File").runMethod(true,"Exists",(Object)(psy.mostCurrent.__c.getField(false,"File").runMethod(true,"getDirInternal")),(Object)(_nomefile)),psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 108;BA.debugLine="Reader.Initialize(File.OpenInput(File.DirInte";
Debug.ShouldStop(2048);
_reader.runVoidMethod ("Initialize",(Object)((psy.mostCurrent.__c.getField(false,"File").runMethod(false,"OpenInput",(Object)(psy.mostCurrent.__c.getField(false,"File").runMethod(true,"getDirInternal")),(Object)(_nomefile)).getObject())));
 BA.debugLineNum = 109;BA.debugLine="Dim line As String";
Debug.ShouldStop(4096);
_line = RemoteObject.createImmutable("");Debug.locals.put("line", _line);
 BA.debugLineNum = 110;BA.debugLine="line = Reader.ReadLine";
Debug.ShouldStop(8192);
_line = _reader.runMethod(true,"ReadLine");Debug.locals.put("line", _line);
 BA.debugLineNum = 111;BA.debugLine="Do While line <> Null";
Debug.ShouldStop(16384);
while (RemoteObject.solveBoolean("N",_line)) {
 BA.debugLineNum = 113;BA.debugLine="If BufferFile.Length > 0 Then";
Debug.ShouldStop(65536);
if (RemoteObject.solveBoolean(">",_bufferfile.runMethod(true,"length"),BA.numberCast(double.class, 0))) { 
 BA.debugLineNum = 114;BA.debugLine="BufferFile = BufferFile & Chr(13) & line";
Debug.ShouldStop(131072);
_bufferfile = RemoteObject.concat(_bufferfile,psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 13))),_line);Debug.locals.put("BufferFile", _bufferfile);
 }else {
 BA.debugLineNum = 116;BA.debugLine="BufferFile = line";
Debug.ShouldStop(524288);
_bufferfile = _line;Debug.locals.put("BufferFile", _bufferfile);
 };
 BA.debugLineNum = 118;BA.debugLine="line = Reader.ReadLine";
Debug.ShouldStop(2097152);
_line = _reader.runMethod(true,"ReadLine");Debug.locals.put("line", _line);
 }
;
 BA.debugLineNum = 120;BA.debugLine="Reader.Close";
Debug.ShouldStop(8388608);
_reader.runVoidMethod ("Close");
 };
 BA.debugLineNum = 122;BA.debugLine="Return BufferFile";
Debug.ShouldStop(33554432);
if (true) return _bufferfile;
 BA.debugLineNum = 123;BA.debugLine="End Sub";
Debug.ShouldStop(67108864);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _rejoinchannel() throws Exception{
try {
		Debug.PushSubsStack("RejoinChannel (psy) ","psy",1,psy.processBA,psy.mostCurrent,545);
if (RapidSub.canDelegate("rejoinchannel")) return psy.remoteMe.runUserSub(false, "psy","rejoinchannel");
RemoteObject _i = RemoteObject.createImmutable(0L);
 BA.debugLineNum = 545;BA.debugLine="Sub RejoinChannel() As String";
Debug.ShouldStop(1);
 BA.debugLineNum = 546;BA.debugLine="If SaveMoth.Length > 0 Then";
Debug.ShouldStop(2);
if (RemoteObject.solveBoolean(">",psy._savemoth.runMethod(true,"length"),BA.numberCast(double.class, 0))) { 
 BA.debugLineNum = 547;BA.debugLine="Dim I As Long";
Debug.ShouldStop(4);
_i = RemoteObject.createImmutable(0L);Debug.locals.put("I", _i);
 BA.debugLineNum = 548;BA.debugLine="WriteSocketIrc(\"nick \"&NormalNick)";
Debug.ShouldStop(8);
_writesocketirc(RemoteObject.concat(RemoteObject.createImmutable("nick "),psy._normalnick));
 BA.debugLineNum = 549;BA.debugLine="WriteSocket(SaveMoth.Replace(\"$nick :\",Nickconnes";
Debug.ShouldStop(16);
_writesocket(psy._savemoth.runMethod(true,"replace",(Object)(BA.ObjectToString("$nick :")),(Object)(RemoteObject.concat(psy._nickconnessione,RemoteObject.createImmutable(" :")))).runMethod(true,"replace",(Object)(BA.ObjectToString("$nick!")),(Object)(RemoteObject.concat(psy._nickconnessione,RemoteObject.createImmutable("!")))));
 BA.debugLineNum = 550;BA.debugLine="For I = 0 To joinchannel.Size - 1";
Debug.ShouldStop(32);
{
final long step5 = 1;
final long limit5 = (long) (0 + RemoteObject.solve(new RemoteObject[] {psy._joinchannel.runMethod(true,"getSize"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue());
for (_i = BA.numberCast(long.class, 0) ; (step5 > 0 && _i.<Long>get().longValue() <= limit5) || (step5 < 0 && _i.<Long>get().longValue() >= limit5); _i = RemoteObject.createImmutable((long)(0 + _i.<Long>get().longValue() + step5)) ) {
Debug.locals.put("I", _i);
 BA.debugLineNum = 552;BA.debugLine="WriteSocket(\":\"&Nickconnessione &\"!psybnc@localh";
Debug.ShouldStop(128);
_writesocket(RemoteObject.concat(RemoteObject.createImmutable(":"),psy._nickconnessione,RemoteObject.createImmutable("!psybnc@localhost.psybnc-arkosoft.com JOIN :"),psy._joinchannel.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i))),psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 13)))));
 BA.debugLineNum = 553;BA.debugLine="Try";
Debug.ShouldStop(256);
try { BA.debugLineNum = 554;BA.debugLine="WriteSocket(\":server.psybnc.com 332 \"&Nickcon";
Debug.ShouldStop(512);
_writesocket(RemoteObject.concat(RemoteObject.createImmutable(":server.psybnc.com 332 "),psy._nickconnessione,RemoteObject.createImmutable(" "),psy._joinchannel.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i))),psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 13))),RemoteObject.createImmutable(" :"),psy._topichannel.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i))),psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 13)))));
 Debug.CheckDeviceExceptions();
} 
       catch (Exception e10) {
			BA.rdebugUtils.runVoidMethod("setLastException",psy.processBA, e10.toString()); };
 BA.debugLineNum = 557;BA.debugLine="WriteSocketIrc(\"join \"&joinchannel.Get(I))";
Debug.ShouldStop(4096);
_writesocketirc(RemoteObject.concat(RemoteObject.createImmutable("join "),psy._joinchannel.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i)))));
 BA.debugLineNum = 558;BA.debugLine="WriteSocketIrc(\"names \"&joinchannel.Get(I))";
Debug.ShouldStop(8192);
_writesocketirc(RemoteObject.concat(RemoteObject.createImmutable("names "),psy._joinchannel.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i)))));
 }
}Debug.locals.put("I", _i);
;
 };
 BA.debugLineNum = 562;BA.debugLine="End Sub";
Debug.ShouldStop(131072);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _ricezione_server(RemoteObject _read) throws Exception{
try {
		Debug.PushSubsStack("Ricezione_Server (psy) ","psy",1,psy.processBA,psy.mostCurrent,235);
if (RapidSub.canDelegate("ricezione_server")) return psy.remoteMe.runUserSub(false, "psy","ricezione_server", _read);
RemoteObject _pingstring = null;
RemoteObject _rigaread = null;
RemoteObject _numeroraw = null;
RemoteObject _start = RemoteObject.createImmutable(0L);
RemoteObject _changemoth = RemoteObject.createImmutable("");
RemoteObject _nmrandom = RemoteObject.createImmutable(0);
RemoteObject _f = RemoteObject.createImmutable("");
RemoteObject _tildechan = RemoteObject.createImmutable("");
RemoteObject _solovhost = null;
RemoteObject _realdate = RemoteObject.createImmutable("");
RemoteObject _messagetext = RemoteObject.createImmutable("");
RemoteObject _solomsg = null;
RemoteObject _solonick = null;
RemoteObject _senzaduepunti = null;
RemoteObject _realchan = null;
int _i = 0;
RemoteObject _nomecanale = RemoteObject.createImmutable("");
RemoteObject _toglipunti = null;
RemoteObject _nuovonick = null;
Debug.locals.put("Read", _read);
 BA.debugLineNum = 235;BA.debugLine="Sub Ricezione_Server(Read As String )";
Debug.ShouldStop(1024);
 BA.debugLineNum = 241;BA.debugLine="Dim PingString() As String";
Debug.ShouldStop(65536);
_pingstring = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("PingString", _pingstring);
 BA.debugLineNum = 242;BA.debugLine="PingString = Regex.Split(\":\",Read)";
Debug.ShouldStop(131072);
_pingstring = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_read));Debug.locals.put("PingString", _pingstring);
 BA.debugLineNum = 243;BA.debugLine="If PingString(0) = \"PING \" Then";
Debug.ShouldStop(262144);
if (RemoteObject.solveBoolean("=",_pingstring.getArrayElement(true,BA.numberCast(int.class, 0)),BA.ObjectToString("PING "))) { 
 BA.debugLineNum = 244;BA.debugLine="WriteSocketIrc(\"PONG \"&PingString(1)&Chr(13))";
Debug.ShouldStop(524288);
_writesocketirc(RemoteObject.concat(RemoteObject.createImmutable("PONG "),_pingstring.getArrayElement(true,BA.numberCast(int.class, 1)),psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 13)))));
 BA.debugLineNum = 245;BA.debugLine="AutoPing = True";
Debug.ShouldStop(1048576);
psy._autoping = psy.mostCurrent.__c.getField(true,"True");
 BA.debugLineNum = 246;BA.debugLine="Return \"\"";
Debug.ShouldStop(2097152);
if (true) return BA.ObjectToString("");
 };
 BA.debugLineNum = 254;BA.debugLine="Dim RigaRead() As String";
Debug.ShouldStop(536870912);
_rigaread = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("RigaRead", _rigaread);
 BA.debugLineNum = 255;BA.debugLine="Dim NumeroRaw() As String";
Debug.ShouldStop(1073741824);
_numeroraw = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("NumeroRaw", _numeroraw);
 BA.debugLineNum = 256;BA.debugLine="Dim Start As Long";
Debug.ShouldStop(-2147483648);
_start = RemoteObject.createImmutable(0L);Debug.locals.put("Start", _start);
 BA.debugLineNum = 257;BA.debugLine="RigaRead = Regex.Split(Chr(13),Read)";
Debug.ShouldStop(1);
_rigaread = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 13))))),(Object)(_read));Debug.locals.put("RigaRead", _rigaread);
 BA.debugLineNum = 258;BA.debugLine="For Start = 0 To RigaRead.Length -1";
Debug.ShouldStop(2);
{
final long step12 = 1;
final long limit12 = (long) (0 + RemoteObject.solve(new RemoteObject[] {_rigaread.getField(true,"length"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue());
for (_start = BA.numberCast(long.class, 0) ; (step12 > 0 && _start.<Long>get().longValue() <= limit12) || (step12 < 0 && _start.<Long>get().longValue() >= limit12); _start = RemoteObject.createImmutable((long)(0 + _start.<Long>get().longValue() + step12)) ) {
Debug.locals.put("Start", _start);
 BA.debugLineNum = 259;BA.debugLine="If RigaRead(Start).Contains(Chr(32)) == True The";
Debug.ShouldStop(4);
if (RemoteObject.solveBoolean("=",_rigaread.getArrayElement(true,BA.numberCast(int.class, _start)).runMethod(true,"contains",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 32)))))),psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 260;BA.debugLine="NumeroRaw = Regex.Split(Chr(32),RigaRead(Star";
Debug.ShouldStop(8);
_numeroraw = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 32))))),(Object)(_rigaread.getArrayElement(true,BA.numberCast(int.class, _start))));Debug.locals.put("NumeroRaw", _numeroraw);
 BA.debugLineNum = 262;BA.debugLine="If NumeroRaw.Length = 1 Then Return \"\"";
Debug.ShouldStop(32);
if (RemoteObject.solveBoolean("=",_numeroraw.getField(true,"length"),BA.numberCast(double.class, 1))) { 
if (true) return BA.ObjectToString("");};
 BA.debugLineNum = 264;BA.debugLine="If NumeroRaw(1) = \"376\" Then";
Debug.ShouldStop(128);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 1)),BA.ObjectToString("376"))) { 
 BA.debugLineNum = 265;BA.debugLine="SaveMoth =  SaveMoth & RigaRead(Start) & Chr(";
Debug.ShouldStop(256);
psy._savemoth = RemoteObject.concat(psy._savemoth,_rigaread.getArrayElement(true,BA.numberCast(int.class, _start)),psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 32))));
 BA.debugLineNum = 266;BA.debugLine="StopMoth = False";
Debug.ShouldStop(512);
psy._stopmoth = psy.mostCurrent.__c.getField(true,"False");
 BA.debugLineNum = 267;BA.debugLine="RejoinChannel";
Debug.ShouldStop(1024);
_rejoinchannel();
 };
 BA.debugLineNum = 270;BA.debugLine="If StopMoth = True Then";
Debug.ShouldStop(8192);
if (RemoteObject.solveBoolean("=",psy._stopmoth,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 271;BA.debugLine="SaveMoth =  SaveMoth & RigaRead(Start) & Chr(";
Debug.ShouldStop(16384);
psy._savemoth = RemoteObject.concat(psy._savemoth,_rigaread.getArrayElement(true,BA.numberCast(int.class, _start)),psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 32))));
 };
 BA.debugLineNum = 278;BA.debugLine="If NumeroRaw(1) = \"001\" Then";
Debug.ShouldStop(2097152);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 1)),BA.ObjectToString("001"))) { 
 BA.debugLineNum = 279;BA.debugLine="StopMoth = True";
Debug.ShouldStop(4194304);
psy._stopmoth = psy.mostCurrent.__c.getField(true,"True");
 BA.debugLineNum = 280;BA.debugLine="Nickconnessione = NumeroRaw(2)";
Debug.ShouldStop(8388608);
psy._nickconnessione = _numeroraw.getArrayElement(true,BA.numberCast(int.class, 2));
 BA.debugLineNum = 281;BA.debugLine="changemoth = RigaRead(Start).Replace(Nickconn";
Debug.ShouldStop(16777216);
_changemoth = _rigaread.getArrayElement(true,BA.numberCast(int.class, _start)).runMethod(true,"replace",(Object)(RemoteObject.concat(psy._nickconnessione,RemoteObject.createImmutable(" :"))),(Object)(RemoteObject.createImmutable("$nick :"))).runMethod(true,"replace",(Object)(RemoteObject.concat(psy._nickconnessione,RemoteObject.createImmutable("!"))),(Object)(RemoteObject.createImmutable("$nick!")));Debug.locals.put("changemoth", _changemoth);
 BA.debugLineNum = 282;BA.debugLine="SaveMoth =  changemoth & Chr(32)";
Debug.ShouldStop(33554432);
psy._savemoth = RemoteObject.concat(_changemoth,psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 32))));
 };
 BA.debugLineNum = 288;BA.debugLine="If NumeroRaw(1)=\"433\" AND Nickconnessione.Leng";
Debug.ShouldStop(-2147483648);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 1)),BA.ObjectToString("433")) && RemoteObject.solveBoolean(">",psy._nickconnessione.runMethod(true,"length"),BA.numberCast(double.class, 0)) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"False"))) { 
 BA.debugLineNum = 289;BA.debugLine="Dim nmrandom As Int";
Debug.ShouldStop(1);
_nmrandom = RemoteObject.createImmutable(0);Debug.locals.put("nmrandom", _nmrandom);
 BA.debugLineNum = 290;BA.debugLine="Dim f As String";
Debug.ShouldStop(2);
_f = RemoteObject.createImmutable("");Debug.locals.put("f", _f);
 BA.debugLineNum = 291;BA.debugLine="nmrandom = Rnd(1,10)";
Debug.ShouldStop(4);
_nmrandom = psy.mostCurrent.__c.runMethod(true,"Rnd",(Object)(BA.numberCast(int.class, 1)),(Object)(BA.numberCast(int.class, 10)));Debug.locals.put("nmrandom", _nmrandom);
 BA.debugLineNum = 292;BA.debugLine="f= nmrandom";
Debug.ShouldStop(8);
_f = BA.NumberToString(_nmrandom);Debug.locals.put("f", _f);
 BA.debugLineNum = 293;BA.debugLine="WriteSocketIrc(\"nick \"&Nickconnessione&f)";
Debug.ShouldStop(16);
_writesocketirc(RemoteObject.concat(RemoteObject.createImmutable("nick "),psy._nickconnessione,_f));
 };
 BA.debugLineNum = 299;BA.debugLine="If NumeroRaw(1) = \"PRIVMSG\" AND joinpasswd = F";
Debug.ShouldStop(1024);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 1)),BA.ObjectToString("PRIVMSG")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"False"))) { 
 BA.debugLineNum = 300;BA.debugLine="Dim TildeChan As String";
Debug.ShouldStop(2048);
_tildechan = RemoteObject.createImmutable("");Debug.locals.put("TildeChan", _tildechan);
 BA.debugLineNum = 301;BA.debugLine="TildeChan = NumeroRaw(2).SubString2(0,1)";
Debug.ShouldStop(4096);
_tildechan = _numeroraw.getArrayElement(true,BA.numberCast(int.class, 2)).runMethod(true,"substring",(Object)(BA.numberCast(int.class, 0)),(Object)(BA.numberCast(int.class, 1)));Debug.locals.put("TildeChan", _tildechan);
 BA.debugLineNum = 302;BA.debugLine="If TildeChan <> \"#\" AND TildeChan <> \"&\" Then";
Debug.ShouldStop(8192);
if (RemoteObject.solveBoolean("!",_tildechan,BA.ObjectToString("#")) && RemoteObject.solveBoolean("!",_tildechan,BA.ObjectToString("&"))) { 
 BA.debugLineNum = 304;BA.debugLine="Dim SoloVhost() As String";
Debug.ShouldStop(32768);
_solovhost = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("SoloVhost", _solovhost);
 BA.debugLineNum = 306;BA.debugLine="Dim RealDate As String";
Debug.ShouldStop(131072);
_realdate = RemoteObject.createImmutable("");Debug.locals.put("RealDate", _realdate);
 BA.debugLineNum = 307;BA.debugLine="SoloVhost = Regex.Split(\":\",NumeroRaw(0))";
Debug.ShouldStop(262144);
_solovhost = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_numeroraw.getArrayElement(true,BA.numberCast(int.class, 0))));Debug.locals.put("SoloVhost", _solovhost);
 BA.debugLineNum = 308;BA.debugLine="RealDate = GeneraDAtaUnix";
Debug.ShouldStop(524288);
_realdate = _generadataunix();Debug.locals.put("RealDate", _realdate);
 BA.debugLineNum = 309;BA.debugLine="Dim Start As Long";
Debug.ShouldStop(1048576);
_start = RemoteObject.createImmutable(0L);Debug.locals.put("Start", _start);
 BA.debugLineNum = 310;BA.debugLine="Dim MessageText As String";
Debug.ShouldStop(2097152);
_messagetext = RemoteObject.createImmutable("");Debug.locals.put("MessageText", _messagetext);
 BA.debugLineNum = 311;BA.debugLine="For Start = 3 To NumeroRaw.Length -1";
Debug.ShouldStop(4194304);
{
final long step47 = 1;
final long limit47 = (long) (0 + RemoteObject.solve(new RemoteObject[] {_numeroraw.getField(true,"length"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue());
for (_start = BA.numberCast(long.class, 3) ; (step47 > 0 && _start.<Long>get().longValue() <= limit47) || (step47 < 0 && _start.<Long>get().longValue() >= limit47); _start = RemoteObject.createImmutable((long)(0 + _start.<Long>get().longValue() + step47)) ) {
Debug.locals.put("Start", _start);
 BA.debugLineNum = 312;BA.debugLine="If Start = 3 Then";
Debug.ShouldStop(8388608);
if (RemoteObject.solveBoolean("=",_start,BA.numberCast(double.class, 3))) { 
 BA.debugLineNum = 313;BA.debugLine="Dim SoloMSG() As String";
Debug.ShouldStop(16777216);
_solomsg = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("SoloMSG", _solomsg);
 BA.debugLineNum = 314;BA.debugLine="SoloMSG = Regex.Split(\":\",NumeroRaw(3))";
Debug.ShouldStop(33554432);
_solomsg = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_numeroraw.getArrayElement(true,BA.numberCast(int.class, 3))));Debug.locals.put("SoloMSG", _solomsg);
 BA.debugLineNum = 315;BA.debugLine="MessageText = SoloMSG(1)";
Debug.ShouldStop(67108864);
_messagetext = _solomsg.getArrayElement(true,BA.numberCast(int.class, 1));Debug.locals.put("MessageText", _messagetext);
 }else {
 BA.debugLineNum = 317;BA.debugLine="MessageText = MessageText & \" \" & NumeroRa";
Debug.ShouldStop(268435456);
_messagetext = RemoteObject.concat(_messagetext,RemoteObject.createImmutable(" "),_numeroraw.getArrayElement(true,BA.numberCast(int.class, _start)));Debug.locals.put("MessageText", _messagetext);
 };
 }
}Debug.locals.put("Start", _start);
;
 BA.debugLineNum = 320;BA.debugLine="MessageQuery.AddAll(Array As String(RealDate";
Debug.ShouldStop(-2147483648);
psy._messagequery.runVoidMethod ("AddAll",(Object)(psy.mostCurrent.__c.runMethod(false, "ArrayToList", (Object)(RemoteObject.createNewArray("String",new int[] {1},new Object[] {RemoteObject.concat(_realdate,RemoteObject.createImmutable(" :("),_solovhost.getArrayElement(true,BA.numberCast(int.class, 1)),RemoteObject.createImmutable(")"),RemoteObject.createImmutable(" "),_messagetext)})))));
 };
 };
 BA.debugLineNum = 326;BA.debugLine="If NumeroRaw(1) = \"JOIN\" Then";
Debug.ShouldStop(32);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 1)),BA.ObjectToString("JOIN"))) { 
 BA.debugLineNum = 327;BA.debugLine="Dim SolOnick() As String";
Debug.ShouldStop(64);
_solonick = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("SolOnick", _solonick);
 BA.debugLineNum = 328;BA.debugLine="Dim SenzaDuePunti() As  String";
Debug.ShouldStop(128);
_senzaduepunti = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("SenzaDuePunti", _senzaduepunti);
 BA.debugLineNum = 329;BA.debugLine="SolOnick = Regex.Split(\"!\",NumeroRaw(0))";
Debug.ShouldStop(256);
_solonick = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString("!")),(Object)(_numeroraw.getArrayElement(true,BA.numberCast(int.class, 0))));Debug.locals.put("SolOnick", _solonick);
 BA.debugLineNum = 330;BA.debugLine="SenzaDuePunti = Regex.Split(\":\",SolOnick(0))";
Debug.ShouldStop(512);
_senzaduepunti = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_solonick.getArrayElement(true,BA.numberCast(int.class, 0))));Debug.locals.put("SenzaDuePunti", _senzaduepunti);
 BA.debugLineNum = 331;BA.debugLine="If SenzaDuePunti(1) = Nickconnessione Then";
Debug.ShouldStop(1024);
if (RemoteObject.solveBoolean("=",_senzaduepunti.getArrayElement(true,BA.numberCast(int.class, 1)),psy._nickconnessione)) { 
 BA.debugLineNum = 332;BA.debugLine="Dim RealChan() As String";
Debug.ShouldStop(2048);
_realchan = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("RealChan", _realchan);
 BA.debugLineNum = 333;BA.debugLine="RealChan = Regex.Split(\":\",NumeroRaw(2))";
Debug.ShouldStop(4096);
_realchan = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_numeroraw.getArrayElement(true,BA.numberCast(int.class, 2))));Debug.locals.put("RealChan", _realchan);
 BA.debugLineNum = 334;BA.debugLine="joinchannel.AddAll(Array As String(RealChan(";
Debug.ShouldStop(8192);
psy._joinchannel.runVoidMethod ("AddAll",(Object)(psy.mostCurrent.__c.runMethod(false, "ArrayToList", (Object)(RemoteObject.createNewArray("String",new int[] {1},new Object[] {_realchan.getArrayElement(true,BA.numberCast(int.class, 1))})))));
 BA.debugLineNum = 335;BA.debugLine="Topichannel.addAll(Array As String(\"\"))";
Debug.ShouldStop(16384);
psy._topichannel.runVoidMethod ("AddAll",(Object)(psy.mostCurrent.__c.runMethod(false, "ArrayToList", (Object)(RemoteObject.createNewArray("String",new int[] {1},new Object[] {RemoteObject.createImmutable("")})))));
 };
 };
 BA.debugLineNum = 339;BA.debugLine="If NumeroRaw(1) =\"332\" Then";
Debug.ShouldStop(262144);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 1)),BA.ObjectToString("332"))) { 
 BA.debugLineNum = 340;BA.debugLine="For i = 0 To joinchannel.Size - 1";
Debug.ShouldStop(524288);
{
final int step72 = 1;
final int limit72 = RemoteObject.solve(new RemoteObject[] {psy._joinchannel.runMethod(true,"getSize"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue();
for (_i = 0 ; (step72 > 0 && _i <= limit72) || (step72 < 0 && _i >= limit72); _i = ((int)(0 + _i + step72)) ) {
Debug.locals.put("i", _i);
 BA.debugLineNum = 341;BA.debugLine="If NumeroRaw(3) = joinchannel.Get(i) Then";
Debug.ShouldStop(1048576);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 3)),BA.ObjectToString(psy._joinchannel.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i)))))) { 
 BA.debugLineNum = 342;BA.debugLine="SaveTopic(i,NumeroRaw)";
Debug.ShouldStop(2097152);
_savetopic(BA.numberCast(long.class, _i),_numeroraw);
 };
 }
}Debug.locals.put("i", _i);
;
 };
 BA.debugLineNum = 351;BA.debugLine="If NumeroRaw(1) = \"PART\" Then";
Debug.ShouldStop(1073741824);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 1)),BA.ObjectToString("PART"))) { 
 BA.debugLineNum = 352;BA.debugLine="Dim SolOnick() As String";
Debug.ShouldStop(-2147483648);
_solonick = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("SolOnick", _solonick);
 BA.debugLineNum = 353;BA.debugLine="Dim SenzaDuePunti() As  String";
Debug.ShouldStop(1);
_senzaduepunti = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("SenzaDuePunti", _senzaduepunti);
 BA.debugLineNum = 354;BA.debugLine="Dim nomecanale As String";
Debug.ShouldStop(2);
_nomecanale = RemoteObject.createImmutable("");Debug.locals.put("nomecanale", _nomecanale);
 BA.debugLineNum = 355;BA.debugLine="SolOnick = Regex.Split(\"!\",NumeroRaw(0))";
Debug.ShouldStop(4);
_solonick = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString("!")),(Object)(_numeroraw.getArrayElement(true,BA.numberCast(int.class, 0))));Debug.locals.put("SolOnick", _solonick);
 BA.debugLineNum = 356;BA.debugLine="SenzaDuePunti = Regex.Split(\":\",SolOnick(0))";
Debug.ShouldStop(8);
_senzaduepunti = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_solonick.getArrayElement(true,BA.numberCast(int.class, 0))));Debug.locals.put("SenzaDuePunti", _senzaduepunti);
 BA.debugLineNum = 357;BA.debugLine="If SenzaDuePunti(1) = Nickconnessione Then";
Debug.ShouldStop(16);
if (RemoteObject.solveBoolean("=",_senzaduepunti.getArrayElement(true,BA.numberCast(int.class, 1)),psy._nickconnessione)) { 
 BA.debugLineNum = 358;BA.debugLine="For i = 0 To joinchannel.Size - 1";
Debug.ShouldStop(32);
{
final int step85 = 1;
final int limit85 = RemoteObject.solve(new RemoteObject[] {psy._joinchannel.runMethod(true,"getSize"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue();
for (_i = 0 ; (step85 > 0 && _i <= limit85) || (step85 < 0 && _i >= limit85); _i = ((int)(0 + _i + step85)) ) {
Debug.locals.put("i", _i);
 BA.debugLineNum = 359;BA.debugLine="If i <= joinchannel.Size -1 Then";
Debug.ShouldStop(64);
if (RemoteObject.solveBoolean("k",RemoteObject.createImmutable(_i),BA.numberCast(double.class, RemoteObject.solve(new RemoteObject[] {psy._joinchannel.runMethod(true,"getSize"),RemoteObject.createImmutable(1)}, "-",1, 1)))) { 
 BA.debugLineNum = 360;BA.debugLine="nomecanale = joinchannel.Get(i)";
Debug.ShouldStop(128);
_nomecanale = BA.ObjectToString(psy._joinchannel.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i))));Debug.locals.put("nomecanale", _nomecanale);
 BA.debugLineNum = 361;BA.debugLine="If NumeroRaw(2) = nomecanale Then";
Debug.ShouldStop(256);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 2)),_nomecanale)) { 
 BA.debugLineNum = 362;BA.debugLine="If joinchannel.get(i) <> Null Then joinc";
Debug.ShouldStop(512);
if (RemoteObject.solveBoolean("N",psy._joinchannel.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i))))) { 
psy._joinchannel.runVoidMethod ("RemoveAt",(Object)(BA.numberCast(int.class, _i)));};
 BA.debugLineNum = 363;BA.debugLine="If Topichannel.get(i) <> Null Then Topic";
Debug.ShouldStop(1024);
if (RemoteObject.solveBoolean("N",psy._topichannel.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i))))) { 
psy._topichannel.runVoidMethod ("RemoveAt",(Object)(BA.numberCast(int.class, _i)));};
 };
 };
 }
}Debug.locals.put("i", _i);
;
 };
 BA.debugLineNum = 368;BA.debugLine="Return Read";
Debug.ShouldStop(32768);
if (true) return _read;
 };
 BA.debugLineNum = 373;BA.debugLine="If NumeroRaw(1) = \"TOPIC\" Then";
Debug.ShouldStop(1048576);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 1)),BA.ObjectToString("TOPIC"))) { 
 BA.debugLineNum = 374;BA.debugLine="For i = 0 To joinchannel.Size - 1";
Debug.ShouldStop(2097152);
{
final int step98 = 1;
final int limit98 = RemoteObject.solve(new RemoteObject[] {psy._joinchannel.runMethod(true,"getSize"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue();
for (_i = 0 ; (step98 > 0 && _i <= limit98) || (step98 < 0 && _i >= limit98); _i = ((int)(0 + _i + step98)) ) {
Debug.locals.put("i", _i);
 BA.debugLineNum = 375;BA.debugLine="If NumeroRaw(2) = joinchannel.Get(i) Then";
Debug.ShouldStop(4194304);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 2)),BA.ObjectToString(psy._joinchannel.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i)))))) { 
 BA.debugLineNum = 376;BA.debugLine="SaveTopic(i,NumeroRaw)";
Debug.ShouldStop(8388608);
_savetopic(BA.numberCast(long.class, _i),_numeroraw);
 };
 }
}Debug.locals.put("i", _i);
;
 BA.debugLineNum = 379;BA.debugLine="Return Read";
Debug.ShouldStop(67108864);
if (true) return _read;
 };
 BA.debugLineNum = 384;BA.debugLine="If NumeroRaw(1) = \"NICK\" Then";
Debug.ShouldStop(-2147483648);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 1)),BA.ObjectToString("NICK"))) { 
 BA.debugLineNum = 385;BA.debugLine="Dim SolOnick() As String";
Debug.ShouldStop(1);
_solonick = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("SolOnick", _solonick);
 BA.debugLineNum = 386;BA.debugLine="Dim TogliPunti() As String";
Debug.ShouldStop(2);
_toglipunti = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("TogliPunti", _toglipunti);
 BA.debugLineNum = 387;BA.debugLine="SolOnick = Regex.Split(\"!\",NumeroRaw(0))";
Debug.ShouldStop(4);
_solonick = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString("!")),(Object)(_numeroraw.getArrayElement(true,BA.numberCast(int.class, 0))));Debug.locals.put("SolOnick", _solonick);
 BA.debugLineNum = 388;BA.debugLine="TogliPunti = Regex.Split(\":\",SolOnick(0))";
Debug.ShouldStop(8);
_toglipunti = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_solonick.getArrayElement(true,BA.numberCast(int.class, 0))));Debug.locals.put("TogliPunti", _toglipunti);
 BA.debugLineNum = 389;BA.debugLine="If TogliPunti(1) = Nickconnessione Then";
Debug.ShouldStop(16);
if (RemoteObject.solveBoolean("=",_toglipunti.getArrayElement(true,BA.numberCast(int.class, 1)),psy._nickconnessione)) { 
 BA.debugLineNum = 390;BA.debugLine="Dim NuovoNick() As String";
Debug.ShouldStop(32);
_nuovonick = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("NuovoNick", _nuovonick);
 BA.debugLineNum = 391;BA.debugLine="NuovoNick = Regex.Split(\":\",NumeroRaw(2))";
Debug.ShouldStop(64);
_nuovonick = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_numeroraw.getArrayElement(true,BA.numberCast(int.class, 2))));Debug.locals.put("NuovoNick", _nuovonick);
 BA.debugLineNum = 392;BA.debugLine="Nickconnessione =NuovoNick(1)";
Debug.ShouldStop(128);
psy._nickconnessione = _nuovonick.getArrayElement(true,BA.numberCast(int.class, 1));
 };
 BA.debugLineNum = 394;BA.debugLine="Return Read";
Debug.ShouldStop(512);
if (true) return _read;
 };
 BA.debugLineNum = 399;BA.debugLine="If NumeroRaw(1) = \"KICK\" Then";
Debug.ShouldStop(16384);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 1)),BA.ObjectToString("KICK"))) { 
 BA.debugLineNum = 400;BA.debugLine="If NumeroRaw(3) = Nickconnessione Then";
Debug.ShouldStop(32768);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 3)),psy._nickconnessione)) { 
 BA.debugLineNum = 401;BA.debugLine="For i = 0 To joinchannel.Size - 1";
Debug.ShouldStop(65536);
{
final int step119 = 1;
final int limit119 = RemoteObject.solve(new RemoteObject[] {psy._joinchannel.runMethod(true,"getSize"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue();
for (_i = 0 ; (step119 > 0 && _i <= limit119) || (step119 < 0 && _i >= limit119); _i = ((int)(0 + _i + step119)) ) {
Debug.locals.put("i", _i);
 BA.debugLineNum = 402;BA.debugLine="If NumeroRaw(2) = joinchannel.Get(i) Then";
Debug.ShouldStop(131072);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 2)),BA.ObjectToString(psy._joinchannel.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i)))))) { 
 BA.debugLineNum = 403;BA.debugLine="joinchannel.RemoveAt(i)";
Debug.ShouldStop(262144);
psy._joinchannel.runVoidMethod ("RemoveAt",(Object)(BA.numberCast(int.class, _i)));
 BA.debugLineNum = 404;BA.debugLine="Topichannel.removeAt(i)";
Debug.ShouldStop(524288);
psy._topichannel.runVoidMethod ("RemoveAt",(Object)(BA.numberCast(int.class, _i)));
 };
 }
}Debug.locals.put("i", _i);
;
 };
 BA.debugLineNum = 408;BA.debugLine="Return Read";
Debug.ShouldStop(8388608);
if (true) return _read;
 };
 };
 }
}Debug.locals.put("Start", _start);
;
 BA.debugLineNum = 416;BA.debugLine="Return Read";
Debug.ShouldStop(-2147483648);
if (true) return _read;
 BA.debugLineNum = 418;BA.debugLine="End Sub";
Debug.ShouldStop(2);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _savetopic(RemoteObject _i,RemoteObject _numeroraw) throws Exception{
try {
		Debug.PushSubsStack("SaveTopic (psy) ","psy",1,psy.processBA,psy.mostCurrent,174);
if (RapidSub.canDelegate("savetopic")) return psy.remoteMe.runUserSub(false, "psy","savetopic", _i, _numeroraw);
RemoteObject _p = RemoteObject.createImmutable(0L);
RemoteObject _totaletopic = RemoteObject.createImmutable("");
RemoteObject _senzapunti = null;
Debug.locals.put("i", _i);
Debug.locals.put("NumeroRaw", _numeroraw);
 BA.debugLineNum = 174;BA.debugLine="Sub SaveTopic(i As Long,NumeroRaw() As String)";
Debug.ShouldStop(8192);
 BA.debugLineNum = 179;BA.debugLine="If NumeroRaw(1) = \"TOPIC\" Then";
Debug.ShouldStop(262144);
if (RemoteObject.solveBoolean("=",_numeroraw.getArrayElement(true,BA.numberCast(int.class, 1)),BA.ObjectToString("TOPIC"))) { 
 BA.debugLineNum = 180;BA.debugLine="Dim p As Long";
Debug.ShouldStop(524288);
_p = RemoteObject.createImmutable(0L);Debug.locals.put("p", _p);
 BA.debugLineNum = 181;BA.debugLine="Dim TotaleTopic As String";
Debug.ShouldStop(1048576);
_totaletopic = RemoteObject.createImmutable("");Debug.locals.put("TotaleTopic", _totaletopic);
 BA.debugLineNum = 182;BA.debugLine="TotaleTopic = \"\"";
Debug.ShouldStop(2097152);
_totaletopic = BA.ObjectToString("");Debug.locals.put("TotaleTopic", _totaletopic);
 BA.debugLineNum = 183;BA.debugLine="For p = 3 To NumeroRaw.Length -1";
Debug.ShouldStop(4194304);
{
final long step5 = 1;
final long limit5 = (long) (0 + RemoteObject.solve(new RemoteObject[] {_numeroraw.getField(true,"length"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue());
for (_p = BA.numberCast(long.class, 3) ; (step5 > 0 && _p.<Long>get().longValue() <= limit5) || (step5 < 0 && _p.<Long>get().longValue() >= limit5); _p = RemoteObject.createImmutable((long)(0 + _p.<Long>get().longValue() + step5)) ) {
Debug.locals.put("p", _p);
 BA.debugLineNum = 184;BA.debugLine="If p = 3 Then";
Debug.ShouldStop(8388608);
if (RemoteObject.solveBoolean("=",_p,BA.numberCast(double.class, 3))) { 
 BA.debugLineNum = 185;BA.debugLine="Dim TotaleTopic As String";
Debug.ShouldStop(16777216);
_totaletopic = RemoteObject.createImmutable("");Debug.locals.put("TotaleTopic", _totaletopic);
 BA.debugLineNum = 186;BA.debugLine="Dim SenzaPunti() As String";
Debug.ShouldStop(33554432);
_senzapunti = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("SenzaPunti", _senzapunti);
 BA.debugLineNum = 187;BA.debugLine="SenzaPunti =  Regex.Split(\":\",NumeroRaw(p))";
Debug.ShouldStop(67108864);
_senzapunti = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_numeroraw.getArrayElement(true,BA.numberCast(int.class, _p))));Debug.locals.put("SenzaPunti", _senzapunti);
 BA.debugLineNum = 188;BA.debugLine="TotaleTopic = SenzaPunti(1) & Chr(32)";
Debug.ShouldStop(134217728);
_totaletopic = RemoteObject.concat(_senzapunti.getArrayElement(true,BA.numberCast(int.class, 1)),psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 32))));Debug.locals.put("TotaleTopic", _totaletopic);
 }else {
 BA.debugLineNum = 190;BA.debugLine="If p = NumeroRaw.Length -1 Then";
Debug.ShouldStop(536870912);
if (RemoteObject.solveBoolean("=",_p,BA.numberCast(double.class, RemoteObject.solve(new RemoteObject[] {_numeroraw.getField(true,"length"),RemoteObject.createImmutable(1)}, "-",1, 1)))) { 
 BA.debugLineNum = 191;BA.debugLine="TotaleTopic = TotaleTopic  & NumeroRaw(p)";
Debug.ShouldStop(1073741824);
_totaletopic = RemoteObject.concat(_totaletopic,_numeroraw.getArrayElement(true,BA.numberCast(int.class, _p)));Debug.locals.put("TotaleTopic", _totaletopic);
 }else {
 BA.debugLineNum = 193;BA.debugLine="TotaleTopic = TotaleTopic  & NumeroRaw(p) & Ch";
Debug.ShouldStop(1);
_totaletopic = RemoteObject.concat(_totaletopic,_numeroraw.getArrayElement(true,BA.numberCast(int.class, _p)),psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 32))));Debug.locals.put("TotaleTopic", _totaletopic);
 };
 };
 }
}Debug.locals.put("p", _p);
;
 }else {
 BA.debugLineNum = 198;BA.debugLine="Dim p As Long";
Debug.ShouldStop(32);
_p = RemoteObject.createImmutable(0L);Debug.locals.put("p", _p);
 BA.debugLineNum = 199;BA.debugLine="For p = 4 To NumeroRaw.Length -1";
Debug.ShouldStop(64);
{
final long step21 = 1;
final long limit21 = (long) (0 + RemoteObject.solve(new RemoteObject[] {_numeroraw.getField(true,"length"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue());
for (_p = BA.numberCast(long.class, 4) ; (step21 > 0 && _p.<Long>get().longValue() <= limit21) || (step21 < 0 && _p.<Long>get().longValue() >= limit21); _p = RemoteObject.createImmutable((long)(0 + _p.<Long>get().longValue() + step21)) ) {
Debug.locals.put("p", _p);
 BA.debugLineNum = 200;BA.debugLine="If p = 4 Then";
Debug.ShouldStop(128);
if (RemoteObject.solveBoolean("=",_p,BA.numberCast(double.class, 4))) { 
 BA.debugLineNum = 201;BA.debugLine="Dim TotaleTopic As String";
Debug.ShouldStop(256);
_totaletopic = RemoteObject.createImmutable("");Debug.locals.put("TotaleTopic", _totaletopic);
 BA.debugLineNum = 202;BA.debugLine="Dim SenzaPunti() As String";
Debug.ShouldStop(512);
_senzapunti = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("SenzaPunti", _senzapunti);
 BA.debugLineNum = 203;BA.debugLine="SenzaPunti =  Regex.Split(\":\",NumeroRaw(p))";
Debug.ShouldStop(1024);
_senzapunti = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_numeroraw.getArrayElement(true,BA.numberCast(int.class, _p))));Debug.locals.put("SenzaPunti", _senzapunti);
 BA.debugLineNum = 204;BA.debugLine="TotaleTopic = SenzaPunti(1)";
Debug.ShouldStop(2048);
_totaletopic = _senzapunti.getArrayElement(true,BA.numberCast(int.class, 1));Debug.locals.put("TotaleTopic", _totaletopic);
 }else {
 BA.debugLineNum = 206;BA.debugLine="TotaleTopic = TotaleTopic  & \" \"& NumeroRaw(p)";
Debug.ShouldStop(8192);
_totaletopic = RemoteObject.concat(_totaletopic,RemoteObject.createImmutable(" "),_numeroraw.getArrayElement(true,BA.numberCast(int.class, _p)));Debug.locals.put("TotaleTopic", _totaletopic);
 };
 }
}Debug.locals.put("p", _p);
;
 };
 BA.debugLineNum = 210;BA.debugLine="If i < Topichannel.Size Then";
Debug.ShouldStop(131072);
if (RemoteObject.solveBoolean("<",_i,BA.numberCast(double.class, psy._topichannel.runMethod(true,"getSize")))) { 
 BA.debugLineNum = 211;BA.debugLine="Topichannel.Set(i, TotaleTopic)";
Debug.ShouldStop(262144);
psy._topichannel.runVoidMethod ("Set",(Object)(BA.numberCast(int.class, _i)),(Object)((_totaletopic)));
 };
 BA.debugLineNum = 214;BA.debugLine="End Sub";
Debug.ShouldStop(2097152);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _server_newconnection(RemoteObject _successful,RemoteObject _newsocket) throws Exception{
try {
		Debug.PushSubsStack("Server_NewConnection (psy) ","psy",1,psy.processBA,psy.mostCurrent,92);
if (RapidSub.canDelegate("server_newconnection")) return psy.remoteMe.runUserSub(false, "psy","server_newconnection", _successful, _newsocket);
Debug.locals.put("Successful", _successful);
Debug.locals.put("NewSocket", _newsocket);
 BA.debugLineNum = 92;BA.debugLine="Sub Server_NewConnection (Successful As Boolean, N";
Debug.ShouldStop(134217728);
 BA.debugLineNum = 93;BA.debugLine="If Successful = True AND datisocket_ricezione.Is";
Debug.ShouldStop(268435456);
if (RemoteObject.solveBoolean("=",_successful,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._datisocket_ricezione.runMethod(true,"IsInitialized"),psy.mostCurrent.__c.getField(true,"False"))) { 
 BA.debugLineNum = 94;BA.debugLine="socket_ricezione_dati = NewSocket";
Debug.ShouldStop(536870912);
psy._socket_ricezione_dati = _newsocket;
 BA.debugLineNum = 95;BA.debugLine="datisocket_ricezione.Initialize(socket_ricezione";
Debug.ShouldStop(1073741824);
psy._datisocket_ricezione.runVoidMethod ("Initialize",psy.processBA,(Object)(psy._socket_ricezione_dati.runMethod(false,"getInputStream")),(Object)(psy._socket_ricezione_dati.runMethod(false,"getOutputStream")),(Object)(RemoteObject.createImmutable("datisocket_ricezione")));
 BA.debugLineNum = 96;BA.debugLine="server.Listen";
Debug.ShouldStop(-2147483648);
psy._server.runVoidMethod ("Listen");
 };
 BA.debugLineNum = 98;BA.debugLine="End Sub";
Debug.ShouldStop(2);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _service_create() throws Exception{
try {
		Debug.PushSubsStack("Service_Create (psy) ","psy",1,psy.processBA,psy.mostCurrent,65);
if (RapidSub.canDelegate("service_create")) return psy.remoteMe.runUserSub(false, "psy","service_create");
 BA.debugLineNum = 65;BA.debugLine="Sub Service_Create";
Debug.ShouldStop(1);
 BA.debugLineNum = 69;BA.debugLine="End Sub";
Debug.ShouldStop(16);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _service_destroy() throws Exception{
try {
		Debug.PushSubsStack("Service_Destroy (psy) ","psy",1,psy.processBA,psy.mostCurrent,100);
if (RapidSub.canDelegate("service_destroy")) return psy.remoteMe.runUserSub(false, "psy","service_destroy");
 BA.debugLineNum = 100;BA.debugLine="Sub Service_Destroy";
Debug.ShouldStop(8);
 BA.debugLineNum = 102;BA.debugLine="End Sub";
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
public static RemoteObject  _service_start(RemoteObject _startingintent) throws Exception{
try {
		Debug.PushSubsStack("Service_Start (psy) ","psy",1,psy.processBA,psy.mostCurrent,73);
if (RapidSub.canDelegate("service_start")) return psy.remoteMe.runUserSub(false, "psy","service_start", _startingintent);
Debug.locals.put("StartingIntent", _startingintent);
 BA.debugLineNum = 73;BA.debugLine="Sub Service_Start (StartingIntent As Intent)";
Debug.ShouldStop(256);
 BA.debugLineNum = 74;BA.debugLine="joinpasswd = False";
Debug.ShouldStop(512);
psy._joinpasswd = psy.mostCurrent.__c.getField(true,"False");
 BA.debugLineNum = 75;BA.debugLine="server.Initialize(serverPort, \"Server\")";
Debug.ShouldStop(1024);
psy._server.runVoidMethod ("Initialize",psy.processBA,(Object)(BA.numberCast(int.class, psy._serverport)),(Object)(RemoteObject.createImmutable("Server")));
 BA.debugLineNum = 76;BA.debugLine="MyIP = server.GetMyIP";
Debug.ShouldStop(2048);
psy._myip = psy._server.runMethod(true,"GetMyIP");
 BA.debugLineNum = 77;BA.debugLine="server.listen";
Debug.ShouldStop(4096);
psy._server.runVoidMethod ("Listen");
 BA.debugLineNum = 78;BA.debugLine="statesocket = True";
Debug.ShouldStop(8192);
psy._statesocket = psy.mostCurrent.__c.getField(true,"True");
 BA.debugLineNum = 80;BA.debugLine="Timerserver.Initialize(\"TimerServer\",100000)";
Debug.ShouldStop(32768);
psy._timerserver.runVoidMethod ("Initialize",psy.processBA,(Object)(BA.ObjectToString("TimerServer")),(Object)(BA.numberCast(long.class, 100000)));
 BA.debugLineNum = 81;BA.debugLine="Timerserver.Enabled = True";
Debug.ShouldStop(65536);
psy._timerserver.runMethod(true,"setEnabled",psy.mostCurrent.__c.getField(true,"True"));
 BA.debugLineNum = 83;BA.debugLine="PingTimer.Initialize(\"pingTimer\",10000)";
Debug.ShouldStop(262144);
psy._pingtimer.runVoidMethod ("Initialize",psy.processBA,(Object)(BA.ObjectToString("pingTimer")),(Object)(BA.numberCast(long.class, 10000)));
 BA.debugLineNum = 84;BA.debugLine="PingTimer.Enabled = True";
Debug.ShouldStop(524288);
psy._pingtimer.runMethod(true,"setEnabled",psy.mostCurrent.__c.getField(true,"True"));
 BA.debugLineNum = 86;BA.debugLine="joinchannel.initialize";
Debug.ShouldStop(2097152);
psy._joinchannel.runVoidMethod ("Initialize");
 BA.debugLineNum = 87;BA.debugLine="Topichannel.initialize";
Debug.ShouldStop(4194304);
psy._topichannel.runVoidMethod ("Initialize");
 BA.debugLineNum = 88;BA.debugLine="MessageQuery.Initialize";
Debug.ShouldStop(8388608);
psy._messagequery.runVoidMethod ("Initialize");
 BA.debugLineNum = 90;BA.debugLine="End Sub";
Debug.ShouldStop(33554432);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _socket_invio_dati_close() throws Exception{
try {
		Debug.PushSubsStack("socket_invio_dati_close (psy) ","psy",1,psy.processBA,psy.mostCurrent,490);
if (RapidSub.canDelegate("socket_invio_dati_close")) return psy.remoteMe.runUserSub(false, "psy","socket_invio_dati_close");
 BA.debugLineNum = 490;BA.debugLine="Sub socket_invio_dati_close()";
Debug.ShouldStop(512);
 BA.debugLineNum = 493;BA.debugLine="End Sub";
Debug.ShouldStop(4096);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _socket_invio_dati_connected(RemoteObject _successful) throws Exception{
try {
		Debug.PushSubsStack("socket_invio_dati_Connected (psy) ","psy",1,psy.processBA,psy.mostCurrent,477);
if (RapidSub.canDelegate("socket_invio_dati_connected")) return psy.remoteMe.runUserSub(false, "psy","socket_invio_dati_connected", _successful);
RemoteObject _tr = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");
RemoteObject _tw = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");
Debug.locals.put("Successful", _successful);
 BA.debugLineNum = 477;BA.debugLine="Sub socket_invio_dati_Connected (Successful As Boo";
Debug.ShouldStop(268435456);
 BA.debugLineNum = 478;BA.debugLine="If Successful = True Then";
Debug.ShouldStop(536870912);
if (RemoteObject.solveBoolean("=",_successful,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 479;BA.debugLine="Dim tr As TextReader";
Debug.ShouldStop(1073741824);
_tr = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");Debug.locals.put("tr", _tr);
 BA.debugLineNum = 480;BA.debugLine="Dim tw As TextWriter";
Debug.ShouldStop(-2147483648);
_tw = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");Debug.locals.put("tw", _tw);
 BA.debugLineNum = 481;BA.debugLine="tr.Initialize(socket_invio_dati.InputStream)";
Debug.ShouldStop(1);
_tr.runVoidMethod ("Initialize",(Object)(psy._socket_invio_dati.runMethod(false,"getInputStream")));
 BA.debugLineNum = 482;BA.debugLine="tw.Initialize(socket_invio_dati.OutputStream)";
Debug.ShouldStop(2);
_tw.runVoidMethod ("Initialize",(Object)(psy._socket_invio_dati.runMethod(false,"getOutputStream")));
 BA.debugLineNum = 483;BA.debugLine="tw.WriteLine(\"CAP LS\")";
Debug.ShouldStop(4);
_tw.runVoidMethod ("WriteLine",(Object)(RemoteObject.createImmutable("CAP LS")));
 BA.debugLineNum = 484;BA.debugLine="tw.Flush";
Debug.ShouldStop(8);
_tw.runVoidMethod ("Flush");
 BA.debugLineNum = 485;BA.debugLine="tw.WriteLine(identIRC)";
Debug.ShouldStop(16);
_tw.runVoidMethod ("WriteLine",(Object)(psy._identirc));
 BA.debugLineNum = 486;BA.debugLine="tw.Flush";
Debug.ShouldStop(32);
_tw.runVoidMethod ("Flush");
 BA.debugLineNum = 487;BA.debugLine="datisocket_ricezione_irc.Initialize(socket_invio";
Debug.ShouldStop(64);
psy._datisocket_ricezione_irc.runVoidMethod ("Initialize",psy.processBA,(Object)(psy._socket_invio_dati.runMethod(false,"getInputStream")),(Object)(psy._socket_invio_dati.runMethod(false,"getOutputStream")),(Object)(RemoteObject.createImmutable("datisocket_ricezione_irc")));
 };
 BA.debugLineNum = 489;BA.debugLine="End Sub";
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
public static RemoteObject  _solouser(RemoteObject _identread) throws Exception{
try {
		Debug.PushSubsStack("Solouser (psy) ","psy",1,psy.processBA,psy.mostCurrent,565);
if (RapidSub.canDelegate("solouser")) return psy.remoteMe.runUserSub(false, "psy","solouser", _identread);
RemoteObject _user = null;
RemoteObject _space = null;
Debug.locals.put("IdentRead", _identread);
 BA.debugLineNum = 565;BA.debugLine="Sub Solouser(IdentRead As String)";
Debug.ShouldStop(1048576);
 BA.debugLineNum = 566;BA.debugLine="If IdentRead.Length > 0 Then";
Debug.ShouldStop(2097152);
if (RemoteObject.solveBoolean(">",_identread.runMethod(true,"length"),BA.numberCast(double.class, 0))) { 
 BA.debugLineNum = 567;BA.debugLine="Dim User() As String";
Debug.ShouldStop(4194304);
_user = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("User", _user);
 BA.debugLineNum = 568;BA.debugLine="Dim Space() As String";
Debug.ShouldStop(8388608);
_space = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("Space", _space);
 BA.debugLineNum = 569;BA.debugLine="User = Regex.Split(\"USER\",IdentRead)";
Debug.ShouldStop(16777216);
_user = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString("USER")),(Object)(_identread));Debug.locals.put("User", _user);
 BA.debugLineNum = 570;BA.debugLine="Space = Regex.Split(\" \",User(1))";
Debug.ShouldStop(33554432);
_space = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(" ")),(Object)(_user.getArrayElement(true,BA.numberCast(int.class, 1))));Debug.locals.put("Space", _space);
 BA.debugLineNum = 571;BA.debugLine="Return Space(1)";
Debug.ShouldStop(67108864);
if (true) return _space.getArrayElement(true,BA.numberCast(int.class, 1));
 };
 BA.debugLineNum = 574;BA.debugLine="End Sub";
Debug.ShouldStop(536870912);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _timerserver_tick() throws Exception{
try {
		Debug.PushSubsStack("TimerServer_Tick (psy) ","psy",1,psy.processBA,psy.mostCurrent,495);
if (RapidSub.canDelegate("timerserver_tick")) return psy.remoteMe.runUserSub(false, "psy","timerserver_tick");
RemoteObject _valuesocket = RemoteObject.createImmutable(false);
RemoteObject _spazioriga = null;
RemoteObject _stringconnection = null;
RemoteObject _realdata = RemoteObject.createImmutable("");
 BA.debugLineNum = 495;BA.debugLine="Sub TimerServer_Tick";
Debug.ShouldStop(16384);
 BA.debugLineNum = 498;BA.debugLine="If server.IsInitialized = False Then";
Debug.ShouldStop(131072);
if (RemoteObject.solveBoolean("=",psy._server.runMethod(true,"IsInitialized"),psy.mostCurrent.__c.getField(true,"False"))) { 
 BA.debugLineNum = 499;BA.debugLine="server.Initialize(serverPort, \"Server\")";
Debug.ShouldStop(262144);
psy._server.runVoidMethod ("Initialize",psy.processBA,(Object)(BA.numberCast(int.class, psy._serverport)),(Object)(RemoteObject.createImmutable("Server")));
 BA.debugLineNum = 500;BA.debugLine="MyIP = server.GetMyIP";
Debug.ShouldStop(524288);
psy._myip = psy._server.runMethod(true,"GetMyIP");
 BA.debugLineNum = 501;BA.debugLine="server.listen";
Debug.ShouldStop(1048576);
psy._server.runVoidMethod ("Listen");
 };
 BA.debugLineNum = 506;BA.debugLine="Dim ValueSocket As Boolean";
Debug.ShouldStop(33554432);
_valuesocket = RemoteObject.createImmutable(false);Debug.locals.put("ValueSocket", _valuesocket);
 BA.debugLineNum = 507;BA.debugLine="ValueSocket = socket_invio_dati.Connected";
Debug.ShouldStop(67108864);
_valuesocket = psy._socket_invio_dati.runMethod(true,"getConnected");Debug.locals.put("ValueSocket", _valuesocket);
 BA.debugLineNum = 508;BA.debugLine="If ValueSocket = False Then";
Debug.ShouldStop(134217728);
if (RemoteObject.solveBoolean("=",_valuesocket,psy.mostCurrent.__c.getField(true,"False"))) { 
 BA.debugLineNum = 509;BA.debugLine="Dim SpazioRiga() As String";
Debug.ShouldStop(268435456);
_spazioriga = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("SpazioRiga", _spazioriga);
 BA.debugLineNum = 510;BA.debugLine="Dim StringConnection()  As String";
Debug.ShouldStop(536870912);
_stringconnection = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("StringConnection", _stringconnection);
 BA.debugLineNum = 511;BA.debugLine="SpazioRiga = Regex.Split(\" \",LeggiFileRiga(\"psybn";
Debug.ShouldStop(1073741824);
_spazioriga = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(" ")),(Object)(_leggifileriga(BA.ObjectToString("psybnc.conf"),BA.numberCast(long.class, 3))));Debug.locals.put("SpazioRiga", _spazioriga);
 BA.debugLineNum = 512;BA.debugLine="Dim RealData As String";
Debug.ShouldStop(-2147483648);
_realdata = RemoteObject.createImmutable("");Debug.locals.put("RealData", _realdata);
 BA.debugLineNum = 513;BA.debugLine="RealData = GeneraDAtaUnix";
Debug.ShouldStop(1);
_realdata = _generadataunix();Debug.locals.put("RealData", _realdata);
 BA.debugLineNum = 514;BA.debugLine="If SpazioRiga.Length > 1 Then";
Debug.ShouldStop(2);
if (RemoteObject.solveBoolean(">",_spazioriga.getField(true,"length"),BA.numberCast(double.class, 1))) { 
 BA.debugLineNum = 515;BA.debugLine="StringConnection = Regex.Split(\":\",SpazioRiga(1)";
Debug.ShouldStop(4);
_stringconnection = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(":")),(Object)(_spazioriga.getArrayElement(true,BA.numberCast(int.class, 1))));Debug.locals.put("StringConnection", _stringconnection);
 BA.debugLineNum = 516;BA.debugLine="If StringConnection.Length = 2 Then";
Debug.ShouldStop(8);
if (RemoteObject.solveBoolean("=",_stringconnection.getField(true,"length"),BA.numberCast(double.class, 2))) { 
 BA.debugLineNum = 517;BA.debugLine="Topichannel.Clear";
Debug.ShouldStop(16);
psy._topichannel.runVoidMethod ("Clear");
 BA.debugLineNum = 518;BA.debugLine="socket_invio_dati.Close";
Debug.ShouldStop(32);
psy._socket_invio_dati.runVoidMethod ("Close");
 BA.debugLineNum = 519;BA.debugLine="socket_invio_dati.Initialize(\"socket_invio_dati";
Debug.ShouldStop(64);
psy._socket_invio_dati.runVoidMethod ("Initialize",(Object)(RemoteObject.createImmutable("socket_invio_dati")));
 BA.debugLineNum = 520;BA.debugLine="socket_invio_dati.Connect(StringConnection(0),S";
Debug.ShouldStop(128);
psy._socket_invio_dati.runVoidMethod ("Connect",psy.processBA,(Object)(_stringconnection.getArrayElement(true,BA.numberCast(int.class, 0))),(Object)(BA.numberCast(int.class, _stringconnection.getArrayElement(true,BA.numberCast(int.class, 1)))),(Object)(BA.numberCast(int.class, 1000)));
 BA.debugLineNum = 521;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC \"&RealData";
Debug.ShouldStop(256);
_writesocket(RemoteObject.concat(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC "),_realdata,RemoteObject.createImmutable(" :User "),_solouser(psy._identirc),RemoteObject.createImmutable(" () trying "),_stringconnection.getArrayElement(true,BA.numberCast(int.class, 0)),RemoteObject.createImmutable(" port "),_stringconnection.getArrayElement(true,BA.numberCast(int.class, 1)),RemoteObject.createImmutable(" ().")));
 };
 }else {
 BA.debugLineNum = 524;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC \"&RealData&";
Debug.ShouldStop(2048);
_writesocket(RemoteObject.concat(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC "),_realdata,RemoteObject.createImmutable(" :User "),_solouser(psy._identirc),RemoteObject.createImmutable(" has no server added")));
 };
 };
 BA.debugLineNum = 529;BA.debugLine="End Sub";
Debug.ShouldStop(65536);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _togliprimocomando(RemoteObject _read) throws Exception{
try {
		Debug.PushSubsStack("TogliPrimoComando (psy) ","psy",1,psy.processBA,psy.mostCurrent,532);
if (RapidSub.canDelegate("togliprimocomando")) return psy.remoteMe.runUserSub(false, "psy","togliprimocomando", _read);
RemoteObject _spazio = null;
RemoteObject _nuovocomando = RemoteObject.createImmutable("");
int _start = 0;
Debug.locals.put("Read", _read);
 BA.debugLineNum = 532;BA.debugLine="Sub TogliPrimoComando(Read As String) As String";
Debug.ShouldStop(524288);
 BA.debugLineNum = 533;BA.debugLine="Dim spazio() As String";
Debug.ShouldStop(1048576);
_spazio = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("spazio", _spazio);
 BA.debugLineNum = 534;BA.debugLine="Dim nuovocomando As String";
Debug.ShouldStop(2097152);
_nuovocomando = RemoteObject.createImmutable("");Debug.locals.put("nuovocomando", _nuovocomando);
 BA.debugLineNum = 535;BA.debugLine="spazio = Regex.Split(Chr(32),Read)";
Debug.ShouldStop(4194304);
_spazio = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 32))))),(Object)(_read));Debug.locals.put("spazio", _spazio);
 BA.debugLineNum = 536;BA.debugLine="For start = 1 To spazio.Length -1";
Debug.ShouldStop(8388608);
{
final int step4 = 1;
final int limit4 = RemoteObject.solve(new RemoteObject[] {_spazio.getField(true,"length"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue();
for (_start = 1 ; (step4 > 0 && _start <= limit4) || (step4 < 0 && _start >= limit4); _start = ((int)(0 + _start + step4)) ) {
Debug.locals.put("start", _start);
 BA.debugLineNum = 537;BA.debugLine="If start == 1 Then";
Debug.ShouldStop(16777216);
if (RemoteObject.solveBoolean("=",RemoteObject.createImmutable(_start),BA.numberCast(double.class, 1))) { 
 BA.debugLineNum = 538;BA.debugLine="nuovocomando = spazio(start)";
Debug.ShouldStop(33554432);
_nuovocomando = _spazio.getArrayElement(true,BA.numberCast(int.class, _start));Debug.locals.put("nuovocomando", _nuovocomando);
 }else {
 BA.debugLineNum = 540;BA.debugLine="nuovocomando = nuovocomando & \" \" & spazio(sta";
Debug.ShouldStop(134217728);
_nuovocomando = RemoteObject.concat(_nuovocomando,RemoteObject.createImmutable(" "),_spazio.getArrayElement(true,BA.numberCast(int.class, _start)));Debug.locals.put("nuovocomando", _nuovocomando);
 };
 }
}Debug.locals.put("start", _start);
;
 BA.debugLineNum = 543;BA.debugLine="Return nuovocomando";
Debug.ShouldStop(1073741824);
if (true) return _nuovocomando;
 BA.debugLineNum = 544;BA.debugLine="End Sub";
Debug.ShouldStop(-2147483648);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _writefile(RemoteObject _nomefile,RemoteObject _write) throws Exception{
try {
		Debug.PushSubsStack("WriteFile (psy) ","psy",1,psy.processBA,psy.mostCurrent,124);
if (RapidSub.canDelegate("writefile")) return psy.remoteMe.runUserSub(false, "psy","writefile", _nomefile, _write);
RemoteObject _writer = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");
Debug.locals.put("NOmeFile", _nomefile);
Debug.locals.put("Write", _write);
 BA.debugLineNum = 124;BA.debugLine="Sub WriteFile(NOmeFile As String,Write As String )";
Debug.ShouldStop(134217728);
 BA.debugLineNum = 125;BA.debugLine="Dim Writer As TextWriter";
Debug.ShouldStop(268435456);
_writer = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");Debug.locals.put("Writer", _writer);
 BA.debugLineNum = 126;BA.debugLine="Writer.Initialize(File.OpenOutput(File.DirInternal";
Debug.ShouldStop(536870912);
_writer.runVoidMethod ("Initialize",(Object)((psy.mostCurrent.__c.getField(false,"File").runMethod(false,"OpenOutput",(Object)(psy.mostCurrent.__c.getField(false,"File").runMethod(true,"getDirInternal")),(Object)(_nomefile),(Object)(psy.mostCurrent.__c.getField(true,"True"))).getObject())));
 BA.debugLineNum = 127;BA.debugLine="Writer.Write(Write)";
Debug.ShouldStop(1073741824);
_writer.runVoidMethod ("Write",(Object)(_write));
 BA.debugLineNum = 128;BA.debugLine="Writer.Close";
Debug.ShouldStop(-2147483648);
_writer.runVoidMethod ("Close");
 BA.debugLineNum = 129;BA.debugLine="End Sub";
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
public static RemoteObject  _writefileriga(RemoteObject _nomefile,RemoteObject _buffer,RemoteObject _riga) throws Exception{
try {
		Debug.PushSubsStack("WriteFileRiga (psy) ","psy",1,psy.processBA,psy.mostCurrent,145);
if (RapidSub.canDelegate("writefileriga")) return psy.remoteMe.runUserSub(false, "psy","writefileriga", _nomefile, _buffer, _riga);
RemoteObject _iline = null;
RemoteObject _nuovobuffer = RemoteObject.createImmutable("");
RemoteObject _writer = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");
int _start = 0;
Debug.locals.put("NomeFile", _nomefile);
Debug.locals.put("Buffer", _buffer);
Debug.locals.put("Riga", _riga);
 BA.debugLineNum = 145;BA.debugLine="Sub WriteFileRiga(NomeFile As String,Buffer As Str";
Debug.ShouldStop(65536);
 BA.debugLineNum = 146;BA.debugLine="Dim iLine() As String";
Debug.ShouldStop(131072);
_iline = RemoteObject.createNewArray ("String", new int[] {0}, new Object[]{});Debug.locals.put("iLine", _iline);
 BA.debugLineNum = 147;BA.debugLine="Dim NuovoBuffer As String";
Debug.ShouldStop(262144);
_nuovobuffer = RemoteObject.createImmutable("");Debug.locals.put("NuovoBuffer", _nuovobuffer);
 BA.debugLineNum = 148;BA.debugLine="Dim Writer As TextWriter";
Debug.ShouldStop(524288);
_writer = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");Debug.locals.put("Writer", _writer);
 BA.debugLineNum = 149;BA.debugLine="Riga = Riga-1";
Debug.ShouldStop(1048576);
_riga = RemoteObject.solve(new RemoteObject[] {_riga,RemoteObject.createImmutable(1)}, "-",1, 2);Debug.locals.put("Riga", _riga);
 BA.debugLineNum = 150;BA.debugLine="iLine = Regex.Split(Chr(13),ReadFile(NomeFile))";
Debug.ShouldStop(2097152);
_iline = psy.mostCurrent.__c.getField(false,"Regex").runMethod(false,"Split",(Object)(BA.ObjectToString(psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 13))))),(Object)(_readfile(_nomefile)));Debug.locals.put("iLine", _iline);
 BA.debugLineNum = 151;BA.debugLine="If iLine.Length -1 < Riga  Then";
Debug.ShouldStop(4194304);
if (RemoteObject.solveBoolean("<",RemoteObject.solve(new RemoteObject[] {_iline.getField(true,"length"),RemoteObject.createImmutable(1)}, "-",1, 1),BA.numberCast(double.class, _riga))) { 
 BA.debugLineNum = 152;BA.debugLine="WriteFile(NomeFile,Buffer)";
Debug.ShouldStop(8388608);
_writefile(_nomefile,_buffer);
 BA.debugLineNum = 153;BA.debugLine="Return \"\"";
Debug.ShouldStop(16777216);
if (true) return BA.ObjectToString("");
 }else {
 BA.debugLineNum = 155;BA.debugLine="For start = 0 To iLine.Length -1";
Debug.ShouldStop(67108864);
{
final int step10 = 1;
final int limit10 = RemoteObject.solve(new RemoteObject[] {_iline.getField(true,"length"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue();
for (_start = 0 ; (step10 > 0 && _start <= limit10) || (step10 < 0 && _start >= limit10); _start = ((int)(0 + _start + step10)) ) {
Debug.locals.put("start", _start);
 BA.debugLineNum = 156;BA.debugLine="If start = 0 Then";
Debug.ShouldStop(134217728);
if (RemoteObject.solveBoolean("=",RemoteObject.createImmutable(_start),BA.numberCast(double.class, 0))) { 
 BA.debugLineNum = 157;BA.debugLine="NuovoBuffer = iLine(start) & Chr(10)";
Debug.ShouldStop(268435456);
_nuovobuffer = RemoteObject.concat(_iline.getArrayElement(true,BA.numberCast(int.class, _start)),psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 10))));Debug.locals.put("NuovoBuffer", _nuovobuffer);
 }else {
 BA.debugLineNum = 159;BA.debugLine="If start = Riga Then";
Debug.ShouldStop(1073741824);
if (RemoteObject.solveBoolean("=",RemoteObject.createImmutable(_start),BA.numberCast(double.class, _riga))) { 
 BA.debugLineNum = 160;BA.debugLine="NuovoBuffer = NuovoBuffer & Buffer & Chr(10)";
Debug.ShouldStop(-2147483648);
_nuovobuffer = RemoteObject.concat(_nuovobuffer,_buffer,psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 10))));Debug.locals.put("NuovoBuffer", _nuovobuffer);
 }else {
 BA.debugLineNum = 162;BA.debugLine="NuovoBuffer = NuovoBuffer & iLine(start) & Chr";
Debug.ShouldStop(2);
_nuovobuffer = RemoteObject.concat(_nuovobuffer,_iline.getArrayElement(true,BA.numberCast(int.class, _start)),psy.mostCurrent.__c.runMethod(true,"Chr",(Object)(BA.numberCast(int.class, 10))));Debug.locals.put("NuovoBuffer", _nuovobuffer);
 };
 };
 }
}Debug.locals.put("start", _start);
;
 };
 BA.debugLineNum = 169;BA.debugLine="Writer.Initialize(File.OpenOutput(File.DirInternal";
Debug.ShouldStop(256);
_writer.runVoidMethod ("Initialize",(Object)((psy.mostCurrent.__c.getField(false,"File").runMethod(false,"OpenOutput",(Object)(psy.mostCurrent.__c.getField(false,"File").runMethod(true,"getDirInternal")),(Object)(_nomefile),(Object)(psy.mostCurrent.__c.getField(true,"False"))).getObject())));
 BA.debugLineNum = 170;BA.debugLine="Writer.Write(NuovoBuffer)";
Debug.ShouldStop(512);
_writer.runVoidMethod ("Write",(Object)(_nuovobuffer));
 BA.debugLineNum = 171;BA.debugLine="Writer.Close";
Debug.ShouldStop(1024);
_writer.runVoidMethod ("Close");
 BA.debugLineNum = 173;BA.debugLine="End Sub";
Debug.ShouldStop(4096);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _writesocket(RemoteObject _read) throws Exception{
try {
		Debug.PushSubsStack("WriteSocket (psy) ","psy",1,psy.processBA,psy.mostCurrent,419);
if (RapidSub.canDelegate("writesocket")) return psy.remoteMe.runUserSub(false, "psy","writesocket", _read);
RemoteObject _tr = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");
RemoteObject _tw = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");
Debug.locals.put("Read", _read);
 BA.debugLineNum = 419;BA.debugLine="Sub WriteSocket(Read As String)";
Debug.ShouldStop(4);
 BA.debugLineNum = 420;BA.debugLine="Try";
Debug.ShouldStop(8);
try { BA.debugLineNum = 421;BA.debugLine="If socket_ricezione_dati.Connected == True AND jo";
Debug.ShouldStop(16);
if (RemoteObject.solveBoolean("=",psy._socket_ricezione_dati.runMethod(true,"getConnected"),psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean(">",_read.runMethod(true,"length"),BA.numberCast(double.class, 0))) { 
 BA.debugLineNum = 423;BA.debugLine="Dim tr As TextReader";
Debug.ShouldStop(64);
_tr = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");Debug.locals.put("tr", _tr);
 BA.debugLineNum = 424;BA.debugLine="Dim tw As TextWriter";
Debug.ShouldStop(128);
_tw = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");Debug.locals.put("tw", _tw);
 BA.debugLineNum = 425;BA.debugLine="tr.Initialize( socket_ricezione_dati.InputStrea";
Debug.ShouldStop(256);
_tr.runVoidMethod ("Initialize",(Object)(psy._socket_ricezione_dati.runMethod(false,"getInputStream")));
 BA.debugLineNum = 426;BA.debugLine="tw.Initialize( socket_ricezione_dati.OutputStre";
Debug.ShouldStop(512);
_tw.runVoidMethod ("Initialize",(Object)(psy._socket_ricezione_dati.runMethod(false,"getOutputStream")));
 BA.debugLineNum = 427;BA.debugLine="tw.WriteLine(Read)";
Debug.ShouldStop(1024);
_tw.runVoidMethod ("WriteLine",(Object)(_read));
 BA.debugLineNum = 428;BA.debugLine="tw.Flush";
Debug.ShouldStop(2048);
_tw.runVoidMethod ("Flush");
 BA.debugLineNum = 429;BA.debugLine="Return Read";
Debug.ShouldStop(4096);
Debug.CheckDeviceExceptions();if (true) return _read;
 };
 Debug.CheckDeviceExceptions();
} 
       catch (Exception e12) {
			BA.rdebugUtils.runVoidMethod("setLastException",psy.processBA, e12.toString()); BA.debugLineNum = 432;BA.debugLine="socket_ricezione_dati.Close";
Debug.ShouldStop(32768);
psy._socket_ricezione_dati.runVoidMethod ("Close");
 };
 BA.debugLineNum = 434;BA.debugLine="End Sub";
Debug.ShouldStop(131072);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			Debug.ErrorCaught(e);
			throw e;
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _writesocketirc(RemoteObject _read) throws Exception{
try {
		Debug.PushSubsStack("WriteSocketIrc (psy) ","psy",1,psy.processBA,psy.mostCurrent,435);
if (RapidSub.canDelegate("writesocketirc")) return psy.remoteMe.runUserSub(false, "psy","writesocketirc", _read);
RemoteObject _tr = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");
RemoteObject _tw = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");
RemoteObject _realdata = RemoteObject.createImmutable("");
int _i = 0;
Debug.locals.put("Read", _read);
 BA.debugLineNum = 435;BA.debugLine="Sub WriteSocketIrc(Read As String)";
Debug.ShouldStop(262144);
 BA.debugLineNum = 436;BA.debugLine="Try";
Debug.ShouldStop(524288);
try { BA.debugLineNum = 437;BA.debugLine="If socket_invio_dati.Connected = True Then";
Debug.ShouldStop(1048576);
if (RemoteObject.solveBoolean("=",psy._socket_invio_dati.runMethod(true,"getConnected"),psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 438;BA.debugLine="Dim tr As TextReader";
Debug.ShouldStop(2097152);
_tr = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextReaderWrapper");Debug.locals.put("tr", _tr);
 BA.debugLineNum = 439;BA.debugLine="Dim tw As TextWriter";
Debug.ShouldStop(4194304);
_tw = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.TextWriterWrapper");Debug.locals.put("tw", _tw);
 BA.debugLineNum = 440;BA.debugLine="tr.Initialize(socket_invio_dati.InputStream)";
Debug.ShouldStop(8388608);
_tr.runVoidMethod ("Initialize",(Object)(psy._socket_invio_dati.runMethod(false,"getInputStream")));
 BA.debugLineNum = 441;BA.debugLine="tw.Initialize(socket_invio_dati.OutputStream)";
Debug.ShouldStop(16777216);
_tw.runVoidMethod ("Initialize",(Object)(psy._socket_invio_dati.runMethod(false,"getOutputStream")));
 BA.debugLineNum = 442;BA.debugLine="tw.WriteLine(Read)";
Debug.ShouldStop(33554432);
_tw.runVoidMethod ("WriteLine",(Object)(_read));
 BA.debugLineNum = 443;BA.debugLine="tw.Flush";
Debug.ShouldStop(67108864);
_tw.runVoidMethod ("Flush");
 BA.debugLineNum = 444;BA.debugLine="Return Read";
Debug.ShouldStop(134217728);
Debug.CheckDeviceExceptions();if (true) return _read;
 };
 Debug.CheckDeviceExceptions();
} 
       catch (Exception e12) {
			BA.rdebugUtils.runVoidMethod("setLastException",psy.processBA, e12.toString()); BA.debugLineNum = 447;BA.debugLine="If IRClient == True AND joinpasswd = True Then";
Debug.ShouldStop(1073741824);
if (RemoteObject.solveBoolean("=",psy._irclient,psy.mostCurrent.__c.getField(true,"True")) && RemoteObject.solveBoolean("=",psy._joinpasswd,psy.mostCurrent.__c.getField(true,"True"))) { 
 BA.debugLineNum = 449;BA.debugLine="Dim RealData As String";
Debug.ShouldStop(1);
_realdata = RemoteObject.createImmutable("");Debug.locals.put("RealData", _realdata);
 BA.debugLineNum = 450;BA.debugLine="RealData = GeneraDAtaUnix";
Debug.ShouldStop(2);
_realdata = _generadataunix();Debug.locals.put("RealData", _realdata);
 BA.debugLineNum = 451;BA.debugLine="For I = 0 To joinchannel.Size - 1";
Debug.ShouldStop(4);
{
final int step15 = 1;
final int limit15 = RemoteObject.solve(new RemoteObject[] {psy._joinchannel.runMethod(true,"getSize"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue();
for (_i = 0 ; (step15 > 0 && _i <= limit15) || (step15 < 0 && _i >= limit15); _i = ((int)(0 + _i + step15)) ) {
Debug.locals.put("I", _i);
 BA.debugLineNum = 452;BA.debugLine="WriteSocket(\":\"&Nickconnessione&\" PART \"&joinc";
Debug.ShouldStop(8);
_writesocket(RemoteObject.concat(RemoteObject.createImmutable(":"),psy._nickconnessione,RemoteObject.createImmutable(" PART "),psy._joinchannel.runMethod(false,"Get",(Object)(BA.numberCast(int.class, _i)))));
 }
}Debug.locals.put("I", _i);
;
 BA.debugLineNum = 454;BA.debugLine="WriteSocket(\":-psyBNC PRIVMSG psyBNC \"&RealData";
Debug.ShouldStop(32);
_writesocket(RemoteObject.concat(RemoteObject.createImmutable(":-psyBNC PRIVMSG psyBNC "),_realdata,RemoteObject.createImmutable(" User "),_solouser(psy._identirc),RemoteObject.createImmutable(" got disconnected from server.")));
 };
 BA.debugLineNum = 456;BA.debugLine="socket_invio_dati.close";
Debug.ShouldStop(128);
psy._socket_invio_dati.runVoidMethod ("Close");
 };
 BA.debugLineNum = 460;BA.debugLine="End Sub";
Debug.ShouldStop(2048);
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