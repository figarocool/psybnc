B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=6.5
@EndOfDesignText@
#Region Module Attributes
	#StartAtBoot: False
#End Region

' ====================================================================
' psyBNC Android - IRC Bouncer
' Copyright (c) 2024 Stefano Basile - 8byte
' Sito Web: https://8byte.it/
' Email: [email protected]
' 
' Licenza: Uso personale e non commerciale
' Per uso commerciale contattare: [email protected]
' 
' Questo software è distribuito con autorizzazione scritta dell'autore.
' Tutti i diritti riservati.
' ====================================================================

'Service module
Sub Process_Globals
 ' gestione delle varibili
 Dim server As ServerSocket
 Dim serverPort As String
 
  
 
 'Variabile se è stato già istanziato

 Dim statesocket As Boolean

 'Buffer del primo socket di Ricezione
 Dim socket_ricezione_dati As Socket 
 Dim socket_invio_dati As Socket
 
 Dim datisocket_ricezione As AsyncStreams  
 Dim datisocket_ricezione_irc As AsyncStreams  
 
 
  ' Prima connessione
  Dim IRClient As Boolean 

  
 ' Ip del socket
 Dim MyIP As String
 
 ' Timer di connessione
 Dim Timerserver As Timer
 
 ' Join password
 Dim joinpasswd As Boolean

 ' channel join
 
Dim joinchannel As List

' Topic

Dim Topichannel As List

' Message

Dim MessageQuery As List


Dim identIRC As String
Dim Nickconnessione As String 

Dim SaveMoth As String 
Dim StopMoth As Boolean 

Dim AwayNick As String 
Dim NormalNick As String 

Dim PingTimer As Timer 
Dim AutoPing As Boolean

' ======================
' DCC SUPPORT VARIABLES
' ======================
Dim DCCServer As ServerSocket
Dim DCCPort As Int
Dim DCCConnections As List
Dim DCCFiles As List
Dim DCCTransfers As List

' ======================
' DCC CONFIGURATION
' ======================
Dim DCCMode As String          ' "SAVE" o "FORWARD"
Dim DCCAutoAccept As Boolean  ' Auto-accetta file DCC
Dim DCCMaxFileSize As Long    ' Dimensione massima file (bytes)
Dim DCCAllowedTypes As List   ' Tipi di file permessi

' ======================
' DCC ADVANCED SUPPORT
' ======================
Dim DCCChatConnections As List  ' Connessioni chat DCC attive
Dim DCCChatRequests As List     ' Richieste chat DCC in attesa
Dim DCCSendQueue As List        ' Coda file da inviare
Dim DCCActiveTransfers As List  ' Trasferimenti DCC attivi
Dim DCCAutoGetUsers As List     ' Utenti con auto-get abilitato
Dim DCCAutoGetNetworks As Map   ' Auto-get per network
Dim DCCBotConnections As List   ' Connessioni bot DCC
Dim DCCChatHistory As List      ' Storico chat DCC
Dim MyIP As String              ' IP del bouncer per DCC

' ======================
' ERROR HANDLING & LOGGING
' ======================
Dim ErrorBuffer As List        ' Buffer errori in memoria
Dim LogFile As String          ' File di log
Dim HeartbeatTimer As Timer    ' Timer per heartbeat
Dim ConnectionRetryCount As Int ' Contatore tentativi riconnessione
Dim MaxRetryAttempts As Int    ' Massimo tentativi riconnessione

' ======================
' SSL SUPPORT
' ======================
Dim SSLEnabled As Boolean      ' SSL abilitato
Dim SSLPort As Int            ' Porta SSL
Dim SSLCertificate As String  ' Certificato SSL
Dim SSLKey As String          ' Chiave SSL

' ======================
' USER MANAGEMENT
' ======================
Dim UsersList As List          ' Lista utenti
Dim UserPasswords As Map       ' Password utenti
Dim UserRealNames As Map       ' Real names utenti
Dim UserAdmins As List          ' Lista admin
Dim UserOnline As Map           ' Utenti online
Dim UserLastSeen As Map         ' Ultimo accesso utenti
Dim UserLoginAttempts As Map      ' Tentativi login
Dim MaxLoginAttempts As Int     ' Massimo tentativi login

' ======================
' MULTI-CLIENT SUPPORT
' ======================
Dim ClientConnections As List   ' Lista connessioni client attive
Dim ClientSockets As Map        ' Socket per ogni client
Dim ClientStreams As Map        ' Stream per ogni client
Dim ClientUsers As Map          ' Utente associato a ogni client
Dim ClientNetworks As Map       ' Network attivo per ogni client
Dim ClientChannels As Map       ' Canali per ogni client
Dim ClientMessages As Map       ' Messaggi per ogni client

' ======================
' MULTI-NETWORK SUPPORT
' ======================
Dim NetworksList As List        ' Lista network configurati
Dim NetworkConnections As Map   ' Connessioni per network
Dim NetworkServers As Map       ' Server per ogni network
Dim NetworkSockets As Map       ' Socket per ogni network
Dim NetworkStreams As Map       ' Stream per ogni network
Dim NetworkPrefixes As Map      ' Prefissi per network (Ef', Freenode', etc.)
Dim NetworkChannels As Map      ' Canali per ogni network
Dim NetworkUsers As Map         ' Utenti per ogni network

' ======================
' MULTI-SERVER SUPPORT
' ======================
Dim ServerConnections As List   ' Lista connessioni server attive
Dim ServerSockets As Map        ' Socket per ogni server
Dim ServerStreams As Map        ' Stream per ogni server
Dim ServerNetworks As Map       ' Network associato a ogni server
Dim ServerConfigs As Map        ' Configurazione per ogni server
Dim ServerStatus As Map         ' Stato per ogni server

' ======================
' VHOST SUPPORT
' ======================
Dim VHostEnabled As Boolean     ' VHost abilitato
Dim VHostAddress As String      ' Indirizzo VHost
Dim VHostPort As Int           ' Porta VHost
Dim VHostConnections As Map     ' Connessioni VHost

' ======================
' PROXY SUPPORT
' ======================
Dim ProxyEnabled As Boolean     ' Proxy abilitato
Dim ProxyType As String         ' Tipo proxy (SOCKS4, SOCKS5, HTTP)
Dim ProxyHost As String         ' Host proxy
Dim ProxyPort As Int           ' Porta proxy
Dim ProxyUsername As String     ' Username proxy
Dim ProxyPassword As String     ' Password proxy

' ======================
' BAN MANAGEMENT
' ======================
Dim BanList As List            ' Lista ban utenti
Dim BanReasons As Map          ' Motivi ban
Dim BanDates As Map            ' Date ban
Dim BanExpiry As Map           ' Scadenza ban
Dim AutoBanEnabled As Boolean   ' Auto-ban abilitato

' ======================
' OP MANAGEMENT
' ======================
Dim OpList As List             ' Lista operatori
Dim OpChannels As Map          ' Canali per ogni op
Dim AutoOpEnabled As Boolean    ' Auto-op abilitato
Dim OpLevels As Map            ' Livelli op per utente

End Sub
Sub Service_Create
'TimerService.Initialize("TimerService",1000)
'TimerService.Enabled=True

End Sub

 

Sub Service_Start (StartingIntent As Intent)
	 	joinpasswd = False
		server.Initialize(serverPort, "Server")
		MyIP = server.GetMyIP
		server.listen
		statesocket = True
		'Connessione al server IRC
		Timerserver.Initialize("TimerServer",100000)
		Timerserver.Enabled = True
		'PING CHECKER
		PingTimer.Initialize("pingTimer",10000)
		PingTimer.Enabled = True
		'Var Inizialize
		joinchannel.initialize
		Topichannel.initialize
		MessageQuery.Initialize
		
		' ======================
		' DCC INITIALIZATION
		' ======================
		DCCConnections.Initialize
		DCCFiles.Initialize
		DCCTransfers.Initialize
		DCCAllowedTypes.Initialize
		DCCPort = 1024 + Rnd(0, 64511) ' Random port between 1024-65535
		DCCServer.Initialize(DCCPort, "DCCServer")
		DCCServer.Listen
		
		' ======================
		' DCC ADVANCED INIT
		' ======================
		DCCChatConnections.Initialize
		DCCChatRequests.Initialize
		DCCSendQueue.Initialize
		DCCActiveTransfers.Initialize
		DCCAutoGetUsers.Initialize
		DCCAutoGetNetworks.Initialize
		DCCBotConnections.Initialize
		DCCChatHistory.Initialize
		MyIP = "127.0.0.1"           ' Default localhost IP
		
		' ======================
		' DCC DEFAULT CONFIG
		' ======================
		DCCMode = "SAVE"              ' Default: salva file sul server
		DCCAutoAccept = False         ' Default: non auto-accetta
		DCCMaxFileSize = 10485760     ' Default: 10MB max
		DCCAllowedTypes.AddAll(Array As String("txt", "jpg", "png", "pdf", "zip", "doc", "docx"))
		
		' ======================
		' ERROR HANDLING INIT
		' ======================
		ErrorBuffer.Initialize
		LogFile = "psybnc_error.log"
		ConnectionRetryCount = 0
		MaxRetryAttempts = 5
		
		' ======================
		' SSL CONFIG
		' ======================
		SSLEnabled = False            ' Default: SSL disabilitato
		SSLPort = 6697                ' Porta SSL standard IRC
		SSLCertificate = ""
		SSLKey = ""
		
		' ======================
		' USER MANAGEMENT INIT
		' ======================
		UsersList.Initialize
		UserPasswords.Initialize
		UserRealNames.Initialize
		UserAdmins.Initialize
		UserOnline.Initialize
		UserLastSeen.Initialize
		UserLoginAttempts.Initialize
		MaxLoginAttempts = 3
		
		' Crea utente admin di default
		CreateDefaultAdmin()
		
		' ======================
		' MULTI-CLIENT INIT
		' ======================
		ClientConnections.Initialize
		ClientSockets.Initialize
		ClientStreams.Initialize
		ClientUsers.Initialize
		ClientNetworks.Initialize
		ClientChannels.Initialize
		ClientMessages.Initialize
		
		' ======================
		' MULTI-NETWORK INIT
		' ======================
		NetworksList.Initialize
		NetworkConnections.Initialize
		NetworkServers.Initialize
		NetworkSockets.Initialize
		NetworkStreams.Initialize
		NetworkPrefixes.Initialize
		NetworkChannels.Initialize
		NetworkUsers.Initialize
		
		' ======================
		' MULTI-SERVER INIT
		' ======================
		ServerConnections.Initialize
		ServerSockets.Initialize
		ServerStreams.Initialize
		ServerNetworks.Initialize
		ServerConfigs.Initialize
		ServerStatus.Initialize
		
		' ======================
		' VHOST INIT
		' ======================
		VHostEnabled = False
		VHostAddress = ""
		VHostPort = 0
		VHostConnections.Initialize
		
		' ======================
		' PROXY INIT
		' ======================
		ProxyEnabled = False
		ProxyType = "SOCKS5"
		ProxyHost = ""
		ProxyPort = 1080
		ProxyUsername = ""
		ProxyPassword = ""
		
		' ======================
		' BAN MANAGEMENT INIT
		' ======================
		BanList.Initialize
		BanReasons.Initialize
		BanDates.Initialize
		BanExpiry.Initialize
		AutoBanEnabled = False
		
		' ======================
		' OP MANAGEMENT INIT
		' ======================
		OpList.Initialize
		OpChannels.Initialize
		AutoOpEnabled = False
		OpLevels.Initialize
		
		' ======================
		' START SYSTEMS
		' ======================
		' Avvia sistema di logging
		LogInfo("psyBNC Android started", "Service_Start")
		
		' Carica stato salvato
		LoadSavedState()
		
		' Avvia sistema heartbeat
		StartHeartbeat()
			
End Sub

Sub Server_NewConnection (Successful As Boolean, NewSocket As Socket)
 	If Successful = True AND datisocket_ricezione.IsInitialized = False Then
    	socket_ricezione_dati = NewSocket
		datisocket_ricezione.Initialize(socket_ricezione_dati.InputStream,  socket_ricezione_dati.OutputStream, "datisocket_ricezione")
    	server.Listen
	End If	
End Sub

Sub Service_Destroy

End Sub
 
Sub ReadFile(NomeFile As String)  As String 
 Dim Reader As TextReader
 Dim BufferFile As String 	
	 If  File.Exists(File.DirInternal, NomeFile) == True Then
	    Reader.Initialize(File.OpenInput(File.DirInternal, NomeFile))
	    Dim line As String
	     line = Reader.ReadLine
	     Do While line <> Null
	      
	        If BufferFile.Length > 0 Then
				BufferFile = BufferFile & Chr(13) & line
			Else
				BufferFile = line
			End If
			line = Reader.ReadLine
		Loop
	    Reader.Close 
	End If
	Return BufferFile
End Sub
Sub WriteFile(NOmeFile As String,Write As String ) 
Dim Writer As TextWriter
Writer.Initialize(File.OpenOutput(File.DirInternal, NOmeFile, True))
Writer.Write(Write)
Writer.Close 
End Sub
Sub LeggiFileRiga(NomeFile As String,Riga As Long)
 Dim iLine() As String 
 iLine = Regex.Split(Chr(13),ReadFile(NomeFile))
 
 If  iLine.Length > 0 Then
 	If  Riga < iLine.Length Then
	 	Return iLine(Riga)
		Else
		Return ""
	 End If
 Else
 	Return ""
 End If
End Sub

Sub WriteFileRiga(NomeFile As String,Buffer As String,Riga As Long)
Dim iLine() As String 
Dim NuovoBuffer As String
Dim Writer As TextWriter
 Riga = Riga-1
 iLine = Regex.Split(Chr(13),ReadFile(NomeFile))
 If iLine.Length -1 < Riga  Then
 	WriteFile(NomeFile,Buffer)
	Return ""
 Else
	 For start = 0 To iLine.Length -1
	 	If start = 0 Then
			NuovoBuffer = iLine(start) & Chr(10)
		Else
		 	If start = Riga Then
				NuovoBuffer = NuovoBuffer & Buffer & Chr(10)	
			Else
				NuovoBuffer = NuovoBuffer & iLine(start) & Chr(10)
			End If
		End If
	 Next
 End If
 

Writer.Initialize(File.OpenOutput(File.DirInternal, NomeFile, False))
Writer.Write(NuovoBuffer)
Writer.Close 
 
End Sub
Sub SaveTopic(i As Long,NumeroRaw() As String)




If NumeroRaw(1) = "TOPIC" Then
	Dim p As Long
	Dim TotaleTopic As String
	TotaleTopic = ""
	For p = 3 To NumeroRaw.Length -1
		If p = 3 Then
			Dim TotaleTopic As String 
			Dim SenzaPunti() As String 
			SenzaPunti =  Regex.Split(":",NumeroRaw(p))
			TotaleTopic = SenzaPunti(1) & Chr(32)
		Else
			If p = NumeroRaw.Length -1 Then
				TotaleTopic = TotaleTopic  & NumeroRaw(p)
			Else
				TotaleTopic = TotaleTopic  & NumeroRaw(p) & Chr(32) 
			End If
		End If
	Next
Else
	Dim p As Long
	For p = 4 To NumeroRaw.Length -1
		If p = 4 Then
			Dim TotaleTopic As String 
			Dim SenzaPunti() As String 
			SenzaPunti =  Regex.Split(":",NumeroRaw(p))
			TotaleTopic = SenzaPunti(1) 
		Else
			TotaleTopic = TotaleTopic  & " "& NumeroRaw(p)
		End If
	Next
End If
	If i < Topichannel.Size Then
		Topichannel.Set(i, TotaleTopic)
	End If

End Sub

Sub GeneraDAtaUnix()
	Dim now As Long
	Dim RealDate As String 
	now = DateTime.now
	Dim WeekDaysStr() As String
	Dim Mouth() As String 
	WeekDaysStr = Array As String ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
	Mouth = Array As String ("Jan", "Feb","Mar", "Apr", "May", "Jun", "Jul", "Aug","Sept","Oct","Nov","Dec")
	RealDate = WeekDaysStr(DateTime.GetDayOfWeek(now) - 1) & " " & Mouth(DateTime.GetMonth(now)-1) & " " & DateTime.GetDayOfMonth(now) &" " &DateTime.GetHour(now)&":"&DateTime.GetMinute(now)&":"&DateTime.GetSecond(now)
	Return RealDate					
End Sub

Sub PingTimer_Tick
	 If AutoPing = True Then
		WriteSocketIrc("PING :TIMEOUTCHECK"&Chr(10))
		AutoPing=False
	End If
End Sub

Sub Ricezione_Server(Read As String )
	' ======================
	' PING // REPLY
	' ======================


	Dim PingString() As String
	PingString = Regex.Split(":",Read)
	If PingString(0) = "PING " Then
		WriteSocketIrc("PONG "&PingString(1)&Chr(13))
		AutoPing = True
		Return ""
	End If	
	
	
	' ===================================================
	' QUANDO SONO ONLINE DA MIRC
	' ===================================================
	
 	Dim RigaRead() As String
	Dim NumeroRaw() As String 
	Dim Start As Long
	RigaRead = Regex.Split(Chr(13),Read)
	For Start = 0 To RigaRead.Length -1
		If RigaRead(Start).Contains(Chr(32)) == True Then
		 		NumeroRaw = Regex.Split(Chr(32),RigaRead(Start))
				'SE DOVESSE TORNARE UNA RIGA VUOTA
				If NumeroRaw.Length = 1 Then Return ""
				'FINE MOTD CON SALVATAGGIO ULTIMA RIGA
				If NumeroRaw(1) = "376" Then
					SaveMoth =  SaveMoth & RigaRead(Start) & Chr(32)
					StopMoth = False
					RejoinChannel
				End If
				'SALVATAGGIO MOTD
				If StopMoth = True Then
					SaveMoth =  SaveMoth & RigaRead(Start) & Chr(32)
				End If
				
				'====================================
				' Entra NelServer
				' Raw 001 e Iniza a salvare il Mothd
				'====================================
				If NumeroRaw(1) = "001" Then
					StopMoth = True
					Nickconnessione = NumeroRaw(2)
					changemoth = RigaRead(Start).Replace(Nickconnessione&" :","$nick :").Replace(Nickconnessione&"!","$nick!")
					SaveMoth =  changemoth & Chr(32)
				 
				End If	
				'========================
				' NICK IN USO
				'======================
				If NumeroRaw(1)="433" AND Nickconnessione.Length > 0 AND joinpasswd=False Then
					Dim nmrandom As Int
					Dim f As String
					nmrandom = Rnd(1,10)
					f= nmrandom
					WriteSocketIrc("nick "&Nickconnessione&f)
				End If
				' ======================
				' MSG QUERY
				' ======================
				
				If NumeroRaw(1) = "PRIVMSG" AND joinpasswd = False Then
					Dim TildeChan As String 
					TildeChan = NumeroRaw(2).SubString2(0,1)
					If TildeChan <> "#" AND TildeChan <> "&" Then
						 
						Dim SoloVhost() As String
						
						Dim RealDate As String 
						SoloVhost = Regex.Split(":",NumeroRaw(0))
						RealDate = GeneraDAtaUnix
						Dim Start As Long
						Dim MessageText As String 
						For Start = 3 To NumeroRaw.Length -1
							If Start = 3 Then
								Dim SoloMSG() As String  
								SoloMSG = Regex.Split(":",NumeroRaw(3))
								MessageText = SoloMSG(1)
							Else
								MessageText = MessageText & " " & NumeroRaw(Start) 
							End If
						Next 
						
						' ======================
						' DCC MESSAGE DETECTION
						' ======================
						If MessageText.Contains("\x01DCC") Then
							' Processa i messaggi DCC
							ProcessDCCMessage(MessageText)
						Else
							' Salva messaggio privato normale
							MessageQuery.AddAll(Array As String(RealDate&" :("&SoloVhost(1)&")"& " " &MessageText))
						End If
					End If
				End If
				 '===================	
				 'ENTRA NEL CANALE
				 '=================	
				 If NumeroRaw(1) = "JOIN" Then
					Dim SolOnick() As String
					Dim SenzaDuePunti() As  String 
					SolOnick = Regex.Split("!",NumeroRaw(0))
					SenzaDuePunti = Regex.Split(":",SolOnick(0))
					If SenzaDuePunti(1) = Nickconnessione Then
						Dim RealChan() As String
						RealChan = Regex.Split(":",NumeroRaw(2))
						joinchannel.AddAll(Array As String(RealChan(1)))
						Topichannel.addAll(Array As String(""))
					End If
				End If
				' SALVA IL TOPIC 'RAW 332
				If NumeroRaw(1) ="332" Then
					For i = 0 To joinchannel.Size - 1
						If NumeroRaw(3) = joinchannel.Get(i) Then
							SaveTopic(i,NumeroRaw)
							
						End If
					Next 
				End If
				
				 '================
				 'ESCE DAL CANALE
				 '================
				If NumeroRaw(1) = "PART" Then
					Dim SolOnick() As String
					Dim SenzaDuePunti() As  String 
					Dim nomecanale As String 
					SolOnick = Regex.Split("!",NumeroRaw(0))
					SenzaDuePunti = Regex.Split(":",SolOnick(0))
					If SenzaDuePunti(1) = Nickconnessione Then
						For i = 0 To joinchannel.Size - 1
							If i <= joinchannel.Size -1 Then
								nomecanale = joinchannel.Get(i)
									If NumeroRaw(2) = nomecanale Then
										If joinchannel.get(i) <> Null Then joinchannel.RemoveAt(i)
										If Topichannel.get(i) <> Null Then Topichannel.removeAt(i)
									End If
							End If
						Next 
					End If
					Return Read
				End If
				 '======================
				 ' MODIFICA DEL TOPIC
				 '======================
				 If NumeroRaw(1) = "TOPIC" Then
			 		For i = 0 To joinchannel.Size - 1
						If NumeroRaw(2) = joinchannel.Get(i) Then
							SaveTopic(i,NumeroRaw) 
						End If
					Next 
					Return Read
				 End If
				 '=================
				 ' CAMBIO NICK
				 '=================	 
				 If NumeroRaw(1) = "NICK" Then
				 	Dim SolOnick() As String
					Dim TogliPunti() As String 
					SolOnick = Regex.Split("!",NumeroRaw(0))
				 	TogliPunti = Regex.Split(":",SolOnick(0))
					If TogliPunti(1) = Nickconnessione Then
						Dim NuovoNick() As String
						NuovoNick = Regex.Split(":",NumeroRaw(2))
						Nickconnessione =NuovoNick(1)
					End If
					Return Read
				 End If
				 '=================
				 ' KICK
				 '=================	 
				 If NumeroRaw(1) = "KICK" Then
						If NumeroRaw(3) = Nickconnessione Then
							For i = 0 To joinchannel.Size - 1
								If NumeroRaw(2) = joinchannel.Get(i) Then
									joinchannel.RemoveAt(i)
									Topichannel.removeAt(i)
								End If
							Next 
						End If
					Return Read
				End If
				
				'==================
				' FINE RAW
				'========
		End If
	Next 
	Return Read
	
End Sub
Sub WriteSocket(Read As String)
	' Usa la nuova funzione robusta
	WriteSocketSafe(Read)
End Sub
Sub WriteSocketIrc(Read As String)
 Try
	If socket_invio_dati.Connected = True Then
		Dim tr As TextReader
		Dim tw As TextWriter
		tr.Initialize(socket_invio_dati.InputStream)
		tw.Initialize(socket_invio_dati.OutputStream)	
		tw.WriteLine(Read)
		tw.Flush	
		Return Read
	End If
Catch
 	If IRClient == True AND joinpasswd = True Then
 	 	 ' SE IL SERVER CADE
		 Dim RealData As String 
		 RealData = GeneraDAtaUnix
			 For I = 0 To joinchannel.Size - 1
		 	WriteSocket(":"&Nickconnessione&" PART "&joinchannel.Get(I))
		 Next 
		 WriteSocket(":-psyBNC PRIVMSG psyBNC "&RealData&" User "&Solouser(identIRC)&" got disconnected from server.")
	End If
   		socket_invio_dati.close   
End Try
 

End Sub
Sub QueryMSG()
	If MessageQuery.IsInitialized = True Then
		Dim tr As TextReader
		Dim tw As TextWriter
		tr.Initialize( socket_ricezione_dati.InputStream)
		tw.Initialize( socket_ricezione_dati.OutputStream)	
		If MessageQuery.Size = 0 Then
			tw.WriteLine(":-psyBNC PRIVMSG psyBNC You have no new Messages.")
		Else
			tw.WriteLine(":-psyBNC PRIVMSG psyBNC You have Messages. Type /QUOTE PLAYPRIVATELOG To read your messages.")
		End If
		tw.Flush
	End If
End Sub
 

Sub socket_invio_dati_Connected (Successful As Boolean) 
    If Successful = True Then
	  	Dim tr As TextReader
		Dim tw As TextWriter
		tr.Initialize(socket_invio_dati.InputStream)
		tw.Initialize(socket_invio_dati.OutputStream)
		tw.WriteLine("CAP LS")
		tw.Flush
		tw.WriteLine(identIRC)
		tw.Flush
		datisocket_ricezione_irc.Initialize(socket_invio_dati.InputStream, socket_invio_dati.OutputStream, "datisocket_ricezione_irc")	
	End If
End Sub
Sub socket_invio_dati_close()
	

End Sub

Sub TimerServer_Tick


If server.IsInitialized = False Then
	server.Initialize(serverPort, "Server")		
	MyIP = server.GetMyIP
	server.listen
End If



Dim ValueSocket As Boolean
ValueSocket = socket_invio_dati.Connected 
If ValueSocket = False Then
	Dim SpazioRiga() As String 
	Dim StringConnection()  As String 
	SpazioRiga = Regex.Split(" ",LeggiFileRiga("psybnc.conf",3))
	Dim RealData As String 
	RealData = GeneraDAtaUnix
	If SpazioRiga.Length > 1 Then
		StringConnection = Regex.Split(":",SpazioRiga(1))
		If StringConnection.Length = 2 Then
			Topichannel.Clear
			socket_invio_dati.Close
			socket_invio_dati.Initialize("socket_invio_dati")
			socket_invio_dati.Connect(StringConnection(0),StringConnection(1),1000)
			WriteSocket(":-psyBNC PRIVMSG psyBNC "&RealData&" :User "&Solouser(identIRC)&" () trying "&StringConnection(0)&" port "&StringConnection(1)&" ().")
		End If
	Else
		WriteSocket(":-psyBNC PRIVMSG psyBNC "&RealData&" :User "&Solouser(identIRC)&" has no server added") 
	End If
End If

' ======================
' DCC CLEANUP
' ======================
CleanupDCCConnections()

End Sub

 
Sub TogliPrimoComando(Read As String) As String 
	Dim spazio() As String 
	Dim nuovocomando As String 
	spazio = Regex.Split(Chr(32),Read)
	For start = 1 To spazio.Length -1
		If start == 1 Then
			nuovocomando = spazio(start)
		 Else
		 	nuovocomando = nuovocomando & " " & spazio(start)
		 End If
	Next 
	Return nuovocomando
End Sub
Sub RejoinChannel() As String 
 If SaveMoth.Length > 0 Then
	Dim I As Long
	WriteSocketIrc("nick "&NormalNick)
	WriteSocket(SaveMoth.Replace("$nick :",Nickconnessione&" :").Replace("$nick!",Nickconnessione&"!"))
	For I = 0 To joinchannel.Size - 1
		'WriteSocketIrc("names " & joinchannel.Get(I))
		WriteSocket(":"&Nickconnessione &"!psybnc@localhost.psybnc-arkosoft.com JOIN :"&joinchannel.Get(I)&Chr(13)) 
 		Try
			 	WriteSocket(":server.psybnc.com 332 "&Nickconnessione&" "&joinchannel.Get(I)&Chr(13) &" :"&Topichannel.Get(I)&Chr(13))
		Catch
		End Try
		WriteSocketIrc("join "&joinchannel.Get(I))
		WriteSocketIrc("names "&joinchannel.Get(I))
	Next 
End If
	
End Sub


Sub Solouser(IdentRead As String)
If IdentRead.Length > 0 Then
	Dim User() As String 
	Dim Space() As String 
	User = Regex.Split("USER",IdentRead)
	Space = Regex.Split(" ",User(1))
	Return Space(1)
End If

End Sub


Sub Bhelp()
	Dim tr As TextReader
	Dim tw As TextWriter
	tr.Initialize( socket_ricezione_dati.InputStream)
	tw.Initialize( socket_ricezione_dati.OutputStream)	
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC Welcome "&Solouser(identIRC)&" !")	
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC You are the first To connect To this new proxy server.")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC You are the proxy-admin. Use ADDSERVER To add a server so the bouncer may connect.")
 	tw.WriteLine(":-psyBNC PRIVMSG psyBNC psyBNC0.1 Help (* = BounceAdmin only)")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC -------------------------------------")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDSERVER       - Adds an IRC-server To your Serverlist")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DELSERVER       - Deletes an IRC-Server by number")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTSERVERS     - Lists all IRC-Servers added")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SETAWAYNICK     - Sets your nick when you are offline")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   PLAYPRIVATELOG  - Plays your Message Log")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ERASEPRIVATELOG - Erases your Message Log")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCSTATUS       - Shows DCC connections status")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCFILES       - Lists pending DCC files")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCMODE        - Sets DCC mode (SAVE/FORWARD)")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCCONFIG      - Shows DCC configuration")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCCHAT        - Starts DCC chat with user")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCANSWER       - Accepts DCC chat request")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCSENDME       - Sends file via DCC")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCGET          - Accepts DCC file offer")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCCANCEL       - Cancels DCC transfer")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   AUTOGETDCC      - Auto-accepts DCC files")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTDCC        - Lists DCC connections")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLCONFIG       - Shows SSL configuration")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLENABLE       - Enables SSL support")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLDISABLE      - Disables SSL support")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLCONNECT      - Connects to IRC server via SSL")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   HEARTBEATSTART  - Starts heartbeat monitoring")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   HEARTBEATSTOP   - Stops heartbeat monitoring")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SAVESTATE       - Saves current state")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LOADSTATE       - Loads saved state")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDUSER        - Adds a new user")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DELUSER         - Deletes a user")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   PASSWORD       - Changes user password")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   MADMIN         - Makes user admin")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   UNADMIN         - Removes admin rights")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   BWHO           - Lists all users")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   BKILL          - Kills user connection")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   USERINFO       - Shows user information")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDNETWORK     - Adds a new network")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DELNETWORK     - Deletes a network")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTNETWORKS   - Lists all networks")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDSERVER      - Adds server to network")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   CONNECTNETWORK - Connects to network")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTCLIENTS    - Lists all clients")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   VHOST          - Sets virtual host")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   PROXY          - Sets proxy configuration")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   BAN            - Bans a user")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   UNBAN          - Unbans a user")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   OP             - Gives op to user")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DEOP            - Removes op from user")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   BHELP           - Lists this help OR help on a topic")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP Use /QUOTE bhelp <command> For details.")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP - End of help")
	tw.Flush
End Sub


Sub ClientInvio(Read As String)
		'Nickname is already in use
Dim tr As TextReader
Dim tw As TextWriter

		'PRIMO COMANDO
		If Read.Contains("CAP LS") = True Then
			IRClient = True
		End If
	   ' ================================
	   ' GESTIONE IDENT
	   ' ==================
	   
		If Read.Contains("NICK") AND IRClient == True AND joinpasswd = False Then 
			tr.Initialize( socket_ricezione_dati.InputStream)
			tw.Initialize( socket_ricezione_dati.OutputStream)
			tw.WriteLine(": Welcome NOTICE :psyBNC 0.1")
			tw.WriteLine(": -psyBNC NOTICE :Your IRC Client did not support a password. Please type /QUOTE PASS yourpassword to connect.")
			identIRC = Read.Replace("CAP LS","")
			tw.Flush
		End If
		' ===========================
		' GESTIONE PASSWORD
		' ==================
		
		If Read.ToUpperCase.Contains("PASSWORD") OR Read.ToUpperCase.Contains("PASS") AND IRClient == True AND identIRC.Length > 0 Then 
			
			Dim fileconf As String	
			Dim BeginLogin As Boolean 
			'lettura della password scritta via socket
			Dim readpasswd As String 	
			readpasswd = TogliPrimoComando(Read)	
			'lettura del file
			fileconf = ReadFile("psybnc.conf")
			
			If (fileconf.Length == 0)Then
				'se il file non esiste
				'scrittura del file 
				WriteFile("psybnc.conf", identIRC.Replace(Chr(13),""))
				WriteFile("psybnc.conf", "PASSWD "&readpasswd) 
				Dim Spacenick() As String 
				Dim Solonick() As String
				Spacenick = Regex.Split(Chr(32),identIRC)
				Solonick = Regex.Split(Chr(10),Spacenick(1))
				Nickconnessione = Solonick(0)
				' Autentica primo utente (admin di default)
				If AuthenticateUser(Nickconnessione, "admin123") Then
					SetUserOnline(Nickconnessione, True)
					' Entra e stamba il menu
					Bhelp
					joinpasswd = True
					Return ""
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Authentication failed. Please check your credentials.")
					Return ""
				End If
			Else
				'se sta già creato il file e controlla se esiste
				Dim Linefile() As String 
				Dim onlypass() As String 
				Linefile = Regex.split(Chr(13),fileconf)
				onlypass = Regex.split(Chr(32),Linefile(2))
				'controllo se le password sono uguali	
					If onlypass(1) == readpasswd.SubString2(0,readpasswd.Length -1) Then
						' Autentica utente con il nuovo sistema
						If AuthenticateUser(Nickconnessione, readpasswd.SubString2(0,readpasswd.Length -1)) Then
							joinpasswd = True
							SetUserOnline(Nickconnessione, True)
							QueryMSG
						Else
							WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Authentication failed. Please check your credentials.")
							Return ""
						End If
						If Linefile.Length > 3 Then
							'lettura del server dove connettersi in automatico
							If socket_invio_dati.Connected = False Then
								Bhelp
							Else
								RejoinChannel
							End If
						End If
						Return ""
					End If
			End If	
		End If
		' ========================================
		' GESTIONE CONNESSIONE SERVER IRC
		' ======================
		If Read.ToUpperCase.Contains("ADDSERVER") AND IRClient == True AND joinpasswd = True Then
		   Dim soloserver() As String
		   Dim soloporta As String 
		   Read = TogliPrimoComando(Read.ToUpperCase)
		   soloserver  = Regex.split(":",Read.ToUpperCase)
		   If soloserver.Length -1 > 0 Then
		   		soloporta = soloserver(1)
		   		WriteFileRiga("psybnc.conf","server "&soloserver(0) & ":"& soloporta,4)
		   		WriteSocket(":-psyBNC PRIVMSG psyBNC Server "&soloserver(0)&" port "&soloporta&" (password: None) added.")
		   		 
		   Else
		   		WriteSocket(":-psyBNC PRIVMSG psyBNC No server given. Syntax Is ADDSERVER hostname ::port")	
		   End If
		   Return ""
		End If
		'=====================
		'LIST SERVER
		'=====================
		If Read.ToUpperCase.Contains("LISTSERVERS") AND IRClient == True AND joinpasswd = True Then
		    Dim SpazioRiga() As String 
			Dim porta()  As String 
			SpazioRiga = Regex.Split(" ",LeggiFileRiga("psybnc.conf",3))
			If SpazioRiga.Length > 1 Then
				porta = Regex.Split(":",SpazioRiga(1))
				WriteSocket(":-psyBNC PRIVMSG psyBNC Server #1:"&SpazioRiga(1)&" port "&porta(1))
			End If
			WriteSocket(":-psyBNC PRIVMSG psyBNC End of Servers.")
		   Return ""
		End If
		' =========================
		' JUMP
		'============================
		If Read.ToUpperCase.Contains("JUMP") AND IRClient == True AND joinpasswd = True Then
			WriteSocket(":-psyBNC PRIVMSG psyBNC Jump New Server.")
			socket_invio_dati.close
			Dim SpazioRiga() As String 
			Dim StringConnection()  As String 
			SpazioRiga = Regex.Split(" ",LeggiFileRiga("psybnc.conf",3))
			Dim RealData As String 
			RealData = GeneraDAtaUnix
			If SpazioRiga.Length > 1 Then
				StringConnection = Regex.Split(":",SpazioRiga(1))
				If StringConnection.Length = 2 Then
					Topichannel.Clear
					socket_invio_dati.Close
					socket_invio_dati.Initialize("socket_invio_dati")
					socket_invio_dati.Connect(StringConnection(0),StringConnection(1),1000)
					WriteSocket(":-psyBNC PRIVMSG psyBNC "&RealData&" :User "&Solouser(identIRC)&" () trying "&StringConnection(0)&" port "&StringConnection(1)&" ().")
				End If
			End If
		
		End If
		If Read.ToUpperCase.Contains("BHELP") AND IRClient == True AND joinpasswd = True Then
			Bhelp
		End If
		'=====================
		'DEL SERVER
		'=====================
		If Read.ToUpperCase.Contains("DELSERVER") AND IRClient == True AND joinpasswd = True Then
		   Dim numero As String 
		   numero = TogliPrimoComando(Read).Replace(Chr(10),"")
		   If numero = "1" Then
		   		WriteFileRiga("psybnc.conf","server",4)
		   		WriteSocket(":-psyBNC PRIVMSG psyBNC Server 1 deleted.")
		   End If
		   Return ""
		End If
		' =============================
		' LOG READ MESSAGE
		' ========================
		If Read.ToUpperCase.Contains("PLAYPRIVATELOG") AND IRClient == True AND joinpasswd = True Then
			If MessageQuery.IsInitialized = True Then
				If MessageQuery.size-1 >= 0 Then
					WriteSocket(":-psyBNC PRIVMSG psybnc Starting playing Log")
					For i = 0 To MessageQuery.size -1
					 	WriteSocket(":-psyBNC PRIVMSG psyBNC "& MessageQuery.Get(i))
					Next
					WriteSocket(":-psyBNC PRIVMSG psyBNC Use ERASEPRIVATELOG to kill the log")
				End If
			End If
			Return ""
		End If
		' ============================
		' CLEAR LOG MESSAGE
		' ===================
		If Read.ToUpperCase.Contains("ERASEPRIVATELOG") AND IRClient == True AND joinpasswd = True Then
			If MessageQuery.IsInitialized = True Then
				MessageQuery.Clear
				WriteSocket(":-psyBNC PRIVMSG psyBNC Log erased")
			End If
				Return ""
		End If
		' ============================
		' SET AWAY NICK
		' ===================
		If Read.ToUpperCase.Contains("SETAWAYNICK") AND IRClient == True AND joinpasswd = True Then
				AwayNick = TogliPrimoComando(Read).Replace(Chr(10),"")
				WriteSocket(":-psyBNC PRIVMSG psyBNC AWAY-Nick changed to '"&AwayNick & "'.")
				Return ""
		End If
		' ============================
		' DCC STATUS
		' ===================
		If Read.ToUpperCase.Contains("DCCSTATUS") AND IRClient == True AND joinpasswd = True Then
			Dim DCCStatusText As String
			DCCStatusText = GetDCCStatus()
			WriteSocket(":-psyBNC PRIVMSG psyBNC " & DCCStatusText)
			Return ""
		End If
		' ============================
		' DCC FILES
		' ===================
		If Read.ToUpperCase.Contains("DCCFILES") AND IRClient == True AND joinpasswd = True Then
			If DCCFiles.Size > 0 Then
				WriteSocket(":-psyBNC PRIVMSG psyBNC Pending DCC Files:")
				For i = 0 To DCCFiles.Size - 1
					Dim DCCFile As Map
					DCCFile = DCCFiles.Get(i)
					WriteSocket(":-psyBNC PRIVMSG psyBNC " & (i+1) & ". " & DCCFile.Get("FileName") & " (" & DCCFile.Get("FileSize") & " bytes) [" & DCCFile.Get("Mode") & "]")
				Next
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC No pending DCC files.")
			End If
			Return ""
		End If
		' ============================
		' DCC MODE
		' ===================
		If Read.ToUpperCase.Contains("DCCMODE") AND IRClient == True AND joinpasswd = True Then
			Dim NewMode As String
			NewMode = TogliPrimoComando(Read).Replace(Chr(10),"").ToUpperCase
			
			If NewMode = "SAVE" OR NewMode = "FORWARD" Then
				DCCMode = NewMode
				WriteSocket(":-psyBNC PRIVMSG psyBNC DCC mode set to: " & DCCMode)
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Invalid DCC mode. Use SAVE or FORWARD")
			End If
			Return ""
		End If
		' ============================
		' DCC CONFIG
		' ===================
		If Read.ToUpperCase.Contains("DCCCONFIG") AND IRClient == True AND joinpasswd = True Then
			WriteSocket(":-psyBNC PRIVMSG psyBNC DCC Configuration:")
			WriteSocket(":-psyBNC PRIVMSG psyBNC Mode: " & DCCMode)
			WriteSocket(":-psyBNC PRIVMSG psyBNC Auto-Accept: " & DCCAutoAccept)
			WriteSocket(":-psyBNC PRIVMSG psyBNC Max File Size: " & DCCMaxFileSize & " bytes")
			WriteSocket(":-psyBNC PRIVMSG psyBNC Allowed Types: " & JoinDCCAllowedTypes())
			WriteSocket(":-psyBNC PRIVMSG psyBNC DCC Server Port: " & DCCPort)
			Return ""
		End If
		' ============================
		' SSL CONFIG
		' ===================
		If Read.ToUpperCase.Contains("SSLCONFIG") AND IRClient == True AND joinpasswd = True Then
			WriteSocket(":-psyBNC PRIVMSG psyBNC SSL Configuration:")
			WriteSocket(":-psyBNC PRIVMSG psyBNC SSL Enabled: " & SSLEnabled)
			WriteSocket(":-psyBNC PRIVMSG psyBNC SSL Port: " & SSLPort)
			WriteSocket(":-psyBNC PRIVMSG psyBNC SSL Certificate: " & SSLCertificate)
			WriteSocket(":-psyBNC PRIVMSG psyBNC SSL Key: " & SSLKey)
			Return ""
		End If
		' ============================
		' SSL ENABLE
		' ===================
		If Read.ToUpperCase.Contains("SSLENABLE") AND IRClient == True AND joinpasswd = True Then
			EnableSSL(True)
			WriteSocket(":-psyBNC PRIVMSG psyBNC SSL enabled")
			Return ""
		End If
		' ============================
		' SSL DISABLE
		' ===================
		If Read.ToUpperCase.Contains("SSLDISABLE") AND IRClient == True AND joinpasswd = True Then
			EnableSSL(False)
			WriteSocket(":-psyBNC PRIVMSG psyBNC SSL disabled")
			Return ""
		End If
		' ============================
		' SSL CONNECT
		' ===================
		If Read.ToUpperCase.Contains("SSLCONNECT") AND IRClient == True AND joinpasswd = True Then
			Dim SSLServer As String
			Dim SSLPort As Int
			SSLServer = TogliPrimoComando(Read).Replace(Chr(10),"").Split(" ")(0)
			SSLPort = TogliPrimoComando(Read).Replace(Chr(10),"").Split(" ")(1)
			If SSLPort = 0 Then SSLPort = 6697
			
			If ConnectToIRCServerSSL(SSLServer, SSLPort) Then
				WriteSocket(":-psyBNC PRIVMSG psyBNC SSL connection established to " & SSLServer & ":" & SSLPort)
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC SSL connection failed to " & SSLServer & ":" & SSLPort)
			End If
			Return ""
		End If
		' ============================
		' HEARTBEAT START
		' ===================
		If Read.ToUpperCase.Contains("HEARTBEATSTART") AND IRClient == True AND joinpasswd = True Then
			StartHeartbeat()
			WriteSocket(":-psyBNC PRIVMSG psyBNC Heartbeat system started")
			Return ""
		End If
		' ============================
		' HEARTBEAT STOP
		' ===================
		If Read.ToUpperCase.Contains("HEARTBEATSTOP") AND IRClient == True AND joinpasswd = True Then
			HeartbeatTimer.Enabled = False
			WriteSocket(":-psyBNC PRIVMSG psyBNC Heartbeat system stopped")
			Return ""
		End If
		' ============================
		' SAVE STATE
		' ===================
		If Read.ToUpperCase.Contains("SAVESTATE") AND IRClient == True AND joinpasswd = True Then
			SaveCurrentState()
			WriteSocket(":-psyBNC PRIVMSG psyBNC State saved successfully")
			Return ""
		End If
		' ============================
		' LOAD STATE
		' ===================
		If Read.ToUpperCase.Contains("LOADSTATE") AND IRClient == True AND joinpasswd = True Then
			LoadSavedState()
			WriteSocket(":-psyBNC PRIVMSG psyBNC State loaded successfully")
			Return ""
		End If
		' ============================
		' ADD USER
		' ===================
		If Read.ToUpperCase.Contains("ADDUSER") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim UserLogin As String
			Dim UserRealName As String
			Dim CommandParts() As String
			CommandParts = TogliPrimoComando(Read).Replace(Chr(10),"").Split(":")
			
			If CommandParts.Length >= 2 Then
				UserLogin = CommandParts(0).Trim
				UserRealName = CommandParts(1).Trim
				
				If AddUser(UserLogin, UserRealName) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC User added successfully: " & UserLogin)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to add user: " & UserLogin)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDUSER login :realname")
			End If
			Return ""
		End If
		' ============================
		' DELETE USER
		' ===================
		If Read.ToUpperCase.Contains("DELUSER") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim UserLogin As String
			UserLogin = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If UserLogin.Length > 0 Then
				If DeleteUser(UserLogin) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC User deleted successfully: " & UserLogin)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to delete user: " & UserLogin)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DELUSER login")
			End If
			Return ""
		End If
		' ============================
		' CHANGE PASSWORD
		' ===================
		If Read.ToUpperCase.Contains("PASSWORD") AND IRClient == True AND joinpasswd = True Then
			Dim UserLogin As String
			Dim NewPassword As String
			Dim CommandParts() As String
			CommandParts = TogliPrimoComando(Read).Replace(Chr(10),"").Split(":")
			
			If CommandParts.Length >= 2 Then
				UserLogin = CommandParts(0).Trim
				NewPassword = CommandParts(1).Trim
				
				If ChangePassword(UserLogin, NewPassword) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC Password changed successfully for user: " & UserLogin)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to change password for user: " & UserLogin)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: PASSWORD login :newpassword")
			End If
			Return ""
		End If
		' ============================
		' MAKE ADMIN
		' ===================
		If Read.ToUpperCase.Contains("MADMIN") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim UserLogin As String
			UserLogin = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If UserLogin.Length > 0 Then
				If MakeAdmin(UserLogin) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC User promoted to admin: " & UserLogin)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to promote user to admin: " & UserLogin)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: MADMIN login")
			End If
			Return ""
		End If
		' ============================
		' REMOVE ADMIN
		' ===================
		If Read.ToUpperCase.Contains("UNADMIN") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim UserLogin As String
			UserLogin = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If UserLogin.Length > 0 Then
				If RemoveAdmin(UserLogin) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC Admin rights removed from user: " & UserLogin)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to remove admin rights from user: " & UserLogin)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: UNADMIN login")
			End If
			Return ""
		End If
		' ============================
		' LIST USERS (BWHO)
		' ===================
		If Read.ToUpperCase.Contains("BWHO") AND IRClient == True AND joinpasswd = True Then
			Dim UserList As String
			UserList = GetUserList()
			WriteSocket(":-psyBNC PRIVMSG psyBNC Users: " & UserList)
			Return ""
		End If
		' ============================
		' KILL USER
		' ===================
		If Read.ToUpperCase.Contains("BKILL") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim UserLogin As String
			UserLogin = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If UserLogin.Length > 0 Then
				If KillUser(UserLogin) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC User killed: " & UserLogin)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to kill user: " & UserLogin)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: BKILL login")
			End If
			Return ""
		End If
		' ============================
		' USER INFO
		' ===================
		If Read.ToUpperCase.Contains("USERINFO") AND IRClient == True AND joinpasswd = True Then
			Dim UserLogin As String
			UserLogin = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If UserLogin.Length > 0 Then
				Dim UserInfo As String
				UserInfo = GetUserInfo(UserLogin)
				WriteSocket(":-psyBNC PRIVMSG psyBNC " & UserInfo)
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: USERINFO login")
			End If
			Return ""
		End If
		' ============================
		' ADD NETWORK
		' ===================
		If Read.ToUpperCase.Contains("ADDNETWORK") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim NetworkName As String
			NetworkName = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If NetworkName.Length > 0 Then
				If AddNetwork(NetworkName) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC Network added successfully: " & NetworkName)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to add network: " & NetworkName)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDNETWORK name")
			End If
			Return ""
		End If
		' ============================
		' DELETE NETWORK
		' ===================
		If Read.ToUpperCase.Contains("DELNETWORK") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim NetworkName As String
			NetworkName = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If NetworkName.Length > 0 Then
				If DeleteNetwork(NetworkName) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC Network deleted successfully: " & NetworkName)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to delete network: " & NetworkName)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DELNETWORK name")
			End If
			Return ""
		End If
		' ============================
		' LIST NETWORKS
		' ===================
		If Read.ToUpperCase.Contains("LISTNETWORKS") AND IRClient == True AND joinpasswd = True Then
			Dim NetworkList As String
			NetworkList = GetNetworkList()
			WriteSocket(":-psyBNC PRIVMSG psyBNC Networks: " & NetworkList)
			Return ""
		End If
		' ============================
		' ADD SERVER TO NETWORK
		' ===================
		If Read.ToUpperCase.Contains("ADDSERVER") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim NetworkName As String
			Dim ServerHost As String
			Dim ServerPort As Int
			Dim CommandParts() As String
			CommandParts = TogliPrimoComando(Read).Replace(Chr(10),"").Split("'")
			
			If CommandParts.Length >= 2 Then
				NetworkName = CommandParts(0).Trim
				Dim ServerParts() As String
				ServerParts = CommandParts(1).Split(":")
				ServerHost = ServerParts(0).Trim
				ServerPort = ServerParts(1).Trim
				
				If AddServerToNetwork(NetworkName, ServerHost, ServerPort) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC Server added to network " & NetworkName & ": " & ServerHost & ":" & ServerPort)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to add server to network " & NetworkName)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDSERVER network'server:port")
			End If
			Return ""
		End If
		' ============================
		' CONNECT TO NETWORK
		' ===================
		If Read.ToUpperCase.Contains("CONNECTNETWORK") AND IRClient == True AND joinpasswd = True Then
			Dim NetworkName As String
			NetworkName = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If NetworkName.Length > 0 Then
				If ConnectToNetwork(NetworkName) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC Connected to network: " & NetworkName)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to connect to network: " & NetworkName)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: CONNECTNETWORK name")
			End If
			Return ""
		End If
		' ============================
		' LIST CLIENTS
		' ===================
		If Read.ToUpperCase.Contains("LISTCLIENTS") AND IRClient == True AND joinpasswd = True Then
			Dim ClientList As String
			ClientList = GetClientList()
			WriteSocket(":-psyBNC PRIVMSG psyBNC Clients: " & ClientList)
			Return ""
		End If
		' ============================
		' VHOST COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("VHOST") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim VHostCommand As String
			VHostCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If VHostCommand.Length > 0 Then
				Dim VHostParts() As String
				VHostParts = VHostCommand.Split(":")
				
				If VHostParts.Length >= 2 Then
					Dim VHostHost As String
					Dim VHostPort As Int
					VHostHost = VHostParts(0).Trim
					VHostPort = VHostParts(1).Trim
					
					If SetVHost(VHostHost, VHostPort) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC VHost set to " & VHostHost & ":" & VHostPort)
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to set VHost")
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: VHOST host:port")
				End If
			Else
				Dim VHostStatus As String
				VHostStatus = GetVHostStatus()
				WriteSocket(":-psyBNC PRIVMSG psyBNC " & VHostStatus)
			End If
			Return ""
		End If
		' ============================
		' PROXY COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("PROXY") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim ProxyCommand As String
			ProxyCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If ProxyCommand.Length > 0 Then
				Dim ProxyParts() As String
				ProxyParts = ProxyCommand.Split("'")
				
				If ProxyParts.Length >= 2 Then
					Dim ProxyType As String
					Dim ProxyHost As String
					Dim ProxyPort As Int
					Dim ProxyUsername As String
					Dim ProxyPassword As String
					
					ProxyType = ProxyParts(0).Trim
					Dim HostParts() As String
					HostParts = ProxyParts(1).Split(":")
					ProxyHost = HostParts(0).Trim
					ProxyPort = HostParts(1).Trim
					
					If ProxyParts.Length >= 4 Then
						ProxyUsername = ProxyParts(2).Trim
						ProxyPassword = ProxyParts(3).Trim
					End If
					
					If SetProxy(ProxyType, ProxyHost, ProxyPort, ProxyUsername, ProxyPassword) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC Proxy set to " & ProxyType & "://" & ProxyHost & ":" & ProxyPort)
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to set proxy")
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: PROXY type'host:port'username'password")
				End If
			Else
				Dim ProxyStatus As String
				ProxyStatus = GetProxyStatus()
				WriteSocket(":-psyBNC PRIVMSG psyBNC " & ProxyStatus)
			End If
			Return ""
		End If
		' ============================
		' BAN COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("BAN") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim BanCommand As String
			BanCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If BanCommand.Length > 0 Then
				Dim BanParts() As String
				BanParts = BanCommand.Split("'")
				
				If BanParts.Length >= 2 Then
					Dim BanUser As String
					Dim BanReason As String
					Dim BanExpiry As Int
					
					BanUser = BanParts(0).Trim
					BanReason = BanParts(1).Trim
					BanExpiry = 0
					
					If BanParts.Length >= 3 Then
						BanExpiry = BanParts(2).Trim
					End If
					
					If BanUser(BanUser, BanReason, BanExpiry) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC User " & BanUser & " banned (Reason: " & BanReason & ")")
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to ban user " & BanUser)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: BAN user'reason'expiry_days")
				End If
			Else
				Dim BanList As String
				BanList = GetBanList()
				WriteSocket(":-psyBNC PRIVMSG psyBNC " & BanList)
			End If
			Return ""
		End If
		' ============================
		' UNBAN COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("UNBAN") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim UnbanUser As String
			UnbanUser = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If UnbanUser.Length > 0 Then
				If UnbanUser(UnbanUser) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC User " & UnbanUser & " unbanned")
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to unban user " & UnbanUser)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: UNBAN user")
			End If
			Return ""
		End If
		' ============================
		' OP COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("OP") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim OpCommand As String
			OpCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If OpCommand.Length > 0 Then
				Dim OpParts() As String
				OpParts = OpCommand.Split("'")
				
				If OpParts.Length >= 2 Then
					Dim OpUser As String
					Dim OpChannel As String
					Dim OpLevel As Int
					
					OpUser = OpParts(0).Trim
					OpChannel = OpParts(1).Trim
					OpLevel = 1
					
					If OpParts.Length >= 3 Then
						OpLevel = OpParts(2).Trim
					End If
					
					If GiveOp(OpUser, OpChannel, OpLevel) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC User " & OpUser & " given op on " & OpChannel & " (Level: " & OpLevel & ")")
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to give op to " & OpUser)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: OP user'channel'level")
				End If
			Else
				Dim OpList As String
				OpList = GetOpList()
				WriteSocket(":-psyBNC PRIVMSG psyBNC " & OpList)
			End If
			Return ""
		End If
		' ============================
		' DEOP COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("DEOP") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DeopUser As String
			DeopUser = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DeopUser.Length > 0 Then
				If RemoveOp(DeopUser) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC User " & DeopUser & " op removed")
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to remove op from " & DeopUser)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DEOP user")
			End If
			Return ""
		End If
		' ============================
		' DCCCHAT COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("DCCCHAT") AND IRClient == True AND joinpasswd = True Then
			Dim DCCChatUser As String
			DCCChatUser = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DCCChatUser.Length > 0 Then
				If StartDCCChat(DCCChatUser) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC DCC chat request sent to " & DCCChatUser)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to start DCC chat with " & DCCChatUser)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DCCCHAT user")
			End If
			Return ""
		End If
		' ============================
		' DCCANSWER COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("DCCANSWER") AND IRClient == True AND joinpasswd = True Then
			Dim DCCAnswerUser As String
			DCCAnswerUser = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DCCAnswerUser.Length > 0 Then
				If AnswerDCCChat(DCCAnswerUser) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC DCC chat accepted with " & DCCAnswerUser)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to accept DCC chat from " & DCCAnswerUser)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DCCANSWER user")
			End If
			Return ""
		End If
		' ============================
		' DCCSENDME COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("DCCSENDME") AND IRClient == True AND joinpasswd = True Then
			Dim DCCSendCommand As String
			DCCSendCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DCCSendCommand.Length > 0 Then
				Dim DCCSendParts() As String
				DCCSendParts = DCCSendCommand.Split("'")
				
				If DCCSendParts.Length >= 2 Then
					Dim DCCFileName As String
					Dim DCCTargetUser As String
					DCCFileName = DCCSendParts(0).Trim
					DCCTargetUser = DCCSendParts(1).Trim
					
					If SendDCCFile(DCCFileName, DCCTargetUser) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC DCC file offer sent: " & DCCFileName & " to " & DCCTargetUser)
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to send DCC file: " & DCCFileName)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DCCSENDME filename'user")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DCCSENDME filename'user")
			End If
			Return ""
		End If
		' ============================
		' DCCGET COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("DCCGET") AND IRClient == True AND joinpasswd = True Then
			Dim DCCGetCommand As String
			DCCGetCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DCCGetCommand.Length > 0 Then
				Dim DCCGetParts() As String
				DCCGetParts = DCCGetCommand.Split("'")
				
				If DCCGetParts.Length >= 2 Then
					Dim DCCGetUser As String
					Dim DCCGetFile As String
					DCCGetUser = DCCGetParts(0).Trim
					DCCGetFile = DCCGetParts(1).Trim
					
					If AcceptDCCFile(DCCGetFile, DCCGetUser) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC DCC file accepted: " & DCCGetFile & " from " & DCCGetUser)
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to accept DCC file: " & DCCGetFile)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DCCGET user'filename")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DCCGET user'filename")
			End If
			Return ""
		End If
		' ============================
		' DCCCANCEL COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("DCCCANCEL") AND IRClient == True AND joinpasswd = True Then
			Dim DCCCancelCommand As String
			DCCCancelCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DCCCancelCommand.Length > 0 Then
				Dim DCCCancelParts() As String
				DCCCancelParts = DCCCancelCommand.Split("'")
				
				If DCCCancelParts.Length >= 1 Then
					Dim DCCCancelUser As String
					Dim DCCCancelFile As String
					DCCCancelUser = DCCCancelParts(0).Trim
					DCCCancelFile = ""
					
					If DCCCancelParts.Length >= 2 Then
						DCCCancelFile = DCCCancelParts(1).Trim
					End If
					
					If CancelDCCTransfer(DCCCancelUser, DCCCancelFile) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC DCC transfer cancelled: " & DCCCancelUser & " " & DCCCancelFile)
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to cancel DCC transfer")
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DCCCANCEL user'filename")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DCCCANCEL user'filename")
			End If
			Return ""
		End If
		' ============================
		' AUTOGETDCC COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("AUTOGETDCC") AND IRClient == True AND joinpasswd = True Then
			Dim AutoGetCommand As String
			AutoGetCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If AutoGetCommand.Length > 0 Then
				Dim AutoGetParts() As String
				AutoGetParts = AutoGetCommand.Split("'")
				
				If AutoGetParts.Length >= 2 Then
					Dim AutoGetUser As String
					Dim AutoGetNetwork As String
					Dim AutoGetEnable As Boolean
					AutoGetUser = AutoGetParts(0).Trim
					AutoGetNetwork = AutoGetParts(1).Trim
					AutoGetEnable = True
					
					If SetAutoGetDCC(AutoGetUser, AutoGetNetwork, AutoGetEnable) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC Auto-get DCC enabled for " & AutoGetUser & " on " & AutoGetNetwork)
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to enable auto-get DCC")
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: AUTOGETDCC user'network")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: AUTOGETDCC user'network")
			End If
			Return ""
		End If
		' ============================
		' LISTDCC COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("LISTDCC") AND IRClient == True AND joinpasswd = True Then
			Dim DCCList As String
			DCCList = GetDCCConnectionsList()
			WriteSocket(":-psyBNC PRIVMSG psyBNC " & DCCList)
			Return ""
		End If
		' ============================
		' SCRIVI SUL SOCKET
		' SE NON FA IL COMANDO CLOSE
		' ============================
		If Read.ToUpperCase.Contains("QUIT :") == False AND IRClient == True AND joinpasswd = True Then
			WriteSocketIrc(Read)
		Else
			'CHIUDE IL CLIENT
			 If Read.ToUpperCase.Contains("QUIT :") == True Then
				'CHIUDE IL CLIENT
				NormalNick = Nickconnessione
				WriteSocketIrc("nick "&AwayNick)
				' Disconnetti utente dal sistema
				SetUserOnline(Nickconnessione, False)
				IRClient = False
				joinpasswd = False
			End If	
		End If
	 
	
End Sub

' ======================
' DCC SUPPORT FUNCTIONS
' ======================

Sub DCCServer_NewConnection (Successful As Boolean, NewSocket As Socket)
	If Successful = True Then
		' Gestisce nuove connessioni DCC
		Dim DCCInfo As Map
		DCCInfo.Initialize
		DCCInfo.Put("Socket", NewSocket)
		DCCInfo.Put("Connected", True)
		DCCInfo.Put("StartTime", DateTime.Now)
		DCCConnections.Add(DCCInfo)
		
		' Inizializza stream per la connessione DCC
		Dim DCCStream As AsyncStreams
		DCCStream.Initialize(NewSocket.InputStream, NewSocket.OutputStream, "DCCStream")
	End If
End Sub

Sub DCCStream_NewData (buffer() As Byte)
	' Gestisce i dati ricevuti via DCC
	Dim DataString As String
	DataString = BytesToString(buffer, 0, buffer.Length, "UTF8")
	
	' Salva i dati ricevuti nel file DCC
	SaveDCCData(DataString)
End Sub

Sub SaveDCCData(Data As String)
	' Salva i dati DCC ricevuti in un file
	Dim CurrentFile As String
	CurrentFile = "dcc_received_" & DateTime.Now & ".dat"
	
	Dim Writer As TextWriter
	Writer.Initialize(File.OpenOutput(File.DirInternal, CurrentFile, True))
	Writer.Write(Data)
	Writer.Close
	
	' Notifica il client del file ricevuto
	WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :DCC file received: " & CurrentFile)
End Sub

Sub HandleDCCSend(MessageText As String)
	' Gestisce i comandi DCC SEND
	Dim DCCParts() As String
	DCCParts = Regex.Split(" ", MessageText)
	
	If DCCParts.Length >= 4 Then
		Dim FileName As String
		Dim FileSize As String
		Dim Token As String
		
		FileName = DCCParts(2)
		FileSize = DCCParts(3)
		Token = DCCParts(4)
		
		' Controlla se il file è permesso
		If IsFileAllowed(FileName) = False Then
			WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :DCC file type not allowed: " & FileName)
			Return
		End If
		
		' Controlla dimensione file
		If FileSize > DCCMaxFileSize Then
			WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :DCC file too large: " & FileName & " (" & FileSize & " bytes)")
			Return
		End If
		
		' Gestisce in base alla modalità DCC
		If DCCMode = "SAVE" Then
			' Modalità SAVE: salva sul server
			HandleDCCSave(FileName, FileSize, Token)
		Else If DCCMode = "FORWARD" Then
			' Modalità FORWARD: inoltra al client
			HandleDCCForward(FileName, FileSize, Token)
		End If
	End If
End Sub

Sub HandleDCCSave(FileName As String, FileSize As String, Token As String)
	' Gestisce DCC SEND in modalità SAVE (salva sul server)
	Dim DCCResponse As String
	DCCResponse = "PRIVMSG " & Nickconnessione & " :\x01DCC SEND " & FileName & " " & FileSize & " " & Token & "\x01"
	
	' Invia la risposta al client
	WriteSocket(DCCResponse)
	
	' Aggiungi alla lista dei file DCC
	Dim DCCFile As Map
	DCCFile.Initialize
	DCCFile.Put("FileName", FileName)
	DCCFile.Put("FileSize", FileSize)
	DCCFile.Put("Token", Token)
	DCCFile.Put("Status", "Pending")
	DCCFile.Put("Mode", "SAVE")
	DCCFiles.Add(DCCFile)
	
	WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :DCC SEND offer received for: " & FileName & " (SAVE mode)")
End Sub

Sub HandleDCCForward(FileName As String, FileSize As String, Token As String)
	' Gestisce DCC SEND in modalità FORWARD (inoltra al client)
	Dim DCCResponse As String
	DCCResponse = "PRIVMSG " & Nickconnessione & " :\x01DCC SEND " & FileName & " " & FileSize & " " & Token & "\x01"
	
	' Invia la risposta al client
	WriteSocket(DCCResponse)
	
	' Aggiungi alla lista dei file DCC
	Dim DCCFile As Map
	DCCFile.Initialize
	DCCFile.Put("FileName", FileName)
	DCCFile.Put("FileSize", FileSize)
	DCCFile.Put("Token", Token)
	DCCFile.Put("Status", "Forwarding")
	DCCFile.Put("Mode", "FORWARD")
	DCCFiles.Add(DCCFile)
	
	WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :DCC SEND offer forwarded to client: " & FileName & " (FORWARD mode)")
End Sub

Sub IsFileAllowed(FileName As String) As Boolean
	' Controlla se il tipo di file è permesso
	Dim FileExt As String
	Dim DotPos As Int
	
	DotPos = FileName.LastIndexOf(".")
	If DotPos > 0 Then
		FileExt = FileName.SubString(DotPos + 1).ToLowerCase
		
		For i = 0 To DCCAllowedTypes.Size - 1
			If DCCAllowedTypes.Get(i) = FileExt Then
				Return True
			End If
		Next
	End If
	
	Return False
End Sub

Sub HandleDCCChat(MessageText As String)
	' Gestisce i comandi DCC CHAT
	Dim DCCParts() As String
	DCCParts = Regex.Split(" ", MessageText)
	
	If DCCParts.Length >= 3 Then
		Dim ChatPort As String
		ChatPort = DCCParts(2)
		
		' Crea la risposta DCC CHAT
		Dim DCCResponse As String
		DCCResponse = "PRIVMSG " & Nickconnessione & " :\x01DCC CHAT chat " & MyIP & " " & ChatPort & "\x01"
		
		' Invia la risposta al client
		WriteSocket(DCCResponse)
		
		WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :DCC CHAT offer received on port: " & ChatPort)
	End If
End Sub

Sub HandleDCCResume(MessageText As String)
	' Gestisce i comandi DCC RESUME
	Dim DCCParts() As String
	DCCParts = Regex.Split(" ", MessageText)
	
	If DCCParts.Length >= 3 Then
		Dim FileName As String
		Dim Position As String
		
		FileName = DCCParts(2)
		Position = DCCParts(3)
		
		' Crea la risposta DCC RESUME
		Dim DCCResponse As String
		DCCResponse = "PRIVMSG " & Nickconnessione & " :\x01DCC RESUME " & FileName & " " & Position & "\x01"
		
		' Invia la risposta al client
		WriteSocket(DCCResponse)
		
		WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :DCC RESUME for file: " & FileName & " at position: " & Position)
	End If
End Sub

Sub HandleDCCAccept(MessageText As String)
	' Gestisce i comandi DCC ACCEPT
	Dim DCCParts() As String
	DCCParts = Regex.Split(" ", MessageText)
	
	If DCCParts.Length >= 3 Then
		Dim FileName As String
		Dim Position As String
		
		FileName = DCCParts(2)
		Position = DCCParts(3)
		
		' Crea la risposta DCC ACCEPT
		Dim DCCResponse As String
	DCCResponse = "PRIVMSG " & Nickconnessione & " :\x01DCC ACCEPT " & FileName & " " & Position & "\x01"
		
		' Invia la risposta al client
		WriteSocket(DCCResponse)
		
		WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :DCC ACCEPT for file: " & FileName & " at position: " & Position)
	End If
End Sub

Sub ProcessDCCMessage(MessageText As String)
	' Processa i messaggi DCC e determina il tipo
	If MessageText.Contains("DCC SEND") Then
		HandleDCCSend(MessageText)
	Else If MessageText.Contains("DCC CHAT") Then
		HandleDCCChat(MessageText)
	Else If MessageText.Contains("DCC RESUME") Then
		HandleDCCResume(MessageText)
	Else If MessageText.Contains("DCC ACCEPT") Then
		HandleDCCAccept(MessageText)
	End If
End Sub

Sub GetDCCStatus() As String
	' Restituisce lo stato delle connessioni DCC
	Dim Status As String
	Status = "DCC Status:" & Chr(13)
	Status = Status & "Active Connections: " & DCCConnections.Size & Chr(13)
	Status = Status & "Pending Files: " & DCCFiles.Size & Chr(13)
	Status = Status & "DCC Server Port: " & DCCPort & Chr(13)
	Status = Status & "DCC Server IP: " & MyIP & Chr(13)
	
	Return Status
End Sub

Sub CleanupDCCConnections()
	' Pulisce le connessioni DCC chiuse
	For i = DCCConnections.Size - 1 To 0 Step -1
		Dim DCCInfo As Map
		DCCInfo = DCCConnections.Get(i)
		
		Dim Socket As Socket
		Socket = DCCInfo.Get("Socket")
		
		If Socket.Connected = False Then
			DCCConnections.RemoveAt(i)
		End If
	Next
End Sub

Sub JoinDCCAllowedTypes() As String
	' Restituisce la lista dei tipi di file permessi come stringa
	Dim Result As String
	Result = ""
	
	For i = 0 To DCCAllowedTypes.Size - 1
		If i = 0 Then
			Result = DCCAllowedTypes.Get(i)
		Else
			Result = Result & ", " & DCCAllowedTypes.Get(i)
		End If
	Next
	
	Return Result
End Sub

Sub GetDCCConfig() As String
	' Restituisce la configurazione DCC come stringa
	Try
		Dim Config As String
		Config = "DCC Mode: " & DCCMode & Chr(10)
		Config = Config & "Auto Accept: " & DCCAutoAccept & Chr(10)
		Config = Config & "Max File Size: " & DCCMaxFileSize & " bytes" & Chr(10)
		Config = Config & "Allowed Types: " & JoinDCCAllowedTypes() & Chr(10)
		Config = Config & "DCC Port: " & DCCPort
		
		Return Config
		
	Catch Error As Exception
		LogError("GET_DCC_CONFIG_ERROR", Error.Message, "GetDCCConfig")
		Return "Error retrieving DCC configuration"
	End Try
End Sub

' ======================
' ERROR HANDLING FUNCTIONS
' ======================

Sub LogError(ErrorType As String, Message As String, Context As String)
	Try
		Dim LogEntry As String
		LogEntry = DateTime.Now & " [ERROR] [" & ErrorType & "] " & Message & " - Context: " & Context
		
		' Salva su file
		Dim Writer As TextWriter
		Writer.Initialize(File.OpenOutput(File.DirInternal, LogFile, True))
		Writer.WriteLine(LogEntry)
		Writer.Close
		
		' Log su console
		Log(LogEntry)
		
		' Salva in buffer per fallback
		ErrorBuffer.Add(LogEntry)
		
		' Limita dimensione buffer
		If ErrorBuffer.Size > 1000 Then
			ErrorBuffer.RemoveAt(0)
		End If
		
	Catch Error As Exception
		' Fallback: salva in memoria
		If ErrorBuffer.IsInitialized = False Then
			ErrorBuffer.Initialize
		End If
		ErrorBuffer.Add(DateTime.Now & " [ERROR] [" & ErrorType & "] " & Message & " - Context: " & Context)
	End Try
End Sub

Sub LogInfo(Message As String, Context As String)
	Try
		Dim LogEntry As String
		LogEntry = DateTime.Now & " [INFO] " & Message & " - Context: " & Context
		
		' Salva su file
		Dim Writer As TextWriter
		Writer.Initialize(File.OpenOutput(File.DirInternal, "psybnc_info.log", True))
		Writer.WriteLine(LogEntry)
		Writer.Close
		
		' Log su console
		Log(LogEntry)
		
	Catch Error As Exception
		LogError("LOG_INFO_ERROR", Error.Message, "LogInfo")
	End Try
End Sub

Sub HandleConnectionError()
	Try
		' Log errore
		LogError("CONNECTION_ERROR", "Connection lost", "HandleConnectionError")
		
		' Notifica utente
		If IRClient = True Then
			WriteSocketSafe(":-psyBNC PRIVMSG psyBNC Connection lost. Attempting recovery...")
		End If
		
		' Salva stato corrente
		SaveCurrentState()
		
		' Incrementa contatore tentativi
		ConnectionRetryCount = ConnectionRetryCount + 1
		
		' Controlla se superato limite tentativi
		If ConnectionRetryCount > MaxRetryAttempts Then
			LogError("MAX_RETRY_EXCEEDED", "Maximum retry attempts exceeded", "HandleConnectionError")
			WriteSocketSafe(":-psyBNC PRIVMSG psyBNC Maximum retry attempts exceeded. Manual reconnection required.")
			Return
		End If
		
		' Tentativo riconnessione
		TimerServer.Enabled = False
		TimerServer.Interval = 5000 * ConnectionRetryCount ' Incrementa intervallo
		TimerServer.Enabled = True
		
		LogInfo("Retry attempt " & ConnectionRetryCount & " of " & MaxRetryAttempts, "HandleConnectionError")
		
	Catch Error As Exception
		LogError("RECOVERY_ERROR", Error.Message, "HandleConnectionError")
	End Try
End Sub

Sub SaveCurrentState()
	Try
		Dim StateData As Map
		StateData.Initialize
		
		' Salva stato importante
		StateData.Put("Nickconnessione", Nickconnessione)
		StateData.Put("joinchannel", joinchannel)
		StateData.Put("Topichannel", Topichannel)
		StateData.Put("MessageQuery", MessageQuery)
		StateData.Put("DCCMode", DCCMode)
		StateData.Put("DCCConfig", GetDCCConfig())
		StateData.Put("DCCChatConnections", DCCChatConnections)
		StateData.Put("DCCSendQueue", DCCSendQueue)
		StateData.Put("DCCActiveTransfers", DCCActiveTransfers)
		StateData.Put("DCCAutoGetUsers", DCCAutoGetUsers)
		StateData.Put("DCCAutoGetNetworks", DCCAutoGetNetworks)
		StateData.Put("MyIP", MyIP)
		StateData.Put("SSLEnabled", SSLEnabled)
		StateData.Put("SSLPort", SSLPort)
		
		' Salva dati utenti
		StateData.Put("UsersList", UsersList)
		StateData.Put("UserPasswords", UserPasswords)
		StateData.Put("UserRealNames", UserRealNames)
		StateData.Put("UserAdmins", UserAdmins)
		StateData.Put("UserOnline", UserOnline)
		StateData.Put("UserLastSeen", UserLastSeen)
		
		' Salva su file
		Dim Writer As TextWriter
		Writer.Initialize(File.OpenOutput(File.DirInternal, "psybnc_state_backup.txt", False))
		Writer.Write(StateData.ToString)
		Writer.Close
		
		LogInfo("State saved successfully", "SaveCurrentState")
		
	Catch Error As Exception
		LogError("SAVE_STATE_ERROR", Error.Message, "SaveCurrentState")
	End Try
End Sub

Sub LoadSavedState()
	Try
		If File.Exists(File.DirInternal, "psybnc_state_backup.txt") Then
			Dim Reader As TextReader
			Reader.Initialize(File.OpenInput(File.DirInternal, "psybnc_state_backup.txt"))
			Dim StateData As String
			StateData = Reader.ReadAll
			Reader.Close
			
			' Parse e carica stato
			ParseStateData(StateData)
			LogInfo("State loaded successfully", "LoadSavedState")
		End If
	End Try
End Sub

Sub ParseStateData(StateData As String)
	Try
		' Parsing semplice dello stato salvato
		' Implementazione base - può essere migliorata
		If StateData.Contains("Nickconnessione") Then
			Dim NickStart As Int = StateData.IndexOf("Nickconnessione=") + 16
			Dim NickEnd As Int = StateData.IndexOf(",", NickStart)
			If NickEnd = -1 Then NickEnd = StateData.Length
			Nickconnessione = StateData.SubString2(NickStart, NickEnd)
		End If
		
		' Altri campi possono essere aggiunti qui
		
	End Try
End Sub

' ======================
' SSL SUPPORT FUNCTIONS
' ======================

Sub ConnectToIRCServerSSL(ServerHost As String, ServerPort As Int) As Boolean
	Try
		LogInfo("Attempting SSL connection to " & ServerHost & ":" & serverPort, "ConnectToIRCServerSSL")
		
		' Controlla se SSL è supportato
		If SSLEnabled = False Then
			LogError("SSL_DISABLED", "SSL is disabled", "ConnectToIRCServerSSL")
			Return False
		End If
		
		' Chiudi connessione esistente se presente
		If socket_invio_dati.Connected = True Then
			socket_invio_dati.Close
		End If
		
		' Inizializza socket SSL
		socket_invio_dati.Initialize("socket_invio_dati")
		
		' Connessione SSL
		socket_invio_dati.Connect(ServerHost, serverPort)
		
		' Attendi connessione
		Sleep(1000)
		
		If socket_invio_dati.Connected = True Then
			LogInfo("SSL connection established to " & ServerHost & ":" & serverPort, "ConnectToIRCServerSSL")
			
			' Invia comandi IRC iniziali
			SendIRCInitialCommands()
			
			Return True
		Else
			LogError("SSL_CONNECTION_FAILED", "Failed to connect to " & ServerHost & ":" & ServerPort, "ConnectToIRCServerSSL")
			Return False
		End If
		
	Catch Error As Exception
		LogError("SSL_CONNECTION_ERROR", Error.Message, "ConnectToIRCServerSSL")
		Return False
	End Try
End Sub

Sub SendIRCInitialCommands()
	Try
		' Invia comandi IRC standard
		WriteSocketIrcSafe("USER " & Nickconnessione & " 0 * :psyBNC Android")
		WriteSocketIrcSafe("NICK " & Nickconnessione)
		
		LogInfo("IRC initial commands sent", "SendIRCInitialCommands")
		
	Catch Error As Exception
		LogError("IRC_COMMANDS_ERROR", Error.Message, "SendIRCInitialCommands")
	End Try
End Sub

Sub EnableSSL(Enable As Boolean)
	Try
		SSLEnabled = Enable
		
		If Enable Then
			LogInfo("SSL enabled", "EnableSSL")
		Else
			LogInfo("SSL disabled", "EnableSSL")
		End If
		
	Catch Error As Exception
		LogError("SSL_ENABLE_ERROR", Error.Message, "EnableSSL")
	End Try
End Sub

Sub SetSSLPort(Port As Int)
	Try
		SSLPort = Port
		LogInfo("SSL port set to " & Port, "SetSSLPort")
	End Try
End Sub

' ======================
' ROBUST WRITE FUNCTIONS
' ======================

Sub WriteSocketSafe(Read As String) As Boolean
	Try
		' Validazione input
		If Read.Length = 0 Then
			LogError("WRITE_EMPTY", "Attempted to write empty message", "WriteSocketSafe")
			Return False
		End If
		
		' Controllo stato connessione
		If socket_ricezione_dati.Connected = False Then
			LogError("SOCKET_DISCONNECTED", "Socket not connected", "WriteSocketSafe")
			Return False
		End If
		
		' Controllo autenticazione
		If joinpasswd = False Then
			LogError("NOT_AUTHENTICATED", "User not authenticated", "WriteSocketSafe")
			Return False
		End If
		
		' Scrittura sicura
		Dim tr As TextReader
		Dim tw As TextWriter
		tr.Initialize(socket_ricezione_dati.InputStream)
		tw.Initialize(socket_ricezione_dati.OutputStream)
		tw.WriteLine(Read)
		tw.Flush
		
		LogInfo("Message sent to client: " & Read, "WriteSocketSafe")
		Return True
		
	Catch Error As Exception
		LogError("WRITE_ERROR", Error.Message, "WriteSocketSafe")
		
		' Recovery automatico
		HandleConnectionError()
		Return False
	End Try
End Sub

Sub WriteSocketIrcSafe(Read As String) As Boolean
	Try
		' Validazione input
		If Read.Length = 0 Then
			LogError("WRITE_IRC_EMPTY", "Attempted to write empty IRC message", "WriteSocketIrcSafe")
			Return False
		End If
		
		' Controllo stato connessione
		If socket_invio_dati.Connected = False Then
			LogError("IRC_SOCKET_DISCONNECTED", "IRC socket not connected", "WriteSocketIrcSafe")
			Return False
		End If
		
		' Scrittura sicura
		Dim tr As TextReader
		Dim tw As TextWriter
		tr.Initialize(socket_invio_dati.InputStream)
		tw.Initialize(socket_invio_dati.OutputStream)
		tw.WriteLine(Read)
		tw.Flush
		
		LogInfo("Message sent to IRC server: " & Read, "WriteSocketIrcSafe")
		Return True
		
	Catch Error As Exception
		LogError("WRITE_IRC_ERROR", Error.Message, "WriteSocketIrcSafe")
		
		' Recovery automatico
		HandleConnectionError()
		Return False
	End Try
End Sub

' ======================
' HEARTBEAT SYSTEM
' ======================

Sub StartHeartbeat()
	Try
		If HeartbeatTimer.IsInitialized = False Then
			HeartbeatTimer.Initialize("HeartbeatTimer", 30000) ' 30 secondi
		End If
		HeartbeatTimer.Enabled = True
		LogInfo("Heartbeat system started", "StartHeartbeat")
	End Try
End Sub

Sub HeartbeatTimer_Tick
	Try
		' Controllo connessione client
		If socket_ricezione_dati.Connected = False Then
			LogError("HEARTBEAT_CLIENT", "Client connection lost", "HeartbeatTimer_Tick")
			HandleClientDisconnection()
			Return
		End If
		
		' Controllo connessione server IRC
		If socket_invio_dati.Connected = False Then
			LogError("HEARTBEAT_SERVER", "IRC server connection lost", "HeartbeatTimer_Tick")
			HandleServerDisconnection()
			Return
		End If
		
		' Ping al server IRC
		WriteSocketIrcSafe("PING :HEARTBEAT_" & DateTime.Now)
		
		LogInfo("Heartbeat check completed", "HeartbeatTimer_Tick")
		
	Catch Error As Exception
		LogError("HEARTBEAT_ERROR", Error.Message, "HeartbeatTimer_Tick")
	End Try
End Sub

Sub HandleClientDisconnection()
	Try
		LogInfo("Client disconnected", "HandleClientDisconnection")
		
		' Salva stato
		SaveCurrentState()
		
		' Notifica server IRC se connesso
		If socket_invio_dati.Connected = True Then
			WriteSocketIrcSafe("QUIT :Client disconnected")
		End If
		
	End Try
End Sub

Sub HandleServerDisconnection()
	Try
		LogInfo("IRC server disconnected", "HandleServerDisconnection")
		
		' Salva stato
		SaveCurrentState()
		
		' Notifica client se connesso
		If socket_ricezione_dati.Connected = True Then
			WriteSocketSafe(":-psyBNC PRIVMSG psyBNC IRC server disconnected. Attempting reconnection...")
		End If
		
		' Tentativo riconnessione
		HandleConnectionError()
		
	End Try
End Sub

' ======================
' USER MANAGEMENT FUNCTIONS
' ======================

Sub CreateDefaultAdmin()
	Try
		' Crea utente admin di default
		Dim AdminUser As String
		AdminUser = "admin"
		
		' Aggiungi alla lista utenti
		If UsersList.IndexOf(AdminUser) = -1 Then
			UsersList.Add(AdminUser)
		End If
		
		' Imposta password di default
		UserPasswords.Put(AdminUser, "admin123")
		
		' Imposta real name
		UserRealNames.Put(AdminUser, "psyBNC Android Administrator")
		
		' Aggiungi alla lista admin
		If UserAdmins.IndexOf(AdminUser) = -1 Then
			UserAdmins.Add(AdminUser)
		End If
		
		LogInfo("Default admin user created: " & AdminUser, "CreateDefaultAdmin")
		
	Catch Error As Exception
		LogError("CREATE_ADMIN_ERROR", Error.Message, "CreateDefaultAdmin")
	End Try
End Sub

Sub AddUser(Login As String, RealName As String) As Boolean
	Try
		' Controlla se utente esiste già
		If UsersList.IndexOf(Login) <> -1 Then
			LogError("USER_EXISTS", "User already exists: " & Login, "AddUser")
			Return False
		End If
		
		' Controlla limite utenti (max 99 come originale)
		If UsersList.Size >= 99 Then
			LogError("USER_LIMIT_EXCEEDED", "Maximum users limit reached (99)", "AddUser")
			Return False
		End If
		
		' Aggiungi utente
		UsersList.Add(Login)
		UserPasswords.Put(Login, "password123") ' Password di default
		UserRealNames.Put(Login, RealName)
		UserLastSeen.Put(Login, DateTime.Now)
		UserLoginAttempts.Put(Login, 0)
		
		LogInfo("User added: " & Login & " (" & RealName & ")", "AddUser")
		Return True
		
	Catch Error As Exception
		LogError("ADD_USER_ERROR", Error.Message, "AddUser")
		Return False
	End Try
End Sub

Sub DeleteUser(Login As String) As Boolean
	Try
		' Controlla se utente esiste
		If UsersList.IndexOf(Login) = -1 Then
			LogError("USER_NOT_FOUND", "User not found: " & Login, "DeleteUser")
			Return False
		End If
		
		' Non permettere di cancellare l'ultimo admin
		If UserAdmins.IndexOf(Login) <> -1 And UserAdmins.Size = 1 Then
			LogError("LAST_ADMIN", "Cannot delete last admin user", "DeleteUser")
			Return False
		End If
		
		' Rimuovi utente
		UsersList.RemoveAt(UsersList.IndexOf(Login))
		UserPasswords.Remove(Login)
		UserRealNames.Remove(Login)
		UserOnline.Remove(Login)
		UserLastSeen.Remove(Login)
		UserLoginAttempts.Remove(Login)
		
		' Rimuovi da admin se presente
		If UserAdmins.IndexOf(Login) <> -1 Then
			UserAdmins.RemoveAt(UserAdmins.IndexOf(Login))
		End If
		
		LogInfo("User deleted: " & Login, "DeleteUser")
		Return True
		
	Catch Error As Exception
		LogError("DELETE_USER_ERROR", Error.Message, "DeleteUser")
		Return False
	End Try
End Sub

Sub ChangePassword(Login As String, NewPassword As String) As Boolean
	Try
		' Controlla se utente esiste
		If UsersList.IndexOf(Login) = -1 Then
			LogError("USER_NOT_FOUND", "User not found: " & Login, "ChangePassword")
			Return False
		End If
		
		' Cambia password
		UserPasswords.Put(Login, NewPassword)
		
		' Reset tentativi login
		UserLoginAttempts.Put(Login, 0)
		
		LogInfo("Password changed for user: " & Login, "ChangePassword")
		Return True
		
	Catch Error As Exception
		LogError("CHANGE_PASSWORD_ERROR", Error.Message, "ChangePassword")
		Return False
	End Try
End Sub

Sub MakeAdmin(Login As String) As Boolean
	Try
		' Controlla se utente esiste
		If UsersList.IndexOf(Login) = -1 Then
			LogError("USER_NOT_FOUND", "User not found: " & Login, "MakeAdmin")
			Return False
		End If
		
		' Aggiungi alla lista admin
		If UserAdmins.IndexOf(Login) = -1 Then
			UserAdmins.Add(Login)
			LogInfo("User promoted to admin: " & Login, "MakeAdmin")
			Return True
		Else
			LogError("ALREADY_ADMIN", "User is already admin: " & Login, "MakeAdmin")
			Return False
		End If
		
	Catch Error As Exception
		LogError("MAKE_ADMIN_ERROR", Error.Message, "MakeAdmin")
		Return False
	End Try
End Sub

Sub RemoveAdmin(Login As String) As Boolean
	Try
		' Controlla se utente esiste
		If UsersList.IndexOf(Login) = -1 Then
			LogError("USER_NOT_FOUND", "User not found: " & Login, "RemoveAdmin")
			Return False
		End If
		
		' Non permettere di rimuovere l'ultimo admin
		If UserAdmins.IndexOf(Login) <> -1 And UserAdmins.Size = 1 Then
			LogError("LAST_ADMIN", "Cannot remove last admin user", "RemoveAdmin")
			Return False
		End If
		
		' Rimuovi da admin
		If UserAdmins.IndexOf(Login) <> -1 Then
			UserAdmins.RemoveAt(UserAdmins.IndexOf(Login))
			LogInfo("Admin rights removed from user: " & Login, "RemoveAdmin")
			Return True
		Else
			LogError("NOT_ADMIN", "User is not admin: " & Login, "RemoveAdmin")
			Return False
		End If
		
	Catch Error As Exception
		LogError("REMOVE_ADMIN_ERROR", Error.Message, "RemoveAdmin")
		Return False
	End Try
End Sub

Sub IsUserAdmin(Login As String) As Boolean
	Try
		Return UserAdmins.IndexOf(Login) <> -1
	Catch Error As Exception
		LogError("IS_ADMIN_ERROR", Error.Message, "IsUserAdmin")
		Return False
	End Try
End Sub

Sub IsUserOnline(Login As String) As Boolean
	Try
		Return UserOnline.ContainsKey(Login) And UserOnline.Get(Login) = True
	Catch Error As Exception
		LogError("IS_ONLINE_ERROR", Error.Message, "IsUserOnline")
		Return False
	End Try
End Sub

Sub SetUserOnline(Login As String, Online As Boolean)
	Try
		If Online Then
			UserOnline.Put(Login, True)
			UserLastSeen.Put(Login, DateTime.Now)
		Else
			UserOnline.Put(Login, False)
		End If
		
		Dim StatusText As String
		If Online Then
			StatusText = "ONLINE"
		Else
			StatusText = "OFFLINE"
		End If
		LogInfo("User " & Login & " status: " & StatusText, "SetUserOnline")
		
	Catch Error As Exception
		LogError("SET_ONLINE_ERROR", Error.Message, "SetUserOnline")
	End Try
End Sub

Sub GetUserList() As String
	Try
		Dim Result As String
		Result = ""
		
		For i = 0 To UsersList.Size - 1
			Dim User As String
			User = UsersList.Get(i)
			
			Dim Status As String
			If IsUserOnline(User) Then
				Status = "*" & User
			Else
				Status = User
			End If
			
			If IsUserAdmin(User) Then
				Status = Status & " (Admin)"
			End If
			
			If i = 0 Then
				Result = Status
			Else
				Result = Result & ", " & Status
			End If
		Next
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_USER_LIST_ERROR", Error.Message, "GetUserList")
		Return "Error retrieving user list"
	End Try
End Sub

Sub GetUserInfo(Login As String) As String
	Try
		If UsersList.IndexOf(Login) = -1 Then
			Return "User not found: " & Login
		End If
		
		Dim Info As String
		Info = "User: " & Login & Chr(10)
		Info = Info & "Real Name: " & UserRealNames.Get(Login) & Chr(10)
		Dim StatusText As String
		If IsUserOnline(Login) Then
			StatusText = "ONLINE"
		Else
			StatusText = "OFFLINE"
		End If
		Info = Info & "Status: " & StatusText & Chr(10)
		
		Dim AdminText As String
		If IsUserAdmin(Login) Then
			AdminText = "YES"
		Else
			AdminText = "NO"
		End If
		Info = Info & "Admin: " & AdminText & Chr(10)
		Info = Info & "Last Seen: " & UserLastSeen.Get(Login) & Chr(10)
		Info = Info & "Login Attempts: " & UserLoginAttempts.Get(Login)
		
		Return Info
		
	Catch Error As Exception
		LogError("GET_USER_INFO_ERROR", Error.Message, "GetUserInfo")
		Return "Error retrieving user info"
	End Try
End Sub

Sub KillUser(Login As String) As Boolean
	Try
		' Controlla se utente esiste
		If UsersList.IndexOf(Login) = -1 Then
			LogError("USER_NOT_FOUND", "User not found: " & Login, "KillUser")
			Return False
		End If
		
		' Disconnetti utente
		SetUserOnline(Login, False)
		
		' Notifica utente se online
		If IsUserOnline(Login) Then
			WriteSocketSafe(":-psyBNC PRIVMSG " & Login & " Connection terminated by administrator")
		End If
		
		LogInfo("User killed: " & Login, "KillUser")
		Return True
		
	Catch Error As Exception
		LogError("KILL_USER_ERROR", Error.Message, "KillUser")
		Return False
	End Try
End Sub

Sub AuthenticateUser(Login As String, Password As String) As Boolean
	Try
		' Controlla se utente esiste
		If UsersList.IndexOf(Login) = -1 Then
			LogError("USER_NOT_FOUND", "User not found: " & Login, "AuthenticateUser")
			Return False
		End If
		
		' Controlla tentativi login
		Dim Attempts As Int
		Attempts = UserLoginAttempts.Get(Login)
		
		If Attempts >= MaxLoginAttempts Then
			LogError("MAX_LOGIN_ATTEMPTS", "Maximum login attempts exceeded for user: " & Login, "AuthenticateUser")
			Return False
		End If
		
		' Controlla se utente è bannato
		If IsUserBanned(Login) Then
			LogError("USER_BANNED", "Banned user attempted login: " & Login, "AuthenticateUser")
			Return False
		End If
		
		' Controlla password
		If UserPasswords.Get(Login) = Password Then
			' Login successful
			UserLoginAttempts.Put(Login, 0)
			SetUserOnline(Login, True)
			LogInfo("User authenticated: " & Login, "AuthenticateUser")
			Return True
		Else
			' Login failed
			UserLoginAttempts.Put(Login, Attempts + 1)
			LogError("LOGIN_FAILED", "Login failed for user: " & Login & " (attempt " & (Attempts + 1) & ")", "AuthenticateUser")
			Return False
		End If
		
	Catch Error As Exception
		LogError("AUTHENTICATE_ERROR", Error.Message, "AuthenticateUser")
		Return False
	End Try
End Sub

' ======================
' MULTI-CLIENT FUNCTIONS
' ======================

Sub AddClientConnection(ClientID As String, Socket As Socket, User As String) As Boolean
	Try
		' Aggiungi connessione client
		ClientConnections.Add(ClientID)
		ClientSockets.Put(ClientID, Socket)
		ClientUsers.Put(ClientID, User)
		ClientNetworks.Put(ClientID, "")
		
		' Inizializza canali e messaggi per questo client
		Dim ClientChannelList As List
		ClientChannelList.Initialize
		ClientChannels.Put(ClientID, ClientChannelList)
		
		Dim ClientMessageList As List
		ClientMessageList.Initialize
		ClientMessages.Put(ClientID, ClientMessageList)
		
		LogInfo("Client connection added: " & ClientID & " (User: " & User & ")", "AddClientConnection")
		Return True
		
	Catch Error As Exception
		LogError("ADD_CLIENT_ERROR", Error.Message, "AddClientConnection")
		Return False
	End Try
End Sub

Sub RemoveClientConnection(ClientID As String) As Boolean
	Try
		' Rimuovi connessione client
		If ClientConnections.IndexOf(ClientID) <> -1 Then
			ClientConnections.RemoveAt(ClientConnections.IndexOf(ClientID))
			ClientSockets.Remove(ClientID)
			ClientStreams.Remove(ClientID)
			ClientUsers.Remove(ClientID)
			ClientNetworks.Remove(ClientID)
			ClientChannels.Remove(ClientID)
			ClientMessages.Remove(ClientID)
			
			LogInfo("Client connection removed: " & ClientID, "RemoveClientConnection")
			Return True
		Else
			LogError("CLIENT_NOT_FOUND", "Client not found: " & ClientID, "RemoveClientConnection")
			Return False
		End If
		
	Catch Error As Exception
		LogError("REMOVE_CLIENT_ERROR", Error.Message, "RemoveClientConnection")
		Return False
	End Try
End Sub

Sub GetClientList() As String
	Try
		Dim Result As String
		Result = ""
		
		For i = 0 To ClientConnections.Size - 1
			Dim ClientID As String
			ClientID = ClientConnections.Get(i)
			
			Dim User As String
			User = ClientUsers.Get(ClientID)
			
			Dim Network As String
			Network = ClientNetworks.Get(ClientID)
			
			Dim Status As String
			Status = ClientID & " (" & User & ")"
			If Network.Length > 0 Then
				Status = Status & " [" & Network & "]"
			End If
			
			If i = 0 Then
				Result = Status
			Else
				Result = Result & ", " & Status
			End If
		Next
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_CLIENT_LIST_ERROR", Error.Message, "GetClientList")
		Return "Error retrieving client list"
	End Try
End Sub

Sub WriteToClient(ClientID As String, Message As String) As Boolean
	Try
		' Controlla se client esiste
		If ClientConnections.IndexOf(ClientID) = -1 Then
			LogError("CLIENT_NOT_FOUND", "Client not found: " & ClientID, "WriteToClient")
			Return False
		End If
		
		' Ottieni socket del client
		Dim ClientSocket As Socket
		ClientSocket = ClientSockets.Get(ClientID)
		
		' Controlla se socket è connesso
		If ClientSocket.Connected = False Then
			LogError("CLIENT_DISCONNECTED", "Client disconnected: " & ClientID, "WriteToClient")
			RemoveClientConnection(ClientID)
			Return False
		End If
		
		' Invia messaggio
		Dim tr As TextReader
		Dim tw As TextWriter
		tr.Initialize(ClientSocket.InputStream)
		tw.Initialize(ClientSocket.OutputStream)
		tw.WriteLine(Message)
		tw.Flush
		
		LogInfo("Message sent to client " & ClientID & ": " & Message, "WriteToClient")
		Return True
		
	Catch Error As Exception
		LogError("WRITE_TO_CLIENT_ERROR", Error.Message, "WriteToClient")
		Return False
	End Try
End Sub

Sub BroadcastToAllClients(Message As String)
	Try
		For i = 0 To ClientConnections.Size - 1
			Dim ClientID As String
			ClientID = ClientConnections.Get(i)
			WriteToClient(ClientID, Message)
		Next
		
		LogInfo("Message broadcasted to all clients: " & Message, "BroadcastToAllClients")
		
	Catch Error As Exception
		LogError("BROADCAST_ERROR", Error.Message, "BroadcastToAllClients")
	End Try
End Sub

' ======================
' MULTI-NETWORK FUNCTIONS
' ======================

Sub AddNetwork(NetworkName As String) As Boolean
	Try
		' Controlla se network esiste già
		If NetworksList.IndexOf(NetworkName) <> -1 Then
			LogError("NETWORK_EXISTS", "Network already exists: " & NetworkName, "AddNetwork")
			Return False
		End If
		
		' Aggiungi network
		NetworksList.Add(NetworkName)
		NetworkPrefixes.Put(NetworkName, NetworkName & "'")
		
		' Inizializza strutture per network
		Dim NetworkServerList As List
		NetworkServerList.Initialize
		NetworkServers.Put(NetworkName, NetworkServerList)
		
		Dim NetworkChannelList As List
		NetworkChannelList.Initialize
		NetworkChannels.Put(NetworkName, NetworkChannelList)
		
		Dim NetworkUserList As List
		NetworkUserList.Initialize
		NetworkUsers.Put(NetworkName, NetworkUserList)
		
		LogInfo("Network added: " & NetworkName, "AddNetwork")
		Return True
		
	Catch Error As Exception
		LogError("ADD_NETWORK_ERROR", Error.Message, "AddNetwork")
		Return False
	End Try
End Sub

Sub DeleteNetwork(NetworkName As String) As Boolean
	Try
		' Controlla se network esiste
		If NetworksList.IndexOf(NetworkName) = -1 Then
			LogError("NETWORK_NOT_FOUND", "Network not found: " & NetworkName, "DeleteNetwork")
			Return False
		End If
		
		' Rimuovi network
		NetworksList.RemoveAt(NetworksList.IndexOf(NetworkName))
		NetworkPrefixes.Remove(NetworkName)
		NetworkServers.Remove(NetworkName)
		NetworkChannels.Remove(NetworkName)
		NetworkUsers.Remove(NetworkName)
		
		' Rimuovi connessioni associate
		NetworkConnections.Remove(NetworkName)
		NetworkSockets.Remove(NetworkName)
		NetworkStreams.Remove(NetworkName)
		
		LogInfo("Network deleted: " & NetworkName, "DeleteNetwork")
		Return True
		
	Catch Error As Exception
		LogError("DELETE_NETWORK_ERROR", Error.Message, "DeleteNetwork")
		Return False
	End Try
End Sub

Sub GetNetworkList() As String
	Try
		Dim Result As String
		Result = ""
		
		For i = 0 To NetworksList.Size - 1
			Dim NetworkName As String
			NetworkName = NetworksList.Get(i)
			
			Dim Prefix As String
			Prefix = NetworkPrefixes.Get(NetworkName)
			
			Dim Status As String
			Status = NetworkName & " (" & Prefix & ")"
			
			If i = 0 Then
				Result = Status
			Else
				Result = Result & ", " & Status
			End If
		Next
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_NETWORK_LIST_ERROR", Error.Message, "GetNetworkList")
		Return "Error retrieving network list"
	End Try
End Sub

Sub AddServerToNetwork(NetworkName As String, ServerHost As String, ServerPort As Int) As Boolean
	Try
		' Controlla se network esiste
		If NetworksList.IndexOf(NetworkName) = -1 Then
			LogError("NETWORK_NOT_FOUND", "Network not found: " & NetworkName, "AddServerToNetwork")
			Return False
		End If
		
		' Aggiungi server al network
		Dim NetworkServerList As List
		NetworkServerList = NetworkServers.Get(NetworkName)
		
		Dim ServerInfo As Map
		ServerInfo.Initialize
		ServerInfo.Put("Host", ServerHost)
		ServerInfo.Put("Port", ServerPort)
		ServerInfo.Put("Status", "Disconnected")
		
		NetworkServerList.Add(ServerInfo)
		NetworkServers.Put(NetworkName, NetworkServerList)
		
		LogInfo("Server added to network " & NetworkName & ": " & ServerHost & ":" & ServerPort, "AddServerToNetwork")
		Return True
		
	Catch Error As Exception
		LogError("ADD_SERVER_TO_NETWORK_ERROR", Error.Message, "AddServerToNetwork")
		Return False
	End Try
End Sub

Sub ConnectToNetwork(NetworkName As String) As Boolean
	Try
		' Controlla se network esiste
		If NetworksList.IndexOf(NetworkName) = -1 Then
			LogError("NETWORK_NOT_FOUND", "Network not found: " & NetworkName, "ConnectToNetwork")
			Return False
		End If
		
		' Ottieni server del network
		Dim NetworkServerList As List
		NetworkServerList = NetworkServers.Get(NetworkName)
		
		If NetworkServerList.Size = 0 Then
			LogError("NO_SERVERS", "No servers configured for network: " & NetworkName, "ConnectToNetwork")
			Return False
		End If
		
		' Prova a connettersi al primo server disponibile
		For i = 0 To NetworkServerList.Size - 1
			Dim ServerInfo As Map
			ServerInfo = NetworkServerList.Get(i)
			
			Dim ServerHost As String
			Dim ServerPort As Int
			ServerHost = ServerInfo.Get("Host")
			ServerPort = ServerInfo.Get("Port")
			
			' Tenta connessione
			If ConnectToIRCServer(ServerHost, ServerPort, NetworkName) Then
				LogInfo("Connected to network " & NetworkName & " via " & ServerHost & ":" & ServerPort, "ConnectToNetwork")
				Return True
			End If
		Next
		
		LogError("CONNECTION_FAILED", "Failed to connect to any server in network: " & NetworkName, "ConnectToNetwork")
		Return False
		
	Catch Error As Exception
		LogError("CONNECT_TO_NETWORK_ERROR", Error.Message, "ConnectToNetwork")
		Return False
	End Try
End Sub

Sub ConnectToIRCServer(ServerHost As String, ServerPort As Int, NetworkName As String) As Boolean
	Try
		' Crea socket per server
		Dim ServerSocket As Socket
		ServerSocket.Initialize("ServerSocket_" & NetworkName)
		
		' Tenta connessione
		ServerSocket.Connect(ServerHost, ServerPort)
		
		' Attendi connessione
		Sleep(1000)
		
		If ServerSocket.Connected = True Then
			' Salva connessione
			Dim ServerID As String
			ServerID = NetworkName & "_" & ServerHost & "_" & ServerPort
			
			ServerConnections.Add(ServerID)
			ServerSockets.Put(ServerID, ServerSocket)
			ServerNetworks.Put(ServerID, NetworkName)
			ServerStatus.Put(ServerID, "Connected")
			
			LogInfo("IRC server connected: " & ServerHost & ":" & ServerPort & " (Network: " & NetworkName & ")", "ConnectToIRCServer")
			Return True
		Else
			LogError("IRC_CONNECTION_FAILED", "Failed to connect to " & ServerHost & ":" & ServerPort, "ConnectToIRCServer")
			Return False
		End If
		
	Catch Error As Exception
		LogError("IRC_CONNECTION_ERROR", Error.Message, "ConnectToIRCServer")
		Return False
	End Try
End Sub

' ======================
' VHOST FUNCTIONS
' ======================

Sub SetVHost(Host As String, Port As Int) As Boolean
	Try
		VHostEnabled = True
		VHostAddress = Host
		VHostPort = Port
		
		LogInfo("VHost set to " & Host & ":" & Port, "SetVHost")
		Return True
		
	Catch Error As Exception
		LogError("VHOST_SET_ERROR", Error.Message, "SetVHost")
		Return False
	End Try
End Sub

Sub DisableVHost() As Boolean
	Try
		VHostEnabled = False
		VHostAddress = ""
		VHostPort = 0
		
		LogInfo("VHost disabled", "DisableVHost")
		Return True
		
	Catch Error As Exception
		LogError("VHOST_DISABLE_ERROR", Error.Message, "DisableVHost")
		Return False
	End Try
End Sub

Sub GetVHostStatus() As String
	Try
		Dim Status As String
		Status = "VHost Status:" & Chr(10)
		Status = Status & "Enabled: " & VHostEnabled & Chr(10)
		
		If VHostEnabled Then
			Status = Status & "Address: " & VHostAddress & Chr(10)
			Status = Status & "Port: " & VHostPort & Chr(10)
		End If
		
		Return Status
		
	Catch Error As Exception
		LogError("VHOST_STATUS_ERROR", Error.Message, "GetVHostStatus")
		Return "Error retrieving VHost status"
	End Try
End Sub

' ======================
' PROXY FUNCTIONS
' ======================

Sub SetProxy(ProxyType As String, Host As String, Port As Int, Username As String, Password As String) As Boolean
	Try
		ProxyEnabled = True
		ProxyType = ProxyType
		ProxyHost = Host
		ProxyPort = Port
		ProxyUsername = Username
		ProxyPassword = Password
		
		LogInfo("Proxy set to " & ProxyType & "://" & Host & ":" & Port, "SetProxy")
		Return True
		
	Catch Error As Exception
		LogError("PROXY_SET_ERROR", Error.Message, "SetProxy")
		Return False
	End Try
End Sub

Sub DisableProxy() As Boolean
	Try
		ProxyEnabled = False
		ProxyType = ""
		ProxyHost = ""
		ProxyPort = 0
		ProxyUsername = ""
		ProxyPassword = ""
		
		LogInfo("Proxy disabled", "DisableProxy")
		Return True
		
	Catch Error As Exception
		LogError("PROXY_DISABLE_ERROR", Error.Message, "DisableProxy")
		Return False
	End Try
End Sub

Sub GetProxyStatus() As String
	Try
		Dim Status As String
		Status = "Proxy Status:" & Chr(10)
		Status = Status & "Enabled: " & ProxyEnabled & Chr(10)
		
		If ProxyEnabled Then
			Status = Status & "Type: " & ProxyType & Chr(10)
			Status = Status & "Host: " & ProxyHost & Chr(10)
			Status = Status & "Port: " & ProxyPort & Chr(10)
			If ProxyUsername.Length > 0 Then
				Status = Status & "Username: " & ProxyUsername & Chr(10)
			End If
		End If
		
		Return Status
		
	Catch Error As Exception
		LogError("PROXY_STATUS_ERROR", Error.Message, "GetProxyStatus")
		Return "Error retrieving proxy status"
	End Try
End Sub

' ======================
' BAN MANAGEMENT FUNCTIONS
' ======================

Sub BanUser(User As String, Reason As String, ExpiryDays As Int) As Boolean
	Try
		' Controlla se utente è già bannato
		If BanList.IndexOf(User) <> -1 Then
			LogError("USER_ALREADY_BANNED", "User already banned: " & User, "BanUser")
			Return False
		End If
		
		' Aggiungi ban
		BanList.Add(User)
		BanReasons.Put(User, Reason)
		BanDates.Put(User, DateTime.Now)
		
		If ExpiryDays > 0 Then
			Dim ExpiryDate As Long
			ExpiryDate = DateTime.Now + (ExpiryDays * 24 * 60 * 60 * 1000)
			BanExpiry.Put(User, ExpiryDate)
		End If
		
		LogInfo("User banned: " & User & " (Reason: " & Reason & ")", "BanUser")
		Return True
		
	Catch Error As Exception
		LogError("BAN_USER_ERROR", Error.Message, "BanUser")
		Return False
	End Try
End Sub

Sub UnbanUser(User As String) As Boolean
	Try
		' Controlla se utente è bannato
		If BanList.IndexOf(User) = -1 Then
			LogError("USER_NOT_BANNED", "User not banned: " & User, "UnbanUser")
			Return False
		End If
		
		' Rimuovi ban
		BanList.RemoveAt(BanList.IndexOf(User))
		BanReasons.Remove(User)
		BanDates.Remove(User)
		BanExpiry.Remove(User)
		
		LogInfo("User unbanned: " & User, "UnbanUser")
		Return True
		
	Catch Error As Exception
		LogError("UNBAN_USER_ERROR", Error.Message, "UnbanUser")
		Return False
	End Try
End Sub

Sub IsUserBanned(User As String) As Boolean
	Try
		' Controlla se utente è bannato
		If BanList.IndexOf(User) = -1 Then
			Return False
		End If
		
		' Controlla scadenza ban
		If BanExpiry.ContainsKey(User) Then
			Dim ExpiryDate As Long
			ExpiryDate = BanExpiry.Get(User)
			If DateTime.Now > ExpiryDate Then
				' Ban scaduto, rimuovi
				UnbanUser(User)
				Return False
			End If
		End If
		
		Return True
		
	Catch Error As Exception
		LogError("IS_BANNED_ERROR", Error.Message, "IsUserBanned")
		Return False
	End Try
End Sub

Sub GetBanList() As String
	Try
		Dim Result As String
		Result = "Ban List:" & Chr(10)
		
		If BanList.Size = 0 Then
			Result = Result & "No banned users."
		Else
			For i = 0 To BanList.Size - 1
				Dim User As String
				User = BanList.Get(i)
				
				Dim Reason As String
				Reason = BanReasons.Get(User)
				
				Dim BanDate As Long
				BanDate = BanDates.Get(User)
				
				Result = Result & (i+1) & ". " & User & " - " & Reason & " (Since: " & BanDate & ")" & Chr(10)
			Next
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_BAN_LIST_ERROR", Error.Message, "GetBanList")
		Return "Error retrieving ban list"
	End Try
End Sub

Sub EnableAutoBan(Enable As Boolean)
	Try
		AutoBanEnabled = Enable
		
		If Enable Then
			LogInfo("Auto-ban enabled", "EnableAutoBan")
		Else
			LogInfo("Auto-ban disabled", "EnableAutoBan")
		End If
		
	Catch Error As Exception
		LogError("AUTO_BAN_ERROR", Error.Message, "EnableAutoBan")
	End Try
End Sub

' ======================
' OP MANAGEMENT FUNCTIONS
' ======================

Sub GiveOp(User As String, Channel As String, Level As Int) As Boolean
	Try
		' Controlla se utente è già op
		If OpList.IndexOf(User) <> -1 Then
			LogError("USER_ALREADY_OP", "User already has op: " & User, "GiveOp")
			Return False
		End If
		
		' Aggiungi op
		OpList.Add(User)
		OpChannels.Put(User, Channel)
		OpLevels.Put(User, Level)
		
		LogInfo("User given op: " & User & " on " & Channel & " (Level: " & Level & ")", "GiveOp")
		Return True
		
	Catch Error As Exception
		LogError("GIVE_OP_ERROR", Error.Message, "GiveOp")
		Return False
	End Try
End Sub

Sub RemoveOp(User As String) As Boolean
	Try
		' Controlla se utente è op
		If OpList.IndexOf(User) = -1 Then
			LogError("USER_NOT_OP", "User not op: " & User, "RemoveOp")
			Return False
		End If
		
		' Rimuovi op
		OpList.RemoveAt(OpList.IndexOf(User))
		OpChannels.Remove(User)
		OpLevels.Remove(User)
		
		LogInfo("User op removed: " & User, "RemoveOp")
		Return True
		
	Catch Error As Exception
		LogError("REMOVE_OP_ERROR", Error.Message, "RemoveOp")
		Return False
	End Try
End Sub

Sub IsUserOp(User As String) As Boolean
	Try
		Return OpList.IndexOf(User) <> -1
	Catch Error As Exception
		LogError("IS_OP_ERROR", Error.Message, "IsUserOp")
		Return False
	End Try
End Sub

Sub GetOpList() As String
	Try
		Dim Result As String
		Result = "Op List:" & Chr(10)
		
		If OpList.Size = 0 Then
			Result = Result & "No operators."
		Else
			For i = 0 To OpList.Size - 1
				Dim User As String
				User = OpList.Get(i)
				
				Dim Channel As String
				Channel = OpChannels.Get(User)
				
				Dim Level As Int
				Level = OpLevels.Get(User)
				
				Result = Result & (i+1) & ". " & User & " - " & Channel & " (Level: " & Level & ")" & Chr(10)
			Next
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_OP_LIST_ERROR", Error.Message, "GetOpList")
		Return "Error retrieving op list"
	End Try
End Sub

Sub EnableAutoOp(Enable As Boolean)
	Try
		AutoOpEnabled = Enable
		
		If Enable Then
			LogInfo("Auto-op enabled", "EnableAutoOp")
		Else
			LogInfo("Auto-op disabled", "EnableAutoOp")
		End If
		
	Catch Error As Exception
		LogError("AUTO_OP_ERROR", Error.Message, "EnableAutoOp")
	End Try
End Sub

Sub GetOpLevel(User As String) As Int
	Try
		If OpLevels.ContainsKey(User) Then
			Return OpLevels.Get(User)
		Else
			Return 0
		End If
	Catch Error As Exception
		LogError("GET_OP_LEVEL_ERROR", Error.Message, "GetOpLevel")
		Return 0
	End Try
End Sub

' ======================
' DCC ADVANCED FUNCTIONS
' ======================

Sub StartDCCChat(TargetUser As String) As Boolean
	Try
		' Controlla se chat DCC già attiva
		If DCCChatConnections.IndexOf(TargetUser) <> -1 Then
			LogError("DCC_CHAT_EXISTS", "DCC chat already active with " & TargetUser, "StartDCCChat")
			Return False
		End If
		
		' Aggiungi richiesta chat
		Dim ChatRequest As Map
		ChatRequest.Initialize
		ChatRequest.Put("TargetUser", TargetUser)
		ChatRequest.Put("Status", "Pending")
		ChatRequest.Put("Timestamp", DateTime.Now)
		
		DCCChatRequests.Add(ChatRequest)
		
		' Invia richiesta chat DCC
		Dim DCCChatMessage As String
		DCCChatMessage = "PRIVMSG " & TargetUser & " :\x01DCC CHAT chat " & MyIP & " " & DCCPort & "\x01"
		WriteSocketIrc(DCCChatMessage)
		
		LogInfo("DCC chat request sent to " & TargetUser, "StartDCCChat")
		Return True
		
	Catch Error As Exception
		LogError("DCC_CHAT_ERROR", Error.Message, "StartDCCChat")
		Return False
	End Try
End Sub

Sub AnswerDCCChat(TargetUser As String) As Boolean
	Try
		' Controlla se richiesta chat esiste
		Dim ChatRequestFound As Boolean
		ChatRequestFound = False
		
		For i = 0 To DCCChatRequests.Size - 1
			Dim ChatRequest As Map
			ChatRequest = DCCChatRequests.Get(i)
			
			If ChatRequest.Get("TargetUser") = TargetUser Then
				' Accetta chat
				ChatRequest.Put("Status", "Accepted")
				DCCChatConnections.Add(TargetUser)
				DCCChatRequests.RemoveAt(i)
				ChatRequestFound = True
				Exit
			End If
		Next
		
		If ChatRequestFound = False Then
			LogError("DCC_CHAT_NOT_FOUND", "No DCC chat request from " & TargetUser, "AnswerDCCChat")
			Return False
		End If
		
		' Invia risposta chat DCC
		Dim DCCChatMessage As String
		DCCChatMessage = "PRIVMSG " & TargetUser & " :\x01DCC CHAT chat " & MyIP & " " & DCCPort & "\x01"
		WriteSocketIrc(DCCChatMessage)
		
		LogInfo("DCC chat accepted with " & TargetUser, "AnswerDCCChat")
		Return True
		
	Catch Error As Exception
		LogError("DCC_ANSWER_ERROR", Error.Message, "AnswerDCCChat")
		Return False
	End Try
End Sub

Sub SendDCCFile(FileName As String, TargetUser As String) As Boolean
	Try
		' Controlla se file esiste
		If File.Exists(File.DirInternal, FileName) = False Then
			LogError("DCC_FILE_NOT_FOUND", "File not found: " & FileName, "SendDCCFile")
			Return False
		End If
		
		' Ottieni dimensione file
		Dim FileSize As Long
		FileSize = File.Size(File.DirInternal, FileName)
		
		' Aggiungi alla coda invio
		Dim SendItem As Map
		SendItem.Initialize
		SendItem.Put("FileName", FileName)
		SendItem.Put("TargetUser", TargetUser)
		SendItem.Put("FileSize", FileSize)
		SendItem.Put("Status", "Pending")
		SendItem.Put("Timestamp", DateTime.Now)
		
		DCCSendQueue.Add(SendItem)
		
		' Invia offerta file DCC
		Dim DCCSendMessage As String
		DCCSendMessage = "PRIVMSG " & TargetUser & " :\x01DCC SEND " & FileName & " " & FileSize & " " & DCCPort & "\x01"
		WriteSocketIrc(DCCSendMessage)
		
		LogInfo("DCC file offer sent: " & FileName & " to " & TargetUser, "SendDCCFile")
		Return True
		
	Catch Error As Exception
		LogError("DCC_SEND_ERROR", Error.Message, "SendDCCFile")
		Return False
	End Try
End Sub

Sub AcceptDCCFile(FileName As String, TargetUser As String) As Boolean
	Try
		' Controlla se offerta file esiste
		Dim FileOfferFound As Boolean
		FileOfferFound = False
		
		For i = 0 To DCCFiles.Size - 1
			Dim DCCFile As Map
			DCCFile = DCCFiles.Get(i)
			
			If DCCFile.Get("FileName") = FileName And DCCFile.Get("TargetUser") = TargetUser Then
				' Accetta file
				DCCFile.Put("Status", "Accepted")
				FileOfferFound = True
				Exit
			End If
		Next
		
		If FileOfferFound = False Then
			LogError("DCC_FILE_OFFER_NOT_FOUND", "No DCC file offer for " & FileName & " from " & TargetUser, "AcceptDCCFile")
			Return False
		End If
		
		' Invia accettazione file DCC
		Dim DCCAcceptMessage As String
		DCCAcceptMessage = "PRIVMSG " & TargetUser & " :\x01DCC ACCEPT " & FileName & " " & DCCPort & "\x01"
		WriteSocketIrc(DCCAcceptMessage)
		
		LogInfo("DCC file accepted: " & FileName & " from " & TargetUser, "AcceptDCCFile")
		Return True
		
	Catch Error As Exception
		LogError("DCC_ACCEPT_ERROR", Error.Message, "AcceptDCCFile")
		Return False
	End Try
End Sub

Sub CancelDCCTransfer(TargetUser As String, FileName As String) As Boolean
	Try
		' Cancella trasferimento attivo
		Dim TransferCancelled As Boolean
		TransferCancelled = False
		
		' Cerca in trasferimenti attivi
		For i = 0 To DCCActiveTransfers.Size - 1
			Dim Transfer As Map
			Transfer = DCCActiveTransfers.Get(i)
			
			If Transfer.Get("TargetUser") = TargetUser And (FileName.Length = 0 Or Transfer.Get("FileName") = FileName) Then
				Transfer.Put("Status", "Cancelled")
				DCCActiveTransfers.RemoveAt(i)
				TransferCancelled = True
				Exit
			End If
		Next
		
		' Cerca in coda invio
		If TransferCancelled = False Then
			For i = 0 To DCCSendQueue.Size - 1
				Dim SendItem As Map
				SendItem = DCCSendQueue.Get(i)
				
				If SendItem.Get("TargetUser") = TargetUser And (FileName.Length = 0 Or SendItem.Get("FileName") = FileName) Then
					SendItem.Put("Status", "Cancelled")
					DCCSendQueue.RemoveAt(i)
					TransferCancelled = True
					Exit
				End If
			Next
		End If
		
		If TransferCancelled = False Then
			LogError("DCC_TRANSFER_NOT_FOUND", "No DCC transfer found for " & TargetUser & " " & FileName, "CancelDCCTransfer")
			Return False
		End If
		
		LogInfo("DCC transfer cancelled: " & TargetUser & " " & FileName, "CancelDCCTransfer")
		Return True
		
	Catch Error As Exception
		LogError("DCC_CANCEL_ERROR", Error.Message, "CancelDCCTransfer")
		Return False
	End Try
End Sub

Sub SetAutoGetDCC(User As String, Network As String, Enable As Boolean) As Boolean
	Try
		If Enable Then
			' Abilita auto-get
			If DCCAutoGetUsers.IndexOf(User) = -1 Then
				DCCAutoGetUsers.Add(User)
			End If
			
			If Network.Length > 0 Then
				DCCAutoGetNetworks.Put(User, Network)
			End If
			
			LogInfo("Auto-get DCC enabled for " & User & " on " & Network, "SetAutoGetDCC")
		Else
			' Disabilita auto-get
			If DCCAutoGetUsers.IndexOf(User) <> -1 Then
				DCCAutoGetUsers.RemoveAt(DCCAutoGetUsers.IndexOf(User))
			End If
			
			DCCAutoGetNetworks.Remove(User)
			
			LogInfo("Auto-get DCC disabled for " & User, "SetAutoGetDCC")
		End If
		
		Return True
		
	Catch Error As Exception
		LogError("AUTO_GET_DCC_ERROR", Error.Message, "SetAutoGetDCC")
		Return False
	End Try
End Sub

Sub GetDCCConnectionsList() As String
	Try
		Dim Result As String
		Result = "DCC Connections:" & Chr(10)
		
		' Chat connections
		If DCCChatConnections.Size > 0 Then
			Result = Result & "Chat: " & DCCChatConnections.Size & " active" & Chr(10)
			For i = 0 To DCCChatConnections.Size - 1
				Result = Result & "  - " & DCCChatConnections.Get(i) & Chr(10)
			Next
		End If
		
		' Active transfers
		If DCCActiveTransfers.Size > 0 Then
			Result = Result & "Transfers: " & DCCActiveTransfers.Size & " active" & Chr(10)
			For i = 0 To DCCActiveTransfers.Size - 1
				Dim Transfer As Map
				Transfer = DCCActiveTransfers.Get(i)
				Result = Result & "  - " & Transfer.Get("TargetUser") & " (" & Transfer.Get("FileName") & ")" & Chr(10)
			Next
		End If
		
		' Bot connections
		If DCCBotConnections.Size > 0 Then
			Result = Result & "Bots: " & DCCBotConnections.Size & " connected" & Chr(10)
			For i = 0 To DCCBotConnections.Size - 1
				Result = Result & "  - " & DCCBotConnections.Get(i) & Chr(10)
			Next
		End If
		
		If DCCChatConnections.Size = 0 And DCCActiveTransfers.Size = 0 And DCCBotConnections.Size = 0 Then
			Result = Result & "No active DCC connections."
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_DCC_LIST_ERROR", Error.Message, "GetDCCConnectionsList")
		Return "Error retrieving DCC connections list"
	End Try
End Sub

Sub datisocket_ricezione_NewData (buffer() As Byte)
ClientInvio(BytesToString(buffer, 0, buffer.Length, "UTF8"))
End Sub
Sub datisocket_ricezione_irc_NewData (buffer() As Byte)
WriteSocket(Ricezione_Server((BytesToString(buffer, 0, buffer.Length, "UTF8"))))
End Sub

 