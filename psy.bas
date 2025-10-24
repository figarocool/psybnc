Type=Service
Version=6.5
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
#Region Module Attributes
	#StartAtBoot: False
#End Region

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
		' DCC DEFAULT CONFIG
		' ======================
		DCCMode = "SAVE"              ' Default: salva file sul server
		DCCAutoAccept = False         ' Default: non auto-accetta
		DCCMaxFileSize = 10485760     ' Default: 10MB max
		DCCAllowedTypes.AddAll(Array As String("txt", "jpg", "png", "pdf", "zip", "doc", "docx"))
			
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
	Try
	If socket_ricezione_dati.Connected == True AND joinpasswd == True AND Read.Length > 0 Then
	
			Dim tr As TextReader
			Dim tw As TextWriter
			tr.Initialize( socket_ricezione_dati.InputStream)
			tw.Initialize( socket_ricezione_dati.OutputStream)	
			tw.WriteLine(Read)
			tw.Flush
			Return Read
	End If
	Catch
		socket_ricezione_dati.Close
	End Try
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
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCFILES        - Lists pending DCC files")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCMODE         - Sets DCC mode (SAVE/FORWARD)")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCCONFIG       - Shows DCC configuration")
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
				' Entra e stamba il menu
				Bhelp
				joinpasswd = True
				Return ""
			Else
				'se sta già creato il file e controlla se esiste
				Dim Linefile() As String 
				Dim onlypass() As String 
				Linefile = Regex.split(Chr(13),fileconf)
				onlypass = Regex.split(Chr(32),Linefile(2))
				'controllo se le password sono uguali	
					If onlypass(1) == readpasswd.SubString2(0,readpasswd.Length -1) Then
						joinpasswd = True
						QueryMSG
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

Sub datisocket_ricezione_NewData (buffer() As Byte)
ClientInvio(BytesToString(buffer, 0, buffer.Length, "UTF8"))
End Sub
Sub datisocket_ricezione_irc_NewData (buffer() As Byte)
WriteSocket(Ricezione_Server((BytesToString(buffer, 0, buffer.Length, "UTF8"))))
End Sub

 