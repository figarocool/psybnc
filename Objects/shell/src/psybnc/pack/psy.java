
package psybnc.pack;

import java.io.IOException;
import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.pc.PCBA;
import anywheresoftware.b4a.pc.RDebug;
import anywheresoftware.b4a.pc.RemoteObject;
import anywheresoftware.b4a.pc.RDebug.IRemote;
import anywheresoftware.b4a.pc.Debug;
import anywheresoftware.b4a.pc.B4XTypes.B4XClass;
import anywheresoftware.b4a.pc.B4XTypes.DeviceClass;

public class psy implements IRemote{
	public static psy mostCurrent;
	public static RemoteObject processBA;
    public static boolean processGlobalsRun;
    public static RemoteObject myClass;
    public static RemoteObject remoteMe;
	public psy() {
		mostCurrent = this;
	}
    public RemoteObject getRemoteMe() {
        return remoteMe;    
    }
    
public boolean isSingleton() {
		return true;
	}
    static {
        anywheresoftware.b4a.pc.RapidSub.moduleToObject.put(new B4XClass("psy"), "psybnc.pack.psy");
	}
     public static RemoteObject getObject() {
		return myClass;
	 }
	public RemoteObject _service;
    private PCBA pcBA;

	public PCBA create(Object[] args) throws ClassNotFoundException{
		processBA = (RemoteObject) args[1];
        _service = (RemoteObject) args[2];
        remoteMe = RemoteObject.declareNull("psybnc.pack.psy");
        anywheresoftware.b4a.keywords.Common.Density = (Float)args[3];
		pcBA = new PCBA(this, psy.class);
        main_subs_0.initializeProcessGlobals();
		return pcBA;
	}
public static RemoteObject __c = RemoteObject.declareNull("anywheresoftware.b4a.keywords.Common");
public static RemoteObject _server = RemoteObject.declareNull("anywheresoftware.b4a.objects.SocketWrapper.ServerSocketWrapper");
public static RemoteObject _serverport = RemoteObject.createImmutable("");
public static RemoteObject _statesocket = RemoteObject.createImmutable(false);
public static RemoteObject _socket_ricezione_dati = RemoteObject.declareNull("anywheresoftware.b4a.objects.SocketWrapper");
public static RemoteObject _socket_invio_dati = RemoteObject.declareNull("anywheresoftware.b4a.objects.SocketWrapper");
public static RemoteObject _datisocket_ricezione = RemoteObject.declareNull("anywheresoftware.b4a.randomaccessfile.AsyncStreams");
public static RemoteObject _datisocket_ricezione_irc = RemoteObject.declareNull("anywheresoftware.b4a.randomaccessfile.AsyncStreams");
public static RemoteObject _irclient = RemoteObject.createImmutable(false);
public static RemoteObject _myip = RemoteObject.createImmutable("");
public static RemoteObject _timerserver = RemoteObject.declareNull("anywheresoftware.b4a.objects.Timer");
public static RemoteObject _joinpasswd = RemoteObject.createImmutable(false);
public static RemoteObject _joinchannel = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
public static RemoteObject _topichannel = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
public static RemoteObject _messagequery = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
public static RemoteObject _identirc = RemoteObject.createImmutable("");
public static RemoteObject _nickconnessione = RemoteObject.createImmutable("");
public static RemoteObject _savemoth = RemoteObject.createImmutable("");
public static RemoteObject _stopmoth = RemoteObject.createImmutable(false);
public static RemoteObject _awaynick = RemoteObject.createImmutable("");
public static RemoteObject _normalnick = RemoteObject.createImmutable("");
public static RemoteObject _pingtimer = RemoteObject.declareNull("anywheresoftware.b4a.objects.Timer");
public static RemoteObject _autoping = RemoteObject.createImmutable(false);
public static psybnc.pack.main _main = null;
  public Object[] GetGlobals() {
		return new Object[] {"AutoPing",psy._autoping,"AwayNick",psy._awaynick,"datisocket_ricezione",psy._datisocket_ricezione,"datisocket_ricezione_irc",psy._datisocket_ricezione_irc,"identIRC",psy._identirc,"IRClient",psy._irclient,"joinchannel",psy._joinchannel,"joinpasswd",psy._joinpasswd,"Main",Debug.moduleToString(psybnc.pack.main.class),"MessageQuery",psy._messagequery,"MyIP",psy._myip,"Nickconnessione",psy._nickconnessione,"NormalNick",psy._normalnick,"PingTimer",psy._pingtimer,"SaveMoth",psy._savemoth,"server",psy._server,"serverPort",psy._serverport,"Service",psy.mostCurrent._service,"socket_invio_dati",psy._socket_invio_dati,"socket_ricezione_dati",psy._socket_ricezione_dati,"statesocket",psy._statesocket,"StopMoth",psy._stopmoth,"Timerserver",psy._timerserver,"Topichannel",psy._topichannel};
}
}