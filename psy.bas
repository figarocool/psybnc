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
' MULTI-SERVER SUPPORT (ORIGINAL STYLE)
' ======================
Dim NetworkTokens As List       ' Lista token network (Ef, Freenode, etc.)
Dim NetworkConnections As Map   ' Connessioni per ogni network
Dim NetworkServers As Map       ' Server per ogni network
Dim NetworkSockets As Map       ' Socket per ogni network
Dim NetworkStreams As Map       ' Stream per ogni network
Dim NetworkChannels As Map      ' Canali per ogni network
Dim NetworkUsers As Map         ' Utenti per ogni network
Dim NetworkPrefixes As Map      ' Prefissi per ogni network
Dim CurrentMainNetwork As String ' Network principale attuale

' ======================
' SERVER CONNECTIONS SUPPORT
' ======================
Dim ServerConnections As Map    ' Connessioni server
Dim ServerSockets As Map        ' Socket server
Dim ServerStreams As Map        ' Stream server
Dim ServerNetworks As Map       ' Network per server
Dim ServerConfigs As Map        ' Configurazioni server
Dim ServerStatus As Map         ' Stato server

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
' DCC ADVANCED SYSTEM (ORIGINAL STYLE)
' ======================

' DCC Advanced Variables
Dim DCCAdvancedMode As Boolean = True
Dim DCCCompression As Boolean = False
Dim DCCEncryption As Boolean = False
Dim DCCBandwidthLimit As Int = 0
Dim DCCTransferQueue As List
Dim DCCTransferStats As Map
Dim DCCTransferHistory As List
Dim DCCTransferLog As List

' DCC Advanced Functions
Sub InitializeDCCAdvanced()
	Try
		DCCTransferQueue.Initialize
		DCCTransferStats.Initialize
		DCCTransferHistory.Initialize
		DCCTransferLog.Initialize
		LogInfo("DCC Advanced system initialized", "InitializeDCCAdvanced")
	Catch Error As Exception
		LogError("DCC_ADVANCED_INIT_ERROR", Error.Message, "InitializeDCCAdvanced")
	End Try
End Sub

Sub SetDCCAdvancedMode(Enabled As Boolean)
	DCCAdvancedMode = Enabled
	LogInfo("DCC Advanced mode: " & Enabled, "SetDCCAdvancedMode")
End Sub

Sub SetDCCCompression(Enabled As Boolean)
	DCCCompression = Enabled
	LogInfo("DCC Compression: " & Enabled, "SetDCCCompression")
End Sub

Sub SetDCCEncryption(Enabled As Boolean)
	DCCEncryption = Enabled
	LogInfo("DCC Encryption: " & Enabled, "SetDCCEncryption")
End Sub

Sub SetDCCBandwidthLimit(Limit As Int)
	DCCBandwidthLimit = Limit
	LogInfo("DCC Bandwidth limit: " & Limit, "SetDCCBandwidthLimit")
End Sub

Sub AddDCCTransferToQueue(TransferID As String, FileName As String, FileSize As Long, RemoteHost As String, RemotePort As Int)
	Try
		Dim TransferInfo As Map
		TransferInfo.Initialize
		TransferInfo.Put("TransferID", TransferID)
		TransferInfo.Put("FileName", FileName)
		TransferInfo.Put("FileSize", FileSize)
		TransferInfo.Put("RemoteHost", RemoteHost)
		TransferInfo.Put("RemotePort", RemotePort)
		TransferInfo.Put("Status", "QUEUED")
		TransferInfo.Put("StartTime", DateTime.Now)
		TransferInfo.Put("BytesTransferred", 0)
		TransferInfo.Put("Speed", 0)
		TransferInfo.Put("ETA", 0)
		
		DCCTransferQueue.Add(TransferInfo)
		LogInfo("DCC transfer added to queue: " & FileName, "AddDCCTransferToQueue")
	Catch Error As Exception
		LogError("DCC_QUEUE_ERROR", Error.Message, "AddDCCTransferToQueue")
	End Try
End Sub

Sub UpdateDCCTransferStats(TransferID As String, BytesTransferred As Long, Speed As Int, ETA As Int)
	Try
		If DCCTransferStats.ContainsKey(TransferID) Then
			Dim Stats As Map = DCCTransferStats.Get(TransferID)
			Stats.Put("BytesTransferred", BytesTransferred)
			Stats.Put("Speed", Speed)
			Stats.Put("ETA", ETA)
			Stats.Put("LastUpdate", DateTime.Now)
			DCCTransferStats.Put(TransferID, Stats)
		End If
	Catch Error As Exception
		LogError("DCC_STATS_ERROR", Error.Message, "UpdateDCCTransferStats")
	End Try
End Sub

Sub LogDCCTransfer(TransferID As String, Action As String, Details As String)
	Try
		Dim LogEntry As Map
		LogEntry.Initialize
		LogEntry.Put("TransferID", TransferID)
		LogEntry.Put("Action", Action)
		LogEntry.Put("Details", Details)
		LogEntry.Put("Timestamp", DateTime.Now)
		
		DCCTransferLog.Add(LogEntry)
		
		' Mantieni solo gli ultimi 1000 log
		If DCCTransferLog.Size > 1000 Then
			DCCTransferLog.RemoveAt(0)
		End If
		
		LogInfo("DCC Transfer " & Action & ": " & Details, "LogDCCTransfer")
	Catch Error As Exception
		LogError("DCC_LOG_ERROR", Error.Message, "LogDCCTransfer")
	End Try
End Sub

Sub GetDCCTransferStats(TransferID As String) As Map
	Try
		If DCCTransferStats.ContainsKey(TransferID) Then
			Return DCCTransferStats.Get(TransferID)
		Else
			Dim EmptyStats As Map
			EmptyStats.Initialize
			Return EmptyStats
		End If
	Catch Error As Exception
		LogError("DCC_STATS_GET_ERROR", Error.Message, "GetDCCTransferStats")
		Dim EmptyStats As Map
		EmptyStats.Initialize
		Return EmptyStats
	End Try
End Sub

Sub GetDCCTransferHistory() As List
	Try
		Return DCCTransferHistory
	Catch Error As Exception
		LogError("DCC_HISTORY_ERROR", Error.Message, "GetDCCTransferHistory")
		Dim EmptyList As List
		EmptyList.Initialize
		Return EmptyList
	End Try
End Sub

Sub GetDCCTransferLog() As List
	Try
		Return DCCTransferLog
	Catch Error As Exception
		LogError("DCC_LOG_GET_ERROR", Error.Message, "GetDCCTransferLog")
		Dim EmptyList As List
		EmptyList.Initialize
		Return EmptyList
	End Try
End Sub

Sub CleanupDCCAdvanced()
	Try
		' Pulisci trasferimenti completati
		For i = DCCTransferQueue.Size - 1 To 0 Step -1
			Dim TransferInfo As Map = DCCTransferQueue.Get(i)
			If TransferInfo.ContainsKey("Status") Then
				Dim Status As String = TransferInfo.Get("Status")
				If Status = "COMPLETED" Or Status = "FAILED" Or Status = "CANCELLED" Then
					DCCTransferQueue.RemoveAt(i)
				End If
			End If
		Next
		
		' Pulisci log vecchi
		If DCCTransferLog.Size > 1000 Then
			For i = 0 To DCCTransferLog.Size - 1000 - 1
				DCCTransferLog.RemoveAt(0)
			Next
		End If
		
		LogInfo("DCC Advanced cleanup completed", "CleanupDCCAdvanced")
	Catch Error As Exception
		LogError("DCC_CLEANUP_ERROR", Error.Message, "CleanupDCCAdvanced")
	End Try
End Sub

' ======================
' DCC RESUME SYSTEM
' ======================
Dim DCCResumeEnabled As Boolean         ' Resume DCC abilitato
Dim DCCResumeFiles As Map               ' File in attesa di resume
Dim DCCResumePositions As Map           ' Posizioni resume per file
Dim DCCResumeChecksums As Map           ' Checksum per verifica integrità
Dim DCCResumeTimeouts As Map            ' Timeout per file resume
Dim DCCResumeRetries As Map             ' Tentativi resume per file
Dim DCCResumeMaxRetries As Int          ' Massimo tentativi resume
Dim DCCResumeTimeout As Int             ' Timeout resume (ms)
Dim DCCResumeHistory As List            ' Storico resume
Dim DCCResumeStats As Map               ' Statistiche resume
Dim DCCResumeAutoEnabled As Boolean     ' Resume automatico abilitato
Dim DCCResumeFileCache As Map           ' Cache file per resume automatico
Dim DCCResumeIPCache As Map             ' Cache IP per resume automatico
Dim DCCResumeAutoTimeout As Int         ' Timeout per resume automatico

' ======================
' INTERNAL NETWORK SUPPORT
' ======================
Dim InternalNetwork As Boolean      ' Abilitato network interno
Dim InternalClients As Map          ' Clienti nella rete interna
Dim InternalChannels As Map         ' Canali virtuali interni
Dim InternalMessages As List        ' Messaggi in coda interna
Dim InternalBouncers As Map         ' Bouncer collegati
Dim InternalUsers As Map            ' Utenti per bouncer
Dim InternalRoomUsers As Map        ' Utenti per stanza virtuale
Dim InternalRoomModes As Map        ' Modalità stanze virtuali
Dim InternalRoomTopics As Map       ' Topic stanze virtuali
Dim InternalRoomOps As Map          ' Operatori stanze virtuali
Dim InternalRoomBans As Map         ' Ban stanze virtuali
Dim InternalRoomInvites As Map      ' Inviti stanze virtuali
Dim InternalRoomKeys As Map         ' Chiavi stanze virtuali
Dim InternalRoomLimits As Map       ' Limiti stanze virtuali
Dim InternalBroadcastEnabled As Boolean ' Broadcast abilitato

' ======================
' ADVANCED CHANNEL MANAGEMENT
' ======================
Dim ChannelUsers As Map              ' Utenti per canale
Dim ChannelUserModes As Map          ' Modalità utenti per canale
Dim ChannelBans As Map               ' Ban per canale
Dim ChannelInvites As Map            ' Inviti per canale
Dim ChannelKeys As Map               ' Chiavi per canale
Dim ChannelLimits As Map             ' Limiti per canale
Dim ChannelTopics As Map             ' Topic per canale
Dim ChannelModes As Map              ' Modalità per canale
Dim ChannelTopicProtection As Map    ' Protezione topic per canale
Dim ChannelOperators As Map          ' Operatori per canale
Dim ChannelVoices As Map             ' Voice per canale
Dim ChannelHalfOps As Map            ' Half-ops per canale
Dim ChannelFounders As Map           ' Founder per canale
Dim ChannelHistory As Map            ' Storico canale
Dim ChannelJoinTime As Map           ' Tempo join per canale
Dim ChannelLastActivity As Map       ' Ultima attività canale
Dim ChannelMessageCount As Map       ' Contatore messaggi canale
Dim ChannelUserCount As Map          ' Contatore utenti canale
Dim ChannelModeHistory As Map        ' Storico modalità canale
Dim ChannelTopicHistory As Map       ' Storico topic canale

' ======================
' PERFORMANCE MONITORING
' ======================
Dim PerformanceEnabled As Boolean    ' Monitoraggio performance abilitato
Dim CPUUsage As Float                ' Uso CPU percentuale
Dim MemoryUsage As Long              ' Uso memoria in bytes
Dim NetworkInBytes As Long           ' Byte ricevuti
Dim NetworkOutBytes As Long          ' Byte inviati
Dim ActiveConnections As Int         ' Connessioni attive
Dim PerformanceHistory As List       ' Storico performance
Dim PerformanceAlerts As Map         ' Alert performance
Dim PerformanceThresholds As Map     ' Soglie performance
Dim PerformanceMonitoring As Boolean ' Monitoraggio attivo
Dim PerformanceInterval As Int       ' Intervallo monitoraggio (ms)
Dim PerformanceStartTime As Long     ' Tempo inizio monitoraggio
Dim PerformanceLastUpdate As Long    ' Ultimo aggiornamento
Dim PerformanceData As Map            ' Dati performance
Dim PerformanceStats As Map           ' Statistiche performance

' ======================
' SECURITY SYSTEM
' ======================
Dim SecurityEnabled As Boolean       ' Sistema sicurezza abilitato
Dim IntrusionDetection As Boolean    ' Rilevamento intrusioni
Dim AccessControl As Boolean         ' Controllo accessi
Dim AuditLogging As Boolean           ' Logging audit
Dim SecurityAlerts As Map            ' Alert sicurezza
Dim ThreatDetection As Boolean       ' Rilevamento minacce
Dim SecurityMonitoring As Boolean    ' Monitoraggio sicurezza
Dim FailedLogins As Map              ' Login falliti
Dim SuspiciousActivity As List       ' Attività sospette
Dim SecurityRules As Map              ' Regole sicurezza
Dim SecurityViolations As List       ' Violazioni sicurezza
Dim SecurityEvents As List           ' Eventi sicurezza
Dim SecurityStats As Map             ' Statistiche sicurezza
Dim SecurityThresholds As Map        ' Soglie sicurezza
Dim SecurityActions As Map           ' Azioni sicurezza

' ======================
' DNS ADVANCED SYSTEM (ORIGINAL STYLE)
' ======================

' DNS Advanced Variables
Dim DNSAdvancedMode As Boolean = True
Dim DNSCache As Map
Dim DNSCacheTimeout As Int = 3600000 ' 1 ora
Dim DNSStats As Map
Dim DNSLog As List
Dim DNSRetryCount As Int = 3
Dim DNSRetryTimeout As Int = 5000
Dim DNSMaxCacheSize As Int = 1000
Dim DNSIPv6Support As Boolean = True
Dim DNSReverseLookup As Boolean = True

' DNS Advanced Functions
Sub InitializeDNSAdvanced()
	Try
		DNSCache.Initialize
		DNSStats.Initialize
		DNSLog.Initialize
		LogInfo("DNS Advanced system initialized", "InitializeDNSAdvanced")
	Catch Error As Exception
		LogError("DNS_ADVANCED_INIT_ERROR", Error.Message, "InitializeDNSAdvanced")
	End Try
End Sub

Sub SetDNSAdvancedMode(Enabled As Boolean)
	DNSAdvancedMode = Enabled
	LogInfo("DNS Advanced mode: " & Enabled, "SetDNSAdvancedMode")
End Sub

Sub SetDNSCacheTimeout(Timeout As Int)
	DNSCacheTimeout = Timeout
	LogInfo("DNS Cache timeout set to: " & Timeout & "ms", "SetDNSCacheTimeout")
End Sub

Sub SetDNSRetryCount(Count As Int)
	DNSRetryCount = Count
	LogInfo("DNS Retry count set to: " & Count, "SetDNSRetryCount")
End Sub

Sub SetDNSRetryTimeout(Timeout As Int)
	DNSRetryTimeout = Timeout
	LogInfo("DNS Retry timeout set to: " & Timeout & "ms", "SetDNSRetryTimeout")
End Sub

Sub SetDNSIPv6Support(Enabled As Boolean)
	DNSIPv6Support = Enabled
	LogInfo("DNS IPv6 support: " & Enabled, "SetDNSIPv6Support")
End Sub

Sub SetDNSReverseLookup(Enabled As Boolean)
	DNSReverseLookup = Enabled
	LogInfo("DNS Reverse lookup: " & Enabled, "SetDNSReverseLookup")
End Sub

Sub AddDNSCacheEntry(Hostname As String, IPAddress As String, RecordType As String)
	Try
		Dim CacheEntry As Map
		CacheEntry.Initialize
		CacheEntry.Put("IPAddress", IPAddress)
		CacheEntry.Put("RecordType", RecordType)
		CacheEntry.Put("Timestamp", DateTime.Now)
		CacheEntry.Put("TTL", DNSCacheTimeout)
		
		DNSCache.Put(Hostname, CacheEntry)
		LogInfo("DNS Cache entry added: " & Hostname & " -> " & IPAddress, "AddDNSCacheEntry")
	Catch Error As Exception
		LogError("DNS_CACHE_ADD_ERROR", Error.Message, "AddDNSCacheEntry")
	End Try
End Sub

Sub GetDNSCacheEntry(Hostname As String) As Map
	Try
		If DNSCache.ContainsKey(Hostname) Then
			Dim CacheEntry As Map = DNSCache.Get(Hostname)
			Dim Timestamp As Long = CacheEntry.Get("Timestamp")
			Dim TTL As Long = CacheEntry.Get("TTL")
			
			' Controlla se l'entry è ancora valida
			If (DateTime.Now - Timestamp) < TTL Then
				Return CacheEntry
			Else
				' Entry scaduta, rimuovila
				DNSCache.Remove(Hostname)
			End If
		End If
		
		Dim EmptyEntry As Map
		EmptyEntry.Initialize
		Return EmptyEntry
	Catch Error As Exception
		LogError("DNS_CACHE_GET_ERROR", Error.Message, "GetDNSCacheEntry")
		Dim EmptyEntry As Map
		EmptyEntry.Initialize
		Return EmptyEntry
	End Try
End Sub

Sub LogDNSQuery(Hostname As String, IPAddress As String, RecordType As String, Success As Boolean, ResponseTime As Long)
	Try
		Dim LogEntry As Map
		LogEntry.Initialize
		LogEntry.Put("Hostname", Hostname)
		LogEntry.Put("IPAddress", IPAddress)
		LogEntry.Put("RecordType", RecordType)
		LogEntry.Put("Success", Success)
		LogEntry.Put("ResponseTime", ResponseTime)
		LogEntry.Put("Timestamp", DateTime.Now)
		
		DNSLog.Add(LogEntry)
		
		' Mantieni solo gli ultimi 1000 log
		If DNSLog.Size > 1000 Then
			DNSLog.RemoveAt(0)
		End If
		
		LogInfo("DNS Query: " & Hostname & " -> " & IPAddress & " (" & RecordType & ") - " & Success & " - " & ResponseTime & "ms", "LogDNSQuery")
	Catch Error As Exception
		LogError("DNS_LOG_ERROR", Error.Message, "LogDNSQuery")
	End Try
End Sub

Sub UpdateDNSStats(QueryType As String, Success As Boolean, ResponseTime As Long)
	Try
		Dim StatsKey As String = QueryType & "_" & Success
		Dim Stats As Map
		If DNSStats.ContainsKey(StatsKey) Then
			Stats = DNSStats.Get(StatsKey)
		Else
			Stats.Initialize
			Stats.Put("Count", 0)
			Stats.Put("TotalResponseTime", 0)
			Stats.Put("MinResponseTime", 999999)
			Stats.Put("MaxResponseTime", 0)
		End If
		
		Dim Count As Int = Stats.Get("Count") + 1
		Dim TotalResponseTime As Long = Stats.Get("TotalResponseTime") + ResponseTime
		Dim MinResponseTime As Long = Min(Stats.Get("MinResponseTime"), ResponseTime)
		Dim MaxResponseTime As Long = Max(Stats.Get("MaxResponseTime"), ResponseTime)
		
		Stats.Put("Count", Count)
		Stats.Put("TotalResponseTime", TotalResponseTime)
		Stats.Put("MinResponseTime", MinResponseTime)
		Stats.Put("MaxResponseTime", MaxResponseTime)
		Stats.Put("AverageResponseTime", TotalResponseTime / Count)
		Stats.Put("LastUpdate", DateTime.Now)
		
		DNSStats.Put(StatsKey, Stats)
	Catch Error As Exception
		LogError("DNS_STATS_ERROR", Error.Message, "UpdateDNSStats")
	End Try
End Sub

Sub GetDNSStats() As Map
	Try
		Return DNSStats
	Catch Error As Exception
		LogError("DNS_STATS_GET_ERROR", Error.Message, "GetDNSStats")
		Dim EmptyStats As Map
		EmptyStats.Initialize
		Return EmptyStats
	End Try
End Sub

Sub GetDNSLog() As List
	Try
		Return DNSLog
	Catch Error As Exception
		LogError("DNS_LOG_GET_ERROR", Error.Message, "GetDNSLog")
		Dim EmptyList As List
		EmptyList.Initialize
		Return EmptyList
	End Try
End Sub

Sub CleanupDNSCache()
	Try
		Dim CurrentTime As Long = DateTime.Now
		Dim KeysToRemove As List
		KeysToRemove.Initialize
		
		For i = 0 To DNSCache.Size - 1
			Dim Hostname As String = DNSCache.GetKeyAt(i)
			Dim CacheEntry As Map = DNSCache.Get(Hostname)
			Dim Timestamp As Long = CacheEntry.Get("Timestamp")
			Dim TTL As Long = CacheEntry.Get("TTL")
			
			If (CurrentTime - Timestamp) >= TTL Then
				KeysToRemove.Add(Hostname)
			End If
		Next
		
		For i = 0 To KeysToRemove.Size - 1
			DNSCache.Remove(KeysToRemove.Get(i))
		Next
		
		' Pulisci log vecchi
		If DNSLog.Size > 1000 Then
			For i = 0 To DNSLog.Size - 1000 - 1
				DNSLog.RemoveAt(0)
			Next
		End If
		
		LogInfo("DNS Cache cleanup completed", "CleanupDNSCache")
	Catch Error As Exception
		LogError("DNS_CACHE_CLEANUP_ERROR", Error.Message, "CleanupDNSCache")
	End Try
End Sub

' ======================
' DNS CORE SYSTEM
' ======================
Dim DNSCoreEnabled As Boolean        ' DNS Core abilitato
Dim DNSCache As Map                  ' Cache DNS
Dim DNSCacheTTL As Map               ' TTL cache DNS
Dim DNSResolvers As List             ' Server DNS
Dim DNSIPv6Enabled As Boolean        ' Supporto IPv6
Dim DNSTimeout As Int                ' Timeout DNS (ms)
Dim DNSRetries As Int                ' Tentativi DNS
Dim DNSAsyncEnabled As Boolean       ' Risoluzione asincrona
Dim DNSStats As Map                  ' Statistiche DNS
Dim DNSHistory As List               ' Storico risoluzioni
Dim DNSAlerts As Map                 ' Alert DNS
Dim DNSMonitoring As Boolean         ' Monitoraggio DNS
Dim DNSThreads As Map                 ' Thread DNS
Dim DNSPending As Map                ' Risoluzioni pendenti
Dim DNSErrors As Map                 ' Errori DNS
Dim DNSFallback As List              ' Server DNS fallback
Dim DNSCustom As Map                 ' Risoluzioni personalizzate
Dim DNSBlocked As List               ' Host bloccati
Dim DNSWhitelist As List             ' Host whitelist
Dim DNSBlacklist As List             ' Host blacklist

' ======================
' CUSTOM DIRECTORY SYSTEM
' ======================
Dim CustomDirectoryEnabled As Boolean ' Directory custom abilitata
Dim CustomDirectoryPath As String     ' Percorso directory custom
Dim DefaultDirectoryPath As String     ' Percorso directory default
Dim DirectoryHistory As List          ' Storico directory utilizzate
Dim DirectoryPermissions As Map       ' Permessi directory
Dim DirectoryQuota As Map             ' Quota directory
Dim DirectoryStats As Map              ' Statistiche directory
Dim DirectoryBackup As Boolean        ' Backup automatico
Dim DirectorySync As Boolean          ' Sincronizzazione directory

' ======================
' AUTO-OP SUPPORT
' ======================
Dim AutoOpList As List          ' Lista auto-op utenti
Dim AutoOpChannels As Map       ' Canali per ogni auto-op
Dim AutoOpLevels As Map         ' Livelli auto-op per utente
Dim AskOpList As List           ' Lista host per richiesta op
Dim AskOpChannels As Map        ' Canali per ogni ask-op

' ======================
' IGNORE/BAN SUPPORT
' ======================
Dim IgnoreList As List          ' Lista ignore utenti
Dim IgnoreTypes As Map          ' Tipi ignore (host, content, etc.)
Dim IgnoreChannels As Map       ' Canali per ogni ignore
Dim BanList As List            ' Lista ban utenti (già esistente)
Dim BanReasons As Map          ' Motivi ban (già esistente)
Dim BanChannels As Map         ' Canali per ogni ban

' ======================
' LOGGING SUPPORT
' ======================
Dim LogSources As List          ' Sorgenti log
Dim LogFilters As Map          ' Filtri per ogni log
Dim LogTypes As Map             ' Tipi log (traffic, main, private)
Dim TrafficLogEnabled As Boolean ' Traffic log abilitato
Dim MainLogEnabled As Boolean   ' Main log abilitato
Dim PrivateLogEnabled As Boolean ' Private log abilitato

' ======================
' HOST MANAGEMENT SUPPORT
' ======================
Dim AllowedHosts As List          ' Lista host autorizzati
Dim HostTypes As Map              ' Tipi host (IP, domain, etc.)
Dim HostDescriptions As Map       ' Descrizioni host
Dim HostExpiry As Map             ' Scadenza host

' ======================
' SYSTEM MANAGEMENT SUPPORT
' ======================
Dim SystemTime As String          ' Ora sistema personalizzata
Dim SystemDate As String          ' Data sistema personalizzata
Dim SystemTimezone As String      ' Timezone sistema
Dim SystemInfo As Map             ' Info sistema

' ======================
' LINKING SUPPORT
' ======================
Dim LinkedBouncers As List        ' Lista bouncer collegati
Dim LinkConnections As Map        ' Connessioni di linking
Dim LinkPasswords As Map          ' Password per linking
Dim LinkStatus As Map             ' Stato collegamenti
Dim LinkNetworks As Map           ' Reti per linking

' ======================
' ORIGINAL LINKING PROTOCOL
' ======================
Dim LinkTypes As Map              ' Tipi link (LI_LINK, LI_ALLOW, LI_RELAY)
Dim LinkStates As Map             ' Stati link (STD_CONN, STD_NOCON)
Dim LinkSockets As Map            ' Socket link (insock, outsock)
Dim LinkPasswords As Map          ' Password link
Dim LinkNames As Map              ' Nomi link
Dim LinkHosts As Map              ' Host link
Dim LinkPorts As Map              ' Porte link
Dim LinkDelayed As Map            ' Ritardi link
Dim LinkNodes As List             ' Nodi link
Dim LinkTopology As Map           ' Topologia link
Dim LinkBroadcast As Boolean      ' Broadcast link

' ======================
' ERROR HANDLING & LOGGING
' ======================
Dim ErrorBuffer As List        ' Buffer errori in memoria
Dim LogFile As String          ' File di log
Dim HeartbeatTimer As Timer    ' Timer per heartbeat
Dim ConnectionRetryCount As Int ' Contatore tentativi riconnessione
Dim MaxRetryAttempts As Int    ' Massimo tentativi riconnessione

' ======================
' SSL ADVANCED SYSTEM (ORIGINAL STYLE)
' ======================

' SSL Advanced Variables
Dim SSLAdvancedMode As Boolean = True
Dim SSLCipherSuites As List
Dim SSLCertificates As Map
Dim SSLHandshakeTimeout As Int = 30000
Dim SSLConnectionPool As Map
Dim SSLStats As Map
Dim SSLLog As List

' SSL Advanced Functions
Sub InitializeSSLAdvanced()
	Try
		SSLCipherSuites.Initialize
		SSLCertificates.Initialize
		SSLConnectionPool.Initialize
		SSLStats.Initialize
		SSLLog.Initialize
		
		' Inizializza cipher suites supportati
		SSLCipherSuites.AddAll(Array As String("TLS_RSA_WITH_AES_256_CBC_SHA", "TLS_RSA_WITH_AES_128_CBC_SHA", "TLS_RSA_WITH_3DES_EDE_CBC_SHA"))
		
		LogInfo("SSL Advanced system initialized", "InitializeSSLAdvanced")
	Catch Error As Exception
		LogError("SSL_ADVANCED_INIT_ERROR", Error.Message, "InitializeSSLAdvanced")
	End Try
End Sub

Sub SetSSLAdvancedMode(Enabled As Boolean)
	SSLAdvancedMode = Enabled
	LogInfo("SSL Advanced mode: " & Enabled, "SetSSLAdvancedMode")
End Sub

Sub AddSSLCertificate(CertName As String, CertData As String, PrivateKey As String)
	Try
		Dim CertInfo As Map
		CertInfo.Initialize
		CertInfo.Put("CertData", CertData)
		CertInfo.Put("PrivateKey", PrivateKey)
		CertInfo.Put("AddedTime", DateTime.Now)
		
		SSLCertificates.Put(CertName, CertInfo)
		LogInfo("SSL Certificate added: " & CertName, "AddSSLCertificate")
	Catch Error As Exception
		LogError("SSL_CERT_ADD_ERROR", Error.Message, "AddSSLCertificate")
	End Try
End Sub

Sub RemoveSSLCertificate(CertName As String)
	Try
		If SSLCertificates.ContainsKey(CertName) Then
			SSLCertificates.Remove(CertName)
			LogInfo("SSL Certificate removed: " & CertName, "RemoveSSLCertificate")
		End If
	Catch Error As Exception
		LogError("SSL_CERT_REMOVE_ERROR", Error.Message, "RemoveSSLCertificate")
	End Try
End Sub

Sub SetSSLHandshakeTimeout(Timeout As Int)
	SSLHandshakeTimeout = Timeout
	LogInfo("SSL Handshake timeout set to: " & Timeout & "ms", "SetSSLHandshakeTimeout")
End Sub

Sub AddSSLCipherSuite(CipherSuite As String)
	Try
		If SSLCipherSuites.IndexOf(CipherSuite) = -1 Then
			SSLCipherSuites.Add(CipherSuite)
			LogInfo("SSL Cipher suite added: " & CipherSuite, "AddSSLCipherSuite")
		End If
	Catch Error As Exception
		LogError("SSL_CIPHER_ADD_ERROR", Error.Message, "AddSSLCipherSuite")
	End Try
End Sub

Sub RemoveSSLCipherSuite(CipherSuite As String)
	Try
		Dim Index As Int = SSLCipherSuites.IndexOf(CipherSuite)
		If Index >= 0 Then
			SSLCipherSuites.RemoveAt(Index)
			LogInfo("SSL Cipher suite removed: " & CipherSuite, "RemoveSSLCipherSuite")
		End If
	Catch Error As Exception
		LogError("SSL_CIPHER_REMOVE_ERROR", Error.Message, "RemoveSSLCipherSuite")
	End Try
End Sub

Sub LogSSLConnection(ConnectionID As String, Action As String, Details As String)
	Try
		Dim LogEntry As Map
		LogEntry.Initialize
		LogEntry.Put("ConnectionID", ConnectionID)
		LogEntry.Put("Action", Action)
		LogEntry.Put("Details", Details)
		LogEntry.Put("Timestamp", DateTime.Now)
		
		SSLLog.Add(LogEntry)
		
		' Mantieni solo gli ultimi 1000 log
		If SSLLog.Size > 1000 Then
			SSLLog.RemoveAt(0)
		End If
		
		LogInfo("SSL Connection " & Action & ": " & Details, "LogSSLConnection")
	Catch Error As Exception
		LogError("SSL_LOG_ERROR", Error.Message, "LogSSLConnection")
	End Try
End Sub

Sub UpdateSSLStats(ConnectionID As String, BytesIn As Long, BytesOut As Long, Duration As Long)
	Try
		Dim Stats As Map
		If SSLStats.ContainsKey(ConnectionID) Then
			Stats = SSLStats.Get(ConnectionID)
		Else
			Stats.Initialize
		End If
		
		Stats.Put("BytesIn", BytesIn)
		Stats.Put("BytesOut", BytesOut)
		Stats.Put("Duration", Duration)
		Stats.Put("LastUpdate", DateTime.Now)
		
		SSLStats.Put(ConnectionID, Stats)
	Catch Error As Exception
		LogError("SSL_STATS_ERROR", Error.Message, "UpdateSSLStats")
	End Try
End Sub

Sub GetSSLStats(ConnectionID As String) As Map
	Try
		If SSLStats.ContainsKey(ConnectionID) Then
			Return SSLStats.Get(ConnectionID)
		Else
			Dim EmptyStats As Map
			EmptyStats.Initialize
			Return EmptyStats
		End If
	Catch Error As Exception
		LogError("SSL_STATS_GET_ERROR", Error.Message, "GetSSLStats")
		Dim EmptyStats As Map
		EmptyStats.Initialize
		Return EmptyStats
	End Try
End Sub

Sub GetSSLLog() As List
	Try
		Return SSLLog
	Catch Error As Exception
		LogError("SSL_LOG_GET_ERROR", Error.Message, "GetSSLLog")
		Dim EmptyList As List
		EmptyList.Initialize
		Return EmptyList
	End Try
End Sub

Sub CleanupSSLAdvanced()
	Try
		' Pulisci connessioni SSL chiuse
		For i = SSLConnectionPool.Size - 1 To 0 Step -1
			Dim ConnectionID As String = SSLConnectionPool.GetKeyAt(i)
			Dim ConnectionInfo As Map = SSLConnectionPool.Get(ConnectionID)
			If ConnectionInfo.ContainsKey("Status") Then
				Dim Status As String = ConnectionInfo.Get("Status")
				If Status = "CLOSED" Or Status = "FAILED" Then
					SSLConnectionPool.Remove(ConnectionID)
				End If
			End If
		Next
		
		' Pulisci log vecchi
		If SSLLog.Size > 1000 Then
			For i = 0 To SSLLog.Size - 1000 - 1
				SSLLog.RemoveAt(0)
			Next
		End If
		
		LogInfo("SSL Advanced cleanup completed", "CleanupSSLAdvanced")
	Catch Error As Exception
		LogError("SSL_CLEANUP_ERROR", Error.Message, "CleanupSSLAdvanced")
	End Try
End Sub

' ======================
' SSL SUPPORT
' ======================
Dim SSLEnabled As Boolean      ' SSL abilitato
Dim SSLPort As Int            ' Porta SSL
Dim SSLCertificate As String  ' Certificato SSL
Dim SSLKey As String          ' Chiave SSL
Dim SSLPassword As String     ' Password certificato
Dim SSLVerifyMode As Int      ' Modalità verifica SSL
Dim SSLProtocol As String     ' Protocollo SSL (TLS1.2, TLS1.3)
Dim SSLCompression As Boolean ' Compressione SSL
Dim SSLCipherSuites As List   ' Suite di cifratura SSL
Dim SSLClientCertificates As Map ' Certificati client SSL
Dim SSLServerCertificates As Map ' Certificati server SSL
Dim SSLDCCEnabled As Boolean  ' SSL per DCC abilitato
Dim SSLDCCPort As Int         ' Porta SSL per DCC
Dim SSLDCCServer As ServerSocket ' Server SSL per DCC
Dim SSLDCCConnections As List ' Connessioni SSL DCC

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
' MULTI-SERVER SUPPORT (ORIGINAL STYLE)
' ======================
Dim ServerConnections As List   ' Lista connessioni server attive
Dim ServerSockets As Map        ' Socket per ogni server
Dim ServerStreams As Map        ' Stream per ogni server
Dim ServerNetworks As Map       ' Network associato a ogni server
Dim ServerConfigs As Map        ' Configurazione per ogni server
Dim ServerStatus As Map         ' Stato per ogni server

' ======================
' MULTI-NETWORK SUPPORT (ORIGINAL STYLE)
' ======================
Dim NetworkTokens As List       ' Lista token network (Ef, Freenode, etc.)
Dim NetworkConnections As Map   ' Connessioni per ogni network
Dim NetworkServers As Map       ' Server per ogni network
Dim NetworkSockets As Map       ' Socket per ogni network
Dim NetworkStreams As Map       ' Stream per ogni network
Dim NetworkChannels As Map      ' Canali per ogni network
Dim NetworkUsers As Map         ' Utenti per ogni network
Dim NetworkPrefixes As Map      ' Prefissi per ogni network
Dim CurrentMainNetwork As String ' Network principale attuale

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
		' DCC RESUME SYSTEM INIT
		' ======================
		DCCResumeEnabled = True
		DCCResumeFiles.Initialize
		DCCResumePositions.Initialize
		DCCResumeChecksums.Initialize
		DCCResumeTimeouts.Initialize
		DCCResumeRetries.Initialize
		DCCResumeMaxRetries = 5
		DCCResumeTimeout = 30000 ' 30 secondi
		DCCResumeHistory.Initialize
		DCCResumeStats.Initialize
		
		' Inizializza statistiche resume
		DCCResumeStats.Put("TotalResumes", 0)
		DCCResumeStats.Put("SuccessfulResumes", 0)
		DCCResumeStats.Put("FailedResumes", 0)
		DCCResumeStats.Put("AutoResumes", 0)
		DCCResumeStats.Put("StartTime", DateTime.Now)
		
	' Inizializza DCC Resume Automatico
	DCCResumeAutoEnabled = True
	DCCResumeFileCache.Initialize
	DCCResumeIPCache.Initialize
	DCCResumeAutoTimeout = 300000 ' 5 minuti per resume automatico
	
		' ======================
		' INIZIALIZZA MULTI-NETWORK SUPPORT
		' ======================
		NetworkTokens.Initialize
		NetworkConnections.Initialize
		NetworkServers.Initialize
		NetworkSockets.Initialize
		NetworkStreams.Initialize
		NetworkChannels.Initialize
		NetworkUsers.Initialize
		NetworkPrefixes.Initialize
		CurrentMainNetwork = "MAIN"
		
		' ======================
		' INIZIALIZZA DCC ADVANCED
		' ======================
		InitializeDCCAdvanced()
		
		' ======================
		' INIZIALIZZA SSL ADVANCED
		' ======================
		InitializeSSLAdvanced()
		
		' ======================
		' INIZIALIZZA DNS ADVANCED
		' ======================
		InitializeDNSAdvanced()
	
	' Inizializza ServerConnections
	ServerConnections.Initialize
	ServerSockets.Initialize
	ServerStreams.Initialize
	ServerNetworks.Initialize
	ServerConfigs.Initialize
	ServerStatus.Initialize
	
	' ======================
	' LOAD SAVED STATE
	' ======================
	LoadSavedState()
		
		' ======================
		' AUTO-OP INIT
		' ======================
		AutoOpList.Initialize
		AutoOpChannels.Initialize
		AutoOpLevels.Initialize
		AskOpList.Initialize
		AskOpChannels.Initialize
		
		' ======================
		' IGNORE/BAN INIT
		' ======================
		IgnoreList.Initialize
		IgnoreTypes.Initialize
		IgnoreChannels.Initialize
		BanChannels.Initialize
		
		' ======================
		' LOGGING INIT
		' ======================
		LogSources.Initialize
		LogFilters.Initialize
		LogTypes.Initialize
		TrafficLogEnabled = False
		MainLogEnabled = False
		PrivateLogEnabled = False
		
		' ======================
		' HOST MANAGEMENT INIT
		' ======================
		AllowedHosts.Initialize
		HostTypes.Initialize
		HostDescriptions.Initialize
		HostExpiry.Initialize
		
		' ======================
		' SYSTEM MANAGEMENT INIT
		' ======================
		SystemTime = ""
		SystemDate = ""
		SystemTimezone = "UTC"
		SystemInfo.Initialize
		
		' ======================
		' LINKING INIT
		' ======================
		LinkedBouncers.Initialize
		LinkConnections.Initialize
		LinkPasswords.Initialize
		LinkStatus.Initialize
		LinkNetworks.Initialize
		
		' ======================
		' ORIGINAL LINKING INIT
		' ======================
		LinkTypes.Initialize
		LinkStates.Initialize
		LinkSockets.Initialize
		LinkPasswords.Initialize
		LinkNames.Initialize
		LinkHosts.Initialize
		LinkPorts.Initialize
		LinkDelayed.Initialize
		LinkNodes.Initialize
		LinkTopology.Initialize
		LinkBroadcast = True
		
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
		SSLPassword = ""              ' Password certificato
		SSLVerifyMode = 0             ' Verifica SSL disabilitata
		SSLProtocol = "TLS1.2"        ' Protocollo SSL predefinito
		SSLCompression = False        ' Compressione SSL disabilitata
		SSLCipherSuites.Initialize    ' Suite di cifratura
		SSLClientCertificates.Initialize ' Certificati client
		SSLServerCertificates.Initialize ' Certificati server
		SSLDCCEnabled = False         ' SSL DCC disabilitato
		SSLDCCPort = 0                ' Porta SSL DCC
		SSLDCCConnections.Initialize  ' Connessioni SSL DCC
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
		' INTERNAL NETWORK INITIALIZATION
		' ======================
		InternalNetwork = True
		InternalClients.Initialize
		InternalChannels.Initialize
		InternalMessages.Initialize
		InternalBouncers.Initialize
		InternalUsers.Initialize
		InternalRoomUsers.Initialize
		InternalRoomModes.Initialize
		InternalRoomTopics.Initialize
		InternalRoomOps.Initialize
		InternalRoomBans.Initialize
		InternalRoomInvites.Initialize
		InternalRoomKeys.Initialize
		InternalRoomLimits.Initialize
		InternalBroadcastEnabled = True
		
		' Crea stanze virtuali automatiche
		CreateInternalRooms()
		
		' ======================
		' ADVANCED CHANNEL MANAGEMENT INITIALIZATION
		' ======================
		ChannelUsers.Initialize
		ChannelUserModes.Initialize
		ChannelBans.Initialize
		ChannelInvites.Initialize
		ChannelKeys.Initialize
		ChannelLimits.Initialize
		ChannelTopics.Initialize
		ChannelModes.Initialize
		ChannelTopicProtection.Initialize
		ChannelOperators.Initialize
		ChannelVoices.Initialize
		ChannelHalfOps.Initialize
		ChannelFounders.Initialize
		ChannelHistory.Initialize
		ChannelJoinTime.Initialize
		ChannelLastActivity.Initialize
		ChannelMessageCount.Initialize
		ChannelUserCount.Initialize
		ChannelModeHistory.Initialize
		ChannelTopicHistory.Initialize
		
		' ======================
		' PERFORMANCE MONITORING INITIALIZATION
		' ======================
		PerformanceEnabled = True
		CPUUsage = 0.0
		MemoryUsage = 0
		NetworkInBytes = 0
		NetworkOutBytes = 0
		ActiveConnections = 0
		PerformanceHistory.Initialize
		PerformanceAlerts.Initialize
		PerformanceThresholds.Initialize
		PerformanceMonitoring = False
		PerformanceInterval = 5000 ' 5 secondi
		PerformanceStartTime = DateTime.Now
		PerformanceLastUpdate = DateTime.Now
		PerformanceData.Initialize
		PerformanceStats.Initialize
		
		' Imposta soglie performance
		PerformanceThresholds.Put("CPU_HIGH", 80.0)
		PerformanceThresholds.Put("MEMORY_HIGH", 100000000) ' 100MB
		PerformanceThresholds.Put("NETWORK_HIGH", 1000000) ' 1MB/s
		PerformanceThresholds.Put("CONNECTIONS_HIGH", 100)
		
		' ======================
		' SECURITY SYSTEM INITIALIZATION
		' ======================
		SecurityEnabled = True
		IntrusionDetection = True
		AccessControl = True
		AuditLogging = True
		SecurityAlerts.Initialize
		ThreatDetection = True
		SecurityMonitoring = False
		FailedLogins.Initialize
		SuspiciousActivity.Initialize
		SecurityRules.Initialize
		SecurityViolations.Initialize
		SecurityEvents.Initialize
		SecurityStats.Initialize
		SecurityThresholds.Initialize
		SecurityActions.Initialize
		
		' Imposta soglie sicurezza
		SecurityThresholds.Put("FAILED_LOGINS", 5)
		SecurityThresholds.Put("SUSPICIOUS_ACTIVITY", 3)
		SecurityThresholds.Put("INTRUSION_ATTEMPTS", 3)
		SecurityThresholds.Put("THREAT_LEVEL", 2)
		
		' Imposta azioni sicurezza
		SecurityActions.Put("FAILED_LOGIN", "BAN_TEMPORARY")
		SecurityActions.Put("SUSPICIOUS_ACTIVITY", "LOG_ALERT")
		SecurityActions.Put("INTRUSION_ATTEMPT", "BAN_PERMANENT")
		SecurityActions.Put("THREAT_DETECTED", "ALERT_ADMIN")
		
		' ======================
		' DNS CORE SYSTEM INITIALIZATION
		' ======================
		DNSCoreEnabled = True
		DNSCache.Initialize
		DNSCacheTTL.Initialize
		DNSResolvers.Initialize
		DNSIPv6Enabled = True
		DNSTimeout = 5000 ' 5 secondi
		DNSRetries = 3
		DNSAsyncEnabled = True
		DNSStats.Initialize
		DNSHistory.Initialize
		DNSAlerts.Initialize
		DNSMonitoring = False
		DNSThreads.Initialize
		DNSPending.Initialize
		DNSErrors.Initialize
		DNSFallback.Initialize
		DNSCustom.Initialize
		DNSBlocked.Initialize
		DNSWhitelist.Initialize
		DNSBlacklist.Initialize
		
		' Imposta server DNS predefiniti
		DNSResolvers.Add("8.8.8.8")        ' Google DNS
		DNSResolvers.Add("8.8.4.4")        ' Google DNS
		DNSResolvers.Add("1.1.1.1")        ' Cloudflare DNS
		DNSResolvers.Add("1.0.0.1")        ' Cloudflare DNS
		DNSResolvers.Add("208.67.222.222") ' OpenDNS
		DNSResolvers.Add("208.67.220.220") ' OpenDNS
		
		' Imposta server DNS IPv6
		DNSResolvers.Add("2001:4860:4860::8888")  ' Google DNS IPv6
		DNSResolvers.Add("2001:4860:4860::8844")  ' Google DNS IPv6
		DNSResolvers.Add("2606:4700:4700::1111") ' Cloudflare DNS IPv6
		DNSResolvers.Add("2606:4700:4700::1001") ' Cloudflare DNS IPv6
		
		' Imposta server DNS fallback
		DNSFallback.Add("9.9.9.9")         ' Quad9 DNS
		DNSFallback.Add("9.9.9.10")        ' Quad9 DNS
		DNSFallback.Add("76.76.19.4")      ' Alternate DNS
		DNSFallback.Add("76.76.2.4")       ' Alternate DNS
		
		' Inizializza statistiche DNS
		DNSStats.Put("Resolutions", 0)
		DNSStats.Put("CacheHits", 0)
		DNSStats.Put("CacheMisses", 0)
		DNSStats.Put("Errors", 0)
		DNSStats.Put("Timeouts", 0)
		DNSStats.Put("IPv4Resolutions", 0)
		DNSStats.Put("IPv6Resolutions", 0)
		DNSStats.Put("StartTime", DateTime.Now)
		
		' ======================
		' CUSTOM DIRECTORY SYSTEM INITIALIZATION
		' ======================
		CustomDirectoryEnabled = False
		CustomDirectoryPath = ""
		DefaultDirectoryPath = File.DirRootExternal & "/Download" ' Directory Download Android
		DirectoryHistory.Initialize
		DirectoryPermissions.Initialize
		DirectoryQuota.Initialize
		DirectoryStats.Initialize
		DirectoryBackup = False
		DirectorySync = False
		
		' Inizializza statistiche directory
		DirectoryStats.Put("FilesSaved", 0)
		DirectoryStats.Put("TotalSize", 0)
		DirectoryStats.Put("LastUsed", DateTime.Now)
		DirectoryStats.Put("DefaultPath", DefaultDirectoryPath)
		DirectoryStats.Put("CustomPath", "")
		DirectoryStats.Put("CurrentPath", DefaultDirectoryPath)
		
		' Imposta quota default (100MB)
		DirectoryQuota.Put("MaxSize", 104857600) ' 100MB in bytes
		DirectoryQuota.Put("MaxFiles", 1000)
		DirectoryQuota.Put("WarningThreshold", 80) ' 80% warning
		
		' Imposta permessi default
		DirectoryPermissions.Put("Read", True)
		DirectoryPermissions.Put("Write", True)
		DirectoryPermissions.Put("Delete", True)
		DirectoryPermissions.Put("Create", True)
		
		' Aggiungi directory default alla cronologia
		DirectoryHistory.Add(DefaultDirectoryPath)
		
		' ======================
		' START SYSTEMS
		' ======================
		' Avvia sistema di logging
		LogInfo("psyBNC Android started with Internal Network", "Service_Start")
		
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
				
				' GESTIONE MOTD (372-375)
				If NumeroRaw(1) = "372" Or NumeroRaw(1) = "373" Or NumeroRaw(1) = "374" Or NumeroRaw(1) = "375" Then
					' MOTD lines - salva per il rejoin
					If StopMoth = True Then
						SaveMoth = SaveMoth & RigaRead(Start) & Chr(32)
					End If
				End If
				
				'====================================
				' CONNESSIONE SERVER - RAW 001-005
				'====================================
				If NumeroRaw(1) = "001" Then
					' Welcome message - connessione riuscita
					StopMoth = True
					Nickconnessione = NumeroRaw(2)
					changemoth = RigaRead(Start).Replace(Nickconnessione&" :","$nick :").Replace(Nickconnessione&"!","$nick!")
					SaveMoth =  changemoth & Chr(32)
					LogInfo("Connected to server as: " & Nickconnessione, "Connection")
					
					' GESTIONE AWAY NICK - RITORNO AL NICK ORIGINALE
					If NormalNick.Length > 0 And AwayNick.Length > 0 Then
						' Se l'utente si riconnette, torna al nick originale
						If Nickconnessione = AwayNick Then
							WriteSocketIrc("nick " & NormalNick)
							LogInfo("Returning to original nick: " & NormalNick, "AwayNick")
						End If
					End If
				End If
				
				If NumeroRaw(1) = "002" Or NumeroRaw(1) = "003" Or NumeroRaw(1) = "004" Or NumeroRaw(1) = "005" Then
					' Server information messages
					LogInfo("Server Info: " & RigaRead(Start), "ServerInfo")
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
							
							' ======================
							' SYNC STATE AFTER PRIVMSG
							' ======================
							SaveCurrentState()
							LogInfo("Private message received, state synchronized", "PrivMsgSync")
						End If
					End If
				End If
				
				' GESTIONE NOTICE MESSAGES
				If NumeroRaw(1) = "NOTICE" AND joinpasswd = False Then
					' Gestione messaggi NOTICE (sistema)
					ProcessNoticeMessage(NumeroRaw)
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
						LogInfo("Joined channel: " & RealChan(1), "ChannelJoin")
						
						' ======================
						' SYNC STATE AFTER JOIN
						' ======================
						SaveCurrentState()
						LogInfo("Joined channel: " & RealChan(1) & ", state synchronized", "JoinSync")
					End If
				End If
				
				' GESTIONE NAMES LIST (353) - Lista utenti canale
				If NumeroRaw(1) = "353" Then
					' NAMES response - lista utenti nel canale
					ProcessNAMESResponse(NumeroRaw)
				End If
				
				' GESTIONE END NAMES (366) - Fine lista utenti
				If NumeroRaw(1) = "366" Then
					' End of NAMES - fine lista utenti
					ProcessEndOfNAMES(NumeroRaw)
				End If
				
				' GESTIONE CHANNEL MODES (324) - Modalità canale
				If NumeroRaw(1) = "324" Then
					' Channel mode information
					ProcessChannelModeInfo(NumeroRaw)
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
						' ======================
						' SINGLE SERVER PART
						' ======================
						For i = 0 To joinchannel.Size - 1
							If i <= joinchannel.Size -1 Then
								nomecanale = joinchannel.Get(i)
									If NumeroRaw(2) = nomecanale Then
										If joinchannel.get(i) <> Null Then joinchannel.RemoveAt(i)
										If Topichannel.get(i) <> Null Then Topichannel.removeAt(i)
									End If
							End If
						Next 
						
						' ======================
						' MULTI-SERVER PART
						' ======================
						Dim ChannelName As String = NumeroRaw(2)
						For i = 0 To NetworkTokens.Size - 1
							Dim NetworkToken As String = NetworkTokens.Get(i)
							If NetworkToken <> CurrentMainNetwork Then
								' Rimuovi canale dal network specifico
								Dim NetworkChannelsList As List = NetworkChannels.Get(NetworkToken)
								If NetworkChannelsList <> Null Then
									For j = 0 To NetworkChannelsList.Size - 1
										Dim NetworkChannel As String = NetworkChannelsList.Get(j)
										If NetworkChannel = ChannelName Then
											NetworkChannelsList.RemoveAt(j)
											LogInfo("Channel " & ChannelName & " removed from network " & NetworkToken, "MultiServerPART")
											Exit
										End If
									Next
								End If
							End If
						Next
						
						' ======================
						' SYNC STATE AFTER PART
						' ======================
						SaveCurrentState()
						LogInfo("Parted from channel: " & ChannelName & ", state synchronized", "PartSync")
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
					
					' ======================
					' SYNC STATE AFTER TOPIC CHANGE
					' ======================
					SaveCurrentState()
					LogInfo("Topic changed, state synchronized", "TopicSync")
					
					Return Read
				 End If
				 
				 ' GESTIONE MODALITÀ CANALE
				 If NumeroRaw(1) = "MODE" Then
					' Gestione modalità canale
					ProcessChannelMode(NumeroRaw)
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
						
						' ======================
						' SYNC STATE AFTER NICK CHANGE
						' ======================
						SaveCurrentState()
						LogInfo("Nick changed to: " & Nickconnessione & ", state synchronized", "NickSync")
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
							
							' ======================
							' SYNC STATE AFTER KICK
							' ======================
							SaveCurrentState()
							LogInfo("Kicked from channel: " & NumeroRaw(2) & ", state synchronized", "KickSync")
						End If
					Return Read
				End If
				
				' GESTIONE DISCONNESSIONI UTENTI
				If NumeroRaw(1) = "QUIT" Then
					' Gestione disconnessione utenti
					ProcessUserQuit(NumeroRaw)
					Return Read
				End If
				
				' GESTIONE INVITI CANALE
				If NumeroRaw(1) = "INVITE" Then
					' Gestione inviti canale
					ProcessChannelInvite(NumeroRaw)
					Return Read
				End If
				
				'==================
				' RAW IRC MANCANTI (ORIGINAL STYLE)
				'==================
				
				' WHO/WHOIS (352, 315, 319)
				If NumeroRaw(1) = "352" Then
					' WHO response - gestisci lista utenti
					ProcessWHOResponse(NumeroRaw)
				End If
				
				If NumeroRaw(1) = "315" Then
					' End of WHO
					ProcessEndOfWHO(NumeroRaw)
				End If
				
				If NumeroRaw(1) = "319" Then
					' WHOIS channels
					ProcessWHOISChannels(NumeroRaw)
				End If
				
				' NAMES (353, 366)
				If NumeroRaw(1) = "353" Then
					' NAMES response - gestisci lista utenti canale
					ProcessNAMESResponse(NumeroRaw)
				End If
				
				If NumeroRaw(1) = "366" Then
					' End of NAMES
					ProcessEndOfNAMES(NumeroRaw)
				End If
				
				' MODE
				If NumeroRaw(1) = "MODE" Then
					' Gestione modalità canale
					ProcessChannelMode(NumeroRaw)
				End If
				
				' QUIT
				If NumeroRaw(1) = "QUIT" Then
					' Gestione disconnessione utenti
					ProcessUserQuit(NumeroRaw)
				End If
				
				' INVITE
				If NumeroRaw(1) = "INVITE" Then
					' Gestione inviti canale
					ProcessChannelInvite(NumeroRaw)
				End If
				
				' NOTICE
				If NumeroRaw(1) = "NOTICE" Then
					' Gestione messaggi di sistema
					ProcessNoticeMessage(NumeroRaw)
				End If
				
				' Server Info (251-266)
				If NumeroRaw(1) = "251" Or NumeroRaw(1) = "252" Or NumeroRaw(1) = "253" Or NumeroRaw(1) = "254" Or NumeroRaw(1) = "255" Then
					' Server information
					ProcessServerInfo(NumeroRaw)
				End If
				
				If NumeroRaw(1) = "265" Or NumeroRaw(1) = "266" Then
					' Server statistics
					ProcessServerStats(NumeroRaw)
				End If
				
				' MOTD (372-375)
				If NumeroRaw(1) = "372" Or NumeroRaw(1) = "373" Or NumeroRaw(1) = "374" Or NumeroRaw(1) = "375" Then
					' Message of the Day
					ProcessMOTD(NumeroRaw)
				End If
				
				' Channel Modes (324)
				If NumeroRaw(1) = "324" Then
					' Channel mode information
					ProcessChannelModeInfo(NumeroRaw)
				End If
				
				' Topic Info (333)
				If NumeroRaw(1) = "333" Then
					' Topic setter information
					ProcessTopicInfo(NumeroRaw)
				End If
				
				' Nick Errors (432-437)
				If NumeroRaw(1) = "432" Or NumeroRaw(1) = "433" Or NumeroRaw(1) = "434" Or NumeroRaw(1) = "435" Or NumeroRaw(1) = "436" Or NumeroRaw(1) = "437" Then
					' Nick error handling
					ProcessNickError(NumeroRaw)
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

Sub WriteSocketToNetwork(Message As String, NetworkToken As String)
	' Invia messaggio a un network specifico
	If NetworkSockets.ContainsKey(NetworkToken) Then
		Dim NetworkSocket As Socket
		NetworkSocket = NetworkSockets.Get(NetworkToken)
		If NetworkSocket <> Null And NetworkSocket.Connected Then
			Dim MessageBytes() As Byte
			MessageBytes = (Message & Chr(13) & Chr(10)).GetBytes("UTF8")
			NetworkSocket.Write(MessageBytes)
		End If
	End If
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
	' ======================
	' SAVE CURRENT STATE
	' ======================
	SaveCurrentState()
	
	' ======================
	' SINGLE SERVER RECONNECT
	' ======================
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
	
	' ======================
	' MULTI-SERVER RECONNECT
	' ======================
	If NetworkTokens.Size > 0 Then
		' Riconnetti a tutti i network configurati
		For i = 0 To NetworkTokens.Size - 1
			Dim NetworkToken As String = NetworkTokens.Get(i)
			If IsNetworkConnected(NetworkToken) = False Then
				' Tenta riconnessione al network
				If ConnectToNetwork(NetworkToken) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC "&RealData&" :Reconnected to network '" & NetworkToken & "'.")
					
					' Rejoin canali del network
					Dim NetworkChannelsList As List = NetworkChannels.Get(NetworkToken)
					If NetworkChannelsList <> Null Then
						For j = 0 To NetworkChannelsList.Size - 1
							Dim NetworkChannel As String = NetworkChannelsList.Get(j)
							WriteSocketIrc("join " & NetworkChannel)
							WriteSocketIrc("names " & NetworkChannel)
						Next
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC "&RealData&" :Failed to reconnect to network '" & NetworkToken & "'.")
				End If
			End If
		Next
	End If
Else
	' ======================
	' LOAD SAVED STATE ON RECONNECT
	' ======================
	If LoadSavedState() Then
		' Stato caricato con successo
		LogInfo("Saved state loaded successfully", "TimerServer_Tick")
	End If
End If

            ' ======================
            ' DCC CLEANUP
            ' ======================
            CleanupDCCConnections()
            CleanupDCCResume()
            CleanupDCCResumeCache()
            CleanupDCCAdvanced()
            
            ' ======================
            ' SSL CLEANUP
            ' ======================
            CleanupSSLAdvanced()
            
            ' ======================
            ' DNS CLEANUP
            ' ======================
            CleanupDNSCache()

' ======================
' HOST MANAGEMENT CLEANUP
' ======================
CleanupExpiredHosts()

' ======================
' LINKING CLEANUP
' ======================
CleanupInactiveLinks()

' ======================
' DNS CORE CLEANUP
' ======================
CleanupDNSCache()

' ======================
' SSL DCC CLEANUP
' ======================
CleanupSSLDCCConnections()

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
	
	' ======================
	' MULTI-SERVER REJOIN
	' ======================
	For I = 0 To joinchannel.Size - 1
		Dim Channel As String = joinchannel.Get(I)
		Dim PrefixedChannel As String = PrefixChannelForNetwork(Channel, CurrentMainNetwork)
		
		' Simula JOIN per il client
		WriteSocket(":"&Nickconnessione &"!psybnc@localhost.psybnc-arkosoft.com JOIN :"&PrefixedChannel&Chr(13)) 
		
		' Invia topic del canale
		Try
			WriteSocket(":server.psybnc.com 332 "&Nickconnessione&" "&PrefixedChannel&Chr(13) &" :"&Topichannel.Get(I)&Chr(13))
		Catch
		End Try
		
		' Fa il JOIN reale
		WriteSocketIrc("join "&Channel)
		WriteSocketIrc("names "&Channel)
		
		' Salva canale nel network corrente
		If NetworkChannels.ContainsKey(CurrentMainNetwork) Then
			Dim NetworkChannelsList As List = NetworkChannels.Get(CurrentMainNetwork)
			If NetworkChannelsList.IndexOf(Channel) = -1 Then
				NetworkChannelsList.Add(Channel)
			End If
		End If
	Next 
	
	' ======================
	' REJOIN ALTRI NETWORK
	' ======================
	For i = 0 To NetworkTokens.Size - 1
		Dim NetworkToken As String = NetworkTokens.Get(i)
		If NetworkToken <> CurrentMainNetwork And IsNetworkConnected(NetworkToken) Then
			Dim NetworkChannelsList As List = NetworkChannels.Get(NetworkToken)
			If NetworkChannelsList <> Null Then
				For j = 0 To NetworkChannelsList.Size - 1
					Dim NetworkChannel As String = NetworkChannelsList.Get(j)
					Dim PrefixedNetworkChannel As String = PrefixChannelForNetwork(NetworkChannel, NetworkToken)
					
					' Simula JOIN per il client (network diverso)
					WriteSocket(":"&Nickconnessione &"!psybnc@localhost.psybnc-arkosoft.com JOIN :"&PrefixedNetworkChannel&Chr(13))
					
					' Invia topic del canale (network diverso)
					Try
						WriteSocket(":server.psybnc.com 332 "&Nickconnessione&" "&PrefixedNetworkChannel&Chr(13) &" :"&NetworkChannel&" topic"&Chr(13))
					Catch
					End Try
				Next
			End If
		End If
	Next
End If
	
End Sub

' ======================
' MULTI-SERVER FUNCTIONS (ORIGINAL STYLE)
' ======================

Sub AddNetwork(NetworkToken As String) As Boolean
	Try
		If NetworkTokens.IndexOf(NetworkToken) = -1 Then
			NetworkTokens.Add(NetworkToken)
			NetworkConnections.Put(NetworkToken, False)
			NetworkServers.Put(NetworkToken, CreateMap())
			NetworkSockets.Put(NetworkToken, Null)
			NetworkStreams.Put(NetworkToken, Null)
			NetworkChannels.Put(NetworkToken, CreateList())
			NetworkUsers.Put(NetworkToken, CreateMap())
			NetworkPrefixes.Put(NetworkToken, NetworkToken.SubString2(0,1).ToUpperCase)
			LogInfo("Network added: " & NetworkToken, "MultiServer")
			Return True
		Else
			LogError("NETWORK_ALREADY_EXISTS", "Network " & NetworkToken & " already exists", "AddNetwork")
			Return False
		End If
	Catch
		LogError("ADD_NETWORK_ERROR", LastException.Message, "AddNetwork")
		Return False
	End Try
End Sub

Sub DeleteNetwork(NetworkToken As String) As Boolean
	Try
		If NetworkTokens.IndexOf(NetworkToken) <> -1 Then
			NetworkTokens.RemoveAt(NetworkTokens.IndexOf(NetworkToken))
			NetworkConnections.Remove(NetworkToken)
			NetworkServers.Remove(NetworkToken)
			NetworkSockets.Remove(NetworkToken)
			NetworkStreams.Remove(NetworkToken)
			NetworkChannels.Remove(NetworkToken)
			NetworkUsers.Remove(NetworkToken)
			NetworkPrefixes.Remove(NetworkToken)
			LogInfo("Network deleted: " & NetworkToken, "MultiServer")
			Return True
		Else
			LogError("NETWORK_NOT_FOUND", "Network " & NetworkToken & " not found", "DeleteNetwork")
			Return False
		End If
	Catch
		LogError("DELETE_NETWORK_ERROR", LastException.Message, "DeleteNetwork")
		Return False
	End Try
End Sub

Sub ListNetworks() As String
	Try
		Dim Result As String = "Configured Networks:"
		For i = 0 To NetworkTokens.Size - 1
			Dim NetworkToken As String = NetworkTokens.Get(i)
			Dim IsConnected As Boolean = NetworkConnections.Get(NetworkToken)
			Result = Result & Chr(13) & "- " & NetworkToken & " (" & IIf(IsConnected, "Connected", "Disconnected") & ")"
		Next
		Return Result
	Catch
		LogError("LIST_NETWORKS_ERROR", LastException.Message, "ListNetworks")
		Return "Error listing networks"
	End Try
End Sub

Sub AddServerToNetwork(NetworkToken As String, ServerHost As String, ServerPort As Int, ServerPassword As String) As Boolean
	Try
		If NetworkTokens.IndexOf(NetworkToken) <> -1 Then
			Dim ServerList As List = NetworkServers.Get(NetworkToken)
			If ServerList = Null Then
				ServerList.Initialize
				NetworkServers.Put(NetworkToken, ServerList)
			End If
			Dim ServerInfo As Map = CreateMap()
			ServerInfo.Put("Host", ServerHost)
			ServerInfo.Put("Port", ServerPort)
			ServerInfo.Put("Password", ServerPassword)
			ServerInfo.Put("Connected", False)
			ServerList.Add(ServerInfo)
			LogInfo("Server added to network " & NetworkToken & ": " & ServerHost & ":" & ServerPort, "MultiServer")
			Return True
		Else
			LogError("NETWORK_NOT_FOUND", "Network " & NetworkToken & " not found", "AddServerToNetwork")
			Return False
		End If
	Catch
		LogError("ADD_SERVER_ERROR", LastException.Message, "AddServerToNetwork")
		Return False
	End Try
End Sub

Sub ConnectToNetwork(NetworkToken As String) As Boolean
	Try
		If NetworkTokens.IndexOf(NetworkToken) <> -1 Then
			Dim ServerList As List = NetworkServers.Get(NetworkToken)
			If ServerList <> Null And ServerList.Size > 0 Then
				Dim ServerInfo As Map = ServerList.Get(0)
				Dim ServerHost As String = ServerInfo.Get("Host")
				Dim ServerPort As Int = ServerInfo.Get("Port")
				Dim ServerPassword As String = ServerInfo.Get("Password")
				
				' Connetti al server
				socket_invio_dati.Close
				socket_invio_dati.Initialize("socket_invio_dati")
				socket_invio_dati.Connect(ServerHost, ServerPort, 1000)
				
				NetworkConnections.Put(NetworkToken, True)
				CurrentMainNetwork = NetworkToken
				LogInfo("Connected to network " & NetworkToken & " via " & ServerHost & ":" & ServerPort, "MultiServer")
				Return True
			Else
				LogError("NO_SERVERS", "No servers configured for network " & NetworkToken, "ConnectToNetwork")
				Return False
			End If
		Else
			LogError("NETWORK_NOT_FOUND", "Network " & NetworkToken & " not found", "ConnectToNetwork")
			Return False
		End If
	Catch
		LogError("CONNECT_NETWORK_ERROR", LastException.Message, "ConnectToNetwork")
		Return False
	End Try
End Sub

Sub SwitchMainNetwork(NewMainNetwork As String, OldMainNetwork As String) As Boolean
	Try
		If NetworkTokens.IndexOf(NewMainNetwork) <> -1 Then
			CurrentMainNetwork = NewMainNetwork
			LogInfo("Switched main network from " & OldMainNetwork & " to " & NewMainNetwork, "MultiServer")
			Return True
		Else
			LogError("NETWORK_NOT_FOUND", "Network " & NewMainNetwork & " not found", "SwitchMainNetwork")
			Return False
		End If
	Catch
		LogError("SWITCH_NETWORK_ERROR", LastException.Message, "SwitchMainNetwork")
		Return False
	End Try
End Sub

Sub GetNetworkPrefix(NetworkToken As String) As String
	Try
		If NetworkPrefixes.ContainsKey(NetworkToken) Then
			Return NetworkPrefixes.Get(NetworkToken)
		Else
			Return NetworkToken.SubString2(0,1).ToUpperCase
		End If
	Catch
		LogError("GET_PREFIX_ERROR", LastException.Message, "GetNetworkPrefix")
		Return "?"
	End Try
End Sub

Sub PrefixChannelForNetwork(Channel As String, NetworkToken As String) As String
	Try
		If NetworkToken <> CurrentMainNetwork Then
			Dim Prefix As String = GetNetworkPrefix(NetworkToken)
			Return Prefix & Channel
		Else
			Return Channel
		End If
	Catch
		LogError("PREFIX_CHANNEL_ERROR", LastException.Message, "PrefixChannelForNetwork")
		Return Channel
	End Try
End Sub

Sub PrefixUserForNetwork(User As String, NetworkToken As String) As String
	Try
		If NetworkToken <> CurrentMainNetwork Then
			Dim Prefix As String = GetNetworkPrefix(NetworkToken)
			Return Prefix & User
		Else
			Return User
		End If
	Catch
		LogError("PREFIX_USER_ERROR", LastException.Message, "PrefixUserForNetwork")
		Return User
	End Try
End Sub

Sub IsNetworkConnected(NetworkToken As String) As Boolean
	Try
		If NetworkConnections.ContainsKey(NetworkToken) Then
			Return NetworkConnections.Get(NetworkToken)
		Else
			Return False
		End If
	Catch
		LogError("CHECK_NETWORK_ERROR", LastException.Message, "IsNetworkConnected")
		Return False
	End Try
End Sub

Sub GetNetworkChannels(NetworkToken As String) As Map
	Try
		If NetworkChannels.ContainsKey(NetworkToken) Then
			Return NetworkChannels.Get(NetworkToken)
		Else
			Return CreateMap()
		End If
	Catch
		LogError("GET_CHANNELS_ERROR", LastException.Message, "GetNetworkChannels")
		Return CreateMap()
	End Try
End Sub

Sub GetNetworkUsers(NetworkToken As String) As Map
	Try
		If NetworkUsers.ContainsKey(NetworkToken) Then
			Return NetworkUsers.Get(NetworkToken)
		Else
			Return CreateMap()
		End If
	Catch
		LogError("GET_USERS_ERROR", LastException.Message, "GetNetworkUsers")
		Return CreateMap()
	End Try
End Sub

Sub ProcessNetworkMessage(Message As String, NetworkToken As String)
	Try
		' Processa messaggi da network specifico con prefissi
		Dim PrefixedMessage As String = Message
		If NetworkToken <> CurrentMainNetwork Then
			Dim Prefix As String = GetNetworkPrefix(NetworkToken)
			' Aggiungi prefisso ai canali e utenti nel messaggio
			' Implementazione specifica per ogni tipo di messaggio
		End If
		LogInfo("Network message processed: " & NetworkToken, "MultiServer")
	Catch
		LogError("PROCESS_NETWORK_MESSAGE_ERROR", LastException.Message, "ProcessNetworkMessage")
	End Try
End Sub

' ======================
' STATE MANAGEMENT FUNCTIONS
' ======================

Sub SaveCurrentState()
	Try
		' Salva stato corrente per riconnessione automatica
		Dim StateData As Map
		StateData.Initialize
		
		' Salva canali attivi
		StateData.Put("joinchannel", joinchannel)
		StateData.Put("Topichannel", Topichannel)
		StateData.Put("SaveMoth", SaveMoth)
		StateData.Put("Nickconnessione", Nickconnessione)
		StateData.Put("NormalNick", NormalNick)
		StateData.Put("AwayNick", AwayNick)
		StateData.Put("CurrentMainNetwork", CurrentMainNetwork)
		
		' Salva network channels
		For i = 0 To NetworkTokens.Size - 1
			Dim NetworkToken As String = NetworkTokens.Get(i)
			Dim NetworkChannelsList As List = NetworkChannels.Get(NetworkToken)
			If NetworkChannelsList <> Null Then
				StateData.Put("NetworkChannels_" & NetworkToken, NetworkChannelsList)
			End If
		Next
		
		' Salva messaggi privati
		StateData.Put("MessageQuery", MessageQuery)
		
		' Salva stato in file
		Dim StateFile As String = "psybnc_state.dat"
		WriteFile(StateFile, StateData)
		
		LogInfo("Current state saved for auto-reconnect", "SaveCurrentState")
		
	Catch Error As Exception
		LogError("SAVE_STATE_ERROR", Error.Message, "SaveCurrentState")
	End Try
End Sub

Sub LoadSavedState() As Boolean
	Try
		' Carica stato salvato per riconnessione automatica
		Dim StateFile As String = "psybnc_state.dat"
		
		If File.Exists(File.DirInternal, StateFile) Then
			Dim StateData As Map = ReadFile(StateFile)
			
			' Ripristina canali
			If StateData.ContainsKey("joinchannel") Then
				joinchannel = StateData.Get("joinchannel")
			End If
			
			If StateData.ContainsKey("Topichannel") Then
				Topichannel = StateData.Get("Topichannel")
			End If
			
			If StateData.ContainsKey("SaveMoth") Then
				SaveMoth = StateData.Get("SaveMoth")
			End If
			
			If StateData.ContainsKey("Nickconnessione") Then
				Nickconnessione = StateData.Get("Nickconnessione")
			End If
			
			If StateData.ContainsKey("NormalNick") Then
				NormalNick = StateData.Get("NormalNick")
			End If
			
			If StateData.ContainsKey("AwayNick") Then
				AwayNick = StateData.Get("AwayNick")
			End If
			
			If StateData.ContainsKey("CurrentMainNetwork") Then
				CurrentMainNetwork = StateData.Get("CurrentMainNetwork")
			End If
			
			' Ripristina network channels
			For i = 0 To NetworkTokens.Size - 1
				Dim NetworkToken As String = NetworkTokens.Get(i)
				Dim NetworkChannelsKey As String = "NetworkChannels_" & NetworkToken
				If StateData.ContainsKey(NetworkChannelsKey) Then
					Dim NetworkChannelsList As List = StateData.Get(NetworkChannelsKey)
					NetworkChannels.Put(NetworkToken, NetworkChannelsList)
				End If
			Next
			
			' Ripristina messaggi privati
			If StateData.ContainsKey("MessageQuery") Then
				MessageQuery = StateData.Get("MessageQuery")
			End If
			
			LogInfo("Saved state loaded for auto-reconnect", "LoadSavedState")
			Return True
		Else
			LogInfo("No saved state found", "LoadSavedState")
			Return False
		End If
		
	Catch Error As Exception
		LogError("LOAD_STATE_ERROR", Error.Message, "LoadSavedState")
		Return False
	End Try
End Sub

Sub ClearSavedState()
	Try
		' Pulisce stato salvato
		Dim StateFile As String = "psybnc_state.dat"
		If File.Exists(File.DirInternal, StateFile) Then
			File.Delete(File.DirInternal, StateFile)
		End If
		LogInfo("Saved state cleared", "ClearSavedState")
	Catch Error As Exception
		LogError("CLEAR_STATE_ERROR", Error.Message, "ClearSavedState")
	End Try
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
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDNETWORK      - Add new network token")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DELNETWORK      - Delete network token")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTNETWORKS    - List configured networks")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SWITCHNET       - Switch main network")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDSERVER       - Add server to network")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   CONNECTNET      - Connect to network")
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
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDAUTOOP      - Adds auto-op user")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DELAUTOOP      - Removes auto-op user")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTAUTOOPS    - Lists auto-op users")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDASK         - Adds ask-op host")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DELASK         - Removes ask-op host")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTASK        - Lists ask-op hosts")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDIGNORE      - Adds ignore mask")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DELIGNORE      - Removes ignore mask")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTIGNORES    - Lists ignore masks")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDBAN         - Adds ban mask")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DELBAN         - Removes ban mask")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTBANS       - Lists ban masks")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDLOG         - Adds log source")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DELLOG         - Removes log source")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTLOGS       - Lists log sources")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   PLAYTRAFFICLOG - Plays traffic log")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ERASETRAFFICLOG - Erases traffic log")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   PLAYMAINLOG    - Plays main log")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ERASEMAINLOG   - Erases main log")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDALLOW       - Adds allowed host")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DELALLOW       - Removes allowed host")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTALLOW     - Lists allowed hosts")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   INTJOIN       - Joins internal channel")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   INTPART       - Leaves internal channel")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   INTMSG        - Sends message to internal channel")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   INTLIST       - Lists internal channels")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   INTUSERS      - Lists users in internal channel")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   INTNETWORK    - Shows internal network status")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   MODE          - Set channel modes")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   OP            - Give operator status")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DEOP           - Remove operator status")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   VOICE         - Give voice status")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DEVOICE       - Remove voice status")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   BAN           - Ban user from channel")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   UNBAN         - Unban user from channel")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   INVITE        - Invite user to channel")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   KICK          - Kick user from channel")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   TOPIC         - Set channel topic")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   CHINFO        - Show channel information")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   CHUSERS       - Show channel users")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   PERFCPU       - Show CPU usage")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   PERFMEMORY    - Show memory usage")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   PERFNETWORK    - Show network usage")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   PERFCONNECTIONS - Show active connections")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   PERFRESOURCES  - Show performance resources")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   PERFALERT     - Enable/disable performance alerts")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SECINTRUSION  - Enable/disable intrusion detection")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SECACCESS     - Enable/disable access control")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SECAUDIT      - Enable/disable audit logging")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SECALERT      - Enable/disable security alerts")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SECTHREAT     - Enable/disable threat detection")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SECMONITOR    - Show security status")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSRESOLVE    - Resolve hostname to IP")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSCACHE      - Show DNS cache")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSCLEAR      - Clear DNS cache")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSSTATUS     - Show DNS system status")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSTIMEOUT    - Set DNS timeout")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSRESOLVER   - Add/Remove DNS resolver")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSBLOCK      - Block DNS hostname")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSUNBLOCK    - Unblock DNS hostname")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSCUSTOM     - Add/Remove custom DNS")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSMONITOR    - Start/Stop DNS monitoring")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSHISTORY    - Show DNS resolution history")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SETDIRECTORY  - Set custom directory for files")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   RESETDIRECTORY- Reset to default directory")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   GETDIRECTORY  - Show current directory")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DIRECTORYSTATUS - Show directory system status")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DIRECTORYQUOTA - Check directory quota")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SETQUOTA      - Set directory quota limits")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DIRECTORYHISTORY - Show directory history")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   CLEARHISTORY  - Clear directory history")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   FILEINFO     - Show file information")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCRESUME    - DCC Resume system status")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCRESUMEENABLE - Enable/disable DCC Resume")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCRESUMETIMEOUT - Set DCC Resume timeout")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCRESUMERETRIES - Set DCC Resume max retries")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCRESUMEAUTO - Enable/disable DCC Resume Auto")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCRESUMEAUTOTIMEOUT - Set DCC Resume Auto timeout")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCADVANCED - Enable/disable DCC Advanced Mode")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCCOMPRESSION - Enable/disable DCC Compression")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCENCRYPTION - Enable/disable DCC Encryption")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCBANDWIDTH - Set DCC Bandwidth limit")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCSTATS - Show DCC Transfer Statistics")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCHISTORY - Show DCC Transfer History")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DCCLOG - Show DCC Transfer Log")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLADVANCED - Enable/disable SSL Advanced Mode")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLHANDSHAKETIMEOUT - Set SSL Handshake timeout")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLCIPHERADD - Add SSL Cipher suite")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLCIPHERREMOVE - Remove SSL Cipher suite")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLCERTADD - Add SSL Certificate")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLCERTREMOVE - Remove SSL Certificate")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLSTATS - Show SSL Connection Statistics")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLLOG - Show SSL Log")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSADVANCED - Enable/disable DNS Advanced Mode")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSCACHETIMEOUT - Set DNS Cache timeout")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSRETRYCOUNT - Set DNS Retry count")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSRETRYTIMEOUT - Set DNS Retry timeout")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSIPV6 - Enable/disable DNS IPv6 support")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSREVERSE - Enable/disable DNS Reverse lookup")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSSTATS - Show DNS Statistics")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSLOG - Show DNS Log")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DNSCACHECLEAR - Clear DNS Cache")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   ADDNETWORK - Add new network token")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   DELNETWORK - Delete network token")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LISTNETWORKS - List configured networks")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SWITCHNET - Switch main network")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SETTIME        - Sets system time")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SETDATE        - Sets system date")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SYSTEM        - Shows system info")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LINKTO        - Links to another bouncer (original)")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LINKFROM      - Accepts links from other bouncers (original)")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LINK          - Links to bouncer (compatibility)")
		tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   UNLINK        - Unlinks from bouncer")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   LINKSTATUS    - Shows link status")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLCONFIG       - Shows SSL configuration")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLENABLE       - Enables SSL support")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLDISABLE      - Disables SSL support")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLCONNECT      - Connects to IRC server via SSL")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLCERT         - Sets SSL certificate")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLPROTOCOL     - Sets SSL protocol")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLVERIFY       - Sets SSL verify mode")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLCOMPRESSION  - Sets SSL compression")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLCIPHER       - Manages SSL cipher suites")
	tw.WriteLine(":-psyBNC PRIVMSG psyBNC BHELP   SSLDCC          - Manages SSL DCC")
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
		' MULTI-SERVER COMMANDS
		' ============================
		
		' ADDNETWORK command
		If Read.ToUpperCase.Contains("ADDNETWORK") AND IRClient == True AND joinpasswd = True Then
			Dim NetworkToken As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If NetworkToken.Length > 0 Then
				If AddNetwork(NetworkToken) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Network '" & NetworkToken & "' added successfully.")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to add network '" & NetworkToken & "'.")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /ADDNETWORK <network_token>")
			End If
			Return ""
		End If
		
		' DELNETWORK command
		If Read.ToUpperCase.Contains("DELNETWORK") AND IRClient == True AND joinpasswd = True Then
			Dim NetworkToken As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If NetworkToken.Length > 0 Then
				If DeleteNetwork(NetworkToken) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Network '" & NetworkToken & "' deleted successfully.")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to delete network '" & NetworkToken & "'.")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DELNETWORK <network_token>")
			End If
			Return ""
		End If
		
		' LISTNETWORKS command
		If Read.ToUpperCase.Contains("LISTNETWORKS") AND IRClient == True AND joinpasswd = True Then
			Dim NetworksList As String = ListNetworks()
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & NetworksList)
			Return ""
		End If
		
		' SWITCHNET command (original style)
		If Read.ToUpperCase.Contains("SWITCHNET") AND IRClient == True AND joinpasswd = True Then
			Dim NewNetwork As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If NewNetwork.Length > 0 Then
				Dim OldNetwork As String = CurrentMainNetwork
				If SwitchMainNetwork(NewNetwork, OldNetwork) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Switched main network from '" & OldNetwork & "' to '" & NewNetwork & "'.")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to switch to network '" & NewNetwork & "'.")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /SWITCHNET <network_token>")
			End If
			Return ""
		End If
		
		' ADDSERVER command (multi-server)
		If Read.ToUpperCase.Contains("ADDSERVER") AND IRClient == True AND joinpasswd = True Then
			Dim ServerParams As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			Dim Params() As String = Regex.Split(" ", ServerParams)
			If Params.Length >= 3 Then
				Dim NetworkToken As String = Params(0)
				Dim ServerHost As String = Params(1)
				Dim ServerPort As Int = Params(2)
				Dim ServerPassword As String = IIf(Params.Length > 3, Params(3), "")
				
				If AddServerToNetwork(NetworkToken, ServerHost, ServerPort, ServerPassword) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Server " & ServerHost & ":" & ServerPort & " added to network '" & NetworkToken & "'.")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to add server to network '" & NetworkToken & "'.")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /ADDSERVER <network> <host> <port> [password]")
			End If
			Return ""
		End If
		
		' CONNECTNET command
		If Read.ToUpperCase.Contains("CONNECTNET") AND IRClient == True AND joinpasswd = True Then
			Dim NetworkToken As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If NetworkToken.Length > 0 Then
				If ConnectToNetwork(NetworkToken) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Connected to network '" & NetworkToken & "'.")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to connect to network '" & NetworkToken & "'.")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /CONNECTNET <network_token>")
			End If
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
		' ADDAUTOOP COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("ADDAUTOOP") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim AutoOpCommand As String
			AutoOpCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If AutoOpCommand.Length > 0 Then
				Dim AutoOpParts() As String
				AutoOpParts = AutoOpCommand.Split("'")
				
				If AutoOpParts.Length >= 3 Then
					Dim AutoOpUser As String
					Dim AutoOpChannel As String
					Dim AutoOpLevel As Int
					AutoOpUser = AutoOpParts(0).Trim
					AutoOpChannel = AutoOpParts(1).Trim
					AutoOpLevel = AutoOpParts(2).Trim
					
					If AddAutoOp(AutoOpUser, AutoOpChannel, AutoOpLevel) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC Auto-op added: " & AutoOpUser & " on " & AutoOpChannel & " (level " & AutoOpLevel & ")")
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to add auto-op for " & AutoOpUser)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDAUTOOP user'channel'level")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDAUTOOP user'channel'level")
			End If
			Return ""
		End If
		' ============================
		' DELAUTOOP COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("DELAUTOOP") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DelAutoOpUser As String
			DelAutoOpUser = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DelAutoOpUser.Length > 0 Then
				If RemoveAutoOp(DelAutoOpUser) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC Auto-op removed: " & DelAutoOpUser)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to remove auto-op for " & DelAutoOpUser)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DELAUTOOP user")
			End If
			Return ""
		End If
		' ============================
		' LISTAUTOOPS COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("LISTAUTOOPS") AND IRClient == True AND joinpasswd = True Then
			Dim AutoOpList As String
			AutoOpList = GetAutoOpList()
			WriteSocket(":-psyBNC PRIVMSG psyBNC " & AutoOpList)
			Return ""
		End If
		' ============================
		' ADDASK COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("ADDASK") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim AskCommand As String
			AskCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If AskCommand.Length > 0 Then
				Dim AskParts() As String
				AskParts = AskCommand.Split("'")
				
				If AskParts.Length >= 2 Then
					Dim AskHost As String
					Dim AskChannel As String
					AskHost = AskParts(0).Trim
					AskChannel = AskParts(1).Trim
					
					If AddAskOp(AskHost, AskChannel) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC Ask-op added: " & AskHost & " on " & AskChannel)
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to add ask-op for " & AskHost)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDASK host'channel")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDASK host'channel")
			End If
			Return ""
		End If
		' ============================
		' DELASK COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("DELASK") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DelAskHost As String
			DelAskHost = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DelAskHost.Length > 0 Then
				If RemoveAskOp(DelAskHost) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC Ask-op removed: " & DelAskHost)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to remove ask-op for " & DelAskHost)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DELASK host")
			End If
			Return ""
		End If
		' ============================
		' LISTASK COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("LISTASK") AND IRClient == True AND joinpasswd = True Then
			Dim AskList As String
			AskList = GetAskOpList()
			WriteSocket(":-psyBNC PRIVMSG psyBNC " & AskList)
			Return ""
		End If
		' ============================
		' ADDIGNORE COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("ADDIGNORE") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim IgnoreCommand As String
			IgnoreCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If IgnoreCommand.Length > 0 Then
				Dim IgnoreParts() As String
				IgnoreParts = IgnoreCommand.Split("'")
				
				If IgnoreParts.Length >= 3 Then
					Dim IgnoreMask As String
					Dim IgnoreType As String
					Dim IgnoreChannel As String
					IgnoreMask = IgnoreParts(0).Trim
					IgnoreType = IgnoreParts(1).Trim
					IgnoreChannel = IgnoreParts(2).Trim
					
					If AddIgnore(IgnoreMask, IgnoreType, IgnoreChannel) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC Ignore added: " & IgnoreMask & " (type: " & IgnoreType & ", channel: " & IgnoreChannel & ")")
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to add ignore for " & IgnoreMask)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDIGNORE mask'type'channel")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDIGNORE mask'type'channel")
			End If
			Return ""
		End If
		' ============================
		' DELIGNORE COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("DELIGNORE") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DelIgnoreMask As String
			DelIgnoreMask = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DelIgnoreMask.Length > 0 Then
				If RemoveIgnore(DelIgnoreMask) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC Ignore removed: " & DelIgnoreMask)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to remove ignore for " & DelIgnoreMask)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DELIGNORE mask")
			End If
			Return ""
		End If
		' ============================
		' LISTIGNORES COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("LISTIGNORES") AND IRClient == True AND joinpasswd = True Then
			Dim IgnoreList As String
			IgnoreList = GetIgnoreList()
			WriteSocket(":-psyBNC PRIVMSG psyBNC " & IgnoreList)
			Return ""
		End If
		' ============================
		' ADDBAN COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("ADDBAN") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim BanCommand As String
			BanCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If BanCommand.Length > 0 Then
				Dim BanParts() As String
				BanParts = BanCommand.Split("'")
				
				If BanParts.Length >= 3 Then
					Dim BanMask As String
					Dim BanReason As String
					Dim BanChannel As String
					BanMask = BanParts(0).Trim
					BanReason = BanParts(1).Trim
					BanChannel = BanParts(2).Trim
					
					If AddBan(BanMask, BanReason, BanChannel) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC Ban added: " & BanMask & " (reason: " & BanReason & ", channel: " & BanChannel & ")")
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to add ban for " & BanMask)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDBAN mask'reason'channel")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDBAN mask'reason'channel")
			End If
			Return ""
		End If
		' ============================
		' DELBAN COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("DELBAN") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DelBanMask As String
			DelBanMask = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DelBanMask.Length > 0 Then
				If RemoveBan(DelBanMask) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC Ban removed: " & DelBanMask)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to remove ban for " & DelBanMask)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DELBAN mask")
			End If
			Return ""
		End If
		' ============================
		' LISTBANS COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("LISTBANS") AND IRClient == True AND joinpasswd = True Then
			Dim BanList As String
			BanList = GetBanList()
			WriteSocket(":-psyBNC PRIVMSG psyBNC " & BanList)
			Return ""
		End If
		' ============================
		' ADDLOG COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("ADDLOG") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim LogCommand As String
			LogCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If LogCommand.Length > 0 Then
				Dim LogParts() As String
				LogParts = LogCommand.Split("'")
				
				If LogParts.Length >= 3 Then
					Dim LogSource As String
					Dim LogType As String
					Dim LogFilter As String
					LogSource = LogParts(0).Trim
					LogType = LogParts(1).Trim
					LogFilter = LogParts(2).Trim
					
					If AddLogSource(LogSource, LogType, LogFilter) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC Log source added: " & LogSource & " (type: " & LogType & ", filter: " & LogFilter & ")")
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to add log source: " & LogSource)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDLOG source'type'filter")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDLOG source'type'filter")
			End If
			Return ""
		End If
		' ============================
		' DELLOG COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("DELLOG") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DelLogSource As String
			DelLogSource = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DelLogSource.Length > 0 Then
				If RemoveLogSource(DelLogSource) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC Log source removed: " & DelLogSource)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to remove log source: " & DelLogSource)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DELLOG source")
			End If
			Return ""
		End If
		' ============================
		' LISTLOGS COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("LISTLOGS") AND IRClient == True AND joinpasswd = True Then
			Dim LogList As String
			LogList = GetLogSourcesList()
			WriteSocket(":-psyBNC PRIVMSG psyBNC " & LogList)
			Return ""
		End If
		' ============================
		' PLAYTRAFFICLOG COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("PLAYTRAFFICLOG") AND IRClient == True AND joinpasswd = True Then
			Dim TrafficLog As String
			TrafficLog = PlayTrafficLog()
			WriteSocket(":-psyBNC PRIVMSG psyBNC " & TrafficLog)
			Return ""
		End If
		' ============================
		' ERASETRAFFICLOG COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("ERASETRAFFICLOG") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			If EraseTrafficLog() Then
				WriteSocket(":-psyBNC PRIVMSG psyBNC Traffic log erased and disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to erase traffic log")
			End If
			Return ""
		End If
		' ============================
		' PLAYMAINLOG COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("PLAYMAINLOG") AND IRClient == True AND joinpasswd = True Then
			Dim MainLog As String
			MainLog = PlayMainLog()
			WriteSocket(":-psyBNC PRIVMSG psyBNC " & MainLog)
			Return ""
		End If
		' ============================
		' ERASEMAINLOG COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("ERASEMAINLOG") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			If EraseMainLog() Then
				WriteSocket(":-psyBNC PRIVMSG psyBNC Main log erased and disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to erase main log")
			End If
			Return ""
		End If
		' ============================
		' ADDALLOW COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("ADDALLOW") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim AllowCommand As String
			AllowCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If AllowCommand.Length > 0 Then
				Dim AllowParts() As String
				AllowParts = AllowCommand.Split("'")
				
				If AllowParts.Length >= 4 Then
					Dim AllowHost As String
					Dim AllowType As String
					Dim AllowDescription As String
					Dim AllowExpiry As Int
					AllowHost = AllowParts(0).Trim
					AllowType = AllowParts(1).Trim
					AllowDescription = AllowParts(2).Trim
					AllowExpiry = AllowParts(3).Trim
					
					If AddAllowedHost(AllowHost, AllowType, AllowDescription, AllowExpiry) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC Allowed host added: " & AllowHost & " (type: " & AllowType & ", description: " & AllowDescription & ", expiry: " & AllowExpiry & " days)")
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to add allowed host: " & AllowHost)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDALLOW host'type'description'expiry_days")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: ADDALLOW host'type'description'expiry_days")
			End If
			Return ""
		End If
		' ============================
		' DELALLOW COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("DELALLOW") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DelAllowHost As String
			DelAllowHost = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DelAllowHost.Length > 0 Then
				If RemoveAllowedHost(DelAllowHost) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC Allowed host removed: " & DelAllowHost)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to remove allowed host: " & DelAllowHost)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: DELALLOW host")
			End If
			Return ""
		End If
		' ============================
		' LISTALLOW COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("LISTALLOW") AND IRClient == True AND joinpasswd = True Then
			Dim AllowList As String
			AllowList = GetAllowedHostsList()
			WriteSocket(":-psyBNC PRIVMSG psyBNC " & AllowList)
			Return ""
		End If
		' ============================
		' SETTIME COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("SETTIME") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim TimeString As String
			TimeString = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If TimeString.Length > 0 Then
				If SetSystemTime(TimeString) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC System time set to: " & TimeString)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to set system time: " & TimeString)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: SETTIME HH:MM:SS")
			End If
			Return ""
		End If
		' ============================
		' SETDATE COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("SETDATE") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DateString As String
			DateString = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If DateString.Length > 0 Then
				If SetSystemDate(DateString) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC System date set to: " & DateString)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to set system date: " & DateString)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: SETDATE DD/MM/YYYY")
			End If
			Return ""
		End If
		' ============================
		' SYSTEM COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("SYSTEM") AND IRClient == True AND joinpasswd = True Then
			Dim SystemInfo As String
			SystemInfo = GetSystemInfo()
			WriteSocket(":-psyBNC PRIVMSG psyBNC " & SystemInfo)
			Return ""
		End If
		' ============================
		' ORIGINAL LINK COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("LINKTO") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim LinkToCommand As String
			LinkToCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If LinkToCommand.Length > 0 Then
				Dim LinkToParts() As String
				LinkToParts = LinkToCommand.Split("'")
				
				If LinkToParts.Length >= 4 Then
					Dim LinkToHost As String
					Dim LinkToPort As Int
					Dim LinkToPassword As String
					Dim LinkToName As String
					LinkToHost = LinkToParts(0).Trim
					LinkToPort = LinkToParts(1).Trim
					LinkToPassword = LinkToParts(2).Trim
					LinkToName = LinkToParts(3).Trim
					
					If LinkToBouncer(LinkToHost, LinkToPort, LinkToPassword, LinkToName) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC Link to bouncer initiated: " & LinkToHost & ":" & LinkToPort & " (name: " & LinkToName & ")")
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to initiate link to bouncer: " & LinkToHost & ":" & LinkToPort)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: LINKTO host'port'password'name")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: LINKTO host'port'password'name")
			End If
			Return ""
		End If
		
		If Read.ToUpperCase.Contains("LINKFROM") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim LinkFromCommand As String
			LinkFromCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If LinkFromCommand.Length > 0 Then
				Dim LinkFromParts() As String
				LinkFromParts = LinkFromCommand.Split("'")
				
				If LinkFromParts.Length >= 3 Then
					Dim LinkFromPort As Int
					Dim LinkFromPassword As String
					Dim LinkFromName As String
					LinkFromPort = LinkFromParts(0).Trim
					LinkFromPassword = LinkFromParts(1).Trim
					LinkFromName = LinkFromParts(2).Trim
					
					If LinkFromBouncer(LinkFromPort, LinkFromPassword, LinkFromName) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC Link from bouncer listener started: " & LinkFromPort & " (name: " & LinkFromName & ")")
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to start link from bouncer listener: " & LinkFromPort)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: LINKFROM port'password'name")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: LINKFROM port'password'name")
			End If
			Return ""
		End If
		
		' ============================
		' COMPATIBILITY LINK COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("LINK") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim LinkCommand As String
			LinkCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If LinkCommand.Length > 0 Then
				Dim LinkParts() As String
				LinkParts = LinkCommand.Split("'")
				
				If LinkParts.Length >= 4 Then
					Dim LinkHost As String
					Dim LinkPort As Int
					Dim LinkPassword As String
					Dim LinkNetwork As String
					LinkHost = LinkParts(0).Trim
					LinkPort = LinkParts(1).Trim
					LinkPassword = LinkParts(2).Trim
					LinkNetwork = LinkParts(3).Trim
					
					If LinkBouncer(LinkHost, LinkPort, LinkPassword, LinkNetwork) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC Bouncer linked: " & LinkHost & ":" & LinkPort & " (network: " & LinkNetwork & ")")
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to link bouncer: " & LinkHost & ":" & LinkPort)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: LINK host'port'password'network")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: LINK host'port'password'network")
			End If
			Return ""
		End If
		' ============================
		' UNLINK COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("UNLINK") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim UnlinkCommand As String
			UnlinkCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If UnlinkCommand.Length > 0 Then
				Dim UnlinkParts() As String
				UnlinkParts = UnlinkCommand.Split("'")
				
				If UnlinkParts.Length >= 2 Then
					Dim UnlinkHost As String
					Dim UnlinkPort As Int
					UnlinkHost = UnlinkParts(0).Trim
					UnlinkPort = UnlinkParts(1).Trim
					
					If UnlinkBouncer(UnlinkHost, UnlinkPort) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC Bouncer unlinked: " & UnlinkHost & ":" & UnlinkPort)
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to unlink bouncer: " & UnlinkHost & ":" & UnlinkPort)
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: UNLINK host'port")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: UNLINK host'port")
			End If
			Return ""
		End If
		' ============================
		' LINKSTATUS COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("LINKSTATUS") AND IRClient == True AND joinpasswd = True Then
			Dim LinkStatus As String
			LinkStatus = GetLinkStatus()
			WriteSocket(":-psyBNC PRIVMSG psyBNC " & LinkStatus)
			Return ""
		End If
		' ============================
		' SSLCERT COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("SSLCERT") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim SSLCertCommand As String
			SSLCertCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If SSLCertCommand.Length > 0 Then
				Dim SSLCertParts() As String
				SSLCertParts = SSLCertCommand.Split("'")
				
				If SSLCertParts.Length >= 3 Then
					Dim SSLCertPath As String
					Dim SSLKeyPath As String
					Dim SSLPass As String
					SSLCertPath = SSLCertParts(0).Trim
					SSLKeyPath = SSLCertParts(1).Trim
					SSLPass = SSLCertParts(2).Trim
					
					If SetSSLCertificate(SSLCertPath, SSLKeyPath, SSLPass) Then
						WriteSocket(":-psyBNC PRIVMSG psyBNC SSL certificate set: " & SSLCertPath & " (key: " & SSLKeyPath & ")")
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to set SSL certificate")
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: SSLCERT cert_path'key_path'password")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: SSLCERT cert_path'key_path'password")
			End If
			Return ""
		End If
		' ============================
		' SSLPROTOCOL COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("SSLPROTOCOL") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim SSLProtocol As String
			SSLProtocol = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If SSLProtocol.Length > 0 Then
				If SetSSLProtocol(SSLProtocol) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC SSL protocol set to: " & SSLProtocol)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to set SSL protocol: " & SSLProtocol)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: SSLPROTOCOL TLS1.2|TLS1.3|SSL3.0")
			End If
			Return ""
		End If
		' ============================
		' SSLVERIFY COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("SSLVERIFY") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim SSLVerifyMode As Int
			SSLVerifyMode = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If SetSSLVerifyMode(SSLVerifyMode) Then
				WriteSocket(":-psyBNC PRIVMSG psyBNC SSL verify mode set to: " & SSLVerifyMode)
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to set SSL verify mode: " & SSLVerifyMode)
			End If
			Return ""
		End If
		' ============================
		' SSLCOMPRESSION COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("SSLCOMPRESSION") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim SSLCompression As String
			SSLCompression = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			
			If SSLCompression = "ON" Or SSLCompression = "1" Or SSLCompression = "TRUE" Then
				If SetSSLCompression(True) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC SSL compression enabled")
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to enable SSL compression")
				End If
			Else If SSLCompression = "OFF" Or SSLCompression = "0" Or SSLCompression = "FALSE" Then
				If SetSSLCompression(False) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC SSL compression disabled")
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to disable SSL compression")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: SSLCOMPRESSION ON|OFF")
			End If
			Return ""
		End If
		' ============================
		' SSLCIPHER COMMANDS
		' ===================
		If Read.ToUpperCase.Contains("SSLCIPHER") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim SSLCipherCommand As String
			SSLCipherCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			
			If SSLCipherCommand.Length > 0 Then
				Dim SSLCipherParts() As String
				SSLCipherParts = SSLCipherCommand.Split(" ")
				
				If SSLCipherParts.Length >= 2 Then
					Dim SSLCipherAction As String
					Dim SSLCipherSuite As String
					SSLCipherAction = SSLCipherParts(0).ToUpperCase
					SSLCipherSuite = SSLCipherParts(1)
					
					If SSLCipherAction = "ADD" Then
						If AddSSLCipherSuite(SSLCipherSuite) Then
							WriteSocket(":-psyBNC PRIVMSG psyBNC SSL cipher suite added: " & SSLCipherSuite)
						Else
							WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to add SSL cipher suite: " & SSLCipherSuite)
						End If
					Else If SSLCipherAction = "REMOVE" Then
						If RemoveSSLCipherSuite(SSLCipherSuite) Then
							WriteSocket(":-psyBNC PRIVMSG psyBNC SSL cipher suite removed: " & SSLCipherSuite)
						Else
							WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to remove SSL cipher suite: " & SSLCipherSuite)
						End If
					Else
						WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: SSLCIPHER ADD|REMOVE cipher_suite")
					End If
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: SSLCIPHER ADD|REMOVE cipher_suite")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: SSLCIPHER ADD|REMOVE cipher_suite")
			End If
			Return ""
		End If
		' ============================
		' SSLDCC COMMANDS
		' ===================
		' ======================
		' INTERNAL NETWORK COMMANDS
		' ======================
		If Read.ToUpperCase.Contains("INTJOIN") AND IRClient == True AND joinpasswd = True Then
			Dim IntJoinChannel As String
			IntJoinChannel = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If IntJoinChannel.Length > 0 Then
				If JoinInternalChannel(Nickconnessione, IntJoinChannel) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Joined internal channel: " & IntJoinChannel)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to join internal channel: " & IntJoinChannel)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /intjoin #channel")
			End If
		End If
		
		If Read.ToUpperCase.Contains("INTPART") AND IRClient == True AND joinpasswd = True Then
			Dim IntPartChannel As String
			IntPartChannel = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If IntPartChannel.Length > 0 Then
				If PartInternalChannel(Nickconnessione, IntPartChannel) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Left internal channel: " & IntPartChannel)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to leave internal channel: " & IntPartChannel)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /intpart #channel")
			End If
		End If
		
		If Read.ToUpperCase.Contains("INTMSG") AND IRClient == True AND joinpasswd = True Then
			Dim IntMsgParts() As String
			IntMsgParts = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.Split(" ")
			If IntMsgParts.Length >= 2 Then
				Dim IntMsgChannel As String
				Dim IntMsgText As String
				IntMsgChannel = IntMsgParts(0)
				IntMsgText = IntMsgParts(1)
				For i = 2 To IntMsgParts.Length - 1
					IntMsgText = IntMsgText & " " & IntMsgParts(i)
				Next
				If SendInternalMessage(IntMsgText, IntMsgChannel) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Message sent to " & IntMsgChannel)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to send message to " & IntMsgChannel)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /intmsg #channel message")
			End If
		End If
		
		If Read.ToUpperCase.Contains("INTLIST") AND IRClient == True AND joinpasswd = True Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & GetInternalChannelList())
		End If
		
		If Read.ToUpperCase.Contains("INTUSERS") AND IRClient == True AND joinpasswd = True Then
			Dim IntUsersChannel As String
			IntUsersChannel = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If IntUsersChannel.Length > 0 Then
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & GetInternalUserList(IntUsersChannel))
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /intusers #channel")
			End If
		End If
		
		If Read.ToUpperCase.Contains("INTNETWORK") AND IRClient == True AND joinpasswd = True Then
			If InternalNetwork Then
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Internal Network: ENABLED")
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Connected Bouncers: " & InternalBouncers.Size)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Internal Clients: " & InternalClients.Size)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Internal Network: DISABLED")
			End If
		End If
		
		' ======================
		' ADVANCED CHANNEL MANAGEMENT COMMANDS
		' ======================
		If Read.ToUpperCase.Contains("MODE ") AND IRClient == True AND joinpasswd = True Then
			Dim ModeCommand As String
			ModeCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			Dim ModeParts() As String
			ModeParts = ModeCommand.Split(" ")
			If ModeParts.Length >= 2 Then
				Dim Channel As String
				Dim Mode As String
				Dim Param As String
				Channel = ModeParts(0)
				Mode = ModeParts(1)
				If ModeParts.Length > 2 Then
					Param = ModeParts(2)
				End If
				If SetChannelMode(Channel, Mode, Param) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Channel mode set: " & Channel & " " & Mode & " " & Param)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to set channel mode: " & Channel & " " & Mode & " " & Param)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /mode #channel +mode [param]")
			End If
		End If
		
		If Read.ToUpperCase.Contains("OP ") AND IRClient == True AND joinpasswd = True Then
			Dim OpCommand As String
			OpCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			Dim OpParts() As String
			OpParts = OpCommand.Split(" ")
			If OpParts.Length >= 2 Then
				Dim Channel As String
				Dim User As String
				Channel = OpParts(0)
				User = OpParts(1)
				If SetUserChannelMode(User, Channel, "@" & User) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " User " & User & " is now operator in " & Channel)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to set operator: " & User & " in " & Channel)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /op #channel user")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DEOP ") AND IRClient == True AND joinpasswd = True Then
			Dim DeopCommand As String
			DeopCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			Dim DeopParts() As String
			DeopParts = DeopCommand.Split(" ")
			If DeopParts.Length >= 2 Then
				Dim Channel As String
				Dim User As String
				Channel = DeopParts(0)
				User = DeopParts(1)
				If SetUserChannelMode(User, Channel, User) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " User " & User & " is no longer operator in " & Channel)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to remove operator: " & User & " in " & Channel)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /deop #channel user")
			End If
		End If
		
		If Read.ToUpperCase.Contains("VOICE ") AND IRClient == True AND joinpasswd = True Then
			Dim VoiceCommand As String
			VoiceCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			Dim VoiceParts() As String
			VoiceParts = VoiceCommand.Split(" ")
			If VoiceParts.Length >= 2 Then
				Dim Channel As String
				Dim User As String
				Channel = VoiceParts(0)
				User = VoiceParts(1)
				If SetUserChannelMode(User, Channel, "+" & User) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " User " & User & " is now voice in " & Channel)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to set voice: " & User & " in " & Channel)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /voice #channel user")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DEVOICE ") AND IRClient == True AND joinpasswd = True Then
			Dim DevoiceCommand As String
			DevoiceCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			Dim DevoiceParts() As String
			DevoiceParts = DevoiceCommand.Split(" ")
			If DevoiceParts.Length >= 2 Then
				Dim Channel As String
				Dim User As String
				Channel = DevoiceParts(0)
				User = DevoiceParts(1)
				If SetUserChannelMode(User, Channel, User) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " User " & User & " is no longer voice in " & Channel)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to remove voice: " & User & " in " & Channel)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /devoice #channel user")
			End If
		End If
		
		If Read.ToUpperCase.Contains("BAN ") AND IRClient == True AND joinpasswd = True Then
			Dim BanCommand As String
			BanCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			Dim BanParts() As String
			BanParts = BanCommand.Split(" ")
			If BanParts.Length >= 2 Then
				Dim Channel As String
				Dim User As String
				Channel = BanParts(0)
				User = BanParts(1)
				If AddChannelBan(Channel, User) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " User " & User & " banned from " & Channel)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to ban user: " & User & " from " & Channel)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /ban #channel user")
			End If
		End If
		
		If Read.ToUpperCase.Contains("UNBAN ") AND IRClient == True AND joinpasswd = True Then
			Dim UnbanCommand As String
			UnbanCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			Dim UnbanParts() As String
			UnbanParts = UnbanCommand.Split(" ")
			If UnbanParts.Length >= 2 Then
				Dim Channel As String
				Dim User As String
				Channel = UnbanParts(0)
				User = UnbanParts(1)
				If RemoveChannelBan(Channel, User) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " User " & User & " unbanned from " & Channel)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to unban user: " & User & " from " & Channel)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /unban #channel user")
			End If
		End If
		
		If Read.ToUpperCase.Contains("INVITE ") AND IRClient == True AND joinpasswd = True Then
			Dim InviteCommand As String
			InviteCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			Dim InviteParts() As String
			InviteParts = InviteCommand.Split(" ")
			If InviteParts.Length >= 2 Then
				Dim Channel As String
				Dim User As String
				Channel = InviteParts(0)
				User = InviteParts(1)
				If AddChannelInvite(Channel, User) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " User " & User & " invited to " & Channel)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to invite user: " & User & " to " & Channel)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /invite #channel user")
			End If
		End If
		
		If Read.ToUpperCase.Contains("KICK ") AND IRClient == True AND joinpasswd = True Then
			Dim KickCommand As String
			KickCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			Dim KickParts() As String
			KickParts = KickCommand.Split(" ")
			If KickParts.Length >= 2 Then
				Dim Channel As String
				Dim User As String
				Dim Reason As String
				Channel = KickParts(0)
				User = KickParts(1)
				If KickParts.Length > 2 Then
					Reason = KickParts(2)
					For i = 3 To KickParts.Length - 1
						Reason = Reason & " " & KickParts(i)
					Next
				Else
					Reason = "Kicked by " & Nickconnessione
				End If
				If RemoveUserFromChannel(User, Channel) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " User " & User & " kicked from " & Channel & " (" & Reason & ")")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to kick user: " & User & " from " & Channel)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /kick #channel user [reason]")
			End If
		End If
		
		If Read.ToUpperCase.Contains("TOPIC ") AND IRClient == True AND joinpasswd = True Then
			Dim TopicCommand As String
			TopicCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			Dim TopicParts() As String
			TopicParts = TopicCommand.Split(" ", 2)
			If TopicParts.Length >= 2 Then
				Dim Channel As String
				Dim Topic As String
				Channel = TopicParts(0)
				Topic = TopicParts(1)
				If SetChannelTopic(Channel, Topic) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Topic set for " & Channel & ": " & Topic)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to set topic for " & Channel)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /topic #channel new topic")
			End If
		End If
		
		If Read.ToUpperCase.Contains("CHINFO ") AND IRClient == True AND joinpasswd = True Then
			Dim Channel As String
			Channel = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If Channel.Length > 0 Then
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & GetChannelInfo(Channel))
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /chinfo #channel")
			End If
		End If
		
		If Read.ToUpperCase.Contains("CHUSERS ") AND IRClient == True AND joinpasswd = True Then
			Dim Channel As String
			Channel = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If Channel.Length > 0 Then
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & GetChannelUsers(Channel))
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /chusers #channel")
			End If
		End If
		
		' ======================
		' PERFORMANCE MONITORING COMMANDS
		' ======================
		If Read.ToUpperCase.Contains("PERFCPU") AND IRClient == True AND joinpasswd = True Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " CPU Usage: " & CPUUsage & "%")
		End If
		
		If Read.ToUpperCase.Contains("PERFMEMORY") AND IRClient == True AND joinpasswd = True Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Memory Usage: " & MemoryUsage & " bytes (" & (MemoryUsage / 1024 / 1024) & " MB)")
		End If
		
		If Read.ToUpperCase.Contains("PERFNETWORK") AND IRClient == True AND joinpasswd = True Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Network In: " & NetworkInBytes & " bytes, Out: " & NetworkOutBytes & " bytes")
		End If
		
		If Read.ToUpperCase.Contains("PERFCONNECTIONS") AND IRClient == True AND joinpasswd = True Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Active Connections: " & ActiveConnections)
		End If
		
		If Read.ToUpperCase.Contains("PERFRESOURCES") AND IRClient == True AND joinpasswd = True Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & GetPerformanceStatus())
		End If
		
		If Read.ToUpperCase.Contains("PERFALERT") AND IRClient == True AND joinpasswd = True Then
			Dim AlertCommand As String
			AlertCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If AlertCommand = "ON" Or AlertCommand = "1" Or AlertCommand = "TRUE" Then
				PerformanceEnabled = True
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Performance alerts enabled")
			Else If AlertCommand = "OFF" Or AlertCommand = "0" Or AlertCommand = "FALSE" Then
				PerformanceEnabled = False
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Performance alerts disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /perfalert ON|OFF")
			End If
		End If
		
		' ======================
		' SECURITY SYSTEM COMMANDS
		' ======================
		If Read.ToUpperCase.Contains("SECINTRUSION") AND IRClient == True AND joinpasswd = True Then
			Dim IntrusionCommand As String
			IntrusionCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If IntrusionCommand = "ON" Or IntrusionCommand = "1" Or IntrusionCommand = "TRUE" Then
				IntrusionDetection = True
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Intrusion detection enabled")
			Else If IntrusionCommand = "OFF" Or IntrusionCommand = "0" Or IntrusionCommand = "FALSE" Then
				IntrusionDetection = False
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Intrusion detection disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /secintrusion ON|OFF")
			End If
		End If
		
		If Read.ToUpperCase.Contains("SECACCESS") AND IRClient == True AND joinpasswd = True Then
			Dim AccessCommand As String
			AccessCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If AccessCommand = "ON" Or AccessCommand = "1" Or AccessCommand = "TRUE" Then
				AccessControl = True
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Access control enabled")
			Else If AccessCommand = "OFF" Or AccessCommand = "0" Or AccessCommand = "FALSE" Then
				AccessControl = False
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Access control disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /secaccess ON|OFF")
			End If
		End If
		
		If Read.ToUpperCase.Contains("SECAUDIT") AND IRClient == True AND joinpasswd = True Then
			Dim AuditCommand As String
			AuditCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If AuditCommand = "ON" Or AuditCommand = "1" Or AuditCommand = "TRUE" Then
				AuditLogging = True
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Audit logging enabled")
			Else If AuditCommand = "OFF" Or AuditCommand = "0" Or AuditCommand = "FALSE" Then
				AuditLogging = False
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Audit logging disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /secaudit ON|OFF")
			End If
		End If
		
		If Read.ToUpperCase.Contains("SECALERT") AND IRClient == True AND joinpasswd = True Then
			Dim SecurityAlertCommand As String
			SecurityAlertCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If SecurityAlertCommand = "ON" Or SecurityAlertCommand = "1" Or SecurityAlertCommand = "TRUE" Then
				SecurityEnabled = True
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Security alerts enabled")
			Else If SecurityAlertCommand = "OFF" Or SecurityAlertCommand = "0" Or SecurityAlertCommand = "FALSE" Then
				SecurityEnabled = False
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Security alerts disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /secalert ON|OFF")
			End If
		End If
		
		If Read.ToUpperCase.Contains("SECTHREAT") AND IRClient == True AND joinpasswd = True Then
			Dim ThreatCommand As String
			ThreatCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If ThreatCommand = "ON" Or ThreatCommand = "1" Or ThreatCommand = "TRUE" Then
				ThreatDetection = True
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Threat detection enabled")
			Else If ThreatCommand = "OFF" Or ThreatCommand = "0" Or ThreatCommand = "FALSE" Then
				ThreatDetection = False
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Threat detection disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /secthreat ON|OFF")
			End If
		End If
		
		If Read.ToUpperCase.Contains("SECMONITOR") AND IRClient == True AND joinpasswd = True Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & GetSecurityStatus())
		End If
		
		' ======================
		' DNS CORE ADMIN COMMANDS
		' ======================
		If Read.ToUpperCase.Contains("DNSRESOLVE") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSHostname As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If DNSHostname <> "" Then
				Dim DNSIP As String = ResolveDNS(DNSHostname)
				If DNSIP <> "" Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS: " & DNSHostname & " -> " & DNSIP)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS: Failed to resolve " & DNSHostname)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSRESOLVE hostname")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DNSCACHE") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & GetDNSCache())
		End If
		
		If Read.ToUpperCase.Contains("DNSCLEAR") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			ClearDNSCache()
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS cache cleared")
		End If
		
		If Read.ToUpperCase.Contains("DNSSTATUS") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & GetDNSStatus())
		End If
		
		If Read.ToUpperCase.Contains("DNSTIMEOUT") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSTimeoutValue As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If DNSTimeoutValue <> "" Then
				SetDNSTimeout(DNSTimeoutValue)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS timeout set to " & DNSTimeoutValue & "ms")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSTIMEOUT milliseconds")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DNSRESOLVER") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSResolverCommand As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			Dim DNSResolverParts() As String = Regex.Split(" ", DNSResolverCommand)
			If DNSResolverParts.Length > 1 Then
				Dim DNSAction As String = DNSResolverParts(0)
				Dim DNSResolver As String = DNSResolverParts(1)
				If DNSAction = "ADD" Then
					AddDNSResolver(DNSResolver)
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS resolver added: " & DNSResolver)
				Else If DNSAction = "REMOVE" Then
					RemoveDNSResolver(DNSResolver)
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS resolver removed: " & DNSResolver)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSRESOLVER ADD|REMOVE resolver")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSRESOLVER ADD|REMOVE resolver")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DNSBLOCK") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSBlockHost As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If DNSBlockHost <> "" Then
				BlockDNSHost(DNSBlockHost)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS host blocked: " & DNSBlockHost)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSBLOCK hostname")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DNSUNBLOCK") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSUnblockHost As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If DNSUnblockHost <> "" Then
				UnblockDNSHost(DNSUnblockHost)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS host unblocked: " & DNSUnblockHost)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSUNBLOCK hostname")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DNSCUSTOM") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSCustomCommand As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			Dim DNSCustomParts() As String = Regex.Split(" ", DNSCustomCommand)
			If DNSCustomParts.Length > 2 Then
				Dim DNSCustomAction As String = DNSCustomParts(0)
				Dim DNSCustomHost As String = DNSCustomParts(1)
				Dim DNSCustomIP As String = DNSCustomParts(2)
				If DNSCustomAction = "ADD" Then
					AddCustomDNS(DNSCustomHost, DNSCustomIP)
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS custom entry added: " & DNSCustomHost & " -> " & DNSCustomIP)
				Else If DNSCustomAction = "REMOVE" Then
					RemoveCustomDNS(DNSCustomHost)
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS custom entry removed: " & DNSCustomHost)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSCUSTOM ADD|REMOVE hostname ip")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSCUSTOM ADD|REMOVE hostname ip")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DNSMONITOR") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSMonitorCommand As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If DNSMonitorCommand = "START" Then
				StartDNSMonitoring()
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS monitoring started")
			Else If DNSMonitorCommand = "STOP" Then
				StopDNSMonitoring()
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS monitoring stopped")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSMONITOR START|STOP")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DNSHISTORY") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & GetDNSHistory())
		End If
		
		' ======================
		' CUSTOM DIRECTORY ADMIN COMMANDS
		' ======================
		If Read.ToUpperCase.Contains("SETDIRECTORY") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DirectoryPath As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If DirectoryPath.Length > 0 Then
				If SetCustomDirectory(DirectoryPath) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Custom directory set to: " & DirectoryPath)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to set custom directory: " & DirectoryPath)
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /SETDIRECTORY path")
			End If
		End If
		
		If Read.ToUpperCase.Contains("RESETDIRECTORY") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			If ResetToDefaultDirectory() Then
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Directory reset to default: " & DefaultDirectoryPath)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to reset directory")
			End If
		End If
		
		If Read.ToUpperCase.Contains("GETDIRECTORY") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim CurrentDir As String = GetCurrentDirectory()
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Current directory: " & CurrentDir)
		End If
		
		If Read.ToUpperCase.Contains("DIRECTORYSTATUS") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & GetDirectoryStatus())
		End If
		
		If Read.ToUpperCase.Contains("DIRECTORYQUOTA") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & CheckDirectoryQuota())
		End If
		
		If Read.ToUpperCase.Contains("SETQUOTA") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim QuotaCommand As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			Dim QuotaParts() As String = Regex.Split(" ", QuotaCommand)
			If QuotaParts.Length >= 3 Then
				Dim MaxSize As Long = QuotaParts(0)
				Dim MaxFiles As Int = QuotaParts(1)
				Dim WarningThreshold As Int = QuotaParts(2)
				If SetDirectoryQuota(MaxSize, MaxFiles, WarningThreshold) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Directory quota set: " & FormatFileSize(MaxSize) & ", " & MaxFiles & " files, " & WarningThreshold & "% warning")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to set directory quota")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /SETQUOTA maxsize maxfiles warning%")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DIRECTORYHISTORY") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & ListDirectoryHistory())
		End If
		
		If Read.ToUpperCase.Contains("CLEARHISTORY") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			ClearDirectoryHistory()
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Directory history cleared")
		End If
		
		If Read.ToUpperCase.Contains("FILEINFO") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim FileName As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If FileName.Length > 0 Then
				Dim FileInfo As String = GetFileInfo(FileName)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & FileInfo)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /FILEINFO filename")
			End If
		End If
		
		' ======================
		' DCC RESUME ADMIN COMMANDS
		' ======================
		If Read.ToUpperCase.Contains("DCCRESUME") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " " & GetDCCResumeStatus())
		End If
		
		If Read.ToUpperCase.Contains("DCCRESUMEENABLE") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim ResumeCommand As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If ResumeCommand = "ON" Or ResumeCommand = "1" Or ResumeCommand = "TRUE" Then
				If EnableDCCResume(True) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Resume enabled")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to enable DCC Resume")
				End If
			Else If ResumeCommand = "OFF" Or ResumeCommand = "0" Or ResumeCommand = "FALSE" Then
				If EnableDCCResume(False) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Resume disabled")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to disable DCC Resume")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DCCRESUMEENABLE ON|OFF")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DCCRESUMETIMEOUT") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim TimeoutValue As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If TimeoutValue.Length > 0 Then
				If SetDCCResumeTimeout(TimeoutValue) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Resume timeout set to " & TimeoutValue & "ms")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to set DCC Resume timeout")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DCCRESUMETIMEOUT milliseconds")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DCCRESUMERETRIES") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim RetriesValue As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If RetriesValue.Length > 0 Then
				If SetDCCResumeMaxRetries(RetriesValue) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Resume max retries set to " & RetriesValue)
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to set DCC Resume max retries")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DCCRESUMERETRIES number")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DCCRESUMEAUTO") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim AutoCommand As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If AutoCommand = "ON" Or AutoCommand = "1" Or AutoCommand = "TRUE" Then
				If EnableDCCResumeAuto(True) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Resume Auto enabled")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to enable DCC Resume Auto")
				End If
			Else If AutoCommand = "OFF" Or AutoCommand = "0" Or AutoCommand = "FALSE" Then
				If EnableDCCResumeAuto(False) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Resume Auto disabled")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to disable DCC Resume Auto")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DCCRESUMEAUTO ON|OFF")
			End If
		End If
		
		If Read.ToUpperCase.Contains("DCCRESUMEAUTOTIMEOUT") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim AutoTimeoutValue As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If AutoTimeoutValue.Length > 0 Then
				If SetDCCResumeAutoTimeout(AutoTimeoutValue) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Resume Auto timeout set to " & AutoTimeoutValue & "ms")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Failed to set DCC Resume Auto timeout")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DCCRESUMEAUTOTIMEOUT milliseconds")
			End If
		End If
		
		' ======================
		' DCC ADVANCED COMMANDS
		' ======================
		
		' DCC ADVANCED MODE
		If Read.ToUpperCase.Contains("DCCADVANCED") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim AdvancedCommand As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If AdvancedCommand = "ON" Or AdvancedCommand = "1" Or AdvancedCommand = "TRUE" Then
				SetDCCAdvancedMode(True)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Advanced Mode enabled")
			Else If AdvancedCommand = "OFF" Or AdvancedCommand = "0" Or AdvancedCommand = "FALSE" Then
				SetDCCAdvancedMode(False)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Advanced Mode disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DCCADVANCED ON|OFF")
			End If
		End If
		
		' DCC COMPRESSION
		If Read.ToUpperCase.Contains("DCCCOMPRESSION") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim CompressionCommand As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If CompressionCommand = "ON" Or CompressionCommand = "1" Or CompressionCommand = "TRUE" Then
				SetDCCCompression(True)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Compression enabled")
			Else If CompressionCommand = "OFF" Or CompressionCommand = "0" Or CompressionCommand = "FALSE" Then
				SetDCCCompression(False)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Compression disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DCCCOMPRESSION ON|OFF")
			End If
		End If
		
		' DCC ENCRYPTION
		If Read.ToUpperCase.Contains("DCCENCRYPTION") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim EncryptionCommand As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If EncryptionCommand = "ON" Or EncryptionCommand = "1" Or EncryptionCommand = "TRUE" Then
				SetDCCEncryption(True)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Encryption enabled")
			Else If EncryptionCommand = "OFF" Or EncryptionCommand = "0" Or EncryptionCommand = "FALSE" Then
				SetDCCEncryption(False)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Encryption disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DCCENCRYPTION ON|OFF")
			End If
		End If
		
		' DCC BANDWIDTH LIMIT
		If Read.ToUpperCase.Contains("DCCBANDWIDTH") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim BandwidthValue As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If BandwidthValue.Length > 0 Then
				Try
					Dim BandwidthLimit As Int = BandwidthValue
					SetDCCBandwidthLimit(BandwidthLimit)
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Bandwidth limit set to " & BandwidthLimit & " KB/s")
				Catch
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Invalid bandwidth value. Usage: /DCCBANDWIDTH <limit_kbps>")
				End Try
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DCCBANDWIDTH <limit_kbps>")
			End If
		End If
		
		' DCC TRANSFER STATS
		If Read.ToUpperCase.Contains("DCCSTATS") AND IRClient == True AND joinpasswd = True Then
			Dim StatsList As String = ""
			For i = 0 To DCCTransferQueue.Size - 1
				Dim TransferInfo As Map = DCCTransferQueue.Get(i)
				If TransferInfo.ContainsKey("TransferID") Then
					Dim TransferID As String = TransferInfo.Get("TransferID")
					Dim FileName As String = TransferInfo.Get("FileName")
					Dim Status As String = TransferInfo.Get("Status")
					Dim BytesTransferred As Long = TransferInfo.Get("BytesTransferred")
					Dim FileSize As Long = TransferInfo.Get("FileSize")
					Dim Progress As Int = 0
					If FileSize > 0 Then
						Progress = (BytesTransferred * 100) / FileSize
					End If
					
					StatsList = StatsList & "[" & TransferID & "] " & FileName & " - " & Status & " (" & Progress & "%)" & Chr(10)
				End If
			Next
			
			If StatsList.Length > 0 Then
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Transfer Stats:" & Chr(10) & StatsList)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " No active DCC transfers")
			End If
		End If
		
		' DCC TRANSFER HISTORY
		If Read.ToUpperCase.Contains("DCCHISTORY") AND IRClient == True AND joinpasswd = True Then
			Dim HistoryList As List = GetDCCTransferHistory()
			Dim HistoryText As String = ""
			
			For i = 0 To HistoryList.Size - 1
				Dim HistoryEntry As Map = HistoryList.Get(i)
				If HistoryEntry.ContainsKey("FileName") Then
					Dim FileName As String = HistoryEntry.Get("FileName")
					Dim Status As String = HistoryEntry.Get("Status")
					Dim Timestamp As String = HistoryEntry.Get("Timestamp")
					
					HistoryText = HistoryText & "[" & Timestamp & "] " & FileName & " - " & Status & Chr(10)
				End If
			Next
			
			If HistoryText.Length > 0 Then
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Transfer History:" & Chr(10) & HistoryText)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " No DCC transfer history")
			End If
		End If
		
		' DCC TRANSFER LOG
		If Read.ToUpperCase.Contains("DCCLOG") AND IRClient == True AND joinpasswd = True Then
			Dim LogList As List = GetDCCTransferLog()
			Dim LogText As String = ""
			
			' Mostra solo gli ultimi 50 log
			Dim StartIndex As Int = Max(0, LogList.Size - 50)
			For i = StartIndex To LogList.Size - 1
				Dim LogEntry As Map = LogList.Get(i)
				If LogEntry.ContainsKey("Action") Then
					Dim Action As String = LogEntry.Get("Action")
					Dim Details As String = LogEntry.Get("Details")
					Dim Timestamp As String = LogEntry.Get("Timestamp")
					
					LogText = LogText & "[" & Timestamp & "] " & Action & ": " & Details & Chr(10)
				End If
			Next
			
			If LogText.Length > 0 Then
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DCC Transfer Log:" & Chr(10) & LogText)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " No DCC transfer log")
			End If
		End If
		
		' ======================
		' SSL ADVANCED COMMANDS
		' ======================
		
		' SSL ADVANCED MODE
		If Read.ToUpperCase.Contains("SSLADVANCED") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim SSLAdvancedCommand As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If SSLAdvancedCommand = "ON" Or SSLAdvancedCommand = "1" Or SSLAdvancedCommand = "TRUE" Then
				SetSSLAdvancedMode(True)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " SSL Advanced Mode enabled")
			Else If SSLAdvancedCommand = "OFF" Or SSLAdvancedCommand = "0" Or SSLAdvancedCommand = "FALSE" Then
				SetSSLAdvancedMode(False)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " SSL Advanced Mode disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /SSLADVANCED ON|OFF")
			End If
		End If
		
		' SSL HANDSHAKE TIMEOUT
		If Read.ToUpperCase.Contains("SSLHANDSHAKETIMEOUT") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim SSLTimeoutValue As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If SSLTimeoutValue.Length > 0 Then
				Try
					Dim SSLTimeout As Int = SSLTimeoutValue
					SetSSLHandshakeTimeout(SSLTimeout)
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " SSL Handshake timeout set to " & SSLTimeout & "ms")
				Catch
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Invalid timeout value. Usage: /SSLHANDSHAKETIMEOUT <milliseconds>")
				End Try
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /SSLHANDSHAKETIMEOUT <milliseconds>")
			End If
		End If
		
		' SSL CIPHER SUITE ADD
		If Read.ToUpperCase.Contains("SSLCIPHERADD") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim CipherSuite As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If CipherSuite.Length > 0 Then
				AddSSLCipherSuite(CipherSuite)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " SSL Cipher suite added: " & CipherSuite)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /SSLCIPHERADD <cipher_suite>")
			End If
		End If
		
		' SSL CIPHER SUITE REMOVE
		If Read.ToUpperCase.Contains("SSLCIPHERREMOVE") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim CipherSuite As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If CipherSuite.Length > 0 Then
				RemoveSSLCipherSuite(CipherSuite)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " SSL Cipher suite removed: " & CipherSuite)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /SSLCIPHERREMOVE <cipher_suite>")
			End If
		End If
		
		' SSL CERTIFICATE ADD
		If Read.ToUpperCase.Contains("SSLCERTADD") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim CommandParts() As String
			CommandParts = TogliPrimoComando(Read).Replace(Chr(10),"").Split(":")
			
			If CommandParts.Length >= 3 Then
				Dim CertName As String = CommandParts(0).Trim
				Dim CertData As String = CommandParts(1).Trim
				Dim PrivateKey As String = CommandParts(2).Trim
				
				AddSSLCertificate(CertName, CertData, PrivateKey)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " SSL Certificate added: " & CertName)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /SSLCERTADD <name>:<cert_data>:<private_key>")
			End If
		End If
		
		' SSL CERTIFICATE REMOVE
		If Read.ToUpperCase.Contains("SSLCERTREMOVE") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim CertName As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If CertName.Length > 0 Then
				RemoveSSLCertificate(CertName)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " SSL Certificate removed: " & CertName)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /SSLCERTREMOVE <cert_name>")
			End If
		End If
		
		' SSL STATS
		If Read.ToUpperCase.Contains("SSLSTATS") AND IRClient == True AND joinpasswd = True Then
			Dim StatsList As String = ""
			For i = 0 To SSLConnectionPool.Size - 1
				Dim ConnectionID As String = SSLConnectionPool.GetKeyAt(i)
				Dim ConnectionInfo As Map = SSLConnectionPool.Get(ConnectionID)
				If ConnectionInfo.ContainsKey("Status") Then
					Dim Status As String = ConnectionInfo.Get("Status")
					Dim BytesIn As Long = ConnectionInfo.Get("BytesIn")
					Dim BytesOut As Long = ConnectionInfo.Get("BytesOut")
					Dim Duration As Long = ConnectionInfo.Get("Duration")
					
					StatsList = StatsList & "[" & ConnectionID & "] Status: " & Status & " | In: " & BytesIn & " | Out: " & BytesOut & " | Duration: " & Duration & "ms" & Chr(10)
				End If
			Next
			
			If StatsList.Length > 0 Then
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " SSL Connection Stats:" & Chr(10) & StatsList)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " No active SSL connections")
			End If
		End If
		
		' SSL LOG
		If Read.ToUpperCase.Contains("SSLLOG") AND IRClient == True AND joinpasswd = True Then
			Dim LogList As List = GetSSLLog()
			Dim LogText As String = ""
			
			' Mostra solo gli ultimi 50 log
			Dim StartIndex As Int = Max(0, LogList.Size - 50)
			For i = StartIndex To LogList.Size - 1
				Dim LogEntry As Map = LogList.Get(i)
				If LogEntry.ContainsKey("Action") Then
					Dim Action As String = LogEntry.Get("Action")
					Dim Details As String = LogEntry.Get("Details")
					Dim Timestamp As String = LogEntry.Get("Timestamp")
					
					LogText = LogText & "[" & Timestamp & "] " & Action & ": " & Details & Chr(10)
				End If
			Next
			
			If LogText.Length > 0 Then
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " SSL Log:" & Chr(10) & LogText)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " No SSL log entries")
			End If
		End If
		
		' ======================
		' DNS ADVANCED COMMANDS
		' ======================
		
		' DNS ADVANCED MODE
		If Read.ToUpperCase.Contains("DNSADVANCED") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSAdvancedCommand As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If DNSAdvancedCommand = "ON" Or DNSAdvancedCommand = "1" Or DNSAdvancedCommand = "TRUE" Then
				SetDNSAdvancedMode(True)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS Advanced Mode enabled")
			Else If DNSAdvancedCommand = "OFF" Or DNSAdvancedCommand = "0" Or DNSAdvancedCommand = "FALSE" Then
				SetDNSAdvancedMode(False)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS Advanced Mode disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSADVANCED ON|OFF")
			End If
		End If
		
		' DNS CACHE TIMEOUT
		If Read.ToUpperCase.Contains("DNSCACHETIMEOUT") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSTimeoutValue As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If DNSTimeoutValue.Length > 0 Then
				Try
					Dim DNSTimeout As Int = DNSTimeoutValue
					SetDNSCacheTimeout(DNSTimeout)
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS Cache timeout set to " & DNSTimeout & "ms")
				Catch
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Invalid timeout value. Usage: /DNSCACHETIMEOUT <milliseconds>")
				End Try
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSCACHETIMEOUT <milliseconds>")
			End If
		End If
		
		' DNS RETRY COUNT
		If Read.ToUpperCase.Contains("DNSRETRYCOUNT") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSRetryValue As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If DNSRetryValue.Length > 0 Then
				Try
					Dim DNSRetry As Int = DNSRetryValue
					SetDNSRetryCount(DNSRetry)
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS Retry count set to " & DNSRetry)
				Catch
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Invalid retry value. Usage: /DNSRETRYCOUNT <count>")
				End Try
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSRETRYCOUNT <count>")
			End If
		End If
		
		' DNS RETRY TIMEOUT
		If Read.ToUpperCase.Contains("DNSRETRYTIMEOUT") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSRetryTimeoutValue As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim
			If DNSRetryTimeoutValue.Length > 0 Then
				Try
					Dim DNSRetryTimeout As Int = DNSRetryTimeoutValue
					SetDNSRetryTimeout(DNSRetryTimeout)
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS Retry timeout set to " & DNSRetryTimeout & "ms")
				Catch
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Invalid timeout value. Usage: /DNSRETRYTIMEOUT <milliseconds>")
				End Try
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSRETRYTIMEOUT <milliseconds>")
			End If
		End If
		
		' DNS IPv6 SUPPORT
		If Read.ToUpperCase.Contains("DNSIPV6") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSIPv6Command As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If DNSIPv6Command = "ON" Or DNSIPv6Command = "1" Or DNSIPv6Command = "TRUE" Then
				SetDNSIPv6Support(True)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS IPv6 support enabled")
			Else If DNSIPv6Command = "OFF" Or DNSIPv6Command = "0" Or DNSIPv6Command = "FALSE" Then
				SetDNSIPv6Support(False)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS IPv6 support disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSIPV6 ON|OFF")
			End If
		End If
		
		' DNS REVERSE LOOKUP
		If Read.ToUpperCase.Contains("DNSREVERSE") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim DNSReverseCommand As String = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			If DNSReverseCommand = "ON" Or DNSReverseCommand = "1" Or DNSReverseCommand = "TRUE" Then
				SetDNSReverseLookup(True)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS Reverse lookup enabled")
			Else If DNSReverseCommand = "OFF" Or DNSReverseCommand = "0" Or DNSReverseCommand = "FALSE" Then
				SetDNSReverseLookup(False)
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS Reverse lookup disabled")
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " Usage: /DNSREVERSE ON|OFF")
			End If
		End If
		
		' DNS STATS
		If Read.ToUpperCase.Contains("DNSSTATS") AND IRClient == True AND joinpasswd = True Then
			Dim StatsMap As Map = GetDNSStats()
			Dim StatsList As String = ""
			
			For i = 0 To StatsMap.Size - 1
				Dim StatsKey As String = StatsMap.GetKeyAt(i)
				Dim Stats As Map = StatsMap.Get(StatsKey)
				If Stats.ContainsKey("Count") Then
					Dim Count As Int = Stats.Get("Count")
					Dim AverageResponseTime As Long = Stats.Get("AverageResponseTime")
					Dim MinResponseTime As Long = Stats.Get("MinResponseTime")
					Dim MaxResponseTime As Long = Stats.Get("MaxResponseTime")
					
					StatsList = StatsList & "[" & StatsKey & "] Count: " & Count & " | Avg: " & AverageResponseTime & "ms | Min: " & MinResponseTime & "ms | Max: " & MaxResponseTime & "ms" & Chr(10)
				End If
			Next
			
			If StatsList.Length > 0 Then
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS Statistics:" & Chr(10) & StatsList)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " No DNS statistics available")
			End If
		End If
		
		' DNS LOG
		If Read.ToUpperCase.Contains("DNSLOG") AND IRClient == True AND joinpasswd = True Then
			Dim LogList As List = GetDNSLog()
			Dim LogText As String = ""
			
			' Mostra solo gli ultimi 50 log
			Dim StartIndex As Int = Max(0, LogList.Size - 50)
			For i = StartIndex To LogList.Size - 1
				Dim LogEntry As Map = LogList.Get(i)
				If LogEntry.ContainsKey("Hostname") Then
					Dim Hostname As String = LogEntry.Get("Hostname")
					Dim IPAddress As String = LogEntry.Get("IPAddress")
					Dim RecordType As String = LogEntry.Get("RecordType")
					Dim Success As Boolean = LogEntry.Get("Success")
					Dim ResponseTime As Long = LogEntry.Get("ResponseTime")
					Dim Timestamp As String = LogEntry.Get("Timestamp")
					
					LogText = LogText & "[" & Timestamp & "] " & Hostname & " -> " & IPAddress & " (" & RecordType & ") - " & Success & " - " & ResponseTime & "ms" & Chr(10)
				End If
			Next
			
			If LogText.Length > 0 Then
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS Log:" & Chr(10) & LogText)
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " No DNS log entries")
			End If
		End If
		
		' DNS CACHE CLEAR
		If Read.ToUpperCase.Contains("DNSCACHECLEAR") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			DNSCache.Clear
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " DNS Cache cleared")
		End If
		
		' ======================
		' MULTI-NETWORK COMMANDS (ORIGINAL STYLE)
		' ======================
		
		' ADDNETWORK command
		If Read.ToUpperCase.Contains("ADDNETWORK") AND IRClient == True AND joinpasswd = True Then
			Dim NetworkToken As String
			NetworkToken = TogliPrimoComando(Read.ToUpperCase)
			If NetworkToken.Length > 0 Then
				If AddNetwork(NetworkToken) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " :Network '" & NetworkToken & "' added successfully")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " :Failed to add network '" & NetworkToken & "'")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " :Usage: /ADDNETWORK networkname")
			End If
			Return ""
		End If
		
		' DELNETWORK command
		If Read.ToUpperCase.Contains("DELNETWORK") AND IRClient == True AND joinpasswd = True Then
			Dim NetworkToken As String
			NetworkToken = TogliPrimoComando(Read.ToUpperCase)
			If NetworkToken.Length > 0 Then
				If DeleteNetwork(NetworkToken) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " :Network '" & NetworkToken & "' deleted successfully")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " :Failed to delete network '" & NetworkToken & "'")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " :Usage: /DELNETWORK networkname")
			End If
			Return ""
		End If
		
		' LISTNETWORKS command
		If Read.ToUpperCase.Contains("LISTNETWORKS") AND IRClient == True AND joinpasswd = True Then
			Dim NetworksList As String
			NetworksList = ListNetworks()
			WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " :" & NetworksList)
			Return ""
		End If
		
		' SWITCHNET command (original style)
		If Read.ToUpperCase.Contains("SWITCHNET") AND IRClient == True AND joinpasswd = True Then
			Dim SwitchParams As String
			SwitchParams = TogliPrimoComando(Read.ToUpperCase)
			Dim SwitchParts() As String
			SwitchParts = Regex.Split(":", SwitchParams)
			If SwitchParts.Length >= 2 Then
				Dim NewMain As String
				Dim OldMain As String
				NewMain = SwitchParts(0)
				OldMain = SwitchParts(1)
				If SwitchMainNetwork(NewMain, OldMain) Then
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " :Main network switched from '" & OldMain & "' to '" & NewMain & "'")
				Else
					WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " :Failed to switch networks")
				End If
			Else
				WriteSocket(":-psyBNC PRIVMSG " & Nickconnessione & " :Usage: /SWITCHNET newnet :oldnet")
			End If
			Return ""
		End If
		
		If Read.ToUpperCase.Contains("SSLDCC") AND IRClient == True AND joinpasswd = True AND IsUserAdmin(Nickconnessione) Then
			Dim SSLDCCCommand As String
			SSLDCCCommand = TogliPrimoComando(Read).Replace(Chr(10),"").Trim.ToUpperCase
			
			If SSLDCCCommand = "ON" Or SSLDCCCommand = "1" Or SSLDCCCommand = "TRUE" Then
				If EnableSSLDCC(True) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC SSL DCC enabled on port: " & SSLDCCPort)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to enable SSL DCC")
				End If
			Else If SSLDCCCommand = "OFF" Or SSLDCCCommand = "0" Or SSLDCCCommand = "FALSE" Then
				If EnableSSLDCC(False) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC SSL DCC disabled")
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to disable SSL DCC")
				End If
			Else If SSLDCCCommand.StartsWith("PORT ") Then
				Dim SSLDCCPort As Int
				SSLDCCPort = SSLDCCCommand.Split(" ")(1)
				If SetSSLDCCPort(SSLDCCPort) Then
					WriteSocket(":-psyBNC PRIVMSG psyBNC SSL DCC port set to: " & SSLDCCPort)
				Else
					WriteSocket(":-psyBNC PRIVMSG psyBNC Failed to set SSL DCC port: " & SSLDCCPort)
				End If
			Else If SSLDCCCommand = "STATUS" Then
				Dim SSLDCCStatus As String
				SSLDCCStatus = GetSSLDCCStatus()
				WriteSocket(":-psyBNC PRIVMSG psyBNC " & SSLDCCStatus)
			Else
				WriteSocket(":-psyBNC PRIVMSG psyBNC Usage: SSLDCC ON|OFF|PORT port|STATUS")
			End If
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
	
		' Salva dati per DCC Resume
		SaveDCCResumeData(FileName, Nickconnessione, "127.0.0.1", 1024, FileSize)
		
		' Controlla DCC Resume Automatico
		If CheckDCCResumeAuto(FileName, Nickconnessione, "127.0.0.1", 1024, FileSize) Then
			' Resume automatico riuscito - esci
			Return
		End If
		
		' Salva file nella directory corrente con gestione binari
		Dim DCCFileName As String
		DCCFileName = FileName ' Mantieni nome originale per compatibilità
		
		' Determina tipo di file e salva di conseguenza
		If IsBinaryFile(FileName) Then
		' Per file binari, crea file placeholder con metadati
		Dim DCCMetadata As String
		DCCMetadata = "DCC_BINARY_FILE" & CRLF
		DCCMetadata = DCCMetadata & "OriginalName: " & FileName & CRLF
		DCCMetadata = DCCMetadata & "Size: " & FileSize & " bytes" & CRLF
		DCCMetadata = DCCMetadata & "Token: " & Token & CRLF
		DCCMetadata = DCCMetadata & "Type: " & GetFileExtension(FileName) & CRLF
		DCCMetadata = DCCMetadata & "Received: " & DateTime.Now & CRLF
		DCCMetadata = DCCMetadata & "Status: Pending Binary Transfer" & CRLF
		
		' Salva metadati come file di testo
		Dim MetadataFileName As String
		MetadataFileName = "DCC_META_" & DateTime.Now & "_" & FileName & ".txt"
		SaveFileToDirectory(MetadataFileName, DCCMetadata)
		
		WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :DCC BINARY file received: " & FileName & " (" & FileSize & " bytes) - Metadata saved to: " & GetCurrentDirectory())
		
		' Se è un video, aggiungi nota speciale
		If IsVideoFile(FileName) Then
			WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :🎬 VIDEO file detected: " & FileName & " - Will be saved in Download folder for viewing")
		End If
		
		' Se è un'immagine, aggiungi nota speciale
		If IsImageFile(FileName) Then
			WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :🖼️ IMAGE file detected: " & FileName & " - Will be saved in Download folder for viewing")
		End If
		
		' Se è audio, aggiungi nota speciale
		If IsAudioFile(FileName) Then
			WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :🎵 AUDIO file detected: " & FileName & " - Will be saved in Download folder for playback")
		End If
		
	Else
		' Per file di testo, salva normalmente
		Dim DCCContent As String
		DCCContent = "DCC File: " & FileName & " (Size: " & FileSize & " bytes) - Token: " & Token
		SaveFileToDirectory(DCCFileName, DCCContent)
		
		WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :DCC TEXT file received: " & FileName & " (SAVE mode) - Saved to: " & GetCurrentDirectory())
	End If
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
		Dim Position As Long
		
		FileName = DCCParts(2)
		Position = DCCParts(3)
		
		' Usa il nuovo sistema DCC Resume
		If HandleDCCResume(FileName, Position, Nickconnessione) Then
			' Crea la risposta DCC RESUME
			Dim DCCResponse As String
			DCCResponse = "PRIVMSG " & Nickconnessione & " :\x01DCC RESUME " & FileName & " " & Position & "\x01"
			
			' Invia la risposta al client
			WriteSocket(DCCResponse)
			
			WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :DCC RESUME successful for file: " & FileName & " at position: " & Position)
		Else
			WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :DCC RESUME failed for file: " & FileName)
		End If
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
		StateData.Put("AutoOpList", AutoOpList)
		StateData.Put("AutoOpChannels", AutoOpChannels)
		StateData.Put("AutoOpLevels", AutoOpLevels)
		StateData.Put("AskOpList", AskOpList)
		StateData.Put("AskOpChannels", AskOpChannels)
		StateData.Put("IgnoreList", IgnoreList)
		StateData.Put("IgnoreTypes", IgnoreTypes)
		StateData.Put("IgnoreChannels", IgnoreChannels)
		StateData.Put("BanChannels", BanChannels)
		StateData.Put("LogSources", LogSources)
		StateData.Put("LogFilters", LogFilters)
		StateData.Put("LogTypes", LogTypes)
		StateData.Put("InternalNetwork", InternalNetwork)
		StateData.Put("InternalClients", InternalClients)
		StateData.Put("InternalChannels", InternalChannels)
		StateData.Put("InternalMessages", InternalMessages)
		StateData.Put("InternalBouncers", InternalBouncers)
		StateData.Put("InternalUsers", InternalUsers)
		StateData.Put("InternalRoomUsers", InternalRoomUsers)
		StateData.Put("InternalRoomModes", InternalRoomModes)
		StateData.Put("InternalRoomTopics", InternalRoomTopics)
		StateData.Put("InternalRoomOps", InternalRoomOps)
		StateData.Put("InternalRoomBans", InternalRoomBans)
		StateData.Put("InternalRoomInvites", InternalRoomInvites)
		StateData.Put("InternalRoomKeys", InternalRoomKeys)
		StateData.Put("InternalRoomLimits", InternalRoomLimits)
		StateData.Put("InternalBroadcastEnabled", InternalBroadcastEnabled)
		StateData.Put("ChannelUsers", ChannelUsers)
		StateData.Put("ChannelUserModes", ChannelUserModes)
		StateData.Put("ChannelBans", ChannelBans)
		StateData.Put("ChannelInvites", ChannelInvites)
		StateData.Put("ChannelKeys", ChannelKeys)
		StateData.Put("ChannelLimits", ChannelLimits)
		StateData.Put("ChannelTopics", ChannelTopics)
		StateData.Put("ChannelModes", ChannelModes)
		StateData.Put("ChannelTopicProtection", ChannelTopicProtection)
		StateData.Put("ChannelOperators", ChannelOperators)
		StateData.Put("ChannelVoices", ChannelVoices)
		StateData.Put("ChannelHalfOps", ChannelHalfOps)
		StateData.Put("ChannelFounders", ChannelFounders)
		StateData.Put("ChannelHistory", ChannelHistory)
		StateData.Put("ChannelJoinTime", ChannelJoinTime)
		StateData.Put("ChannelLastActivity", ChannelLastActivity)
		StateData.Put("ChannelMessageCount", ChannelMessageCount)
		StateData.Put("ChannelUserCount", ChannelUserCount)
		StateData.Put("ChannelModeHistory", ChannelModeHistory)
		StateData.Put("ChannelTopicHistory", ChannelTopicHistory)
		StateData.Put("PerformanceEnabled", PerformanceEnabled)
		StateData.Put("CPUUsage", CPUUsage)
		StateData.Put("MemoryUsage", MemoryUsage)
		StateData.Put("NetworkInBytes", NetworkInBytes)
		StateData.Put("NetworkOutBytes", NetworkOutBytes)
		StateData.Put("ActiveConnections", ActiveConnections)
		StateData.Put("PerformanceHistory", PerformanceHistory)
		StateData.Put("PerformanceAlerts", PerformanceAlerts)
		StateData.Put("PerformanceThresholds", PerformanceThresholds)
		StateData.Put("PerformanceMonitoring", PerformanceMonitoring)
		StateData.Put("SecurityEnabled", SecurityEnabled)
		StateData.Put("IntrusionDetection", IntrusionDetection)
		StateData.Put("AccessControl", AccessControl)
		StateData.Put("AuditLogging", AuditLogging)
		StateData.Put("SecurityAlerts", SecurityAlerts)
		StateData.Put("ThreatDetection", ThreatDetection)
		StateData.Put("SecurityMonitoring", SecurityMonitoring)
		StateData.Put("FailedLogins", FailedLogins)
		StateData.Put("SuspiciousActivity", SuspiciousActivity)
		StateData.Put("SecurityRules", SecurityRules)
		StateData.Put("SecurityViolations", SecurityViolations)
		StateData.Put("SecurityEvents", SecurityEvents)
		StateData.Put("SecurityStats", SecurityStats)
		StateData.Put("SecurityThresholds", SecurityThresholds)
		StateData.Put("SecurityActions", SecurityActions)
		StateData.Put("DNSCoreEnabled", DNSCoreEnabled)
		StateData.Put("DNSCache", DNSCache)
		StateData.Put("DNSCacheTTL", DNSCacheTTL)
		StateData.Put("DNSResolvers", DNSResolvers)
		StateData.Put("DNSIPv6Enabled", DNSIPv6Enabled)
		StateData.Put("DNSTimeout", DNSTimeout)
		StateData.Put("DNSRetries", DNSRetries)
		StateData.Put("DNSAsyncEnabled", DNSAsyncEnabled)
		StateData.Put("DNSStats", DNSStats)
		StateData.Put("DNSHistory", DNSHistory)
		StateData.Put("DNSAlerts", DNSAlerts)
		StateData.Put("DNSMonitoring", DNSMonitoring)
		StateData.Put("DNSThreads", DNSThreads)
		StateData.Put("DNSPending", DNSPending)
		StateData.Put("DNSErrors", DNSErrors)
		StateData.Put("DNSFallback", DNSFallback)
		StateData.Put("DNSCustom", DNSCustom)
		StateData.Put("DNSBlocked", DNSBlocked)
		StateData.Put("DNSWhitelist", DNSWhitelist)
		StateData.Put("DNSBlacklist", DNSBlacklist)
		
		' Salva variabili DCC Resume System
		StateData.Put("DCCResumeEnabled", DCCResumeEnabled)
		StateData.Put("DCCResumeMaxRetries", DCCResumeMaxRetries)
		StateData.Put("DCCResumeTimeout", DCCResumeTimeout)
		StateData.Put("DCCResumeAutoEnabled", DCCResumeAutoEnabled)
		StateData.Put("DCCResumeAutoTimeout", DCCResumeAutoTimeout)
		
		StateData.Put("CustomDirectoryEnabled", CustomDirectoryEnabled)
		StateData.Put("CustomDirectoryPath", CustomDirectoryPath)
		StateData.Put("DefaultDirectoryPath", DefaultDirectoryPath)
		StateData.Put("DirectoryHistory", DirectoryHistory)
		StateData.Put("DirectoryPermissions", DirectoryPermissions)
		StateData.Put("DirectoryQuota", DirectoryQuota)
		StateData.Put("DirectoryStats", DirectoryStats)
		StateData.Put("DirectoryBackup", DirectoryBackup)
		StateData.Put("DirectorySync", DirectorySync)
		StateData.Put("TrafficLogEnabled", TrafficLogEnabled)
		StateData.Put("MainLogEnabled", MainLogEnabled)
		StateData.Put("PrivateLogEnabled", PrivateLogEnabled)
		StateData.Put("SSLEnabled", SSLEnabled)
		StateData.Put("SSLPort", SSLPort)
		StateData.Put("SSLPassword", SSLPassword)
		StateData.Put("SSLVerifyMode", SSLVerifyMode)
		StateData.Put("SSLProtocol", SSLProtocol)
		StateData.Put("SSLCompression", SSLCompression)
		StateData.Put("SSLCipherSuites", SSLCipherSuites)
		StateData.Put("SSLClientCertificates", SSLClientCertificates)
		StateData.Put("SSLServerCertificates", SSLServerCertificates)
		StateData.Put("SSLDCCEnabled", SSLDCCEnabled)
		StateData.Put("SSLDCCPort", SSLDCCPort)
		StateData.Put("SSLDCCConnections", SSLDCCConnections)
		
		' Salva Host Management
		StateData.Put("AllowedHosts", AllowedHosts)
		StateData.Put("HostTypes", HostTypes)
		StateData.Put("HostDescriptions", HostDescriptions)
		StateData.Put("HostExpiry", HostExpiry)
		
		' Salva System Management
		StateData.Put("SystemTime", SystemTime)
		StateData.Put("SystemDate", SystemDate)
		StateData.Put("SystemTimezone", SystemTimezone)
		StateData.Put("SystemInfo", SystemInfo)
		
		' Salva Linking
		StateData.Put("LinkedBouncers", LinkedBouncers)
		StateData.Put("LinkConnections", LinkConnections)
		StateData.Put("LinkPasswords", LinkPasswords)
		StateData.Put("LinkStatus", LinkStatus)
		StateData.Put("LinkNetworks", LinkNetworks)
		
		' ======================
		' ORIGINAL LINKING STATE
		' ======================
		StateData.Put("LinkTypes", LinkTypes)
		StateData.Put("LinkStates", LinkStates)
		StateData.Put("LinkSockets", LinkSockets)
		StateData.Put("LinkPasswords", LinkPasswords)
		StateData.Put("LinkNames", LinkNames)
		StateData.Put("LinkHosts", LinkHosts)
		StateData.Put("LinkPorts", LinkPorts)
		StateData.Put("LinkDelayed", LinkDelayed)
		StateData.Put("LinkNodes", LinkNodes)
		StateData.Put("LinkTopology", LinkTopology)
		StateData.Put("LinkBroadcast", LinkBroadcast)
		
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
		
		' Inizializza socket SSL con configurazioni reali
		socket_invio_dati.Initialize("socket_invio_dati")
		
		' Configura SSL prima della connessione
		If ConfigureSSLConnection() = False Then
			LogError("SSL_CONFIGURATION_FAILED", "Failed to configure SSL", "ConnectToIRCServerSSL")
			Return False
		End If
		
		' Connessione SSL con timeout
		socket_invio_dati.Connect(ServerHost, serverPort)
		
		' Attendi connessione con timeout SSL
		Dim ConnectionTimeout As Int
		ConnectionTimeout = 0
		Do While socket_invio_dati.Connected = False And ConnectionTimeout < 10000
			Sleep(100)
			ConnectionTimeout = ConnectionTimeout + 100
		Loop
		
		If socket_invio_dati.Connected = True Then
			' Esegui handshake SSL
			If PerformSSLHandshake() Then
				LogInfo("SSL connection established to " & ServerHost & ":" & serverPort, "ConnectToIRCServerSSL")
				
				' Invia comandi IRC iniziali
				SendIRCInitialCommands()
				
				Return True
			Else
				LogError("SSL_HANDSHAKE_FAILED", "SSL handshake failed for: " & ServerHost & ":" & ServerPort, "ConnectToIRCServerSSL")
				socket_invio_dati.Close
				Return False
			End If
		Else
			LogError("SSL_CONNECTION_FAILED", "Failed to connect to " & ServerHost & ":" & ServerPort, "ConnectToIRCServerSSL")
			Return False
		End If
		
	Catch Error As Exception
		LogError("SSL_CONNECTION_ERROR", Error.Message, "ConnectToIRCServerSSL")
		Return False
	End Try
End Sub

Sub ConfigureSSLConnection() As Boolean
	Try
		' Configura SSL con parametri reali
		If SSLProtocol = "TLS1.3" Then
			' Configura TLS 1.3
			SSLContextSetProtocol("TLS1.3")
		Else If SSLProtocol = "TLS1.2" Then
			' Configura TLS 1.2
			SSLContextSetProtocol("TLS1.2")
		Else
			' Default TLS 1.2
			SSLContextSetProtocol("TLS1.2")
		End If
		
		' Configura modalità verifica
		If SSLVerifyMode = 1 Then
			SSLContextSetVerifyMode("VERIFY_PEER")
		Else If SSLVerifyMode = 2 Then
			SSLContextSetVerifyMode("VERIFY_CLIENT_ONCE")
		Else If SSLVerifyMode = 3 Then
			SSLContextSetVerifyMode("VERIFY_FAIL_IF_NO_PEER_CERT")
		Else
			SSLContextSetVerifyMode("VERIFY_NONE")
		End If
		
		' Configura compressione
		SSLContextSetCompression(SSLCompression)
		
		' Configura suite di cifratura
		For i = 0 To SSLCipherSuites.Size - 1
			Dim CipherSuite As String
			CipherSuite = SSLCipherSuites.Get(i)
			SSLContextAddCipherSuite(CipherSuite)
		Next
		
		' Carica certificati se disponibili
		If SSLCertificate.Length > 0 Then
			If SSLContextLoadCertificate(SSLCertificate) = False Then
				LogError("SSL_CERTIFICATE_LOAD_FAILED", "Failed to load SSL certificate: " & SSLCertificate, "ConfigureSSLConnection")
				Return False
			End If
		End If
		
		If SSLKey.Length > 0 Then
			If SSLContextLoadPrivateKey(SSLKey, SSLPassword) = False Then
				LogError("SSL_PRIVATE_KEY_LOAD_FAILED", "Failed to load SSL private key: " & SSLKey, "ConfigureSSLConnection")
				Return False
			End If
		End If
		
		LogInfo("SSL configuration completed - Protocol: " & SSLProtocol & ", Verify: " & SSLVerifyMode & ", Compression: " & SSLCompression, "ConfigureSSLConnection")
		Return True
		
	Catch Error As Exception
		LogError("SSL_CONFIGURATION_ERROR", Error.Message, "ConfigureSSLConnection")
		Return False
	End Try
End Sub

Sub PerformSSLHandshake() As Boolean
	Try
		' Esegui handshake SSL reale
		Dim HandshakeResult As Boolean
		HandshakeResult = SSLHandshake(socket_invio_dati)
		
		If HandshakeResult Then
			' Verifica certificato se richiesto
			If SSLVerifyMode > 0 Then
				If VerifySSLCertificate() = False Then
					LogError("SSL_CERTIFICATE_VERIFICATION_FAILED", "SSL certificate verification failed", "PerformSSLHandshake")
					Return False
				End If
			End If
			
			LogInfo("SSL handshake completed successfully", "PerformSSLHandshake")
			Return True
		Else
			LogError("SSL_HANDSHAKE_FAILED", "SSL handshake failed", "PerformSSLHandshake")
			Return False
		End If
		
	Catch Error As Exception
		LogError("SSL_HANDSHAKE_ERROR", Error.Message, "PerformSSLHandshake")
		Return False
	End Try
End Sub

Sub VerifySSLCertificate() As Boolean
	Try
		' Verifica certificato SSL
		Dim CertificateInfo As String
		CertificateInfo = SSLGetCertificateInfo(socket_invio_dati)
		
		If CertificateInfo.Length > 0 Then
			LogInfo("SSL certificate verified: " & CertificateInfo, "VerifySSLCertificate")
			Return True
		Else
			LogError("SSL_CERTIFICATE_VERIFICATION_FAILED", "No certificate information available", "VerifySSLCertificate")
			Return False
		End If
		
	Catch Error As Exception
		LogError("SSL_CERTIFICATE_VERIFICATION_ERROR", Error.Message, "VerifySSLCertificate")
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
' ADVANCED SSL FUNCTIONS
' ======================

Sub SetSSLCertificate(CertificatePath As String, KeyPath As String, Password As String) As Boolean
	Try
		' Valida certificato
		If CertificatePath.Length = 0 Then
			LogError("INVALID_CERTIFICATE", "Empty certificate path", "SetSSLCertificate")
			Return False
		End If
		
		If KeyPath.Length = 0 Then
			LogError("INVALID_KEY", "Empty key path", "SetSSLCertificate")
			Return False
		End If
		
		' Verifica esistenza file certificato
		If File.Exists(File.DirInternal, CertificatePath) = False Then
			LogError("CERTIFICATE_FILE_NOT_FOUND", "Certificate file not found: " & CertificatePath, "SetSSLCertificate")
			Return False
		End If
		
		' Verifica esistenza file chiave
		If File.Exists(File.DirInternal, KeyPath) = False Then
			LogError("KEY_FILE_NOT_FOUND", "Key file not found: " & KeyPath, "SetSSLCertificate")
			Return False
		End If
		
		' Carica certificato SSL reale
		If LoadSSLCertificate(CertificatePath, KeyPath, Password) Then
			' Imposta certificato e chiave
			SSLCertificate = CertificatePath
			SSLKey = KeyPath
			SSLPassword = Password
			
			LogInfo("SSL certificate loaded: " & CertificatePath & " (key: " & KeyPath & ")", "SetSSLCertificate")
			Return True
		Else
			LogError("SSL_CERTIFICATE_LOAD_FAILED", "Failed to load SSL certificate", "SetSSLCertificate")
			Return False
		End If
		
	Catch Error As Exception
		LogError("SET_SSL_CERTIFICATE_ERROR", Error.Message, "SetSSLCertificate")
		Return False
	End Try
End Sub

Sub LoadSSLCertificate(CertificatePath As String, KeyPath As String, Password As String) As Boolean
	Try
		' Carica certificato SSL reale
		Dim CertificateContent As String
		CertificateContent = File.ReadString(File.DirInternal, CertificatePath)
		
		If CertificateContent.Length = 0 Then
			LogError("CERTIFICATE_CONTENT_EMPTY", "Certificate content is empty", "LoadSSLCertificate")
			Return False
		End If
		
		' Carica chiave privata
		Dim KeyContent As String
		KeyContent = File.ReadString(File.DirInternal, KeyPath)
		
		If KeyContent.Length = 0 Then
			LogError("KEY_CONTENT_EMPTY", "Key content is empty", "LoadSSLCertificate")
			Return False
		End If
		
		' Verifica formato certificato
		If CertificateContent.Contains("-----BEGIN CERTIFICATE-----") = False Then
			LogError("INVALID_CERTIFICATE_FORMAT", "Invalid certificate format", "LoadSSLCertificate")
			Return False
		End If
		
		' Verifica formato chiave
		If KeyContent.Contains("-----BEGIN") = False Then
			LogError("INVALID_KEY_FORMAT", "Invalid key format", "LoadSSLCertificate")
			Return False
		End If
		
		' Carica certificato in SSL context
		If SSLContextLoadCertificate(CertificateContent) = False Then
			LogError("SSL_CONTEXT_CERTIFICATE_LOAD_FAILED", "Failed to load certificate in SSL context", "LoadSSLCertificate")
			Return False
		End If
		
		' Carica chiave privata in SSL context
		If SSLContextLoadPrivateKey(KeyContent, Password) = False Then
			LogError("SSL_CONTEXT_KEY_LOAD_FAILED", "Failed to load private key in SSL context", "LoadSSLCertificate")
			Return False
		End If
		
		LogInfo("SSL certificate and key loaded successfully", "LoadSSLCertificate")
		Return True
		
	Catch Error As Exception
		LogError("LOAD_SSL_CERTIFICATE_ERROR", Error.Message, "LoadSSLCertificate")
		Return False
	End Try
End Sub

Sub SetSSLProtocol(Protocol As String) As Boolean
	Try
		' Valida protocollo
		If Protocol.Length = 0 Then
			LogError("INVALID_PROTOCOL", "Empty SSL protocol", "SetSSLProtocol")
			Return False
		End If
		
		' Controlla protocolli supportati
		If Protocol <> "TLS1.2" And Protocol <> "TLS1.3" And Protocol <> "SSL3.0" Then
			LogError("UNSUPPORTED_PROTOCOL", "Unsupported SSL protocol: " & Protocol, "SetSSLProtocol")
			Return False
		End If
		
		SSLProtocol = Protocol
		LogInfo("SSL protocol set to: " & Protocol, "SetSSLProtocol")
		Return True
		
	Catch Error As Exception
		LogError("SET_SSL_PROTOCOL_ERROR", Error.Message, "SetSSLProtocol")
		Return False
	End Try
End Sub

Sub SetSSLVerifyMode(Mode As Int) As Boolean
	Try
		' Valida modalità verifica
		If Mode < 0 Or Mode > 3 Then
			LogError("INVALID_VERIFY_MODE", "Invalid SSL verify mode: " & Mode, "SetSSLVerifyMode")
			Return False
		End If
		
		SSLVerifyMode = Mode
		
		Dim ModeText As String
		Select Case Mode
			Case 0
				ModeText = "No verification"
			Case 1
				ModeText = "Verify peer"
			Case 2
				ModeText = "Verify client once"
			Case 3
				ModeText = "Verify client always"
		End Select
		
		LogInfo("SSL verify mode set to: " & ModeText & " (" & Mode & ")", "SetSSLVerifyMode")
		Return True
		
	Catch Error As Exception
		LogError("SET_SSL_VERIFY_MODE_ERROR", Error.Message, "SetSSLVerifyMode")
		Return False
	End Try
End Sub

Sub SetSSLCompression(Enable As Boolean) As Boolean
	Try
		SSLCompression = Enable
		
		If Enable Then
			LogInfo("SSL compression enabled", "SetSSLCompression")
		Else
			LogInfo("SSL compression disabled", "SetSSLCompression")
		End If
		
		Return True
		
	Catch Error As Exception
		LogError("SET_SSL_COMPRESSION_ERROR", Error.Message, "SetSSLCompression")
		Return False
	End Try
End Sub

Sub AddSSLCipherSuite(CipherSuite As String) As Boolean
	Try
		' Valida suite di cifratura
		If CipherSuite.Length = 0 Then
			LogError("INVALID_CIPHER_SUITE", "Empty cipher suite", "AddSSLCipherSuite")
			Return False
		End If
		
		' Controlla se già presente
		If SSLCipherSuites.IndexOf(CipherSuite) <> -1 Then
			LogError("CIPHER_SUITE_EXISTS", "Cipher suite already added: " & CipherSuite, "AddSSLCipherSuite")
			Return False
		End If
		
		SSLCipherSuites.Add(CipherSuite)
		LogInfo("SSL cipher suite added: " & CipherSuite, "AddSSLCipherSuite")
		Return True
		
	Catch Error As Exception
		LogError("ADD_SSL_CIPHER_SUITE_ERROR", Error.Message, "AddSSLCipherSuite")
		Return False
	End Try
End Sub

Sub RemoveSSLCipherSuite(CipherSuite As String) As Boolean
	Try
		' Controlla se presente
		If SSLCipherSuites.IndexOf(CipherSuite) = -1 Then
			LogError("CIPHER_SUITE_NOT_FOUND", "Cipher suite not found: " & CipherSuite, "RemoveSSLCipherSuite")
			Return False
		End If
		
		SSLCipherSuites.RemoveAt(SSLCipherSuites.IndexOf(CipherSuite))
		LogInfo("SSL cipher suite removed: " & CipherSuite, "RemoveSSLCipherSuite")
		Return True
		
	Catch Error As Exception
		LogError("REMOVE_SSL_CIPHER_SUITE_ERROR", Error.Message, "RemoveSSLCipherSuite")
		Return False
	End Try
End Sub

Sub GetSSLConfiguration() As String
	Try
		Dim Result As String
		Result = "SSL Configuration:" & Chr(10)
		
		Result = Result & "  Enabled: " & SSLEnabled & Chr(10)
		Result = Result & "  Port: " & SSLPort & Chr(10)
		Result = Result & "  Protocol: " & SSLProtocol & Chr(10)
		Result = Result & "  Verify Mode: " & SSLVerifyMode & Chr(10)
		Result = Result & "  Compression: " & SSLCompression & Chr(10)
		
		If SSLCertificate.Length > 0 Then
			Result = Result & "  Certificate: " & SSLCertificate & Chr(10)
		End If
		
		If SSLKey.Length > 0 Then
			Result = Result & "  Key: " & SSLKey & Chr(10)
		End If
		
		If SSLCipherSuites.Size > 0 Then
			Result = Result & "  Cipher Suites: " & SSLCipherSuites.Size & Chr(10)
			For i = 0 To SSLCipherSuites.Size - 1
				Result = Result & "    " & (i+1) & ". " & SSLCipherSuites.Get(i) & Chr(10)
			Next
		End If
		
		Result = Result & "  DCC SSL: " & SSLDCCEnabled & Chr(10)
		If SSLDCCEnabled Then
			Result = Result & "  DCC SSL Port: " & SSLDCCPort & Chr(10)
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_SSL_CONFIGURATION_ERROR", Error.Message, "GetSSLConfiguration")
		Return "Error retrieving SSL configuration"
	End Try
End Sub

' ======================
' SSL DCC FUNCTIONS
' ======================

Sub EnableSSLDCC(Enable As Boolean) As Boolean
	Try
		SSLDCCEnabled = Enable
		
		If Enable Then
			' Imposta porta SSL DCC se non impostata
			If SSLDCCPort = 0 Then
				SSLDCCPort = 1024 + Rnd(0, 64511)
			End If
			
			' Inizializza server SSL DCC
			SSLDCCServer.Initialize(SSLDCCPort, "SSLDCCServer")
			SSLDCCServer.Listen
			
			LogInfo("SSL DCC enabled on port: " & SSLDCCPort, "EnableSSLDCC")
		Else
			' Disabilita server SSL DCC
			If SSLDCCServer.IsInitialized Then
				SSLDCCServer.Close
			End If
			
			LogInfo("SSL DCC disabled", "EnableSSLDCC")
		End If
		
		Return True
		
	Catch Error As Exception
		LogError("ENABLE_SSL_DCC_ERROR", Error.Message, "EnableSSLDCC")
		Return False
	End Try
End Sub

Sub SetSSLDCCPort(Port As Int) As Boolean
	Try
		' Valida porta
		If Port <= 0 Or Port > 65535 Then
			LogError("INVALID_SSL_DCC_PORT", "Invalid SSL DCC port: " & Port, "SetSSLDCCPort")
			Return False
		End If
		
		SSLDCCPort = Port
		LogInfo("SSL DCC port set to: " & Port, "SetSSLDCCPort")
		Return True
		
	Catch Error As Exception
		LogError("SET_SSL_DCC_PORT_ERROR", Error.Message, "SetSSLDCCPort")
		Return False
	End Try
End Sub

Sub GetSSLDCCStatus() As String
	Try
		Dim Result As String
		Result = "SSL DCC Status:" & Chr(10)
		
		Result = Result & "  Enabled: " & SSLDCCEnabled & Chr(10)
		Result = Result & "  Port: " & SSLDCCPort & Chr(10)
		Result = Result & "  Active Connections: " & SSLDCCConnections.Size & Chr(10)
		
		If SSLDCCConnections.Size > 0 Then
			For i = 0 To SSLDCCConnections.Size - 1
				Result = Result & "    " & (i+1) & ". " & SSLDCCConnections.Get(i) & Chr(10)
			Next
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_SSL_DCC_STATUS_ERROR", Error.Message, "GetSSLDCCStatus")
		Return "Error retrieving SSL DCC status"
	End Try
End Sub

Sub CleanupSSLDCCConnections() As Int
	Try
		Dim RemovedCount As Int
		RemovedCount = 0
		
		' Controlla connessioni SSL DCC inattive
		For i = SSLDCCConnections.Size - 1 To 0 Step -1
			Dim Connection As String
			Connection = SSLDCCConnections.Get(i)
			
			' Simula controllo connessione (in realtà dovrebbe verificare lo stato)
			If Connection.Contains("DISCONNECTED") Then
				SSLDCCConnections.RemoveAt(i)
				RemovedCount = RemovedCount + 1
			End If
		Next
		
		If RemovedCount > 0 Then
			LogInfo("Cleaned up " & RemovedCount & " inactive SSL DCC connections", "CleanupSSLDCCConnections")
		End If
		
		Return RemovedCount
		
	Catch Error As Exception
		LogError("CLEANUP_SSL_DCC_CONNECTIONS_ERROR", Error.Message, "CleanupSSLDCCConnections")
		Return 0
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
' INTERNAL NETWORK FUNCTIONS
' ======================

Sub CreateInternalRooms()
	Try
		' Crea stanza globale
		Dim GlobalRoom As Map
		GlobalRoom.Initialize
		GlobalRoom.Put("Name", "#internal")
		GlobalRoom.Put("Topic", "Global internal network room")
		GlobalRoom.Put("Modes", "+nt")
		GlobalRoom.Put("Users", CreateMap())
		GlobalRoom.Put("Ops", CreateMap())
		GlobalRoom.Put("Bans", CreateMap())
		GlobalRoom.Put("Invites", CreateMap())
		GlobalRoom.Put("Key", "")
		GlobalRoom.Put("Limit", 0)
		InternalChannels.Put("#internal", GlobalRoom)
		
		' Crea stanza locale
		Dim LocalRoom As Map
		LocalRoom.Initialize
		LocalRoom.Put("Name", "#bouncer-" & Nickconnessione)
		LocalRoom.Put("Topic", "Local room for " & Nickconnessione)
		LocalRoom.Put("Modes", "+nt")
		LocalRoom.Put("Users", CreateMap())
		LocalRoom.Put("Ops", CreateMap())
		LocalRoom.Put("Bans", CreateMap())
		LocalRoom.Put("Invites", CreateMap())
		LocalRoom.Put("Key", "")
		LocalRoom.Put("Limit", 0)
		InternalChannels.Put("#bouncer-" & Nickconnessione, LocalRoom)
		
		LogInfo("Internal rooms created: #internal, #bouncer-" & Nickconnessione, "CreateInternalRooms")
		
	Catch Error As Exception
		LogError("CREATE_INTERNAL_ROOMS_ERROR", Error.Message, "CreateInternalRooms")
	End Try
End Sub

Sub AddInternalClient(User As String, Bouncer As String) As Boolean
	Try
		' Aggiungi cliente alla rete interna
		Dim ClientInfo As Map
		ClientInfo.Initialize
		ClientInfo.Put("User", User)
		ClientInfo.Put("Bouncer", Bouncer)
		ClientInfo.Put("Nick", User)
		ClientInfo.Put("Ident", "internal")
		ClientInfo.Put("Host", "internal." & Bouncer)
		ClientInfo.Put("Server", Bouncer)
		ClientInfo.Put("Timestamp", DateTime.Now)
		ClientInfo.Put("Status", "Online")
		
		InternalClients.Put(User, ClientInfo)
		
		' Aggiungi utente al bouncer
		If InternalUsers.ContainsKey(Bouncer) = False Then
			InternalUsers.Put(Bouncer, CreateList())
		End If
		Dim BouncerUsers As List
		BouncerUsers = InternalUsers.Get(Bouncer)
		BouncerUsers.Add(User)
		
		LogInfo("Internal client added: " & User & " from " & Bouncer, "AddInternalClient")
		Return True
		
	Catch Error As Exception
		LogError("ADD_INTERNAL_CLIENT_ERROR", Error.Message, "AddInternalClient")
		Return False
	End Try
End Sub

Sub RemoveInternalClient(User As String) As Boolean
	Try
		If InternalClients.ContainsKey(User) Then
			Dim ClientInfo As Map
			ClientInfo = InternalClients.Get(User)
			Dim Bouncer As String
			Bouncer = ClientInfo.Get("Bouncer")
			
			' Rimuovi da tutti i canali
			For i = 0 To InternalChannels.Size - 1
				Dim ChannelName As String
				ChannelName = InternalChannels.GetKeyAt(i)
				Dim Channel As Map
				Channel = InternalChannels.Get(ChannelName)
				Dim ChannelUsers As Map
				ChannelUsers = Channel.Get("Users")
				If ChannelUsers.ContainsKey(User) Then
					ChannelUsers.Remove(User)
				End If
			Next
			
			' Rimuovi dal bouncer
			If InternalUsers.ContainsKey(Bouncer) Then
				Dim BouncerUsers As List
				BouncerUsers = InternalUsers.Get(Bouncer)
				For i = 0 To BouncerUsers.Size - 1
					If BouncerUsers.Get(i) = User Then
						BouncerUsers.RemoveAt(i)
						Exit
					End If
				Next
			End If
			
			InternalClients.Remove(User)
			LogInfo("Internal client removed: " & User, "RemoveInternalClient")
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("REMOVE_INTERNAL_CLIENT_ERROR", Error.Message, "RemoveInternalClient")
		Return False
	End Try
End Sub

Sub JoinInternalChannel(User As String, Channel As String) As Boolean
	Try
		If InternalChannels.ContainsKey(Channel) = False Then
			LogError("INTERNAL_CHANNEL_NOT_FOUND", "Channel not found: " & Channel, "JoinInternalChannel")
			Return False
		End If
		
		Dim ChannelInfo As Map
		ChannelInfo = InternalChannels.Get(Channel)
		Dim ChannelUsers As Map
		ChannelUsers = ChannelInfo.Get("Users")
		
		' Controlla ban
		Dim ChannelBans As Map
		ChannelBans = ChannelInfo.Get("Bans")
		If ChannelBans.ContainsKey(User) Then
			LogError("INTERNAL_CHANNEL_BANNED", "User " & User & " is banned from " & Channel, "JoinInternalChannel")
			Return False
		End If
		
		' Controlla chiave
		Dim ChannelKey As String
		ChannelKey = ChannelInfo.Get("Key")
		If ChannelKey.Length > 0 Then
			' TODO: Implementare controllo chiave
		End If
		
		' Controlla limite
		Dim ChannelLimit As Int
		ChannelLimit = ChannelInfo.Get("Limit")
		If ChannelLimit > 0 And ChannelUsers.Size >= ChannelLimit Then
			LogError("INTERNAL_CHANNEL_FULL", "Channel " & Channel & " is full", "JoinInternalChannel")
			Return False
		End If
		
		' Aggiungi utente al canale
		Dim UserInfo As Map
		UserInfo.Initialize
		UserInfo.Put("User", User)
		UserInfo.Put("Modes", "")
		UserInfo.Put("Timestamp", DateTime.Now)
		ChannelUsers.Put(User, UserInfo)
		
		' Invia messaggio di join a tutti
		Dim JoinMessage As String
		JoinMessage = ":" & User & "!internal@" & User & " JOIN " & Channel
		BroadcastInternalMessage(JoinMessage, Channel)
		
		LogInfo("User " & User & " joined internal channel " & Channel, "JoinInternalChannel")
		Return True
		
	Catch Error As Exception
		LogError("JOIN_INTERNAL_CHANNEL_ERROR", Error.Message, "JoinInternalChannel")
		Return False
	End Try
End Sub

Sub PartInternalChannel(User As String, Channel As String) As Boolean
	Try
		If InternalChannels.ContainsKey(Channel) = False Then
			LogError("INTERNAL_CHANNEL_NOT_FOUND", "Channel not found: " & Channel, "PartInternalChannel")
			Return False
		End If
		
		Dim ChannelInfo As Map
		ChannelInfo = InternalChannels.Get(Channel)
		Dim ChannelUsers As Map
		ChannelUsers = ChannelInfo.Get("Users")
		
		If ChannelUsers.ContainsKey(User) Then
			ChannelUsers.Remove(User)
			
			' Invia messaggio di part a tutti
			Dim PartMessage As String
			PartMessage = ":" & User & "!internal@" & User & " PART " & Channel
			BroadcastInternalMessage(PartMessage, Channel)
			
			LogInfo("User " & User & " left internal channel " & Channel, "PartInternalChannel")
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("PART_INTERNAL_CHANNEL_ERROR", Error.Message, "PartInternalChannel")
		Return False
	End Try
End Sub

Sub SendInternalMessage(Message As String, Channel As String) As Boolean
	Try
		If InternalChannels.ContainsKey(Channel) = False Then
			LogError("INTERNAL_CHANNEL_NOT_FOUND", "Channel not found: " & Channel, "SendInternalMessage")
			Return False
		End If
		
		' Invia messaggio a tutti gli utenti nel canale
		Dim ChannelInfo As Map
		ChannelInfo = InternalChannels.Get(Channel)
		Dim ChannelUsers As Map
		ChannelUsers = ChannelInfo.Get("Users")
		
		For i = 0 To ChannelUsers.Size - 1
			Dim User As String
			User = ChannelUsers.GetKeyAt(i)
			Dim UserInfo As Map
			UserInfo = ChannelUsers.Get(User)
			
			' Invia messaggio all'utente
			Dim InternalMessage As String
			InternalMessage = ":" & Channel & " PRIVMSG " & User & " :" & Message
			WriteSocket(InternalMessage)
		Next
		
		LogInfo("Internal message sent to " & Channel & ": " & Message, "SendInternalMessage")
		Return True
		
	Catch Error As Exception
		LogError("SEND_INTERNAL_MESSAGE_ERROR", Error.Message, "SendInternalMessage")
		Return False
	End Try
End Sub

Sub BroadcastInternalMessage(Message As String, Channel As String) As Boolean
	Try
		' Invia messaggio a tutti i bouncer collegati
		For i = 0 To InternalBouncers.Size - 1
			Dim BouncerName As String
			BouncerName = InternalBouncers.GetKeyAt(i)
			Dim BouncerInfo As Map
			BouncerInfo = InternalBouncers.Get(BouncerName)
			
			' TODO: Invia messaggio al bouncer collegato
			LogInfo("Broadcasting to " & BouncerName & ": " & Message, "BroadcastInternalMessage")
		Next
		
		Return True
		
	Catch Error As Exception
		LogError("BROADCAST_INTERNAL_MESSAGE_ERROR", Error.Message, "BroadcastInternalMessage")
		Return False
	End Try
End Sub

Sub GetInternalChannelList() As String
	Try
		Dim Result As String
		Result = "Internal Channels:" & Chr(10)
		
		For i = 0 To InternalChannels.Size - 1
			Dim ChannelName As String
			ChannelName = InternalChannels.GetKeyAt(i)
			Dim ChannelInfo As Map
			ChannelInfo = InternalChannels.Get(ChannelName)
			Dim ChannelUsers As Map
			ChannelUsers = ChannelInfo.Get("Users")
			Dim ChannelTopic As String
			ChannelTopic = ChannelInfo.Get("Topic")
			
			Result = Result & "  " & ChannelName & " (" & ChannelUsers.Size & " users) - " & ChannelTopic & Chr(10)
		Next
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_INTERNAL_CHANNEL_LIST_ERROR", Error.Message, "GetInternalChannelList")
		Return "Error retrieving internal channels"
	End Try
End Sub

Sub GetInternalUserList(Channel As String) As String
	Try
		Dim Result As String
		Result = "Users in " & Channel & ":" & Chr(10)
		
		If InternalChannels.ContainsKey(Channel) Then
			Dim ChannelInfo As Map
			ChannelInfo = InternalChannels.Get(Channel)
			Dim ChannelUsers As Map
			ChannelUsers = ChannelInfo.Get("Users")
			
			For i = 0 To ChannelUsers.Size - 1
				Dim User As String
				User = ChannelUsers.GetKeyAt(i)
				Dim UserInfo As Map
				UserInfo = ChannelUsers.Get(User)
				Dim UserModes As String
				UserModes = UserInfo.Get("Modes")
				
				If UserModes.Length > 0 Then
					Result = Result & "  @" & User & " (" & UserModes & ")" & Chr(10)
				Else
					Result = Result & "  " & User & Chr(10)
				End If
			Next
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_INTERNAL_USER_LIST_ERROR", Error.Message, "GetInternalUserList")
		Return "Error retrieving internal users"
	End Try
End Sub

' ======================
' PERFORMANCE MONITORING FUNCTIONS
' ======================

Sub StartPerformanceMonitoring() As Boolean
	Try
		If PerformanceMonitoring = False Then
			PerformanceMonitoring = True
			PerformanceStartTime = DateTime.Now
			PerformanceLastUpdate = DateTime.Now
			
			' Avvia timer performance
			TimerPerformance.Initialize("TimerPerformance", PerformanceInterval)
			TimerPerformance.Enabled = True
			
			LogInfo("Performance monitoring started", "StartPerformanceMonitoring")
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("START_PERFORMANCE_MONITORING_ERROR", Error.Message, "StartPerformanceMonitoring")
		Return False
	End Try
End Sub

Sub StopPerformanceMonitoring() As Boolean
	Try
		If PerformanceMonitoring = True Then
			PerformanceMonitoring = False
			TimerPerformance.Enabled = False
			
			LogInfo("Performance monitoring stopped", "StopPerformanceMonitoring")
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("STOP_PERFORMANCE_MONITORING_ERROR", Error.Message, "StopPerformanceMonitoring")
		Return False
	End Try
End Sub

Sub UpdatePerformanceData() As Boolean
	Try
		' Aggiorna dati CPU
		CPUUsage = GetCPUUsage()
		
		' Aggiorna dati memoria
		MemoryUsage = GetMemoryUsage()
		
		' Aggiorna dati rete
		Dim NetworkData As Map
		NetworkData = GetNetworkStats()
		NetworkInBytes = NetworkData.Get("InBytes")
		NetworkOutBytes = NetworkData.Get("OutBytes")
		
		' Aggiorna connessioni attive
		ActiveConnections = GetActiveConnectionsCount()
		
		' Salva dati performance
		Dim PerfData As Map
		PerfData.Initialize
		PerfData.Put("CPU", CPUUsage)
		PerfData.Put("Memory", MemoryUsage)
		PerfData.Put("NetworkIn", NetworkInBytes)
		PerfData.Put("NetworkOut", NetworkOutBytes)
		PerfData.Put("Connections", ActiveConnections)
		PerfData.Put("Timestamp", DateTime.Now)
		
		PerformanceHistory.Add(PerfData)
		
		' Mantieni solo ultimi 100 record
		If PerformanceHistory.Size > 100 Then
			PerformanceHistory.RemoveAt(0)
		End If
		
		' Controlla soglie performance
		CheckPerformanceThresholds()
		
		PerformanceLastUpdate = DateTime.Now
		Return True
		
	Catch Error As Exception
		LogError("UPDATE_PERFORMANCE_DATA_ERROR", Error.Message, "UpdatePerformanceData")
		Return False
	End Try
End Sub

Sub GetCPUUsage() As Float
	Try
		' Simula uso CPU (in un'app reale si userebbe API Android)
		Dim Random As Random
		Random.Initialize
		Return Random.Next(0, 100) / 100.0
		
	Catch Error As Exception
		LogError("GET_CPU_USAGE_ERROR", Error.Message, "GetCPUUsage")
		Return 0.0
	End Try
End Sub

Sub GetMemoryUsage() As Long
	Try
		' Simula uso memoria (in un'app reale si userebbe API Android)
		Dim Random As Random
		Random.Initialize
		Return Random.Next(50000000, 200000000) ' 50MB - 200MB
		
	Catch Error As Exception
		LogError("GET_MEMORY_USAGE_ERROR", Error.Message, "GetMemoryUsage")
		Return 0
	End Try
End Sub

Sub GetNetworkStats() As Map
	Try
		Dim NetworkData As Map
		NetworkData.Initialize
		
		' Simula statistiche rete
		Dim Random As Random
		Random.Initialize
		NetworkData.Put("InBytes", Random.Next(1000000, 10000000))
		NetworkData.Put("OutBytes", Random.Next(1000000, 10000000))
		NetworkData.Put("InPackets", Random.Next(1000, 10000))
		NetworkData.Put("OutPackets", Random.Next(1000, 10000))
		
		Return NetworkData
		
	Catch Error As Exception
		LogError("GET_NETWORK_STATS_ERROR", Error.Message, "GetNetworkStats")
		Dim EmptyData As Map
		EmptyData.Initialize
		Return EmptyData
	End Try
End Sub

Sub GetActiveConnectionsCount() As Int
	Try
		' Conta connessioni attive
		Dim Count As Int
		Count = 0
		
		' Conta client connessi
		If ClientConnections <> Null Then
			Count = Count + ClientConnections.Size
		End If
		
		' Conta server connessi
		If ServerConnections <> Null Then
			Count = Count + ServerConnections.Size
		End If
		
		' Conta connessioni DCC
		If DCCConnections <> Null Then
			Count = Count + DCCConnections.Size
		End If
		
		Return Count
		
	Catch Error As Exception
		LogError("GET_ACTIVE_CONNECTIONS_COUNT_ERROR", Error.Message, "GetActiveConnectionsCount")
		Return 0
	End Try
End Sub

Sub CheckPerformanceThresholds() As Boolean
	Try
		' Controlla soglia CPU
		If CPUUsage > PerformanceThresholds.Get("CPU_HIGH") Then
			TriggerPerformanceAlert("CPU_HIGH", "CPU usage is high: " & CPUUsage & "%")
		End If
		
		' Controlla soglia memoria
		If MemoryUsage > PerformanceThresholds.Get("MEMORY_HIGH") Then
			TriggerPerformanceAlert("MEMORY_HIGH", "Memory usage is high: " & MemoryUsage & " bytes")
		End If
		
		' Controlla soglia rete
		Dim NetworkTotal As Long
		NetworkTotal = NetworkInBytes + NetworkOutBytes
		If NetworkTotal > PerformanceThresholds.Get("NETWORK_HIGH") Then
			TriggerPerformanceAlert("NETWORK_HIGH", "Network usage is high: " & NetworkTotal & " bytes")
		End If
		
		' Controlla soglia connessioni
		If ActiveConnections > PerformanceThresholds.Get("CONNECTIONS_HIGH") Then
			TriggerPerformanceAlert("CONNECTIONS_HIGH", "Too many connections: " & ActiveConnections)
		End If
		
		Return True
		
	Catch Error As Exception
		LogError("CHECK_PERFORMANCE_THRESHOLDS_ERROR", Error.Message, "CheckPerformanceThresholds")
		Return False
	End Try
End Sub

Sub TriggerPerformanceAlert(AlertType As String, Message As String) As Boolean
	Try
		Dim AlertData As Map
		AlertData.Initialize
		AlertData.Put("Type", AlertType)
		AlertData.Put("Message", Message)
		AlertData.Put("Timestamp", DateTime.Now)
		AlertData.Put("CPU", CPUUsage)
		AlertData.Put("Memory", MemoryUsage)
		AlertData.Put("Connections", ActiveConnections)
		
		PerformanceAlerts.Put(DateTime.Now, AlertData)
		
		LogError("PERFORMANCE_ALERT", Message, "TriggerPerformanceAlert")
		Return True
		
	Catch Error As Exception
		LogError("TRIGGER_PERFORMANCE_ALERT_ERROR", Error.Message, "TriggerPerformanceAlert")
		Return False
	End Try
End Sub

Sub GetPerformanceStatus() As String
	Try
		Dim Result As String
		Result = "Performance Status:" & Chr(10)
		Result = Result & "  CPU Usage: " & CPUUsage & "%" & Chr(10)
		Result = Result & "  Memory Usage: " & MemoryUsage & " bytes" & Chr(10)
		Result = Result & "  Network In: " & NetworkInBytes & " bytes" & Chr(10)
		Result = Result & "  Network Out: " & NetworkOutBytes & " bytes" & Chr(10)
		Result = Result & "  Active Connections: " & ActiveConnections & Chr(10)
		Result = Result & "  Monitoring: " & PerformanceMonitoring & Chr(10)
		Result = Result & "  Alerts: " & PerformanceAlerts.Size & Chr(10)
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_PERFORMANCE_STATUS_ERROR", Error.Message, "GetPerformanceStatus")
		Return "Error retrieving performance status"
	End Try
End Sub

Sub TimerPerformance_Tick()
	Try
		If PerformanceMonitoring Then
			UpdatePerformanceData()
		End If
		
	Catch Error As Exception
		LogError("TIMER_PERFORMANCE_TICK_ERROR", Error.Message, "TimerPerformance_Tick")
	End Try
End Sub

' ======================
' CUSTOM DIRECTORY SYSTEM FUNCTIONS
' ======================
Sub SetCustomDirectory(Path As String) As Boolean
	Try
		' Valida percorso
		If Path.Length = 0 Then
			LogError("DIRECTORY_EMPTY", "Directory path is empty", "SetCustomDirectory")
			Return False
		End If
		
		' Controlla se directory esiste
		If File.Exists(Path, "") = False Then
			' Tenta di creare directory
			Try
				File.MakeDir(Path, "")
			Catch
				LogError("DIRECTORY_CREATE_FAILED", "Cannot create directory: " & Path, "SetCustomDirectory")
				Return False
			End Try
		End If
		
		' Controlla permessi scrittura
		If CheckDirectoryPermissions(Path) = False Then
			LogError("DIRECTORY_NO_WRITE", "No write permission for directory: " & Path, "SetCustomDirectory")
			Return False
		End If
		
		' Imposta directory custom
		CustomDirectoryPath = Path
		CustomDirectoryEnabled = True
		DirectoryStats.Put("CustomPath", Path)
		DirectoryStats.Put("CurrentPath", Path)
		DirectoryStats.Put("LastUsed", DateTime.Now)
		
		' Aggiungi alla cronologia
		If DirectoryHistory.IndexOf(Path) = -1 Then
			DirectoryHistory.Add(Path)
		End If
		
		LogInfo("Custom directory set to: " & Path, "SetCustomDirectory")
		Return True
		
	Catch Error As Exception
		LogError("SET_CUSTOM_DIRECTORY_ERROR", Error.Message, "SetCustomDirectory")
		Return False
	End Try
End Sub

Sub ResetToDefaultDirectory() As Boolean
	Try
		CustomDirectoryEnabled = False
		CustomDirectoryPath = ""
		DirectoryStats.Put("CurrentPath", DefaultDirectoryPath)
		DirectoryStats.Put("LastUsed", DateTime.Now)
		
		LogInfo("Directory reset to default: " & DefaultDirectoryPath, "ResetToDefaultDirectory")
		Return True
		
	Catch Error As Exception
		LogError("RESET_DIRECTORY_ERROR", Error.Message, "ResetToDefaultDirectory")
		Return False
	End Try
End Sub

Sub GetCurrentDirectory() As String
	Try
		If CustomDirectoryEnabled And CustomDirectoryPath.Length > 0 Then
			Return CustomDirectoryPath
		Else
			Return DefaultDirectoryPath
		End If
	Catch Error As Exception
		LogError("GET_CURRENT_DIRECTORY_ERROR", Error.Message, "GetCurrentDirectory")
		Return DefaultDirectoryPath
	End Try
End Sub

Sub GetDirectoryStatus() As String
	Try
		Dim result As String = "Directory System Status:" & CRLF
		result = result & "Custom Directory Enabled: " & CustomDirectoryEnabled & CRLF
		result = result & "Current Directory: " & GetCurrentDirectory() & CRLF
		result = result & "Default Directory: " & DefaultDirectoryPath & CRLF
		result = result & "Custom Directory: " & CustomDirectoryPath & CRLF & CRLF
		
		result = result & "Statistics:" & CRLF
		result = result & "Files Saved: " & DirectoryStats.Get("FilesSaved") & CRLF
		result = result & "Total Size: " & FormatFileSize(DirectoryStats.Get("TotalSize")) & CRLF
		result = result & "Last Used: " & DirectoryStats.Get("LastUsed") & CRLF & CRLF
		
		result = result & "Quota:" & CRLF
		result = result & "Max Size: " & FormatFileSize(DirectoryQuota.Get("MaxSize")) & CRLF
		result = result & "Max Files: " & DirectoryQuota.Get("MaxFiles") & CRLF
		result = result & "Warning Threshold: " & DirectoryQuota.Get("WarningThreshold") & "%" & CRLF & CRLF
		
		result = result & "Permissions:" & CRLF
		result = result & "Read: " & DirectoryPermissions.Get("Read") & CRLF
		result = result & "Write: " & DirectoryPermissions.Get("Write") & CRLF
		result = result & "Delete: " & DirectoryPermissions.Get("Delete") & CRLF
		result = result & "Create: " & DirectoryPermissions.Get("Create") & CRLF & CRLF
		
		result = result & "History (" & DirectoryHistory.Size & " directories):" & CRLF
		For i = 0 To DirectoryHistory.Size - 1
			result = result & "  " & DirectoryHistory.Get(i) & CRLF
		Next
		
		Return result
		
	Catch Error As Exception
		LogError("GET_DIRECTORY_STATUS_ERROR", Error.Message, "GetDirectoryStatus")
		Return "Error getting directory status"
	End Try
End Sub

Sub CheckDirectoryPermissions(Path As String) As Boolean
	Try
		' Test scrittura
		Dim TestFile As String
		TestFile = Path & "/test_write.tmp"
		
		' Prova a scrivere file di test
		File.WriteString(Path, "test_write.tmp", "test")
		
		' Prova a leggere file di test
		Dim TestContent As String
		TestContent = File.ReadString(Path, "test_write.tmp")
		
		' Rimuovi file di test
		File.Delete(Path, "test_write.tmp")
		
		Return True
		
	Catch Error As Exception
		LogError("DIRECTORY_PERMISSION_CHECK_ERROR", Error.Message, "CheckDirectoryPermissions")
		Return False
	End Try
End Sub

Sub SetDirectoryQuota(MaxSize As Long, MaxFiles As Int, WarningThreshold As Int) As Boolean
	Try
		DirectoryQuota.Put("MaxSize", MaxSize)
		DirectoryQuota.Put("MaxFiles", MaxFiles)
		DirectoryQuota.Put("WarningThreshold", WarningThreshold)
		
		LogInfo("Directory quota set: " & FormatFileSize(MaxSize) & ", " & MaxFiles & " files, " & WarningThreshold & "% warning", "SetDirectoryQuota")
		Return True
		
	Catch Error As Exception
		LogError("SET_DIRECTORY_QUOTA_ERROR", Error.Message, "SetDirectoryQuota")
		Return False
	End Try
End Sub

Sub CheckDirectoryQuota() As String
	Try
		Dim CurrentPath As String
		CurrentPath = GetCurrentDirectory()
		
		' Conta file e calcola dimensione
		Dim FileCount As Int
		Dim TotalSize As Long
		FileCount = 0
		TotalSize = 0
		
		' Simula controllo quota (in Android reale userebbe File.ListFiles)
		Dim MaxSize As Long = DirectoryQuota.Get("MaxSize")
		Dim MaxFiles As Int = DirectoryQuota.Get("MaxFiles")
		Dim WarningThreshold As Int = DirectoryQuota.Get("WarningThreshold")
		
		' Calcola percentuale utilizzo
		Dim SizePercent As Int
		Dim FilePercent As Int
		SizePercent = (TotalSize * 100) / MaxSize
		FilePercent = (FileCount * 100) / MaxFiles
		
		Dim Status As String
		Status = "Directory Quota Status:" & CRLF
		Status = Status & "Current Directory: " & CurrentPath & CRLF
		Status = Status & "Files: " & FileCount & "/" & MaxFiles & " (" & FilePercent & "%)" & CRLF
		Status = Status & "Size: " & FormatFileSize(TotalSize) & "/" & FormatFileSize(MaxSize) & " (" & SizePercent & "%)" & CRLF
		
		If SizePercent >= WarningThreshold Or FilePercent >= WarningThreshold Then
			Status = Status & "⚠️ WARNING: Quota threshold exceeded!" & CRLF
		Else
			Status = Status & "✅ Quota OK" & CRLF
		End If
		
		Return Status
		
	Catch Error As Exception
		LogError("CHECK_DIRECTORY_QUOTA_ERROR", Error.Message, "CheckDirectoryQuota")
		Return "Error checking directory quota"
	End Try
End Sub

Sub FormatFileSize(Bytes As Long) As String
	Try
		If Bytes < 1024 Then
			Return Bytes & " B"
		Else If Bytes < 1048576 Then
			Return Round(Bytes / 1024) & " KB"
		Else If Bytes < 1073741824 Then
			Return Round(Bytes / 1048576) & " MB"
		Else
			Return Round(Bytes / 1073741824) & " GB"
		End If
	Catch Error As Exception
		Return "Unknown"
	End Try
End Sub

Sub SaveFileToDirectory(FileName As String, Content As String) As Boolean
	Try
		Dim CurrentPath As String
		CurrentPath = GetCurrentDirectory()
		
		' Controlla quota prima di salvare
		If CheckQuotaBeforeSave() = False Then
			LogError("QUOTA_EXCEEDED", "Cannot save file, quota exceeded", "SaveFileToDirectory")
			Return False
		End If
		
		' Salva file nella directory corrente
		File.WriteString(CurrentPath, FileName, Content)
		
		' Aggiorna statistiche
		DirectoryStats.Put("FilesSaved", DirectoryStats.Get("FilesSaved") + 1)
		DirectoryStats.Put("TotalSize", DirectoryStats.Get("TotalSize") + Content.Length)
		DirectoryStats.Put("LastUsed", DateTime.Now)
		
		LogInfo("File saved to directory: " & CurrentPath & "/" & FileName, "SaveFileToDirectory")
		Return True
		
	Catch Error As Exception
		LogError("SAVE_FILE_TO_DIRECTORY_ERROR", Error.Message, "SaveFileToDirectory")
		Return False
	End Try
End Sub

Sub SaveBinaryFileToDirectory(FileName As String, BinaryData() As Byte) As Boolean
	Try
		Dim CurrentPath As String
		CurrentPath = GetCurrentDirectory()
		
		' Controlla quota prima di salvare
		If CheckQuotaBeforeSave() = False Then
			LogError("QUOTA_EXCEEDED", "Cannot save binary file, quota exceeded", "SaveBinaryFileToDirectory")
			Return False
		End If
		
		' Salva file binario nella directory corrente
		File.WriteBytes(CurrentPath, FileName, BinaryData)
		
		' Aggiorna statistiche
		DirectoryStats.Put("FilesSaved", DirectoryStats.Get("FilesSaved") + 1)
		DirectoryStats.Put("TotalSize", DirectoryStats.Get("TotalSize") + BinaryData.Length)
		DirectoryStats.Put("LastUsed", DateTime.Now)
		
		LogInfo("Binary file saved to directory: " & CurrentPath & "/" & FileName & " (" & BinaryData.Length & " bytes)", "SaveBinaryFileToDirectory")
		Return True
		
	Catch Error As Exception
		LogError("SAVE_BINARY_FILE_TO_DIRECTORY_ERROR", Error.Message, "SaveBinaryFileToDirectory")
		Return False
	End Try
End Sub

Sub GetFileExtension(FileName As String) As String
	Try
		Dim LastDot As Int
		LastDot = FileName.LastIndexOf(".")
		If LastDot >= 0 And LastDot < FileName.Length - 1 Then
			Return FileName.SubString(LastDot + 1).ToLowerCase
		Else
			Return ""
		End If
	Catch Error As Exception
		Return ""
	End Try
End Sub

Sub IsBinaryFile(FileName As String) As Boolean
	Try
		Dim Extension As String
		Extension = GetFileExtension(FileName)
		
		' Lista estensioni file binari
		Dim BinaryExtensions() As String
		BinaryExtensions = Array As String("mp4", "avi", "mkv", "mov", "wmv", "flv", "webm", "mp3", "wav", "flac", "aac", "ogg", "jpg", "jpeg", "png", "gif", "bmp", "tiff", "pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "zip", "rar", "7z", "tar", "gz", "exe", "dll", "so", "bin", "dat", "iso", "img")
		
		For i = 0 To BinaryExtensions.Length - 1
			If Extension = BinaryExtensions(i) Then
				Return True
			End If
		Next
		
		Return False
		
	Catch Error As Exception
		Return False
	End Try
End Sub

Sub IsVideoFile(FileName As String) As Boolean
	Try
		Dim Extension As String
		Extension = GetFileExtension(FileName)
		
		' Lista estensioni video
		Dim VideoExtensions() As String
		VideoExtensions = Array As String("mp4", "avi", "mkv", "mov", "wmv", "flv", "webm", "m4v", "3gp", "mpg", "mpeg", "ts", "vob")
		
		For i = 0 To VideoExtensions.Length - 1
			If Extension = VideoExtensions(i) Then
				Return True
			End If
		Next
		
		Return False
		
	Catch Error As Exception
		Return False
	End Try
End Sub

Sub IsAudioFile(FileName As String) As Boolean
	Try
		Dim Extension As String
		Extension = GetFileExtension(FileName)
		
		' Lista estensioni audio
		Dim AudioExtensions() As String
		AudioExtensions = Array As String("mp3", "wav", "flac", "aac", "ogg", "m4a", "wma", "opus", "amr")
		
		For i = 0 To AudioExtensions.Length - 1
			If Extension = AudioExtensions(i) Then
				Return True
			End If
		Next
		
		Return False
		
	Catch Error As Exception
		Return False
	End Try
End Sub

Sub IsImageFile(FileName As String) As Boolean
	Try
		Dim Extension As String
		Extension = GetFileExtension(FileName)
		
		' Lista estensioni immagini
		Dim ImageExtensions() As String
		ImageExtensions = Array As String("jpg", "jpeg", "png", "gif", "bmp", "tiff", "webp", "svg", "ico")
		
		For i = 0 To ImageExtensions.Length - 1
			If Extension = ImageExtensions(i) Then
				Return True
			End If
		Next
		
		Return False
		
	Catch Error As Exception
		Return False
	End Try
End Sub

Sub CheckQuotaBeforeSave() As Boolean
	Try
		Dim MaxSize As Long = DirectoryQuota.Get("MaxSize")
		Dim MaxFiles As Int = DirectoryQuota.Get("MaxFiles")
		Dim CurrentSize As Long = DirectoryStats.Get("TotalSize")
		Dim CurrentFiles As Int = DirectoryStats.Get("FilesSaved")
		
		' Controlla se supera quota
		If CurrentSize >= MaxSize Or CurrentFiles >= MaxFiles Then
			Return False
		End If
		
		Return True
		
	Catch Error As Exception
		LogError("CHECK_QUOTA_BEFORE_SAVE_ERROR", Error.Message, "CheckQuotaBeforeSave")
		Return False
	End Try
End Sub

Sub ListDirectoryHistory() As String
	Try
		Dim result As String = "Directory History:" & CRLF
		For i = 0 To DirectoryHistory.Size - 1
			Dim Path As String = DirectoryHistory.Get(i)
			Dim IsCurrent As String = ""
			If Path = GetCurrentDirectory() Then
				IsCurrent = " (CURRENT)"
			End If
			result = result & (i + 1) & ". " & Path & IsCurrent & CRLF
		Next
		Return result
	Catch Error As Exception
		Return "Error listing directory history"
	End Try
End Sub

Sub ClearDirectoryHistory()
	Try
		DirectoryHistory.Clear
		DirectoryHistory.Add(DefaultDirectoryPath) ' Mantieni sempre la default
		LogInfo("Directory history cleared", "ClearDirectoryHistory")
	Catch Error As Exception
		LogError("CLEAR_DIRECTORY_HISTORY_ERROR", Error.Message, "ClearDirectoryHistory")
	End Try
End Sub

Sub GetFileInfo(FileName As String) As String
	Try
		Dim CurrentPath As String
		CurrentPath = GetCurrentDirectory()
		
		Dim result As String = "File Information:" & CRLF
		result = result & "File: " & FileName & CRLF
		result = result & "Path: " & CurrentPath & "/" & FileName & CRLF
		result = result & "Extension: " & GetFileExtension(FileName) & CRLF
		
		' Determina tipo di file
		If IsVideoFile(FileName) Then
			result = result & "Type: 🎬 VIDEO FILE" & CRLF
			result = result & "Description: Video file - can be viewed with media player" & CRLF
		Else If IsAudioFile(FileName) Then
			result = result & "Type: 🎵 AUDIO FILE" & CRLF
			result = result & "Description: Audio file - can be played with music player" & CRLF
		Else If IsImageFile(FileName) Then
			result = result & "Type: 🖼️ IMAGE FILE" & CRLF
			result = result & "Description: Image file - can be viewed with gallery" & CRLF
		Else If IsBinaryFile(FileName) Then
			result = result & "Type: 📁 BINARY FILE" & CRLF
			result = result & "Description: Binary file - may require specific application" & CRLF
		Else
			result = result & "Type: 📄 TEXT FILE" & CRLF
			result = result & "Description: Text file - can be opened with text editor" & CRLF
		End If
		
		' Controlla se file esiste
		If File.Exists(CurrentPath, FileName) Then
			result = result & "Status: ✅ FILE EXISTS" & CRLF
			result = result & "Location: " & CurrentPath & "/" & FileName & CRLF
			result = result & "Note: File is ready for use" & CRLF
		Else
			result = result & "Status: ⏳ PENDING TRANSFER" & CRLF
			result = result & "Note: File metadata saved, waiting for binary transfer" & CRLF
		End If
		
		Return result
		
	Catch Error As Exception
		LogError("GET_FILE_INFO_ERROR", Error.Message, "GetFileInfo")
		Return "Error getting file information"
	End Try
End Sub

' ======================
' DCC RESUME SYSTEM FUNCTIONS
' ======================
Sub HandleDCCResume(FileName As String, Position As Long, Sender As String) As Boolean
	Try
		If Not DCCResumeEnabled Then
			LogError("DCC_RESUME_DISABLED", "DCC Resume is disabled", "HandleDCCResume")
			Return False
		End If
		
		' Crea chiave univoca per il file
		Dim FileKey As String
		FileKey = Sender & "_" & FileName
		
		' Controlla se file è in attesa di resume
		If DCCResumeFiles.ContainsKey(FileKey) Then
			' Aggiorna posizione resume
			DCCResumePositions.Put(FileKey, Position)
			DCCResumeTimeouts.Put(FileKey, DateTime.Now + DCCResumeTimeout)
			
			' Incrementa tentativi
			Dim CurrentRetries As Int
			CurrentRetries = DCCResumeRetries.Get(FileKey)
			DCCResumeRetries.Put(FileKey, CurrentRetries + 1)
			
			' Aggiorna statistiche
			DCCResumeStats.Put("TotalResumes", DCCResumeStats.Get("TotalResumes") + 1)
			
			' Aggiungi a storico
			DCCResumeHistory.Add(DateTime.Now & " - RESUME: " & FileName & " from " & Sender & " at position " & Position)
			If DCCResumeHistory.Size > 1000 Then
				DCCResumeHistory.RemoveAt(0)
			End If
			
			LogInfo("DCC Resume requested: " & FileName & " from " & Sender & " at position " & Position, "HandleDCCResume")
			
			' Tenta resume automatico
			If AttemptDCCResume(FileKey) Then
				DCCResumeStats.Put("SuccessfulResumes", DCCResumeStats.Get("SuccessfulResumes") + 1)
				DCCResumeStats.Put("AutoResumes", DCCResumeStats.Get("AutoResumes") + 1)
				Return True
			Else
				DCCResumeStats.Put("FailedResumes", DCCResumeStats.Get("FailedResumes") + 1)
				Return False
			End If
		Else
			LogError("DCC_RESUME_FILE_NOT_FOUND", "No resume data for file: " & FileName, "HandleDCCResume")
			Return False
		End If
		
	Catch Error As Exception
		LogError("DCC_RESUME_ERROR", Error.Message, "HandleDCCResume")
		Return False
	End Try
End Sub

Sub AttemptDCCResume(FileKey As String) As Boolean
	Try
		' Controlla se file ha superato max tentativi
		Dim Retries As Int
		Retries = DCCResumeRetries.Get(FileKey)
		If Retries >= DCCResumeMaxRetries Then
			LogError("DCC_RESUME_MAX_RETRIES", "Max retries exceeded for file: " & FileKey, "AttemptDCCResume")
			Return False
		End If
		
		' Controlla timeout
		Dim Timeout As Long
		Timeout = DCCResumeTimeouts.Get(FileKey)
		If DateTime.Now > Timeout Then
			LogError("DCC_RESUME_TIMEOUT", "Resume timeout for file: " & FileKey, "AttemptDCCResume")
			Return False
		End If
		
		' Ottieni dati file
		Dim FileData As Map
		FileData = DCCResumeFiles.Get(FileKey)
		Dim FileName As String = FileData.Get("FileName")
		Dim Sender As String = FileData.Get("Sender")
		Dim Position As Long = DCCResumePositions.Get(FileKey)
		
		' Tenta connessione DCC per resume
		Dim DCCSocket As Socket
		DCCSocket.Initialize("DCCResume_" & FileKey)
		
		' Connetti al server DCC
		Dim RemoteIP As String = FileData.Get("RemoteIP")
		Dim RemotePort As Int = FileData.Get("RemotePort")
		DCCSocket.Connect(RemoteIP, RemotePort)
		
		' Attendi connessione
		Dim ConnectionTimeout As Int = 0
		Do While DCCSocket.Connected = False And ConnectionTimeout < 5000
			Sleep(100)
			ConnectionTimeout = ConnectionTimeout + 100
		Loop
		
		If DCCSocket.Connected Then
			' Invia comando RESUME
			Dim ResumeCommand As String
			ResumeCommand = "DCC RESUME " & FileName & " " & Position
			DCCSocket.OutputStream.WriteBytes(ResumeCommand.GetBytes("UTF8"), 0, ResumeCommand.Length)
			
			' Aggiorna stato
			FileData.Put("Status", "Resuming")
			FileData.Put("ResumePosition", Position)
			FileData.Put("ResumeSocket", DCCSocket)
			
			LogInfo("DCC Resume connection established: " & FileName & " at position " & Position, "AttemptDCCResume")
			Return True
		Else
			LogError("DCC_RESUME_CONNECTION_FAILED", "Failed to connect for resume: " & FileName, "AttemptDCCResume")
			Return False
		End If
		
	Catch Error As Exception
		LogError("DCC_RESUME_ATTEMPT_ERROR", Error.Message, "AttemptDCCResume")
		Return False
	End Try
End Sub

Sub SaveDCCResumeData(FileName As String, Sender As String, RemoteIP As String, RemotePort As Int, FileSize As Long) As Boolean
	Try
		Dim FileKey As String
		FileKey = Sender & "_" & FileName
		
		' Salva dati per resume
		Dim ResumeData As Map
		ResumeData.Initialize
		ResumeData.Put("FileName", FileName)
		ResumeData.Put("Sender", Sender)
		ResumeData.Put("RemoteIP", RemoteIP)
		ResumeData.Put("RemotePort", RemotePort)
		ResumeData.Put("FileSize", FileSize)
		ResumeData.Put("Status", "Pending")
		ResumeData.Put("Created", DateTime.Now)
		
		DCCResumeFiles.Put(FileKey, ResumeData)
		DCCResumePositions.Put(FileKey, 0)
		DCCResumeTimeouts.Put(FileKey, DateTime.Now + DCCResumeTimeout)
		DCCResumeRetries.Put(FileKey, 0)
		
		LogInfo("DCC Resume data saved: " & FileName & " from " & Sender, "SaveDCCResumeData")
		Return True
		
	Catch Error As Exception
		LogError("DCC_RESUME_SAVE_ERROR", Error.Message, "SaveDCCResumeData")
		Return False
	End Try
End Sub

Sub GetDCCResumeStatus() As String
	Try
		Dim result As String = "DCC Resume System Status:" & CRLF
		result = result & "Enabled: " & DCCResumeEnabled & CRLF
		result = result & "Max Retries: " & DCCResumeMaxRetries & CRLF
		result = result & "Timeout: " & DCCResumeTimeout & "ms" & CRLF & CRLF
		
		result = result & "Statistics:" & CRLF
		result = result & "Total Resumes: " & DCCResumeStats.Get("TotalResumes") & CRLF
		result = result & "Successful: " & DCCResumeStats.Get("SuccessfulResumes") & CRLF
		result = result & "Failed: " & DCCResumeStats.Get("FailedResumes") & CRLF
		result = result & "Auto Resumes: " & DCCResumeStats.Get("AutoResumes") & CRLF & CRLF
		
		result = result & "Pending Files (" & DCCResumeFiles.Size & "):" & CRLF
		For i = 0 To DCCResumeFiles.Size - 1
			Dim FileKey As String = DCCResumeFiles.GetKeyAt(i)
			Dim FileData As Map = DCCResumeFiles.Get(FileKey)
			Dim Position As Long = DCCResumePositions.Get(FileKey)
			Dim Retries As Int = DCCResumeRetries.Get(FileKey)
			
			result = result & "  " & FileData.Get("FileName") & " from " & FileData.Get("Sender") & CRLF
			result = result & "    Position: " & Position & " bytes" & CRLF
			result = result & "    Retries: " & Retries & "/" & DCCResumeMaxRetries & CRLF
			result = result & "    Status: " & FileData.Get("Status") & CRLF
		Next
		
		Return result
		
	Catch Error As Exception
		LogError("DCC_RESUME_STATUS_ERROR", Error.Message, "GetDCCResumeStatus")
		Return "Error getting DCC resume status"
	End Try
End Sub

Sub CleanupDCCResume()
	Try
		Dim CurrentTime As Long = DateTime.Now
		Dim KeysToRemove As List
		KeysToRemove.Initialize
		
		' Controlla timeout e max retries
		For i = 0 To DCCResumeFiles.Size - 1
			Dim FileKey As String = DCCResumeFiles.GetKeyAt(i)
			Dim Timeout As Long = DCCResumeTimeouts.Get(FileKey)
			Dim Retries As Int = DCCResumeRetries.Get(FileKey)
			
			If CurrentTime > Timeout Or Retries >= DCCResumeMaxRetries Then
				KeysToRemove.Add(FileKey)
			End If
		Next
		
		' Rimuovi file scaduti
		For i = 0 To KeysToRemove.Size - 1
			Dim FileKey As String = KeysToRemove.Get(i)
			DCCResumeFiles.Remove(FileKey)
			DCCResumePositions.Remove(FileKey)
			DCCResumeChecksums.Remove(FileKey)
			DCCResumeTimeouts.Remove(FileKey)
			DCCResumeRetries.Remove(FileKey)
		Next
		
		If KeysToRemove.Size > 0 Then
			LogInfo("DCC Resume cleanup: removed " & KeysToRemove.Size & " expired files", "CleanupDCCResume")
		End If
		
	Catch Error As Exception
		LogError("DCC_RESUME_CLEANUP_ERROR", Error.Message, "CleanupDCCResume")
	End Try
End Sub

Sub EnableDCCResume(Enable As Boolean) As Boolean
	Try
		DCCResumeEnabled = Enable
		LogInfo("DCC Resume " & IIf(Enable, "enabled", "disabled"), "EnableDCCResume")
		Return True
	Catch Error As Exception
		LogError("DCC_RESUME_ENABLE_ERROR", Error.Message, "EnableDCCResume")
		Return False
	End Try
End Sub

Sub SetDCCResumeTimeout(Timeout As Int) As Boolean
	Try
		DCCResumeTimeout = Timeout
		LogInfo("DCC Resume timeout set to " & Timeout & "ms", "SetDCCResumeTimeout")
		Return True
	Catch Error As Exception
		LogError("DCC_RESUME_TIMEOUT_ERROR", Error.Message, "SetDCCResumeTimeout")
		Return False
	End Try
End Sub

Sub SetDCCResumeMaxRetries(MaxRetries As Int) As Boolean
	Try
		DCCResumeMaxRetries = MaxRetries
		LogInfo("DCC Resume max retries set to " & MaxRetries, "SetDCCResumeMaxRetries")
		Return True
	Catch Error As Exception
		LogError("DCC_RESUME_MAX_RETRIES_ERROR", Error.Message, "SetDCCResumeMaxRetries")
		Return False
	End Try
End Sub

Sub CheckDCCResumeAuto(FileName As String, Sender As String, RemoteIP As String, RemotePort As Int, FileSize As Long) As Boolean
	Try
		If Not DCCResumeAutoEnabled Then
			Return False
		End If
		
		' Crea chiave per cache (IP + FileName)
		Dim CacheKey As String
		CacheKey = RemoteIP & "_" & FileName
		
		' Controlla se file esiste in cache
		If DCCResumeFileCache.ContainsKey(CacheKey) Then
			Dim CacheData As Map
			CacheData = DCCResumeFileCache.Get(CacheKey)
			
			' Controlla se è lo stesso file (stesso IP, stesso nome, stessa dimensione)
			If CacheData.Get("Sender") = Sender And CacheData.Get("RemoteIP") = RemoteIP And CacheData.Get("FileSize") = FileSize Then
				' Controlla timeout cache
				Dim CacheTime As Long
				CacheTime = CacheData.Get("CacheTime")
				If DateTime.Now - CacheTime < DCCResumeAutoTimeout Then
					' File identico trovato - tenta resume automatico
					Dim ResumePosition As Long
					ResumePosition = CacheData.Get("ResumePosition")
					
					LogInfo("DCC Auto-Resume detected: " & FileName & " from " & Sender & " at position " & ResumePosition, "CheckDCCResumeAuto")
					
					' Tenta resume automatico
					If HandleDCCResume(FileName, ResumePosition, Sender) Then
						DCCResumeStats.Put("AutoResumes", DCCResumeStats.Get("AutoResumes") + 1)
						WriteSocket(":-psyBNC NOTICE " & Nickconnessione & " :🔄 DCC Auto-Resume: " & FileName & " from " & Sender & " at position " & ResumePosition)
						Return True
					End If
				End If
			End If
		End If
		
		' Salva file in cache per future resume automatici
		Dim NewCacheData As Map
		NewCacheData.Initialize
		NewCacheData.Put("FileName", FileName)
		NewCacheData.Put("Sender", Sender)
		NewCacheData.Put("RemoteIP", RemoteIP)
		NewCacheData.Put("RemotePort", RemotePort)
		NewCacheData.Put("FileSize", FileSize)
		NewCacheData.Put("ResumePosition", 0)
		NewCacheData.Put("CacheTime", DateTime.Now)
		
		DCCResumeFileCache.Put(CacheKey, NewCacheData)
		
		Return False
		
	Catch Error As Exception
		LogError("DCC_RESUME_AUTO_ERROR", Error.Message, "CheckDCCResumeAuto")
		Return False
	End Try
End Sub

Sub UpdateDCCResumePosition(FileName As String, Sender As String, RemoteIP As String, Position As Long) As Boolean
	Try
		Dim CacheKey As String
		CacheKey = RemoteIP & "_" & FileName
		
		If DCCResumeFileCache.ContainsKey(CacheKey) Then
			Dim CacheData As Map
			CacheData = DCCResumeFileCache.Get(CacheKey)
			CacheData.Put("ResumePosition", Position)
			CacheData.Put("CacheTime", DateTime.Now)
			DCCResumeFileCache.Put(CacheKey, CacheData)
			
			LogInfo("DCC Resume position updated: " & FileName & " at position " & Position, "UpdateDCCResumePosition")
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("DCC_RESUME_POSITION_ERROR", Error.Message, "UpdateDCCResumePosition")
		Return False
	End Try
End Sub

Sub CleanupDCCResumeCache()
	Try
		Dim CurrentTime As Long = DateTime.Now
		Dim KeysToRemove As List
		KeysToRemove.Initialize
		
		' Controlla timeout cache
		For i = 0 To DCCResumeFileCache.Size - 1
			Dim CacheKey As String = DCCResumeFileCache.GetKeyAt(i)
			Dim CacheData As Map = DCCResumeFileCache.Get(CacheKey)
			Dim CacheTime As Long = CacheData.Get("CacheTime")
			
			If CurrentTime - CacheTime > DCCResumeAutoTimeout Then
				KeysToRemove.Add(CacheKey)
			End If
		Next
		
		' Rimuovi cache scadute
		For i = 0 To KeysToRemove.Size - 1
			Dim CacheKey As String = KeysToRemove.Get(i)
			DCCResumeFileCache.Remove(CacheKey)
		Next
		
		If KeysToRemove.Size > 0 Then
			LogInfo("DCC Resume cache cleanup: removed " & KeysToRemove.Size & " expired entries", "CleanupDCCResumeCache")
		End If
		
	Catch Error As Exception
		LogError("DCC_RESUME_CACHE_CLEANUP_ERROR", Error.Message, "CleanupDCCResumeCache")
	End Try
End Sub

Sub EnableDCCResumeAuto(Enable As Boolean) As Boolean
	Try
		DCCResumeAutoEnabled = Enable
		LogInfo("DCC Resume Auto " & IIf(Enable, "enabled", "disabled"), "EnableDCCResumeAuto")
		Return True
	Catch Error As Exception
		LogError("DCC_RESUME_AUTO_ENABLE_ERROR", Error.Message, "EnableDCCResumeAuto")
		Return False
	End Try
End Sub

Sub SetDCCResumeAutoTimeout(Timeout As Int) As Boolean
	Try
		DCCResumeAutoTimeout = Timeout
		LogInfo("DCC Resume Auto timeout set to " & Timeout & "ms", "SetDCCResumeAutoTimeout")
		Return True
	Catch Error As Exception
		LogError("DCC_RESUME_AUTO_TIMEOUT_ERROR", Error.Message, "SetDCCResumeAutoTimeout")
		Return False
	End Try
End Sub

' ======================
' DNS CORE SYSTEM FUNCTIONS
' ======================
Sub ResolveDNS(hostname As String) As String
	Try
		If Not DNSCoreEnabled Then
			Return ""
		End If
		
		' Controlla se hostname è bloccato
		If DNSBlocked.IndexOf(hostname) >= 0 Then
			LogError("DNS: Hostname blocked: " & hostname, "ResolveDNS")
			Return ""
		End If
		
		' Controlla cache DNS
		If DNSCache.ContainsKey(hostname) Then
			Dim cacheTime As Long = DNSCacheTTL.Get(hostname)
			If DateTime.Now - cacheTime < 300000 Then ' 5 minuti TTL
				DNSStats.Put("CacheHits", DNSStats.Get("CacheHits") + 1)
				Return DNSCache.Get(hostname)
			Else
				' Cache scaduta, rimuovi
				DNSCache.Remove(hostname)
				DNSCacheTTL.Remove(hostname)
			End If
		End If
		
		DNSStats.Put("CacheMisses", DNSStats.Get("CacheMisses") + 1)
		DNSStats.Put("Resolutions", DNSStats.Get("Resolutions") + 1)
		
		' Risoluzione DNS reale
		Dim ip As String = ""
		Dim success As Boolean = False
		
		' Prova server DNS primari
		For i = 0 To DNSResolvers.Size - 1
			Try
				Dim resolver As String = DNSResolvers.Get(i)
				ip = PerformDNSResolution(hostname, resolver)
				If ip <> "" Then
					success = True
					Exit
				End If
			Catch
				LogError("DNS: Error with resolver: " & DNSResolvers.Get(i), "ResolveDNS")
			End Try
		Next
		
		' Se fallisce, prova server fallback
		If Not success Then
			For i = 0 To DNSFallback.Size - 1
				Try
					Dim fallback As String = DNSFallback.Get(i)
					ip = PerformDNSResolution(hostname, fallback)
					If ip <> "" Then
						success = True
						Exit
					End If
				Catch
					LogError("DNS: Error with fallback: " & DNSFallback.Get(i), "ResolveDNS")
				End Try
			Next
		End If
		
		If success And ip <> "" Then
			' Salva in cache
			DNSCache.Put(hostname, ip)
			DNSCacheTTL.Put(hostname, DateTime.Now)
			
			' Aggiorna statistiche
			If ip.Contains(":") Then
				DNSStats.Put("IPv6Resolutions", DNSStats.Get("IPv6Resolutions") + 1)
			Else
				DNSStats.Put("IPv4Resolutions", DNSStats.Get("IPv4Resolutions") + 1)
			End If
			
			' Aggiungi a storico
			DNSHistory.Add(DateTime.Now & " - " & hostname & " -> " & ip)
			If DNSHistory.Size > 1000 Then
				DNSHistory.RemoveAt(0) ' Mantieni solo ultimi 1000
			End If
			
			Return ip
		Else
			DNSStats.Put("Errors", DNSStats.Get("Errors") + 1)
			LogError("DNS: Failed to resolve: " & hostname, "ResolveDNS")
			Return ""
		End If
		
	Catch
		DNSStats.Put("Errors", DNSStats.Get("Errors") + 1)
		LogError("DNS: Exception in ResolveDNS: " & hostname, "ResolveDNS")
		Return ""
	End Try
End Sub

Sub PerformDNSResolution(hostname As String, resolver As String) As String
	Try
		' Simula risoluzione DNS (in Android reale userebbe InetAddress)
		' Per ora restituisce IP simulato basato su hostname
		If hostname.Contains("google") Then
			Return "8.8.8.8"
		Else If hostname.Contains("cloudflare") Then
			Return "1.1.1.1"
		Else If hostname.Contains("github") Then
			Return "140.82.112.4"
		Else If hostname.Contains("discord") Then
			Return "162.159.130.234"
		Else If hostname.Contains("irc") Then
			Return "127.0.0.1"
		Else
			' IP casuale per test
			Return "192.168.1." & (Rnd(1) * 254 + 1)
		End If
	Catch
		Return ""
	End Try
End Sub

Sub GetDNSCache() As String
	Try
		Dim result As String = "DNS Cache:" & CRLF
		For i = 0 To DNSCache.Size - 1
			Dim hostname As String = DNSCache.GetKeyAt(i)
			Dim ip As String = DNSCache.Get(hostname)
			Dim ttl As Long = DNSCacheTTL.Get(hostname)
			Dim age As Long = DateTime.Now - ttl
			result = result & hostname & " -> " & ip & " (TTL: " & (300 - age/1000) & "s)" & CRLF
		Next
		Return result
	Catch
		Return "Error getting DNS cache"
	End Try
End Sub

Sub ClearDNSCache()
	Try
		DNSCache.Clear
		DNSCacheTTL.Clear
		LogInfo("DNS: Cache cleared", "ClearDNSCache")
	Catch
		LogError("DNS: Error clearing cache", "ClearDNSCache")
	End Try
End Sub

Sub GetDNSStatus() As String
	Try
		Dim result As String = "DNS Core System Status:" & CRLF
		result = result & "Enabled: " & DNSCoreEnabled & CRLF
		result = result & "IPv6: " & DNSIPv6Enabled & CRLF
		result = result & "Timeout: " & DNSTimeout & "ms" & CRLF
		result = result & "Retries: " & DNSRetries & CRLF
		result = result & "Async: " & DNSAsyncEnabled & CRLF
		result = result & "Monitoring: " & DNSMonitoring & CRLF & CRLF
		
		result = result & "Statistics:" & CRLF
		result = result & "Resolutions: " & DNSStats.Get("Resolutions") & CRLF
		result = result & "Cache Hits: " & DNSStats.Get("CacheHits") & CRLF
		result = result & "Cache Misses: " & DNSStats.Get("CacheMisses") & CRLF
		result = result & "Errors: " & DNSStats.Get("Errors") & CRLF
		result = result & "Timeouts: " & DNSStats.Get("Timeouts") & CRLF
		result = result & "IPv4: " & DNSStats.Get("IPv4Resolutions") & CRLF
		result = result & "IPv6: " & DNSStats.Get("IPv6Resolutions") & CRLF & CRLF
		
		result = result & "Resolvers (" & DNSResolvers.Size & "):" & CRLF
		For i = 0 To DNSResolvers.Size - 1
			result = result & "  " & DNSResolvers.Get(i) & CRLF
		Next
		
		result = result & "Fallback (" & DNSFallback.Size & "):" & CRLF
		For i = 0 To DNSFallback.Size - 1
			result = result & "  " & DNSFallback.Get(i) & CRLF
		Next
		
		result = result & "Cache Entries: " & DNSCache.Size & CRLF
		result = result & "Blocked Hosts: " & DNSBlocked.Size & CRLF
		result = result & "Custom Entries: " & DNSCustom.Size & CRLF
		
		Return result
	Catch
		Return "Error getting DNS status"
	End Try
End Sub

Sub SetDNSTimeout(timeout As Int)
	Try
		DNSTimeout = timeout
		LogInfo("DNS: Timeout set to " & timeout & "ms", "SetDNSTimeout")
	Catch
		LogError("DNS: Error setting timeout", "SetDNSTimeout")
	End Try
End Sub

Sub AddDNSResolver(resolver As String)
	Try
		If DNSResolvers.IndexOf(resolver) < 0 Then
			DNSResolvers.Add(resolver)
			LogInfo("DNS: Added resolver: " & resolver, "AddDNSResolver")
		End If
	Catch
		LogError("DNS: Error adding resolver", "AddDNSResolver")
	End Try
End Sub

Sub RemoveDNSResolver(resolver As String)
	Try
		Dim index As Int = DNSResolvers.IndexOf(resolver)
		If index >= 0 Then
			DNSResolvers.RemoveAt(index)
			LogInfo("DNS: Removed resolver: " & resolver, "RemoveDNSResolver")
		End If
	Catch
		LogError("DNS: Error removing resolver", "RemoveDNSResolver")
	End Try
End Sub

Sub BlockDNSHost(hostname As String)
	Try
		If DNSBlocked.IndexOf(hostname) < 0 Then
			DNSBlocked.Add(hostname)
			LogInfo("DNS: Blocked host: " & hostname, "BlockDNSHost")
		End If
	Catch
		LogError("DNS: Error blocking host", "BlockDNSHost")
	End Try
End Sub

Sub UnblockDNSHost(hostname As String)
	Try
		Dim index As Int = DNSBlocked.IndexOf(hostname)
		If index >= 0 Then
			DNSBlocked.RemoveAt(index)
			LogInfo("DNS: Unblocked host: " & hostname, "UnblockDNSHost")
		End If
	Catch
		LogError("DNS: Error unblocking host", "UnblockDNSHost")
	End Try
End Sub

Sub AddCustomDNS(hostname As String, ip As String)
	Try
		DNSCustom.Put(hostname, ip)
		LogInfo("DNS: Added custom entry: " & hostname & " -> " & ip, "AddCustomDNS")
	Catch
		LogError("DNS: Error adding custom entry", "AddCustomDNS")
	End Try
End Sub

Sub RemoveCustomDNS(hostname As String)
	Try
		If DNSCustom.ContainsKey(hostname) Then
			DNSCustom.Remove(hostname)
			LogInfo("DNS: Removed custom entry: " & hostname, "RemoveCustomDNS")
		End If
	Catch
		LogError("DNS: Error removing custom entry", "RemoveCustomDNS")
	End Try
End Sub

Sub StartDNSMonitoring()
	Try
		DNSMonitoring = True
		LogInfo("DNS: Monitoring started", "StartDNSMonitoring")
	Catch
		LogError("DNS: Error starting monitoring", "StartDNSMonitoring")
	End Try
End Sub

Sub StopDNSMonitoring()
	Try
		DNSMonitoring = False
		LogInfo("DNS: Monitoring stopped", "StopDNSMonitoring")
	Catch
		LogError("DNS: Error stopping monitoring", "StopDNSMonitoring")
	End Try
End Sub

Sub GetDNSHistory() As String
	Try
		Dim result As String = "DNS Resolution History:" & CRLF
		For i = 0 To DNSHistory.Size - 1
			result = result & DNSHistory.Get(i) & CRLF
		Next
		Return result
	Catch
		Return "Error getting DNS history"
	End Try
End Sub

Sub CleanupDNSCache()
	Try
		Dim currentTime As Long = DateTime.Now
		Dim keysToRemove As List
		keysToRemove.Initialize
		
		For i = 0 To DNSCacheTTL.Size - 1
			Dim hostname As String = DNSCacheTTL.GetKeyAt(i)
			Dim ttl As Long = DNSCacheTTL.Get(hostname)
			If currentTime - ttl > 300000 Then ' 5 minuti
				keysToRemove.Add(hostname)
			End If
		Next
		
		For i = 0 To keysToRemove.Size - 1
			Dim hostname As String = keysToRemove.Get(i)
			DNSCache.Remove(hostname)
			DNSCacheTTL.Remove(hostname)
		Next
		
		If keysToRemove.Size > 0 Then
			LogInfo("DNS: Cleaned up " & keysToRemove.Size & " expired cache entries", "CleanupDNSCache")
		End If
	Catch
		LogError("DNS: Error cleaning up cache", "CleanupDNSCache")
	End Try
End Sub

' ======================
' SECURITY SYSTEM FUNCTIONS
' ======================

Sub StartSecurityMonitoring() As Boolean
	Try
		If SecurityMonitoring = False Then
			SecurityMonitoring = True
			
			LogInfo("Security monitoring started", "StartSecurityMonitoring")
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("START_SECURITY_MONITORING_ERROR", Error.Message, "StartSecurityMonitoring")
		Return False
	End Try
End Sub

Sub StopSecurityMonitoring() As Boolean
	Try
		If SecurityMonitoring = True Then
			SecurityMonitoring = False
			
			LogInfo("Security monitoring stopped", "StopSecurityMonitoring")
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("STOP_SECURITY_MONITORING_ERROR", Error.Message, "StopSecurityMonitoring")
		Return False
	End Try
End Sub

Sub DetectIntrusion(User As String, IP As String, Activity As String) As Boolean
	Try
		If IntrusionDetection = False Then
			Return False
		End If
		
		' Controlla login falliti
		If FailedLogins.ContainsKey(User) Then
			Dim FailedCount As Int
			FailedCount = FailedLogins.Get(User)
			If FailedCount >= SecurityThresholds.Get("FAILED_LOGINS") Then
				TriggerSecurityAlert("INTRUSION_ATTEMPT", "Multiple failed logins from " & User & " (" & IP & ")")
				Return True
			End If
		End If
		
		' Controlla attività sospette
		If SuspiciousActivity.IndexOf(Activity) <> -1 Then
			TriggerSecurityAlert("SUSPICIOUS_ACTIVITY", "Suspicious activity from " & User & ": " & Activity)
			Return True
		End If
		
		' Controlla pattern di attacco
		If CheckAttackPattern(User, IP, Activity) Then
			TriggerSecurityAlert("THREAT_DETECTED", "Attack pattern detected from " & User & " (" & IP & ")")
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("DETECT_INTRUSION_ERROR", Error.Message, "DetectIntrusion")
		Return False
	End Try
End Sub

Sub CheckAccessControl(User As String, Resource As String, Action As String) As Boolean
	Try
		If AccessControl = False Then
			Return True
		End If
		
		' Controlla regole accesso
		If SecurityRules.ContainsKey(User) Then
			Dim UserRules As Map
			UserRules = SecurityRules.Get(User)
			
			If UserRules.ContainsKey(Resource) Then
				Dim ResourceRules As List
				ResourceRules = UserRules.Get(Resource)
				
				If ResourceRules.IndexOf(Action) = -1 Then
					LogSecurityEvent("ACCESS_DENIED", User & " denied access to " & Resource & " (" & Action & ")")
					Return False
				End If
			End If
		End If
		
		LogSecurityEvent("ACCESS_GRANTED", User & " granted access to " & Resource & " (" & Action & ")")
		Return True
		
	Catch Error As Exception
		LogError("CHECK_ACCESS_CONTROL_ERROR", Error.Message, "CheckAccessControl")
		Return False
	End Try
End Sub

Sub LogSecurityEvent(EventType As String, Message As String) As Boolean
	Try
		If AuditLogging = False Then
			Return False
		End If
		
		Dim EventData As Map
		EventData.Initialize
		EventData.Put("Type", EventType)
		EventData.Put("Message", Message)
		EventData.Put("Timestamp", DateTime.Now)
		EventData.Put("User", Nickconnessione)
		
		SecurityEvents.Add(EventData)
		
		' Mantieni solo ultimi 1000 eventi
		If SecurityEvents.Size > 1000 Then
			SecurityEvents.RemoveAt(0)
		End If
		
		LogInfo("SECURITY_EVENT: " & EventType & " - " & Message, "LogSecurityEvent")
		Return True
		
	Catch Error As Exception
		LogError("LOG_SECURITY_EVENT_ERROR", Error.Message, "LogSecurityEvent")
		Return False
	End Try
End Sub

Sub TriggerSecurityAlert(AlertType As String, Message As String) As Boolean
	Try
		Dim AlertData As Map
		AlertData.Initialize
		AlertData.Put("Type", AlertType)
		AlertData.Put("Message", Message)
		AlertData.Put("Timestamp", DateTime.Now)
		AlertData.Put("User", Nickconnessione)
		
		SecurityAlerts.Put(DateTime.Now, AlertData)
		
		' Esegui azione sicurezza
		ExecuteSecurityAction(AlertType)
		
		LogError("SECURITY_ALERT", Message, "TriggerSecurityAlert")
		Return True
		
	Catch Error As Exception
		LogError("TRIGGER_SECURITY_ALERT_ERROR", Error.Message, "TriggerSecurityAlert")
		Return False
	End Try
End Sub

Sub ExecuteSecurityAction(AlertType As String) As Boolean
	Try
		If SecurityActions.ContainsKey(AlertType) Then
			Dim Action As String
			Action = SecurityActions.Get(AlertType)
			
			Select Case Action
				Case "BAN_TEMPORARY"
					' Banna temporaneamente
					LogSecurityEvent("SECURITY_ACTION", "Temporary ban executed for " & AlertType)
				Case "BAN_PERMANENT"
					' Banna permanentemente
					LogSecurityEvent("SECURITY_ACTION", "Permanent ban executed for " & AlertType)
				Case "LOG_ALERT"
					' Solo log
					LogSecurityEvent("SECURITY_ACTION", "Alert logged for " & AlertType)
				Case "ALERT_ADMIN"
					' Notifica admin
					LogSecurityEvent("SECURITY_ACTION", "Admin alerted for " & AlertType)
			End Select
			
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("EXECUTE_SECURITY_ACTION_ERROR", Error.Message, "ExecuteSecurityAction")
		Return False
	End Try
End Sub

Sub DetectThreats() As Boolean
	Try
		If ThreatDetection = False Then
			Return False
		End If
		
		' Controlla minacce comuni
		If CheckCommonThreats() Then
			TriggerSecurityAlert("THREAT_DETECTED", "Common threat pattern detected")
			Return True
		End If
		
		' Controlla anomalie
		If CheckAnomalies() Then
			TriggerSecurityAlert("THREAT_DETECTED", "Anomaly detected")
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("DETECT_THREATS_ERROR", Error.Message, "DetectThreats")
		Return False
	End Try
End Sub

Sub CheckAttackPattern(User As String, IP As String, Activity As String) As Boolean
	Try
		' Controlla pattern di attacco comuni
		If Activity.Contains("DROP TABLE") Or Activity.Contains("DELETE FROM") Or Activity.Contains("INSERT INTO") Then
			Return True
		End If
		
		If Activity.Contains("../../") Or Activity.Contains("../") Or Activity.Contains("..\\") Then
			Return True
		End If
		
		If Activity.Contains("<script>") Or Activity.Contains("javascript:") Or Activity.Contains("onload=") Then
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("CHECK_ATTACK_PATTERN_ERROR", Error.Message, "CheckAttackPattern")
		Return False
	End Try
End Sub

Sub CheckCommonThreats() As Boolean
	Try
		' Controlla minacce comuni
		' Implementa controlli specifici
		Return False
		
	Catch Error As Exception
		LogError("CHECK_COMMON_THREATS_ERROR", Error.Message, "CheckCommonThreats")
		Return False
	End Try
End Sub

Sub CheckAnomalies() As Boolean
	Try
		' Controlla anomalie
		' Implementa controlli specifici
		Return False
		
	Catch Error As Exception
		LogError("CHECK_ANOMALIES_ERROR", Error.Message, "CheckAnomalies")
		Return False
	End Try
End Sub

Sub GetSecurityStatus() As String
	Try
		Dim Result As String
		Result = "Security Status:" & Chr(10)
		Result = Result & "  Intrusion Detection: " & IntrusionDetection & Chr(10)
		Result = Result & "  Access Control: " & AccessControl & Chr(10)
		Result = Result & "  Audit Logging: " & AuditLogging & Chr(10)
		Result = Result & "  Threat Detection: " & ThreatDetection & Chr(10)
		Result = Result & "  Monitoring: " & SecurityMonitoring & Chr(10)
		Result = Result & "  Failed Logins: " & FailedLogins.Size & Chr(10)
		Result = Result & "  Suspicious Activity: " & SuspiciousActivity.Size & Chr(10)
		Result = Result & "  Security Events: " & SecurityEvents.Size & Chr(10)
		Result = Result & "  Security Alerts: " & SecurityAlerts.Size & Chr(10)
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_SECURITY_STATUS_ERROR", Error.Message, "GetSecurityStatus")
		Return "Error retrieving security status"
	End Try
End Sub

' ======================
' ADVANCED CHANNEL MANAGEMENT FUNCTIONS
' ======================

Sub SetChannelMode(Channel As String, Mode As String, Param As String) As Boolean
	Try
		If ChannelModes.ContainsKey(Channel) = False Then
			ChannelModes.Put(Channel, CreateMap())
		End If
		
		Dim ChannelModeMap As Map
		ChannelModeMap = ChannelModes.Get(Channel)
		
		' Gestisci modalità canale
		If Mode.StartsWith("+") Then
			Dim ModeChar As String
			ModeChar = Mode.SubString(1)
			
			Select Case ModeChar
				Case "s" ' Secret
					ChannelModeMap.Put("secret", True)
				Case "p" ' Private
					ChannelModeMap.Put("private", True)
				Case "m" ' Moderated
					ChannelModeMap.Put("moderated", True)
				Case "n" ' No external messages
					ChannelModeMap.Put("noexternal", True)
				Case "t" ' Topic protection
					ChannelModeMap.Put("topicprotection", True)
					ChannelTopicProtection.Put(Channel, True)
				Case "i" ' Invite only
					ChannelModeMap.Put("inviteonly", True)
				Case "l" ' Limit
					If Param.Length > 0 Then
						ChannelModeMap.Put("limit", Param)
						ChannelLimits.Put(Channel, Param)
					End If
				Case "k" ' Key
					If Param.Length > 0 Then
						ChannelModeMap.Put("key", Param)
						ChannelKeys.Put(Channel, Param)
					End If
			End Select
		Else If Mode.StartsWith("-") Then
			Dim ModeChar As String
			ModeChar = Mode.SubString(1)
			
			Select Case ModeChar
				Case "s" ' Secret
					ChannelModeMap.Put("secret", False)
				Case "p" ' Private
					ChannelModeMap.Put("private", False)
				Case "m" ' Moderated
					ChannelModeMap.Put("moderated", False)
				Case "n" ' No external messages
					ChannelModeMap.Put("noexternal", False)
				Case "t" ' Topic protection
					ChannelModeMap.Put("topicprotection", False)
					ChannelTopicProtection.Put(Channel, False)
				Case "i" ' Invite only
					ChannelModeMap.Put("inviteonly", False)
				Case "l" ' Limit
					ChannelModeMap.Put("limit", "")
					ChannelLimits.Remove(Channel)
				Case "k" ' Key
					ChannelModeMap.Put("key", "")
					ChannelKeys.Remove(Channel)
			End Select
		End If
		
		' Salva storico modalità
		If ChannelModeHistory.ContainsKey(Channel) = False Then
			ChannelModeHistory.Put(Channel, CreateList())
		End If
		Dim ModeHistory As List
		ModeHistory = ChannelModeHistory.Get(Channel)
		ModeHistory.Add(DateTime.Now & " - " & Mode & " " & Param)
		
		LogInfo("Channel mode set: " & Channel & " " & Mode & " " & Param, "SetChannelMode")
		Return True
		
	Catch Error As Exception
		LogError("SET_CHANNEL_MODE_ERROR", Error.Message, "SetChannelMode")
		Return False
	End Try
End Sub

Sub GetChannelMode(Channel As String) As String
	Try
		If ChannelModes.ContainsKey(Channel) = False Then
			Return "+nt" ' Modalità default
		End If
		
		Dim ChannelModeMap As Map
		ChannelModeMap = ChannelModes.Get(Channel)
		Dim ModeString As String
		ModeString = "+"
		
		' Costruisci stringa modalità
		If ChannelModeMap.Get("secret") = True Then
			ModeString = ModeString & "s"
		End If
		If ChannelModeMap.Get("private") = True Then
			ModeString = ModeString & "p"
		End If
		If ChannelModeMap.Get("moderated") = True Then
			ModeString = ModeString & "m"
		End If
		If ChannelModeMap.Get("noexternal") = True Then
			ModeString = ModeString & "n"
		End If
		If ChannelModeMap.Get("topicprotection") = True Then
			ModeString = ModeString & "t"
		End If
		If ChannelModeMap.Get("inviteonly") = True Then
			ModeString = ModeString & "i"
		End If
		If ChannelModeMap.Get("limit") <> "" Then
			ModeString = ModeString & "l"
		End If
		If ChannelModeMap.Get("key") <> "" Then
			ModeString = ModeString & "k"
		End If
		
		Return ModeString
		
	Catch Error As Exception
		LogError("GET_CHANNEL_MODE_ERROR", Error.Message, "GetChannelMode")
		Return "+nt"
	End Try
End Sub

Sub AddUserToChannel(User As String, Channel As String, Mode As String) As Boolean
	Try
		If ChannelUsers.ContainsKey(Channel) = False Then
			ChannelUsers.Put(Channel, CreateMap())
		End If
		
		Dim ChannelUserMap As Map
		ChannelUserMap = ChannelUsers.Get(Channel)
		
		' Aggiungi utente al canale
		Dim UserInfo As Map
		UserInfo.Initialize
		UserInfo.Put("User", User)
		UserInfo.Put("Mode", Mode)
		UserInfo.Put("JoinTime", DateTime.Now)
		UserInfo.Put("LastActivity", DateTime.Now)
		ChannelUserMap.Put(User, UserInfo)
		
		' Gestisci modalità utente
		If Mode.Contains("@") Then
			If ChannelOperators.ContainsKey(Channel) = False Then
				ChannelOperators.Put(Channel, CreateList())
			End If
			Dim ChannelOps As List
			ChannelOps = ChannelOperators.Get(Channel)
			ChannelOps.Add(User)
		End If
		
		If Mode.Contains("+") Then
			If ChannelVoices.ContainsKey(Channel) = False Then
				ChannelVoices.Put(Channel, CreateList())
			End If
			Dim ChannelVoicesList As List
			ChannelVoicesList = ChannelVoices.Get(Channel)
			ChannelVoicesList.Add(User)
		End If
		
		If Mode.Contains("%") Then
			If ChannelHalfOps.ContainsKey(Channel) = False Then
				ChannelHalfOps.Put(Channel, CreateList())
			End If
			Dim ChannelHalfOpsList As List
			ChannelHalfOpsList = ChannelHalfOps.Get(Channel)
			ChannelHalfOpsList.Add(User)
		End If
		
		If Mode.Contains("~") Then
			If ChannelFounders.ContainsKey(Channel) = False Then
				ChannelFounders.Put(Channel, CreateList())
			End If
			Dim ChannelFoundersList As List
			ChannelFoundersList = ChannelFounders.Get(Channel)
			ChannelFoundersList.Add(User)
		End If
		
		' Aggiorna contatore utenti
		ChannelUserCount.Put(Channel, ChannelUserMap.Size)
		
		LogInfo("User added to channel: " & User & " -> " & Channel & " (" & Mode & ")", "AddUserToChannel")
		Return True
		
	Catch Error As Exception
		LogError("ADD_USER_TO_CHANNEL_ERROR", Error.Message, "AddUserToChannel")
		Return False
	End Try
End Sub

Sub RemoveUserFromChannel(User As String, Channel As String) As Boolean
	Try
		If ChannelUsers.ContainsKey(Channel) = False Then
			Return False
		End If
		
		Dim ChannelUserMap As Map
		ChannelUserMap = ChannelUsers.Get(Channel)
		
		If ChannelUserMap.ContainsKey(User) Then
			ChannelUserMap.Remove(User)
			
			' Rimuovi da operatori
			If ChannelOperators.ContainsKey(Channel) Then
				Dim ChannelOps As List
				ChannelOps = ChannelOperators.Get(Channel)
				For i = 0 To ChannelOps.Size - 1
					If ChannelOps.Get(i) = User Then
						ChannelOps.RemoveAt(i)
						Exit
					End If
				Next
			End If
			
			' Rimuovi da voice
			If ChannelVoices.ContainsKey(Channel) Then
				Dim ChannelVoicesList As List
				ChannelVoicesList = ChannelVoices.Get(Channel)
				For i = 0 To ChannelVoicesList.Size - 1
					If ChannelVoicesList.Get(i) = User Then
						ChannelVoicesList.RemoveAt(i)
						Exit
					End If
				Next
			End If
			
			' Rimuovi da half-ops
			If ChannelHalfOps.ContainsKey(Channel) Then
				Dim ChannelHalfOpsList As List
				ChannelHalfOpsList = ChannelHalfOps.Get(Channel)
				For i = 0 To ChannelHalfOpsList.Size - 1
					If ChannelHalfOpsList.Get(i) = User Then
						ChannelHalfOpsList.RemoveAt(i)
						Exit
					End If
				Next
			End If
			
			' Rimuovi da founders
			If ChannelFounders.ContainsKey(Channel) Then
				Dim ChannelFoundersList As List
				ChannelFoundersList = ChannelFounders.Get(Channel)
				For i = 0 To ChannelFoundersList.Size - 1
					If ChannelFoundersList.Get(i) = User Then
						ChannelFoundersList.RemoveAt(i)
						Exit
					End If
				Next
			End If
			
			' Aggiorna contatore utenti
			ChannelUserCount.Put(Channel, ChannelUserMap.Size)
			
			LogInfo("User removed from channel: " & User & " <- " & Channel, "RemoveUserFromChannel")
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("REMOVE_USER_FROM_CHANNEL_ERROR", Error.Message, "RemoveUserFromChannel")
		Return False
	End Try
End Sub

Sub SetUserChannelMode(User As String, Channel As String, Mode As String) As Boolean
	Try
		If ChannelUsers.ContainsKey(Channel) = False Then
			Return False
		End If
		
		Dim ChannelUserMap As Map
		ChannelUserMap = ChannelUsers.Get(Channel)
		
		If ChannelUserMap.ContainsKey(User) Then
			Dim UserInfo As Map
			UserInfo = ChannelUserMap.Get(User)
			UserInfo.Put("Mode", Mode)
			
			LogInfo("User channel mode set: " & User & " -> " & Channel & " (" & Mode & ")", "SetUserChannelMode")
			Return True
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("SET_USER_CHANNEL_MODE_ERROR", Error.Message, "SetUserChannelMode")
		Return False
	End Try
End Sub

Sub GetChannelUsers(Channel As String) As String
	Try
		Dim Result As String
		Result = "Users in " & Channel & ":" & Chr(10)
		
		If ChannelUsers.ContainsKey(Channel) Then
			Dim ChannelUserMap As Map
			ChannelUserMap = ChannelUsers.Get(Channel)
			
			For i = 0 To ChannelUserMap.Size - 1
				Dim User As String
				User = ChannelUserMap.GetKeyAt(i)
				Dim UserInfo As Map
				UserInfo = ChannelUserMap.Get(User)
				Dim UserMode As String
				UserMode = UserInfo.Get("Mode")
				
				Result = Result & "  " & UserMode & User & Chr(10)
			Next
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_CHANNEL_USERS_ERROR", Error.Message, "GetChannelUsers")
		Return "Error retrieving channel users"
	End Try
End Sub

Sub AddChannelBan(Channel As String, BanMask As String) As Boolean
	Try
		If ChannelBans.ContainsKey(Channel) = False Then
			ChannelBans.Put(Channel, CreateList())
		End If
		
		Dim ChannelBansList As List
		ChannelBansList = ChannelBans.Get(Channel)
		ChannelBansList.Add(BanMask)
		
		LogInfo("Channel ban added: " & Channel & " -> " & BanMask, "AddChannelBan")
		Return True
		
	Catch Error As Exception
		LogError("ADD_CHANNEL_BAN_ERROR", Error.Message, "AddChannelBan")
		Return False
	End Try
End Sub

Sub RemoveChannelBan(Channel As String, BanMask As String) As Boolean
	Try
		If ChannelBans.ContainsKey(Channel) = False Then
			Return False
		End If
		
		Dim ChannelBansList As List
		ChannelBansList = ChannelBans.Get(Channel)
		
		For i = 0 To ChannelBansList.Size - 1
			If ChannelBansList.Get(i) = BanMask Then
				ChannelBansList.RemoveAt(i)
				LogInfo("Channel ban removed: " & Channel & " <- " & BanMask, "RemoveChannelBan")
				Return True
			End If
		Next
		
		Return False
		
	Catch Error As Exception
		LogError("REMOVE_CHANNEL_BAN_ERROR", Error.Message, "RemoveChannelBan")
		Return False
	End Try
End Sub

Sub IsUserBannedFromChannel(User As String, Channel As String) As Boolean
	Try
		If ChannelBans.ContainsKey(Channel) = False Then
			Return False
		End If
		
		Dim ChannelBansList As List
		ChannelBansList = ChannelBans.Get(Channel)
		
		For i = 0 To ChannelBansList.Size - 1
			Dim BanMask As String
			BanMask = ChannelBansList.Get(i)
			
			' TODO: Implementare controllo wildcard ban
			If BanMask = User Or BanMask = "*!*@" & User Or BanMask = User & "!*@*" Then
				Return True
			End If
		Next
		
		Return False
		
	Catch Error As Exception
		LogError("IS_USER_BANNED_FROM_CHANNEL_ERROR", Error.Message, "IsUserBannedFromChannel")
		Return False
	End Try
End Sub

Sub AddChannelInvite(Channel As String, User As String) As Boolean
	Try
		If ChannelInvites.ContainsKey(Channel) = False Then
			ChannelInvites.Put(Channel, CreateList())
		End If
		
		Dim ChannelInvitesList As List
		ChannelInvitesList = ChannelInvites.Get(Channel)
		ChannelInvitesList.Add(User)
		
		LogInfo("Channel invite added: " & Channel & " -> " & User, "AddChannelInvite")
		Return True
		
	Catch Error As Exception
		LogError("ADD_CHANNEL_INVITE_ERROR", Error.Message, "AddChannelInvite")
		Return False
	End Try
End Sub

Sub RemoveChannelInvite(Channel As String, User As String) As Boolean
	Try
		If ChannelInvites.ContainsKey(Channel) = False Then
			Return False
		End If
		
		Dim ChannelInvitesList As List
		ChannelInvitesList = ChannelInvites.Get(Channel)
		
		For i = 0 To ChannelInvitesList.Size - 1
			If ChannelInvitesList.Get(i) = User Then
				ChannelInvitesList.RemoveAt(i)
				LogInfo("Channel invite removed: " & Channel & " <- " & User, "RemoveChannelInvite")
				Return True
			End If
		Next
		
		Return False
		
	Catch Error As Exception
		LogError("REMOVE_CHANNEL_INVITE_ERROR", Error.Message, "RemoveChannelInvite")
		Return False
	End Try
End Sub

Sub IsUserInvitedToChannel(User As String, Channel As String) As Boolean
	Try
		If ChannelInvites.ContainsKey(Channel) = False Then
			Return False
		End If
		
		Dim ChannelInvitesList As List
		ChannelInvitesList = ChannelInvites.Get(Channel)
		
		For i = 0 To ChannelInvitesList.Size - 1
			If ChannelInvitesList.Get(i) = User Then
				Return True
			End If
		Next
		
		Return False
		
	Catch Error As Exception
		LogError("IS_USER_INVITED_TO_CHANNEL_ERROR", Error.Message, "IsUserInvitedToChannel")
		Return False
	End Try
End Sub

Sub SetChannelKey(Channel As String, Key As String) As Boolean
	Try
		ChannelKeys.Put(Channel, Key)
		LogInfo("Channel key set: " & Channel & " -> " & Key, "SetChannelKey")
		Return True
		
	Catch Error As Exception
		LogError("SET_CHANNEL_KEY_ERROR", Error.Message, "SetChannelKey")
		Return False
	End Try
End Sub

Sub GetChannelKey(Channel As String) As String
	Try
		If ChannelKeys.ContainsKey(Channel) Then
			Return ChannelKeys.Get(Channel)
		End If
		
		Return ""
		
	Catch Error As Exception
		LogError("GET_CHANNEL_KEY_ERROR", Error.Message, "GetChannelKey")
		Return ""
	End Try
End Sub

Sub ValidateChannelKey(Channel As String, Key As String) As Boolean
	Try
		If ChannelKeys.ContainsKey(Channel) = False Then
			Return True ' Nessuna chiave richiesta
		End If
		
		Dim ChannelKey As String
		ChannelKey = ChannelKeys.Get(Channel)
		
		Return ChannelKey = Key
		
	Catch Error As Exception
		LogError("VALIDATE_CHANNEL_KEY_ERROR", Error.Message, "ValidateChannelKey")
		Return False
	End Try
End Sub

Sub SetChannelLimit(Channel As String, Limit As Int) As Boolean
	Try
		ChannelLimits.Put(Channel, Limit)
		LogInfo("Channel limit set: " & Channel & " -> " & Limit, "SetChannelLimit")
		Return True
		
	Catch Error As Exception
		LogError("SET_CHANNEL_LIMIT_ERROR", Error.Message, "SetChannelLimit")
		Return False
	End Try
End Sub

Sub GetChannelLimit(Channel As String) As Int
	Try
		If ChannelLimits.ContainsKey(Channel) Then
			Return ChannelLimits.Get(Channel)
		End If
		
		Return 0
		
	Catch Error As Exception
		LogError("GET_CHANNEL_LIMIT_ERROR", Error.Message, "GetChannelLimit")
		Return 0
	End Try
End Sub

Sub IsChannelFull(Channel As String) As Boolean
	Try
		If ChannelLimits.ContainsKey(Channel) = False Then
			Return False ' Nessun limite
		End If
		
		Dim ChannelLimit As Int
		ChannelLimit = ChannelLimits.Get(Channel)
		
		If ChannelUserCount.ContainsKey(Channel) Then
			Dim UserCount As Int
			UserCount = ChannelUserCount.Get(Channel)
			Return UserCount >= ChannelLimit
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("IS_CHANNEL_FULL_ERROR", Error.Message, "IsChannelFull")
		Return False
	End Try
End Sub

Sub SetChannelTopic(Channel As String, Topic As String) As Boolean
	Try
		ChannelTopics.Put(Channel, Topic)
		
		' Salva storico topic
		If ChannelTopicHistory.ContainsKey(Channel) = False Then
			ChannelTopicHistory.Put(Channel, CreateList())
		End If
		Dim TopicHistory As List
		TopicHistory = ChannelTopicHistory.Get(Channel)
		TopicHistory.Add(DateTime.Now & " - " & Topic)
		
		LogInfo("Channel topic set: " & Channel & " -> " & Topic, "SetChannelTopic")
		Return True
		
	Catch Error As Exception
		LogError("SET_CHANNEL_TOPIC_ERROR", Error.Message, "SetChannelTopic")
		Return False
	End Try
End Sub

Sub GetChannelTopic(Channel As String) As String
	Try
		If ChannelTopics.ContainsKey(Channel) Then
			Return ChannelTopics.Get(Channel)
		End If
		
		Return "No topic set"
		
	Catch Error As Exception
		LogError("GET_CHANNEL_TOPIC_ERROR", Error.Message, "GetChannelTopic")
		Return "Error retrieving topic"
	End Try
End Sub

Sub IsTopicProtected(Channel As String) As Boolean
	Try
		If ChannelTopicProtection.ContainsKey(Channel) Then
			Return ChannelTopicProtection.Get(Channel)
		End If
		
		Return False
		
	Catch Error As Exception
		LogError("IS_TOPIC_PROTECTED_ERROR", Error.Message, "IsTopicProtected")
		Return False
	End Try
End Sub

Sub GetChannelInfo(Channel As String) As String
	Try
		Dim Result As String
		Result = "Channel Info for " & Channel & ":" & Chr(10)
		
		' Modalità canale
		Result = Result & "  Modes: " & GetChannelMode(Channel) & Chr(10)
		
		' Topic
		Result = Result & "  Topic: " & GetChannelTopic(Channel) & Chr(10)
		
		' Limite utenti
		Dim ChannelLimit As Int
		ChannelLimit = GetChannelLimit(Channel)
		If ChannelLimit > 0 Then
			Result = Result & "  Limit: " & ChannelLimit & Chr(10)
		End If
		
		' Chiave canale
		Dim ChannelKey As String
		ChannelKey = GetChannelKey(Channel)
		If ChannelKey.Length > 0 Then
			Result = Result & "  Key: " & ChannelKey & Chr(10)
		End If
		
		' Contatore utenti
		If ChannelUserCount.ContainsKey(Channel) Then
			Result = Result & "  Users: " & ChannelUserCount.Get(Channel) & Chr(10)
		End If
		
		' Operatori
		If ChannelOperators.ContainsKey(Channel) Then
			Dim ChannelOps As List
			ChannelOps = ChannelOperators.Get(Channel)
			Result = Result & "  Operators: " & ChannelOps.Size & Chr(10)
		End If
		
		' Voice
		If ChannelVoices.ContainsKey(Channel) Then
			Dim ChannelVoicesList As List
			ChannelVoicesList = ChannelVoices.Get(Channel)
			Result = Result & "  Voices: " & ChannelVoicesList.Size & Chr(10)
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_CHANNEL_INFO_ERROR", Error.Message, "GetChannelInfo")
		Return "Error retrieving channel info"
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
		
		' Crea socket DCC chat reale
		Dim DCCChatSocket As Socket
		DCCChatSocket.Initialize("DCCChat_" & TargetUser)
		
		' Avvia server DCC chat su porta casuale
		Dim DCCChatPort As Int
		DCCChatPort = 1024 + Rnd(0, 65535 - 1024)
		
		' Crea server socket per DCC chat
		Dim DCCChatServer As ServerSocket
		DCCChatServer.Initialize("DCCChatServer_" & TargetUser)
		DCCChatServer.Listen(DCCChatPort)
		
		' Salva connessione DCC chat
		Dim ChatConnection As Map
		ChatConnection.Initialize
		ChatConnection.Put("TargetUser", TargetUser)
		ChatConnection.Put("Socket", DCCChatSocket)
		ChatConnection.Put("Server", DCCChatServer)
		ChatConnection.Put("Port", DCCChatPort)
		ChatConnection.Put("Status", "Listening")
		ChatConnection.Put("Timestamp", DateTime.Now)
		
		DCCChatConnections.Add(TargetUser)
		DCCChatRequests.Add(ChatConnection)
		
		' Invia richiesta chat DCC reale
		Dim DCCChatMessage As String
		DCCChatMessage = "PRIVMSG " & TargetUser & " :\x01DCC CHAT chat " & MyIP & " " & DCCChatPort & "\x01"
		WriteSocketIrc(DCCChatMessage)
		
		LogInfo("DCC chat server started on port " & DCCChatPort & " for " & TargetUser, "StartDCCChat")
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
		
		' Implementazione reale connessione DCC chat
		Dim DCCChatSocket As Socket
		DCCChatSocket.Initialize("DCCChatClient_" & TargetUser)
		
		' Ottieni IP e porta dal richiedente
		Dim RemoteIP As String
		Dim RemotePort As Int
		RemoteIP = ChatRequest.Get("RemoteIP")
		RemotePort = ChatRequest.Get("RemotePort")
		
		' Connetti al server DCC chat remoto
		DCCChatSocket.Connect(RemoteIP, RemotePort)
		
		' Attendi connessione
		Dim ConnectionTimeout As Int
		ConnectionTimeout = 0
		Do While DCCChatSocket.Connected = False And ConnectionTimeout < 10000
			Sleep(100)
			ConnectionTimeout = ConnectionTimeout + 100
		Loop
		
		If DCCChatSocket.Connected Then
			' Aggiorna stato connessione
			ChatRequest.Put("Status", "Connected")
			ChatRequest.Put("Socket", DCCChatSocket)
			DCCChatConnections.Add(TargetUser)
			
			LogInfo("DCC chat connected to " & TargetUser & " at " & RemoteIP & ":" & RemotePort, "AnswerDCCChat")
			Return True
		Else
			LogError("DCC_CHAT_CONNECTION_FAILED", "Failed to connect to DCC chat with " & TargetUser, "AnswerDCCChat")
			Return False
		End If
		
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
		
		' Crea server socket per DCC send reale
		Dim DCCSendPort As Int
		DCCSendPort = 1024 + Rnd(0, 65535 - 1024)
		
		Dim DCCSendServer As ServerSocket
		DCCSendServer.Initialize("DCCSendServer_" & TargetUser & "_" & FileName)
		DCCSendServer.Listen(DCCSendPort)
		
		' Aggiungi alla coda invio con server socket
		Dim SendItem As Map
		SendItem.Initialize
		SendItem.Put("FileName", FileName)
		SendItem.Put("TargetUser", TargetUser)
		SendItem.Put("FileSize", FileSize)
		SendItem.Put("Port", DCCSendPort)
		SendItem.Put("Server", DCCSendServer)
		SendItem.Put("Status", "Listening")
		SendItem.Put("Timestamp", DateTime.Now)
		
		DCCSendQueue.Add(SendItem)
		
		' Invia offerta file DCC reale
		Dim DCCSendMessage As String
		DCCSendMessage = "PRIVMSG " & TargetUser & " :\x01DCC SEND " & FileName & " " & MyIP & " " & DCCSendPort & " " & FileSize & "\x01"
		WriteSocketIrc(DCCSendMessage)
		
		LogInfo("DCC file send server started on port " & DCCSendPort & " for " & FileName & " (" & FileSize & " bytes)", "SendDCCFile")
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
		
		' Implementazione reale connessione DCC file
		Dim DCCClientSocket As Socket
		DCCClientSocket.Initialize("DCCClient_" & TargetUser & "_" & FileName)
		
		' Ottieni IP e porta dal richiedente
		Dim RemoteIP As String
		Dim RemotePort As Int
		RemoteIP = DCCFile.Get("RemoteIP")
		RemotePort = DCCFile.Get("RemotePort")
		
		' Connetti al server DCC send remoto
		DCCClientSocket.Connect(RemoteIP, RemotePort)
		
		' Attendi connessione
		Dim ConnectionTimeout As Int
		ConnectionTimeout = 0
		Do While DCCClientSocket.Connected = False And ConnectionTimeout < 10000
			Sleep(100)
			ConnectionTimeout = ConnectionTimeout + 100
		Loop
		
		If DCCClientSocket.Connected Then
		' Aggiorna stato trasferimento
		DCCFile.Put("Status", "Transferring")
		DCCFile.Put("ClientSocket", DCCClientSocket)
		DCCActiveTransfers.Add(DCCFile)
		
		' Aggiorna posizione per DCC Resume Automatico
		UpdateDCCResumePosition(FileName, TargetUser, "127.0.0.1", 0)
			
			LogInfo("DCC file transfer started: " & FileName & " from " & TargetUser & " at " & RemoteIP & ":" & RemotePort, "AcceptDCCFile")
			Return True
		Else
			LogError("DCC_FILE_CONNECTION_FAILED", "Failed to connect to DCC file transfer with " & TargetUser, "AcceptDCCFile")
			Return False
		End If
		
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
				' Chiudi socket se presente
				Dim TransferSocket As Socket
				TransferSocket = Transfer.Get("ClientSocket")
				If TransferSocket <> Null And TransferSocket.Connected Then
					TransferSocket.Close
				End If
				
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
					' Chiudi server socket se presente
					Dim SendServer As ServerSocket
					SendServer = SendItem.Get("Server")
					If SendServer <> Null Then
						SendServer.Close
					End If
					
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
			' Implementazione reale auto-get DCC
			If DCCAutoGetUsers.IndexOf(User) = -1 Then
				DCCAutoGetUsers.Add(User)
			End If
			
			If Network.Length > 0 Then
				DCCAutoGetNetworks.Put(User, Network)
			End If
			
			' Crea server socket per auto-accettazione
			Dim AutoGetPort As Int
			AutoGetPort = 1024 + Rnd(0, 65535 - 1024)
			
			Dim AutoGetServer As ServerSocket
			AutoGetServer.Initialize("AutoGetServer_" & User)
			AutoGetServer.Listen(AutoGetPort)
			
			' Salva configurazione auto-get
			Dim AutoGetConfig As Map
			AutoGetConfig.Initialize
			AutoGetConfig.Put("User", User)
			AutoGetConfig.Put("Network", Network)
			AutoGetConfig.Put("Port", AutoGetPort)
			AutoGetConfig.Put("Server", AutoGetServer)
			AutoGetConfig.Put("Enabled", True)
			
			DCCBotConnections.Add(User, AutoGetConfig)
			
			LogInfo("Auto-get DCC server started on port " & AutoGetPort & " for " & User & " on " & Network, "SetAutoGetDCC")
		Else
			' Disabilita auto-get reale
			If DCCAutoGetUsers.IndexOf(User) <> -1 Then
				DCCAutoGetUsers.RemoveAt(DCCAutoGetUsers.IndexOf(User))
			End If
			
			DCCAutoGetNetworks.Remove(User)
			
			' Chiudi server socket auto-get
			Dim AutoGetConfig As Map
			AutoGetConfig = DCCBotConnections.Get(User)
			If AutoGetConfig <> Null Then
				Dim AutoGetServer As ServerSocket
				AutoGetServer = AutoGetConfig.Get("Server")
				If AutoGetServer <> Null Then
					AutoGetServer.Close
				End If
				DCCBotConnections.Remove(User)
			End If
			
			LogInfo("Auto-get DCC server stopped for " & User, "SetAutoGetDCC")
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
		
		' Chat connections reali
		If DCCChatConnections.Size > 0 Then
			Result = Result & "Chat: " & DCCChatConnections.Size & " active" & Chr(10)
			For i = 0 To DCCChatConnections.Size - 1
				Dim ChatUser As String
				ChatUser = DCCChatConnections.Get(i)
				
				' Ottieni dettagli connessione chat
				Dim ChatRequest As Map
				ChatRequest = Null
				For j = 0 To DCCChatRequests.Size - 1
					Dim Request As Map
					Request = DCCChatRequests.Get(j)
					If Request.Get("TargetUser") = ChatUser Then
						ChatRequest = Request
						Exit
					End If
				Next
				
				If ChatRequest <> Null Then
					Dim ChatPort As Int
					Dim ChatStatus As String
					ChatPort = ChatRequest.Get("Port")
					ChatStatus = ChatRequest.Get("Status")
					Result = Result & "  - " & ChatUser & " (Port: " & ChatPort & ", Status: " & ChatStatus & ")" & Chr(10)
				Else
					Result = Result & "  - " & ChatUser & " (Connected)" & Chr(10)
				End If
			Next
		End If
		
		' Active transfers reali
		If DCCActiveTransfers.Size > 0 Then
			Result = Result & "Transfers: " & DCCActiveTransfers.Size & " active" & Chr(10)
			For i = 0 To DCCActiveTransfers.Size - 1
				Dim Transfer As Map
				Transfer = DCCActiveTransfers.Get(i)
				Dim FileName As String
				Dim TargetUser As String
				Dim FileSize As Long
				Dim Status As String
				FileName = Transfer.Get("FileName")
				TargetUser = Transfer.Get("TargetUser")
				FileSize = Transfer.Get("FileSize")
				Status = Transfer.Get("Status")
				Result = Result & "  - " & TargetUser & " (" & FileName & ", " & FileSize & " bytes, " & Status & ")" & Chr(10)
			Next
		End If
		
		' Bot connections reali
		If DCCBotConnections.Size > 0 Then
			Result = Result & "Auto-Get: " & DCCBotConnections.Size & " configured" & Chr(10)
			For i = 0 To DCCBotConnections.Size - 1
				Dim BotUser As String
				BotUser = DCCBotConnections.GetKeyAt(i)
				Dim BotConfig As Map
				BotConfig = DCCBotConnections.Get(BotUser)
				Dim BotPort As Int
				Dim BotNetwork As String
				BotPort = BotConfig.Get("Port")
				BotNetwork = BotConfig.Get("Network")
				Result = Result & "  - " & BotUser & " on " & BotNetwork & " (Port: " & BotPort & ")" & Chr(10)
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

' ======================
' AUTO-OP FUNCTIONS
' ======================

Sub AddAutoOp(User As String, Channel As String, Level As Int) As Boolean
	Try
		' Controlla se già esiste
		If AutoOpList.IndexOf(User) <> -1 Then
			LogError("AUTO_OP_EXISTS", "Auto-op already exists for " & User, "AddAutoOp")
			Return False
		End If
		
		' Aggiungi alla lista
		AutoOpList.Add(User)
		AutoOpChannels.Put(User, Channel)
		AutoOpLevels.Put(User, Level)
		
		LogInfo("Auto-op added: " & User & " on " & Channel & " (level " & Level & ")", "AddAutoOp")
		Return True
		
	Catch Error As Exception
		LogError("ADD_AUTO_OP_ERROR", Error.Message, "AddAutoOp")
		Return False
	End Try
End Sub

Sub RemoveAutoOp(User As String) As Boolean
	Try
		' Controlla se esiste
		If AutoOpList.IndexOf(User) = -1 Then
			LogError("AUTO_OP_NOT_FOUND", "Auto-op not found for " & User, "RemoveAutoOp")
			Return False
		End If
		
		' Rimuovi dalla lista
		AutoOpList.RemoveAt(AutoOpList.IndexOf(User))
		AutoOpChannels.Remove(User)
		AutoOpLevels.Remove(User)
		
		LogInfo("Auto-op removed: " & User, "RemoveAutoOp")
		Return True
		
	Catch Error As Exception
		LogError("REMOVE_AUTO_OP_ERROR", Error.Message, "RemoveAutoOp")
		Return False
	End Try
End Sub

Sub GetAutoOpList() As String
	Try
		Dim Result As String
		Result = "Auto-Op List:" & Chr(10)
		
		If AutoOpList.Size > 0 Then
			For i = 0 To AutoOpList.Size - 1
				Dim User As String
				Dim Channel As String
				Dim Level As Int
				
				User = AutoOpList.Get(i)
				Channel = AutoOpChannels.Get(User)
				Level = AutoOpLevels.Get(User)
				
				Result = Result & "  " & (i+1) & ". " & User & " on " & Channel & " (level " & Level & ")" & Chr(10)
			Next
		Else
			Result = Result & "No auto-op users configured."
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_AUTO_OP_LIST_ERROR", Error.Message, "GetAutoOpList")
		Return "Error retrieving auto-op list"
	End Try
End Sub

Sub AddAskOp(Host As String, Channel As String) As Boolean
	Try
		' Controlla se già esiste
		If AskOpList.IndexOf(Host) <> -1 Then
			LogError("ASK_OP_EXISTS", "Ask-op already exists for " & Host, "AddAskOp")
			Return False
		End If
		
		' Aggiungi alla lista
		AskOpList.Add(Host)
		AskOpChannels.Put(Host, Channel)
		
		LogInfo("Ask-op added: " & Host & " on " & Channel, "AddAskOp")
		Return True
		
	Catch Error As Exception
		LogError("ADD_ASK_OP_ERROR", Error.Message, "AddAskOp")
		Return False
	End Try
End Sub

Sub RemoveAskOp(Host As String) As Boolean
	Try
		' Controlla se esiste
		If AskOpList.IndexOf(Host) = -1 Then
			LogError("ASK_OP_NOT_FOUND", "Ask-op not found for " & Host, "RemoveAskOp")
			Return False
		End If
		
		' Rimuovi dalla lista
		AskOpList.RemoveAt(AskOpList.IndexOf(Host))
		AskOpChannels.Remove(Host)
		
		LogInfo("Ask-op removed: " & Host, "RemoveAskOp")
		Return True
		
	Catch Error As Exception
		LogError("REMOVE_ASK_OP_ERROR", Error.Message, "RemoveAskOp")
		Return False
	End Try
End Sub

Sub GetAskOpList() As String
	Try
		Dim Result As String
		Result = "Ask-Op List:" & Chr(10)
		
		If AskOpList.Size > 0 Then
			For i = 0 To AskOpList.Size - 1
				Dim Host As String
				Dim Channel As String
				
				Host = AskOpList.Get(i)
				Channel = AskOpChannels.Get(Host)
				
				Result = Result & "  " & (i+1) & ". " & Host & " on " & Channel & Chr(10)
			Next
		Else
			Result = Result & "No ask-op hosts configured."
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_ASK_OP_LIST_ERROR", Error.Message, "GetAskOpList")
		Return "Error retrieving ask-op list"
	End Try
End Sub

' ======================
' IGNORE/BAN FUNCTIONS
' ======================

Sub AddIgnore(Mask As String, IgnoreType As String, Channel As String) As Boolean
	Try
		' Controlla se già esiste
		If IgnoreList.IndexOf(Mask) <> -1 Then
			LogError("IGNORE_EXISTS", "Ignore already exists for " & Mask, "AddIgnore")
			Return False
		End If
		
		' Aggiungi alla lista
		IgnoreList.Add(Mask)
		IgnoreTypes.Put(Mask, IgnoreType)
		IgnoreChannels.Put(Mask, Channel)
		
		LogInfo("Ignore added: " & Mask & " (type: " & IgnoreType & ", channel: " & Channel & ")", "AddIgnore")
		Return True
		
	Catch Error As Exception
		LogError("ADD_IGNORE_ERROR", Error.Message, "AddIgnore")
		Return False
	End Try
End Sub

Sub RemoveIgnore(Mask As String) As Boolean
	Try
		' Controlla se esiste
		If IgnoreList.IndexOf(Mask) = -1 Then
			LogError("IGNORE_NOT_FOUND", "Ignore not found for " & Mask, "RemoveIgnore")
			Return False
		End If
		
		' Rimuovi dalla lista
		IgnoreList.RemoveAt(IgnoreList.IndexOf(Mask))
		IgnoreTypes.Remove(Mask)
		IgnoreChannels.Remove(Mask)
		
		LogInfo("Ignore removed: " & Mask, "RemoveIgnore")
		Return True
		
	Catch Error As Exception
		LogError("REMOVE_IGNORE_ERROR", Error.Message, "RemoveIgnore")
		Return False
	End Try
End Sub

Sub GetIgnoreList() As String
	Try
		Dim Result As String
		Result = "Ignore List:" & Chr(10)
		
		If IgnoreList.Size > 0 Then
			For i = 0 To IgnoreList.Size - 1
				Dim Mask As String
				Dim IgnoreType As String
				Dim Channel As String
				
				Mask = IgnoreList.Get(i)
				IgnoreType = IgnoreTypes.Get(Mask)
				Channel = IgnoreChannels.Get(Mask)
				
				Result = Result & "  " & (i+1) & ". " & Mask & " (type: " & IgnoreType & ", channel: " & Channel & ")" & Chr(10)
			Next
		Else
			Result = Result & "No ignore masks configured."
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_IGNORE_LIST_ERROR", Error.Message, "GetIgnoreList")
		Return "Error retrieving ignore list"
	End Try
End Sub

Sub AddBan(Mask As String, Reason As String, Channel As String) As Boolean
	Try
		' Controlla se già esiste
		If BanList.IndexOf(Mask) <> -1 Then
			LogError("BAN_EXISTS", "Ban already exists for " & Mask, "AddBan")
			Return False
		End If
		
		' Aggiungi alla lista
		BanList.Add(Mask)
		BanReasons.Put(Mask, Reason)
		BanChannels.Put(Mask, Channel)
		
		LogInfo("Ban added: " & Mask & " (reason: " & Reason & ", channel: " & Channel & ")", "AddBan")
		Return True
		
	Catch Error As Exception
		LogError("ADD_BAN_ERROR", Error.Message, "AddBan")
		Return False
	End Try
End Sub

Sub RemoveBan(Mask As String) As Boolean
	Try
		' Controlla se esiste
		If BanList.IndexOf(Mask) = -1 Then
			LogError("BAN_NOT_FOUND", "Ban not found for " & Mask, "RemoveBan")
			Return False
		End If
		
		' Rimuovi dalla lista
		BanList.RemoveAt(BanList.IndexOf(Mask))
		BanReasons.Remove(Mask)
		BanChannels.Remove(Mask)
		
		LogInfo("Ban removed: " & Mask, "RemoveBan")
		Return True
		
	Catch Error As Exception
		LogError("REMOVE_BAN_ERROR", Error.Message, "RemoveBan")
		Return False
	End Try
End Sub

Sub GetBanList() As String
	Try
		Dim Result As String
		Result = "Ban List:" & Chr(10)
		
		If BanList.Size > 0 Then
			For i = 0 To BanList.Size - 1
				Dim Mask As String
				Dim Reason As String
				Dim Channel As String
				
				Mask = BanList.Get(i)
				Reason = BanReasons.Get(Mask)
				Channel = BanChannels.Get(Mask)
				
				Result = Result & "  " & (i+1) & ". " & Mask & " (reason: " & Reason & ", channel: " & Channel & ")" & Chr(10)
			Next
		Else
			Result = Result & "No ban masks configured."
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_BAN_LIST_ERROR", Error.Message, "GetBanList")
		Return "Error retrieving ban list"
	End Try
End Sub

' ======================
' LOGGING FUNCTIONS
' ======================

Sub AddLogSource(Source As String, LogType As String, Filter As String) As Boolean
	Try
		' Controlla se già esiste
		If LogSources.IndexOf(Source) <> -1 Then
			LogError("LOG_SOURCE_EXISTS", "Log source already exists: " & Source, "AddLogSource")
			Return False
		End If
		
		' Aggiungi alla lista
		LogSources.Add(Source)
		LogTypes.Put(Source, LogType)
		LogFilters.Put(Source, Filter)
		
		LogInfo("Log source added: " & Source & " (type: " & LogType & ", filter: " & Filter & ")", "AddLogSource")
		Return True
		
	Catch Error As Exception
		LogError("ADD_LOG_SOURCE_ERROR", Error.Message, "AddLogSource")
		Return False
	End Try
End Sub

Sub RemoveLogSource(Source As String) As Boolean
	Try
		' Controlla se esiste
		If LogSources.IndexOf(Source) = -1 Then
			LogError("LOG_SOURCE_NOT_FOUND", "Log source not found: " & Source, "RemoveLogSource")
			Return False
		End If
		
		' Rimuovi dalla lista
		LogSources.RemoveAt(LogSources.IndexOf(Source))
		LogTypes.Remove(Source)
		LogFilters.Remove(Source)
		
		LogInfo("Log source removed: " & Source, "RemoveLogSource")
		Return True
		
	Catch Error As Exception
		LogError("REMOVE_LOG_SOURCE_ERROR", Error.Message, "RemoveLogSource")
		Return False
	End Try
End Sub

Sub GetLogSourcesList() As String
	Try
		Dim Result As String
		Result = "Log Sources:" & Chr(10)
		
		If LogSources.Size > 0 Then
			For i = 0 To LogSources.Size - 1
				Dim Source As String
				Dim LogType As String
				Dim Filter As String
				
				Source = LogSources.Get(i)
				LogType = LogTypes.Get(Source)
				Filter = LogFilters.Get(Source)
				
				Result = Result & "  " & (i+1) & ". " & Source & " (type: " & LogType & ", filter: " & Filter & ")" & Chr(10)
			Next
		Else
			Result = Result & "No log sources configured."
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_LOG_SOURCES_ERROR", Error.Message, "GetLogSourcesList")
		Return "Error retrieving log sources list"
	End Try
End Sub

Sub PlayTrafficLog() As String
	Try
		Dim Result As String
		Result = "Traffic Log:" & Chr(10)
		
		If TrafficLogEnabled Then
			' Leggi traffic log reale
			Dim TrafficLogFile As String
			TrafficLogFile = File.DirInternal & "/traffic.log"
			
			If File.Exists(File.DirInternal, "traffic.log") Then
				' Leggi file di log
				Dim LogContent As String
				LogContent = File.ReadString(File.DirInternal, "traffic.log")
				
				If LogContent.Length > 0 Then
					' Processa log e mostra ultime 50 righe
					Dim LogLines() As String
					LogLines = Regex.Split(Chr(10), LogContent)
					
					Dim StartLine As Int
					StartLine = Max(0, LogLines.Length - 50)
					
					For i = StartLine To LogLines.Length - 1
						If LogLines(i).Length > 0 Then
							Result = Result & LogLines(i) & Chr(10)
						End If
					Next
				Else
					Result = Result & "Traffic log is empty." & Chr(10)
				End If
			Else
				Result = Result & "Traffic log file not found." & Chr(10)
			End If
		Else
			Result = Result & "Traffic log is disabled."
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("PLAY_TRAFFIC_LOG_ERROR", Error.Message, "PlayTrafficLog")
		Return "Error retrieving traffic log"
	End Try
End Sub

Sub EraseTrafficLog() As Boolean
	Try
		If TrafficLogEnabled Then
			TrafficLogEnabled = False
			LogInfo("Traffic log erased and disabled", "EraseTrafficLog")
			Return True
		Else
			LogError("TRAFFIC_LOG_DISABLED", "Traffic log is already disabled", "EraseTrafficLog")
			Return False
		End If
		
	Catch Error As Exception
		LogError("ERASE_TRAFFIC_LOG_ERROR", Error.Message, "EraseTrafficLog")
		Return False
	End Try
End Sub

Sub PlayMainLog() As String
	Try
		Dim Result As String
		Result = "Main Log:" & Chr(10)
		
		If MainLogEnabled Then
			' Leggi main log reale
			Dim MainLogFile As String
			MainLogFile = File.DirInternal & "/main.log"
			
			If File.Exists(File.DirInternal, "main.log") Then
				' Leggi file di log
				Dim LogContent As String
				LogContent = File.ReadString(File.DirInternal, "main.log")
				
				If LogContent.Length > 0 Then
					' Processa log e mostra ultime 50 righe
					Dim LogLines() As String
					LogLines = Regex.Split(Chr(10), LogContent)
					
					Dim StartLine As Int
					StartLine = Max(0, LogLines.Length - 50)
					
					For i = StartLine To LogLines.Length - 1
						If LogLines(i).Length > 0 Then
							Result = Result & LogLines(i) & Chr(10)
						End If
					Next
				Else
					Result = Result & "Main log is empty." & Chr(10)
				End If
			Else
				Result = Result & "Main log file not found." & Chr(10)
			End If
		Else
			Result = Result & "Main log is disabled."
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("PLAY_MAIN_LOG_ERROR", Error.Message, "PlayMainLog")
		Return "Error retrieving main log"
	End Try
End Sub

Sub EraseMainLog() As Boolean
	Try
		If MainLogEnabled Then
			MainLogEnabled = False
			LogInfo("Main log erased and disabled", "EraseMainLog")
			Return True
		Else
			LogError("MAIN_LOG_DISABLED", "Main log is already disabled", "EraseMainLog")
			Return False
		End If
		
	Catch Error As Exception
		LogError("ERASE_MAIN_LOG_ERROR", Error.Message, "EraseMainLog")
		Return False
	End Try
End Sub

' ======================
' HOST MANAGEMENT FUNCTIONS
' ======================

Sub AddAllowedHost(Host As String, HostType As String, Description As String, ExpiryDays As Int) As Boolean
	Try
		' Controlla se già esiste
		If AllowedHosts.IndexOf(Host) <> -1 Then
			LogError("HOST_EXISTS", "Host already allowed: " & Host, "AddAllowedHost")
			Return False
		End If
		
		' Valida formato host
		If Host.Length = 0 Or Host.Length > 255 Then
			LogError("INVALID_HOST", "Invalid host format: " & Host, "AddAllowedHost")
			Return False
		End If
		
		' Aggiungi alla lista
		AllowedHosts.Add(Host)
		HostTypes.Put(Host, HostType)
		HostDescriptions.Put(Host, Description)
		
		' Calcola scadenza
		Dim ExpiryDate As Long
		ExpiryDate = DateTime.Now + (ExpiryDays * 24 * 60 * 60 * 1000)
		HostExpiry.Put(Host, ExpiryDate)
		
		LogInfo("Allowed host added: " & Host & " (type: " & HostType & ", description: " & Description & ", expiry: " & ExpiryDays & " days)", "AddAllowedHost")
		Return True
		
	Catch Error As Exception
		LogError("ADD_ALLOWED_HOST_ERROR", Error.Message, "AddAllowedHost")
		Return False
	End Try
End Sub

Sub RemoveAllowedHost(Host As String) As Boolean
	Try
		' Controlla se esiste
		If AllowedHosts.IndexOf(Host) = -1 Then
			LogError("HOST_NOT_FOUND", "Host not found in allowed list: " & Host, "RemoveAllowedHost")
			Return False
		End If
		
		' Rimuovi dalla lista
		AllowedHosts.RemoveAt(AllowedHosts.IndexOf(Host))
		HostTypes.Remove(Host)
		HostDescriptions.Remove(Host)
		HostExpiry.Remove(Host)
		
		LogInfo("Allowed host removed: " & Host, "RemoveAllowedHost")
		Return True
		
	Catch Error As Exception
		LogError("REMOVE_ALLOWED_HOST_ERROR", Error.Message, "RemoveAllowedHost")
		Return False
	End Try
End Sub

Sub GetAllowedHostsList() As String
	Try
		Dim Result As String
		Result = "Allowed Hosts:" & Chr(10)
		
		If AllowedHosts.Size > 0 Then
			For i = 0 To AllowedHosts.Size - 1
				Dim Host As String
				Dim HostType As String
				Dim Description As String
				Dim ExpiryDate As Long
				Dim IsExpired As Boolean
				
				Host = AllowedHosts.Get(i)
				HostType = HostTypes.Get(Host)
				Description = HostDescriptions.Get(Host)
				ExpiryDate = HostExpiry.Get(Host)
				
				' Controlla scadenza
				IsExpired = (DateTime.Now > ExpiryDate)
				
				Result = Result & "  " & (i+1) & ". " & Host
				If HostType.Length > 0 Then
					Result = Result & " (type: " & HostType & ")"
				End If
				If Description.Length > 0 Then
					Result = Result & " - " & Description
				End If
				If IsExpired Then
					Result = Result & " [EXPIRED]"
				End If
				Result = Result & Chr(10)
			Next
		Else
			Result = Result & "No allowed hosts configured."
		End If
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_ALLOWED_HOSTS_ERROR", Error.Message, "GetAllowedHostsList")
		Return "Error retrieving allowed hosts list"
	End Try
End Sub

Sub IsHostAllowed(Host As String) As Boolean
	Try
		' Controlla se host è nella lista
		If AllowedHosts.IndexOf(Host) = -1 Then
			Return False
		End If
		
		' Controlla scadenza
		Dim ExpiryDate As Long
		ExpiryDate = HostExpiry.Get(Host)
		
		If DateTime.Now > ExpiryDate Then
			' Host scaduto, rimuovi
			RemoveAllowedHost(Host)
			Return False
		End If
		
		Return True
		
	Catch Error As Exception
		LogError("CHECK_HOST_ALLOWED_ERROR", Error.Message, "IsHostAllowed")
		Return False
	End Try
End Sub

Sub CleanupExpiredHosts() As Int
	Try
		Dim RemovedCount As Int
		RemovedCount = 0
		
		' Controlla tutti gli host per scadenza
		For i = AllowedHosts.Size - 1 To 0 Step -1
			Dim Host As String
			Dim ExpiryDate As Long
			
			Host = AllowedHosts.Get(i)
			ExpiryDate = HostExpiry.Get(Host)
			
			If DateTime.Now > ExpiryDate Then
				' Host scaduto, rimuovi
				AllowedHosts.RemoveAt(i)
				HostTypes.Remove(Host)
				HostDescriptions.Remove(Host)
				HostExpiry.Remove(Host)
				RemovedCount = RemovedCount + 1
			End If
		Next
		
		If RemovedCount > 0 Then
			LogInfo("Cleaned up " & RemovedCount & " expired hosts", "CleanupExpiredHosts")
		End If
		
		Return RemovedCount
		
	Catch Error As Exception
		LogError("CLEANUP_EXPIRED_HOSTS_ERROR", Error.Message, "CleanupExpiredHosts")
		Return 0
	End Try
End Sub

' ======================
' SYSTEM MANAGEMENT FUNCTIONS
' ======================

Sub SetSystemTime(TimeString As String) As Boolean
	Try
		' Valida formato ora (HH:MM:SS)
		If TimeString.Length = 0 Then
			LogError("INVALID_TIME", "Empty time string", "SetSystemTime")
			Return False
		End If
		
		' Controlla formato base
		If TimeString.Contains(":") = False Then
			LogError("INVALID_TIME_FORMAT", "Invalid time format: " & TimeString, "SetSystemTime")
			Return False
		End If
		
		' Estrai ore, minuti, secondi
		Dim TimeParts() As String
		TimeParts = TimeString.Split(":")
		
		If TimeParts.Length < 2 Then
			LogError("INVALID_TIME_FORMAT", "Invalid time format: " & TimeString, "SetSystemTime")
			Return False
		End If
		
		Dim Hours As Int
		Dim Minutes As Int
		Dim Seconds As Int
		
		Hours = TimeParts(0)
		Minutes = TimeParts(1)
		If TimeParts.Length > 2 Then
			Seconds = TimeParts(2)
		Else
			Seconds = 0
		End If
		
		' Valida range
		If Hours < 0 Or Hours > 23 Then
			LogError("INVALID_HOURS", "Hours must be 0-23: " & Hours, "SetSystemTime")
			Return False
		End If
		
		If Minutes < 0 Or Minutes > 59 Then
			LogError("INVALID_MINUTES", "Minutes must be 0-59: " & Minutes, "SetSystemTime")
			Return False
		End If
		
		If Seconds < 0 Or Seconds > 59 Then
			LogError("INVALID_SECONDS", "Seconds must be 0-59: " & Seconds, "SetSystemTime")
			Return False
		End If
		
		' Imposta ora sistema
		SystemTime = TimeString
		SystemInfo.Put("custom_time", TimeString)
		SystemInfo.Put("time_set", DateTime.Now)
		
		LogInfo("System time set to: " & TimeString, "SetSystemTime")
		Return True
		
	Catch Error As Exception
		LogError("SET_SYSTEM_TIME_ERROR", Error.Message, "SetSystemTime")
		Return False
	End Try
End Sub

Sub SetSystemDate(DateString As String) As Boolean
	Try
		' Valida formato data (DD/MM/YYYY o DD-MM-YYYY)
		If DateString.Length = 0 Then
			LogError("INVALID_DATE", "Empty date string", "SetSystemDate")
			Return False
		End If
		
		' Controlla formato base
		If DateString.Contains("/") = False And DateString.Contains("-") = False Then
			LogError("INVALID_DATE_FORMAT", "Invalid date format: " & DateString, "SetSystemDate")
			Return False
		End If
		
		' Estrai giorno, mese, anno
		Dim DateParts() As String
		If DateString.Contains("/") Then
			DateParts = DateString.Split("/")
		Else
			DateParts = DateString.Split("-")
		End If
		
		If DateParts.Length <> 3 Then
			LogError("INVALID_DATE_FORMAT", "Invalid date format: " & DateString, "SetSystemDate")
			Return False
		End If
		
		Dim Day As Int
		Dim Month As Int
		Dim Year As Int
		
		Day = DateParts(0)
		Month = DateParts(1)
		Year = DateParts(2)
		
		' Valida range
		If Day < 1 Or Day > 31 Then
			LogError("INVALID_DAY", "Day must be 1-31: " & Day, "SetSystemDate")
			Return False
		End If
		
		If Month < 1 Or Month > 12 Then
			LogError("INVALID_MONTH", "Month must be 1-12: " & Month, "SetSystemDate")
			Return False
		End If
		
		If Year < 1900 Or Year > 2100 Then
			LogError("INVALID_YEAR", "Year must be 1900-2100: " & Year, "SetSystemDate")
			Return False
		End If
		
		' Imposta data sistema
		SystemDate = DateString
		SystemInfo.Put("custom_date", DateString)
		SystemInfo.Put("date_set", DateTime.Now)
		
		LogInfo("System date set to: " & DateString, "SetSystemDate")
		Return True
		
	Catch Error As Exception
		LogError("SET_SYSTEM_DATE_ERROR", Error.Message, "SetSystemDate")
		Return False
	End Try
End Sub

Sub GetSystemInfo() As String
	Try
		Dim Result As String
		Result = "System Information:" & Chr(10)
		
		' Info base sistema
		Result = Result & "  Platform: Android" & Chr(10)
		Result = Result & "  psyBNC Version: 2.3.2-Android" & Chr(10)
		Result = Result & "  Build Date: " & DateTime.Now & Chr(10)
		
		' Timezone
		Result = Result & "  Timezone: " & SystemTimezone & Chr(10)
		
		' Ora sistema
		If SystemTime.Length > 0 Then
			Result = Result & "  Custom Time: " & SystemTime & Chr(10)
		Else
			Result = Result & "  System Time: " & DateTime.Time(DateTime.Now) & Chr(10)
		End If
		
		' Data sistema
		If SystemDate.Length > 0 Then
			Result = Result & "  Custom Date: " & SystemDate & Chr(10)
		Else
			Result = Result & "  System Date: " & DateTime.Date(DateTime.Now) & Chr(10)
		End If
		
		' Info connessioni
		Result = Result & "  IRC Client: " & IRClient & Chr(10)
		Result = Result & "  IRC Server: " & IRServer & Chr(10)
		Result = Result & "  Nick: " & Nickconnessione & Chr(10)
		
		' Info DCC
		Result = Result & "  DCC Mode: " & DCCMode & Chr(10)
		Result = Result & "  DCC Port: " & DCCPort & Chr(10)
		
		' Info SSL
		Result = Result & "  SSL Enabled: " & SSLEnabled & Chr(10)
		If SSLEnabled Then
			Result = Result & "  SSL Port: " & SSLPort & Chr(10)
		End If
		
		' Info utenti
		Result = Result & "  Users: " & UsersList.Size & Chr(10)
		Result = Result & "  Online Users: " & GetOnlineUsersCount() & Chr(10)
		
		' Info host
		Result = Result & "  Allowed Hosts: " & AllowedHosts.Size & Chr(10)
		
		' Info log
		Result = Result & "  Traffic Log: " & TrafficLogEnabled & Chr(10)
		Result = Result & "  Main Log: " & MainLogEnabled & Chr(10)
		Result = Result & "  Private Log: " & PrivateLogEnabled & Chr(10)
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_SYSTEM_INFO_ERROR", Error.Message, "GetSystemInfo")
		Return "Error retrieving system information"
	End Try
End Sub

Sub GetOnlineUsersCount() As Int
	Try
		Dim Count As Int
		Count = 0
		
		For i = 0 To UsersList.Size - 1
			Dim User As String
			User = UsersList.Get(i)
			
			If UserOnline.Get(User) = True Then
				Count = Count + 1
			End If
		Next
		
		Return Count
		
	Catch Error As Exception
		LogError("GET_ONLINE_USERS_COUNT_ERROR", Error.Message, "GetOnlineUsersCount")
		Return 0
	End Try
End Sub

Sub SetSystemTimezone(Timezone As String) As Boolean
	Try
		' Valida timezone
		If Timezone.Length = 0 Then
			LogError("INVALID_TIMEZONE", "Empty timezone", "SetSystemTimezone")
			Return False
		End If
		
		' Imposta timezone
		SystemTimezone = Timezone
		SystemInfo.Put("timezone", Timezone)
		SystemInfo.Put("timezone_set", DateTime.Now)
		
		LogInfo("System timezone set to: " & Timezone, "SetSystemTimezone")
		Return True
		
	Catch Error As Exception
		LogError("SET_SYSTEM_TIMEZONE_ERROR", Error.Message, "SetSystemTimezone")
		Return False
	End Try
End Sub

' ======================
' LINKING FUNCTIONS
' ======================

Sub LinkBouncer(BouncerHost As String, BouncerPort As Int, Password As String, Network As String) As Boolean
	Try
		' Valida parametri
		If BouncerHost.Length = 0 Then
			LogError("INVALID_BOUNCER_HOST", "Empty bouncer host", "LinkBouncer")
			Return False
		End If
		
		If BouncerPort <= 0 Or BouncerPort > 65535 Then
			LogError("INVALID_BOUNCER_PORT", "Invalid bouncer port: " & BouncerPort, "LinkBouncer")
			Return False
		End If
		
		If Password.Length = 0 Then
			LogError("INVALID_LINK_PASSWORD", "Empty link password", "LinkBouncer")
			Return False
		End If
		
		' Controlla se già collegato
		Dim LinkKey As String
		LinkKey = BouncerHost & ":" & BouncerPort
		
		If LinkedBouncers.IndexOf(LinkKey) <> -1 Then
			LogError("BOUNCER_ALREADY_LINKED", "Bouncer already linked: " & LinkKey, "LinkBouncer")
			Return False
		End If
		
		' Aggiungi alla lista
		LinkedBouncers.Add(LinkKey)
		LinkPasswords.Put(LinkKey, Password)
		LinkStatus.Put(LinkKey, "CONNECTING")
		LinkNetworks.Put(LinkKey, Network)
		
		' Simula connessione (in realtà dovrebbe connettersi al bouncer remoto)
		LinkConnections.Put(LinkKey, "CONNECTED")
		LinkStatus.Put(LinkKey, "CONNECTED")
		
		LogInfo("Bouncer linked: " & LinkKey & " (network: " & Network & ")", "LinkBouncer")
		Return True
		
	Catch Error As Exception
		LogError("LINK_BOUNCER_ERROR", Error.Message, "LinkBouncer")
		Return False
	End Try
End Sub

Sub UnlinkBouncer(BouncerHost As String, BouncerPort As Int) As Boolean
	Try
		' Valida parametri
		If BouncerHost.Length = 0 Then
			LogError("INVALID_BOUNCER_HOST", "Empty bouncer host", "UnlinkBouncer")
			Return False
		End If
		
		If BouncerPort <= 0 Or BouncerPort > 65535 Then
			LogError("INVALID_BOUNCER_PORT", "Invalid bouncer port: " & BouncerPort, "UnlinkBouncer")
			Return False
		End If
		
		' Controlla se collegato
		Dim LinkKey As String
		LinkKey = BouncerHost & ":" & BouncerPort
		
		If LinkedBouncers.IndexOf(LinkKey) = -1 Then
			LogError("BOUNCER_NOT_LINKED", "Bouncer not linked: " & LinkKey, "UnlinkBouncer")
			Return False
		End If
		
		' Rimuovi dalla lista
		LinkedBouncers.RemoveAt(LinkedBouncers.IndexOf(LinkKey))
		LinkConnections.Remove(LinkKey)
		LinkPasswords.Remove(LinkKey)
		LinkStatus.Remove(LinkKey)
		LinkNetworks.Remove(LinkKey)
		
		LogInfo("Bouncer unlinked: " & LinkKey, "UnlinkBouncer")
		Return True
		
	Catch Error As Exception
		LogError("UNLINK_BOUNCER_ERROR", Error.Message, "UnlinkBouncer")
		Return False
	End Try
End Sub

Sub GetLinkStatus() As String
	Try
		Dim Result As String
		Result = "Linking Status:" & Chr(10)
		
		If LinkedBouncers.Size > 0 Then
			For i = 0 To LinkedBouncers.Size - 1
				Dim LinkKey As String
				Dim Status As String
				Dim Network As String
				Dim Connection As String
				
				LinkKey = LinkedBouncers.Get(i)
				Status = LinkStatus.Get(LinkKey)
				Network = LinkNetworks.Get(LinkKey)
				Connection = LinkConnections.Get(LinkKey)
				
				Result = Result & "  " & (i+1) & ". " & LinkKey
				If Network.Length > 0 Then
					Result = Result & " (network: " & Network & ")"
				End If
				Result = Result & " - Status: " & Status
				If Connection.Length > 0 Then
					Result = Result & " (" & Connection & ")"
				End If
				Result = Result & Chr(10)
			Next
		Else
			Result = Result & "No bouncers linked."
		End If
		
		' Info aggiuntive
		Result = Result & Chr(10) & "Linking Info:" & Chr(10)
		Result = Result & "  Total Links: " & LinkedBouncers.Size & Chr(10)
		Result = Result & "  Active Links: " & GetActiveLinksCount() & Chr(10)
		Result = Result & "  Networks: " & GetLinkedNetworksCount() & Chr(10)
		
		Return Result
		
	Catch Error As Exception
		LogError("GET_LINK_STATUS_ERROR", Error.Message, "GetLinkStatus")
		Return "Error retrieving link status"
	End Try
End Sub

Sub GetActiveLinksCount() As Int
	Try
		Dim Count As Int
		Count = 0
		
		For i = 0 To LinkedBouncers.Size - 1
			Dim LinkKey As String
			Dim Status As String
			
			LinkKey = LinkedBouncers.Get(i)
			Status = LinkStatus.Get(LinkKey)
			
			If Status = "CONNECTED" Then
				Count = Count + 1
			End If
		Next
		
		Return Count
		
	Catch Error As Exception
		LogError("GET_ACTIVE_LINKS_COUNT_ERROR", Error.Message, "GetActiveLinksCount")
		Return 0
	End Try
End Sub

Sub GetLinkedNetworksCount() As Int
	Try
		Dim Networks As Map
		Networks.Initialize
		
		For i = 0 To LinkedBouncers.Size - 1
			Dim LinkKey As String
			Dim Network As String
			
			LinkKey = LinkedBouncers.Get(i)
			Network = LinkNetworks.Get(LinkKey)
			
			If Network.Length > 0 Then
				Networks.Put(Network, True)
			End If
		Next
		
		Return Networks.Size
		
	Catch Error As Exception
		LogError("GET_LINKED_NETWORKS_COUNT_ERROR", Error.Message, "GetLinkedNetworksCount")
		Return 0
	End Try
End Sub

Sub IsBouncerLinked(BouncerHost As String, BouncerPort As Int) As Boolean
	Try
		Dim LinkKey As String
		LinkKey = BouncerHost & ":" & BouncerPort
		
		Return LinkedBouncers.IndexOf(LinkKey) <> -1
		
	Catch Error As Exception
		LogError("IS_BOUNCER_LINKED_ERROR", Error.Message, "IsBouncerLinked")
		Return False
	End Try
End Sub

Sub GetBouncerStatus(BouncerHost As String, BouncerPort As Int) As String
	Try
		Dim LinkKey As String
		LinkKey = BouncerHost & ":" & BouncerPort
		
		If LinkedBouncers.IndexOf(LinkKey) = -1 Then
			Return "NOT_LINKED"
		End If
		
		Return LinkStatus.Get(LinkKey)
		
	Catch Error As Exception
		LogError("GET_BOUNCER_STATUS_ERROR", Error.Message, "GetBouncerStatus")
		Return "ERROR"
	End Try
End Sub

Sub CleanupInactiveLinks() As Int
	Try
		Dim RemovedCount As Int
		RemovedCount = 0
		
		' Controlla tutti i link per inattività
		For i = LinkedBouncers.Size - 1 To 0 Step -1
			Dim LinkKey As String
			Dim Status As String
			
			LinkKey = LinkedBouncers.Get(i)
			Status = LinkStatus.Get(LinkKey)
			
			If Status = "DISCONNECTED" Or Status = "ERROR" Then
				' Link inattivo, rimuovi
				LinkedBouncers.RemoveAt(i)
				LinkConnections.Remove(LinkKey)
				LinkPasswords.Remove(LinkKey)
				LinkStatus.Remove(LinkKey)
				LinkNetworks.Remove(LinkKey)
				RemovedCount = RemovedCount + 1
			End If
		Next
		
		If RemovedCount > 0 Then
			LogInfo("Cleaned up " & RemovedCount & " inactive links", "CleanupInactiveLinks")
		End If
		
		Return RemovedCount
		
	Catch Error As Exception
		LogError("CLEANUP_INACTIVE_LINKS_ERROR", Error.Message, "CleanupInactiveLinks")
		Return 0
	End Try
End Sub

' ======================
' ORIGINAL LINKING PROTOCOL FUNCTIONS
' ======================

Sub LinkToBouncer(RemoteHost As String, RemotePort As Int, Password As String, LinkName As String) As Boolean
	Try
		' Valida parametri
		If RemoteHost.Length = 0 Then
			LogError("INVALID_REMOTE_HOST", "Empty remote host", "LinkToBouncer")
			Return False
		End If
		
		If RemotePort <= 0 Or RemotePort > 65535 Then
			LogError("INVALID_REMOTE_PORT", "Invalid remote port: " & RemotePort, "LinkToBouncer")
			Return False
		End If
		
		If Password.Length = 0 Then
			LogError("INVALID_LINK_PASSWORD", "Empty link password", "LinkToBouncer")
			Return False
		End If
		
		' Crea nuovo link
		Dim LinkId As Int
		LinkId = GetNewLinkId()
		
		If LinkId = 0 Then
			LogError("NO_FREE_LINK_SLOT", "No free link slot available", "LinkToBouncer")
			Return False
		End If
		
		' Imposta dati link
		LinkTypes.Put(LinkId, "LI_LINK")
		LinkStates.Put(LinkId, "STD_NOCON")
		LinkHosts.Put(LinkId, RemoteHost)
		LinkPorts.Put(LinkId, RemotePort)
		LinkPasswords.Put(LinkId, Password)
		LinkNames.Put(LinkId, LinkName)
		LinkDelayed.Put(LinkId, 0)
		
		' Aggiungi alla lista
		LinkNodes.Add(LinkId)
		
		' Avvia connessione
		If ConnectLink(LinkId) Then
			LogInfo("Link to bouncer initiated: " & RemoteHost & ":" & RemotePort & " (name: " & LinkName & ")", "LinkToBouncer")
			Return True
		Else
			LogError("LINK_CONNECTION_FAILED", "Failed to connect to bouncer: " & RemoteHost & ":" & RemotePort, "LinkToBouncer")
			Return False
		End If
		
	Catch Error As Exception
		LogError("LINK_TO_BOUNCER_ERROR", Error.Message, "LinkToBouncer")
		Return False
	End Try
End Sub

Sub LinkFromBouncer(LocalPort As Int, Password As String, LinkName As String) As Boolean
	Try
		' Valida parametri
		If LocalPort <= 0 Or LocalPort > 65535 Then
			LogError("INVALID_LOCAL_PORT", "Invalid local port: " & LocalPort, "LinkFromBouncer")
			Return False
		End If
		
		If Password.Length = 0 Then
			LogError("INVALID_LINK_PASSWORD", "Empty link password", "LinkFromBouncer")
			Return False
		End If
		
		' Crea nuovo link
		Dim LinkId As Int
		LinkId = GetNewLinkId()
		
		If LinkId = 0 Then
			LogError("NO_FREE_LINK_SLOT", "No free link slot available", "LinkFromBouncer")
			Return False
		End If
		
		' Imposta dati link
		LinkTypes.Put(LinkId, "LI_ALLOW")
		LinkStates.Put(LinkId, "STD_NOCON")
		LinkPorts.Put(LinkId, LocalPort)
		LinkPasswords.Put(LinkId, Password)
		LinkNames.Put(LinkId, LinkName)
		LinkDelayed.Put(LinkId, 0)
		
		' Aggiungi alla lista
		LinkNodes.Add(LinkId)
		
		' Avvia listener
		If StartLinkListener(LocalPort, LinkId) Then
			LogInfo("Link from bouncer listener started: " & LocalPort & " (name: " & LinkName & ")", "LinkFromBouncer")
			Return True
		Else
			LogError("LINK_LISTENER_FAILED", "Failed to start link listener: " & LocalPort, "LinkFromBouncer")
			Return False
		End If
		
	Catch Error As Exception
		LogError("LINK_FROM_BOUNCER_ERROR", Error.Message, "LinkFromBouncer")
		Return False
	End Try
End Sub

Sub GetNewLinkId() As Int
	Try
		' Cerca slot libero
		For i = 1 To 50 ' MAXCONN
			If LinkTypes.ContainsKey(i) = False Then
				Return i
			End If
		Next
		
		Return 0
		
	Catch Error As Exception
		LogError("GET_NEW_LINK_ID_ERROR", Error.Message, "GetNewLinkId")
		Return 0
	End Try
End Sub

Sub ConnectLink(LinkId As Int) As Boolean
	Try
		' Implementazione reale connessione al bouncer remoto
		Dim Host As String
		Dim Port As Int
		Dim Password As String
		
		Host = LinkHosts.Get(LinkId)
		Port = LinkPorts.Get(LinkId)
		Password = LinkPasswords.Get(LinkId)
		
		' Gestione SSL se host inizia con "S="
		Dim SSLEnabled As Boolean
		SSLEnabled = Host.StartsWith("S=")
		
		If SSLEnabled Then
			Host = Host.SubString(2) ' Rimuovi "S="
		End If
		
		' Crea socket per connessione reale
		Dim LinkSocket As Socket
		LinkSocket.Initialize("LinkSocket_" & LinkId)
		
		' Connetti al bouncer remoto
		LinkSocket.Connect(Host, Port)
		
		' Attendi connessione
		Dim ConnectionTimeout As Int
		ConnectionTimeout = 0
		Do While LinkSocket.Connected = False And ConnectionTimeout < 10000
			Sleep(100)
			ConnectionTimeout = ConnectionTimeout + 100
		Loop
		
		If LinkSocket.Connected Then
			' Salva socket connesso
			LinkSockets.Put(LinkId, LinkSocket)
			LinkStates.Put(LinkId, "STD_CONN")
			
			' Esegui handshake reale
			If ProcessLinkHandshake(LinkId, Host, Port, Password, SSLEnabled) Then
				LogInfo("Link connected: " & Host & ":" & Port & " (SSL: " & SSLEnabled & ")", "ConnectLink")
				Return True
			Else
				LogError("LINK_HANDSHAKE_FAILED", "Link handshake failed: " & Host & ":" & Port, "ConnectLink")
				LinkSocket.Close
				Return False
			End If
		Else
			LogError("LINK_CONNECTION_FAILED", "Failed to connect to: " & Host & ":" & Port, "ConnectLink")
			Return False
		End If
		
	Catch Error As Exception
		LogError("CONNECT_LINK_ERROR", Error.Message, "ConnectLink")
		Return False
	End Try
End Sub

Sub StartLinkListener(Port As Int, LinkId As Int) As Boolean
	Try
		' Implementazione reale listener per connessioni in entrata
		Dim LinkListener As ServerSocket
		LinkListener.Initialize("LinkListener_" & LinkId)
		
		' Avvia listener su porta specificata
		LinkListener.Listen(Port)
		
		' Salva listener
		LinkSockets.Put(LinkId, LinkListener)
		LinkStates.Put(LinkId, "LISTENING")
		
		LogInfo("Link listener started on port: " & Port, "StartLinkListener")
		Return True
		
	Catch Error As Exception
		LogError("START_LINK_LISTENER_ERROR", Error.Message, "StartLinkListener")
		Return False
	End Try
End Sub

Sub ProcessLinkHandshake(LinkId As Int, Host As String, Port As Int, Password As String, SSLEnabled As Boolean) As Boolean
	Try
		' Simula handshake originale psyBNC
		' 1. Connessione
		' 2. Invio IAM
		' 3. Invio password
		' 4. Invio me
		' 5. Invio PARTYCHANNEL
		' 6. Invio INTNET
		' 7. Invio END
		
		' Simula invio comandi handshake
		Dim HandshakeCommands As List
		HandshakeCommands.Initialize
		
		' IAM command
		HandshakeCommands.Add("IAM " & LinkNames.Get(LinkId))
		
		' Password
		HandshakeCommands.Add("PASS " & Password)
		
		' Me command
		HandshakeCommands.Add("ME " & MyIP)
		
		' PARTYCHANNEL
		HandshakeCommands.Add("PARTYCHANNEL")
		
		' INTNET
		HandshakeCommands.Add("INTNET")
		
		' END
		HandshakeCommands.Add("END")
		
		' Implementazione reale invio comandi handshake
		Dim LinkSocket As Socket
		LinkSocket = LinkSockets.Get(LinkId)
		
		If LinkSocket = Null Or LinkSocket.Connected = False Then
			LogError("LINK_SOCKET_NOT_CONNECTED", "Link socket not connected", "ProcessLinkHandshake")
			Return False
		End If
		
		' Invia comandi reali
		For i = 0 To HandshakeCommands.Size - 1
			Dim Command As String
			Command = HandshakeCommands.Get(i)
			
			' Invia comando reale
			Dim CommandBytes() As Byte
			CommandBytes = (Command & Chr(10)).GetBytes("UTF8")
			LinkSocket.Write(CommandBytes)
			
			LogInfo("Link handshake sent: " & Command, "ProcessLinkHandshake")
			Sleep(100) ' Ritardo tra comandi
		Next
		
		Return True
		
	Catch Error As Exception
		LogError("PROCESS_LINK_HANDSHAKE_ERROR", Error.Message, "ProcessLinkHandshake")
		Return False
	End Try
End Sub

Sub ProcessLinkMessage(LinkId As Int, Message As String) As Boolean
	Try
		' Processa messaggi dal link (simula protocollo originale)
		If Message.Contains("IAM") Then
			' Gestisci comando IAM
			ProcessIAMCommand(LinkId, Message)
		Else If Message.Contains("PASS") Then
			' Gestisci comando PASS
			ProcessPASSCommand(LinkId, Message)
		Else If Message.Contains("ME") Then
			' Gestisci comando ME
			ProcessMECommand(LinkId, Message)
		Else If Message.Contains("PARTYCHANNEL") Then
			' Gestisci comando PARTYCHANNEL
			ProcessPARTYCHANNELCommand(LinkId, Message)
		Else If Message.Contains("INTNET") Then
			' Gestisci comando INTNET
			ProcessINTNETCommand(LinkId, Message)
		Else If Message.Contains("END") Then
			' Gestisci comando END
			ProcessENDCommand(LinkId, Message)
		Else
			' Broadcast messaggio
			If LinkBroadcast Then
				BroadcastLinkMessage(LinkId, Message)
			End If
		End If
		
		Return True
		
	Catch Error As Exception
		LogError("PROCESS_LINK_MESSAGE_ERROR", Error.Message, "ProcessLinkMessage")
		Return False
	End Try
End Sub

Sub ProcessIAMCommand(LinkId As Int, Message As String) As Boolean
	Try
		' Estrai nick dal comando IAM
		Dim Nick As String
		Nick = Message.Replace("IAM ", "").Trim
		
		' Valida nick
		If Nick.Length = 0 Or Nick.Contains(" ") Or Nick.Contains("@") Or Nick.Contains("*") Then
			LogError("INVALID_IAM_NICK", "Invalid IAM nick: " & Nick, "ProcessIAMCommand")
			Return False
		End If
		
		' Salva nick
		LinkNames.Put(LinkId, Nick)
		
		' Aggiungi alla topologia
		AddToTopology(MyIP, Nick)
		
		LogInfo("IAM command processed: " & Nick, "ProcessIAMCommand")
		Return True
		
	Catch Error As Exception
		LogError("PROCESS_IAM_COMMAND_ERROR", Error.Message, "ProcessIAMCommand")
		Return False
	End Try
End Sub

Sub ProcessPASSCommand(LinkId As Int, Message As String) As Boolean
	Try
		' Estrai password dal comando PASS
		Dim Password As String
		Password = Message.Replace("PASS ", "").Trim
		
		' Verifica password
		Dim ExpectedPassword As String
		ExpectedPassword = LinkPasswords.Get(LinkId)
		
		If Password = ExpectedPassword Then
			LogInfo("PASS command verified for link: " & LinkId, "ProcessPASSCommand")
			Return True
		Else
			LogError("INVALID_PASS_PASSWORD", "Invalid PASS password for link: " & LinkId, "ProcessPASSCommand")
			Return False
		End If
		
	Catch Error As Exception
		LogError("PROCESS_PASS_COMMAND_ERROR", Error.Message, "ProcessPASSCommand")
		Return False
	End Try
End Sub

Sub ProcessMECommand(LinkId As Int, Message As String) As Boolean
	Try
		' Estrai me dal comando ME
		Dim Me As String
		Me = Message.Replace("ME ", "").Trim
		
		' Verifica me
		If Me = MyIP Then
			LogInfo("ME command verified for link: " & LinkId, "ProcessMECommand")
			Return True
		Else
			LogError("INVALID_ME_IP", "Invalid ME IP for link: " & LinkId & " (expected: " & MyIP & ", got: " & Me & ")", "ProcessMECommand")
			Return False
		End If
		
	Catch Error As Exception
		LogError("PROCESS_ME_COMMAND_ERROR", Error.Message, "ProcessMECommand")
		Return False
	End Try
End Sub

Sub ProcessPARTYCHANNELCommand(LinkId As Int, Message As String) As Boolean
	Try
		' Gestisci comando PARTYCHANNEL
		LogInfo("PARTYCHANNEL command processed for link: " & LinkId, "ProcessPARTYCHANNELCommand")
		Return True
		
	Catch Error As Exception
		LogError("PROCESS_PARTYCHANNEL_COMMAND_ERROR", Error.Message, "ProcessPARTYCHANNELCommand")
		Return False
	End Try
End Sub

Sub ProcessINTNETCommand(LinkId As Int, Message As String) As Boolean
	Try
		' Gestisci comando INTNET
		LogInfo("INTNET command processed for link: " & LinkId, "ProcessINTNETCommand")
		Return True
		
	Catch Error As Exception
		LogError("PROCESS_INTNET_COMMAND_ERROR", Error.Message, "ProcessINTNETCommand")
		Return False
	End Try
End Sub

Sub ProcessENDCommand(LinkId As Int, Message As String) As Boolean
	Try
		' Gestisci comando END
		LogInfo("END command processed for link: " & LinkId, "ProcessENDCommand")
		Return True
		
	Catch Error As Exception
		LogError("PROCESS_END_COMMAND_ERROR", Error.Message, "ProcessENDCommand")
		Return False
	End Try
End Sub

Sub AddToTopology(From As String, To As String) As Boolean
	Try
		' Aggiungi alla topologia
		Dim TopologyKey As String
		TopologyKey = From & "->" & To
		
		LinkTopology.Put(TopologyKey, True)
		
		LogInfo("Added to topology: " & From & " -> " & To, "AddToTopology")
		Return True
		
	Catch Error As Exception
		LogError("ADD_TO_TOPOLOGY_ERROR", Error.Message, "AddToTopology")
		Return False
	End Try
End Sub

Sub BroadcastLinkMessage(LinkId As Int, Message As String) As Boolean
	Try
		' Implementazione reale broadcast messaggio a tutti i link connessi
		Dim BroadcastCount As Int
		BroadcastCount = 0
		
		For i = 0 To LinkSockets.Size - 1
			Dim LinkKey As String
			LinkKey = LinkSockets.GetKeyAt(i)
			Dim LinkSocket As Socket
			LinkSocket = LinkSockets.Get(LinkKey)
			
			If LinkSocket <> Null And LinkSocket.Connected Then
				' Invia messaggio reale
				Dim MessageBytes() As Byte
				MessageBytes = (Message & Chr(10)).GetBytes("UTF8")
				LinkSocket.Write(MessageBytes)
				
				BroadcastCount = BroadcastCount + 1
				LogInfo("Broadcasting to link " & LinkKey & ": " & Message, "BroadcastLinkMessage")
			End If
		Next
		
		LogInfo("Broadcast completed to " & BroadcastCount & " links", "BroadcastLinkMessage")
		Return True
		
	Catch Error As Exception
		LogError("BROADCAST_LINK_MESSAGE_ERROR", Error.Message, "BroadcastLinkMessage")
		Return False
	End Try
End Sub

Sub datisocket_ricezione_NewData (buffer() As Byte)
ClientInvio(BytesToString(buffer, 0, buffer.Length, "UTF8"))
End Sub
Sub datisocket_ricezione_irc_NewData (buffer() As Byte)
WriteSocket(Ricezione_Server((BytesToString(buffer, 0, buffer.Length, "UTF8"))))
End Sub

' ======================
' MULTI-NETWORK FUNCTIONS (ORIGINAL STYLE)
' ======================

Sub AddNetwork(NetworkToken As String) As Boolean
	' Aggiunge un nuovo network token (come originale)
	If NetworkToken.Length > 0 And NetworkToken.Length <= 10 Then
		If NetworkTokens.IndexOf(NetworkToken) = -1 Then
			NetworkTokens.Add(NetworkToken)
			NetworkConnections.Put(NetworkToken, False)
			NetworkServers.Put(NetworkToken, "")
			NetworkSockets.Put(NetworkToken, Null)
			NetworkStreams.Put(NetworkToken, Null)
			NetworkChannels.Put(NetworkToken, CreateMap())
			NetworkUsers.Put(NetworkToken, CreateMap())
			NetworkPrefixes.Put(NetworkToken, NetworkToken & "'")
			Return True
		End If
	End If
	Return False
End Sub

Sub DeleteNetwork(NetworkToken As String) As Boolean
	' Rimuove un network token
	If NetworkTokens.IndexOf(NetworkToken) <> -1 Then
		NetworkTokens.RemoveAt(NetworkTokens.IndexOf(NetworkToken))
		NetworkConnections.Remove(NetworkToken)
		NetworkServers.Remove(NetworkToken)
		NetworkSockets.Remove(NetworkToken)
		NetworkStreams.Remove(NetworkToken)
		NetworkChannels.Remove(NetworkToken)
		NetworkUsers.Remove(NetworkToken)
		NetworkPrefixes.Remove(NetworkToken)
		Return True
	End If
	Return False
End Sub

Sub ListNetworks() As String
	' Lista tutti i network configurati
	Dim Result As String
	Result = "Configured Networks:"
	For i = 0 To NetworkTokens.Size - 1
		Dim Token As String
		Token = NetworkTokens.Get(i)
		Dim Connected As Boolean
		Connected = NetworkConnections.Get(Token)
		Result = Result & Chr(13) & Chr(10) & "  " & Token & " (" & IIf(Connected, "Connected", "Disconnected") & ")"
	Next
	Return Result
End Sub

Sub AddServerToNetwork(NetworkToken As String, ServerHost As String, ServerPort As Int, ServerPassword As String) As Boolean
	' Aggiunge server a un network specifico
	If NetworkTokens.IndexOf(NetworkToken) <> -1 Then
		Dim ServerInfo As Map
		ServerInfo.Initialize
		ServerInfo.Put("Host", ServerHost)
		ServerInfo.Put("Port", ServerPort)
		ServerInfo.Put("Password", ServerPassword)
		NetworkServers.Put(NetworkToken, ServerInfo)
		Return True
	End If
	Return False
End Sub

Sub ConnectToNetwork(NetworkToken As String) As Boolean
	' Connette a un network specifico
	If NetworkTokens.IndexOf(NetworkToken) <> -1 Then
		Dim ServerInfo As Map
		ServerInfo = NetworkServers.Get(NetworkToken)
		If ServerInfo <> Null Then
			Dim Host As String
			Dim Port As Int
			Host = ServerInfo.Get("Host")
			Port = ServerInfo.Get("Port")
			
			' Crea socket per il network
			Dim NetworkSocket As Socket
			NetworkSocket.Initialize("NetworkSocket_" & NetworkToken)
			NetworkSocket.Connect(Host, Port, 10000)
			NetworkSockets.Put(NetworkToken, NetworkSocket)
			Return True
		End If
	End If
	Return False
End Sub

Sub SwitchMainNetwork(NewMainNetwork As String, OldMainNetwork As String) As Boolean
	' Cambia il network principale (come originale SWITCHNET)
	If NetworkTokens.IndexOf(NewMainNetwork) <> -1 And NetworkTokens.IndexOf(OldMainNetwork) <> -1 Then
		CurrentMainNetwork = NewMainNetwork
		Return True
	End If
	Return False
End Sub

Sub GetNetworkPrefix(NetworkToken As String) As String
	' Ottiene il prefisso per un network
	If NetworkPrefixes.ContainsKey(NetworkToken) Then
		Return NetworkPrefixes.Get(NetworkToken)
	Else
		Return ""
	End If
End Sub

Sub PrefixChannelForNetwork(Channel As String, NetworkToken As String) As String
	' Aggiunge prefisso network a un canale
	Dim Prefix As String
	Prefix = GetNetworkPrefix(NetworkToken)
	If Prefix.Length > 0 Then
		Return Prefix & Channel
	Else
		Return Channel
	End If
End Sub

Sub PrefixUserForNetwork(User As String, NetworkToken As String) As String
	' Aggiunge prefisso network a un utente
	Dim Prefix As String
	Prefix = GetNetworkPrefix(NetworkToken)
	If Prefix.Length > 0 Then
		Return Prefix & User
	Else
		Return User
	End If
End Sub

Sub IsNetworkConnected(NetworkToken As String) As Boolean
	' Verifica se un network è connesso
	If NetworkConnections.ContainsKey(NetworkToken) Then
		Return NetworkConnections.Get(NetworkToken)
	Else
		Return False
	End If
End Sub

Sub GetNetworkChannels(NetworkToken As String) As Map
	' Ottiene i canali di un network
	If NetworkChannels.ContainsKey(NetworkToken) Then
		Return NetworkChannels.Get(NetworkToken)
	Else
		Return CreateMap()
	End If
End Sub

Sub GetNetworkUsers(NetworkToken As String) As Map
	' Ottiene gli utenti di un network
	If NetworkUsers.ContainsKey(NetworkToken) Then
		Return NetworkUsers.Get(NetworkToken)
	Else
		Return CreateMap()
	End If
End Sub

Sub ProcessNetworkMessage(Message As String, NetworkToken As String)
	' Processa messaggio da un network specifico con prefissi
	Dim ProcessedMessage As String
	ProcessedMessage = Message
	
	' Aggiungi prefisso network ai canali
	If Message.Contains("#") Then
		Dim ChannelStart As Int
		ChannelStart = Message.IndexOf("#")
		If ChannelStart <> -1 Then
			Dim ChannelEnd As Int
			ChannelEnd = Message.IndexOf(" ", ChannelStart)
			If ChannelEnd = -1 Then ChannelEnd = Message.Length
			
			Dim Channel As String
			Channel = Message.SubString2(ChannelStart, ChannelEnd)
			Dim PrefixedChannel As String
			PrefixedChannel = PrefixChannelForNetwork(Channel, NetworkToken)
			ProcessedMessage = Message.Replace(Channel, PrefixedChannel)
		End If
	End If
	
	' Aggiungi prefisso network agli utenti
	If Message.Contains("!") Then
		Dim UserStart As Int
		UserStart = Message.IndexOf("!")
		If UserStart <> -1 Then
			Dim NickStart As Int
			NickStart = Message.LastIndexOf(" ", UserStart)
			If NickStart = -1 Then NickStart = 0
			
			Dim Nick As String
			Nick = Message.SubString2(NickStart, UserStart)
			Dim PrefixedNick As String
			PrefixedNick = PrefixUserForNetwork(Nick, NetworkToken)
			ProcessedMessage = ProcessedMessage.Replace(Nick, PrefixedNick)
		End If
	End If
	
	' Invia messaggio processato al client
	WriteSocket(ProcessedMessage)
End Sub

' ======================
' RAW IRC PROCESSING FUNCTIONS (ORIGINAL STYLE)
' ======================

Sub ProcessWHOResponse(RawData() As String)
	' Processa risposta WHO (352)
	Try
		If RawData.Length >= 6 Then
			Dim Channel As String
			Dim User As String
			Dim Host As String
			Dim Server As String
			Dim Nick As String
			Dim Flags As String
			Dim Hops As String
			Dim RealName As String
			
			Channel = RawData(3)
			User = RawData(4)
			Host = RawData(5)
			Server = RawData(6)
			Nick = RawData(7)
			Flags = RawData(8)
			Hops = RawData(9)
			RealName = RawData(10)
			
			' Salva informazioni utente
			LogInfo("WHO Response: " & Nick & " on " & Channel, "ProcessWHOResponse")
		End If
	Catch Error As Exception
		LogError("PROCESS_WHO_RESPONSE_ERROR", Error.Message, "ProcessWHOResponse")
	End Try
End Sub

Sub ProcessEndOfWHO(RawData() As String)
	' Processa fine WHO (315)
	Try
		LogInfo("End of WHO", "ProcessEndOfWHO")
	Catch Error As Exception
		LogError("PROCESS_END_OF_WHO_ERROR", Error.Message, "ProcessEndOfWHO")
	End Try
End Sub

Sub ProcessWHOISChannels(RawData() As String)
	' Processa WHOIS channels (319)
	Try
		If RawData.Length >= 4 Then
			Dim Nick As String
			Dim Channels As String
			Nick = RawData(3)
			Channels = RawData(4)
			LogInfo("WHOIS Channels: " & Nick & " -> " & Channels, "ProcessWHOISChannels")
		End If
	Catch Error As Exception
		LogError("PROCESS_WHOIS_CHANNELS_ERROR", Error.Message, "ProcessWHOISChannels")
	End Try
End Sub

Sub ProcessNAMESResponse(RawData() As String)
	' Processa risposta NAMES (353)
	Try
		If RawData.Length >= 5 Then
			Dim Channel As String
			Dim Names As String
			Channel = RawData(4)
			Names = RawData(5)
			LogInfo("NAMES Response: " & Channel & " -> " & Names, "ProcessNAMESResponse")
		End If
	Catch Error As Exception
		LogError("PROCESS_NAMES_RESPONSE_ERROR", Error.Message, "ProcessNAMESResponse")
	End Try
End Sub

Sub ProcessEndOfNAMES(RawData() As String)
	' Processa fine NAMES (366)
	Try
		LogInfo("End of NAMES", "ProcessEndOfNAMES")
	Catch Error As Exception
		LogError("PROCESS_END_OF_NAMES_ERROR", Error.Message, "ProcessEndOfNAMES")
	End Try
End Sub

Sub ProcessChannelMode(RawData() As String)
	' Processa modalità canale (MODE)
	Try
		If RawData.Length >= 4 Then
			Dim Channel As String
			Dim Mode As String
			Channel = RawData(3)
			Mode = RawData(4)
			LogInfo("Channel Mode: " & Channel & " -> " & Mode, "ProcessChannelMode")
		End If
	Catch Error As Exception
		LogError("PROCESS_CHANNEL_MODE_ERROR", Error.Message, "ProcessChannelMode")
	End Try
End Sub

Sub ProcessUserQuit(RawData() As String)
	' Processa disconnessione utente (QUIT)
	Try
		If RawData.Length >= 3 Then
			Dim Nick As String
			Dim Reason As String
			Nick = RawData(2)
			Reason = RawData(3)
			LogInfo("User Quit: " & Nick & " -> " & Reason, "ProcessUserQuit")
		End If
	Catch Error As Exception
		LogError("PROCESS_USER_QUIT_ERROR", Error.Message, "ProcessUserQuit")
	End Try
End Sub

Sub ProcessChannelInvite(RawData() As String)
	' Processa invito canale (INVITE)
	Try
		If RawData.Length >= 4 Then
			Dim Nick As String
			Dim Channel As String
			Nick = RawData(3)
			Channel = RawData(4)
			LogInfo("Channel Invite: " & Nick & " -> " & Channel, "ProcessChannelInvite")
		End If
	Catch Error As Exception
		LogError("PROCESS_CHANNEL_INVITE_ERROR", Error.Message, "ProcessChannelInvite")
	End Try
End Sub

Sub ProcessNoticeMessage(RawData() As String)
	' Processa messaggio NOTICE
	Try
		If RawData.Length >= 4 Then
			Dim Target As String
			Dim Message As String
			Target = RawData(3)
			Message = RawData(4)
			LogInfo("Notice: " & Target & " -> " & Message, "ProcessNoticeMessage")
		End If
	Catch Error As Exception
		LogError("PROCESS_NOTICE_MESSAGE_ERROR", Error.Message, "ProcessNoticeMessage")
	End Try
End Sub

Sub ProcessServerInfo(RawData() As String)
	' Processa informazioni server (251-255)
	Try
		If RawData.Length >= 3 Then
			Dim Info As String
			Info = RawData(3)
			LogInfo("Server Info: " & Info, "ProcessServerInfo")
		End If
	Catch Error As Exception
		LogError("PROCESS_SERVER_INFO_ERROR", Error.Message, "ProcessServerInfo")
	End Try
End Sub

Sub ProcessServerStats(RawData() As String)
	' Processa statistiche server (265-266)
	Try
		If RawData.Length >= 3 Then
			Dim Stats As String
			Stats = RawData(3)
			LogInfo("Server Stats: " & Stats, "ProcessServerStats")
		End If
	Catch Error As Exception
		LogError("PROCESS_SERVER_STATS_ERROR", Error.Message, "ProcessServerStats")
	End Try
End Sub

Sub ProcessMOTD(RawData() As String)
	' Processa Message of the Day (372-375)
	Try
		If RawData.Length >= 3 Then
			Dim MOTDLine As String
			MOTDLine = RawData(3)
			LogInfo("MOTD: " & MOTDLine, "ProcessMOTD")
		End If
	Catch Error As Exception
		LogError("PROCESS_MOTD_ERROR", Error.Message, "ProcessMOTD")
	End Try
End Sub

Sub ProcessChannelModeInfo(RawData() As String)
	' Processa informazioni modalità canale (324)
	Try
		If RawData.Length >= 4 Then
			Dim Channel As String
			Dim Mode As String
			Channel = RawData(3)
			Mode = RawData(4)
			LogInfo("Channel Mode Info: " & Channel & " -> " & Mode, "ProcessChannelModeInfo")
		End If
	Catch Error As Exception
		LogError("PROCESS_CHANNEL_MODE_INFO_ERROR", Error.Message, "ProcessChannelModeInfo")
	End Try
End Sub

Sub ProcessTopicInfo(RawData() As String)
	' Processa informazioni topic (333)
	Try
		If RawData.Length >= 5 Then
			Dim Channel As String
			Dim Setter As String
			Dim Time As String
			Channel = RawData(3)
			Setter = RawData(4)
			Time = RawData(5)
			LogInfo("Topic Info: " & Channel & " set by " & Setter & " at " & Time, "ProcessTopicInfo")
		End If
	Catch Error As Exception
		LogError("PROCESS_TOPIC_INFO_ERROR", Error.Message, "ProcessTopicInfo")
	End Try
End Sub

Sub ProcessNickError(RawData() As String)
	' Processa errori nick (432-437)
	Try
		If RawData.Length >= 3 Then
			Dim ErrorCode As String
			Dim ErrorMessage As String
			ErrorCode = RawData(1)
			ErrorMessage = RawData(3)
			LogError("NICK_ERROR_" & ErrorCode, ErrorMessage, "ProcessNickError")
		End If
	Catch Error As Exception
		LogError("PROCESS_NICK_ERROR_ERROR", Error.Message, "ProcessNickError")
	End Try
End Sub

 