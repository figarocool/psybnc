# Documentazione Tecnica - psyBNC

## Analisi Architetturale

### Panoramica del Sistema

psyBNC è un IRC Bouncer implementato in Basic4Android (B4A) che funziona come proxy tra client IRC e server IRC. Il sistema è composto da due componenti principali:

1. **Server Bouncer** (`psy.bas`) - Service Android che mantiene connessioni persistenti
2. **Client di Test** (`irc connect/`) - Applicazione di esempio per testare connessioni IRC

### Architettura a Livelli

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Client IRC    │◄──►│   psyBNC        │◄──►│   Server IRC    │
│   (mIRC, etc.)  │    │   (Android)     │    │   (es. irc.freenode.net)│
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Analisi del Codice Sorgente

### 1. Service Principal (psy.bas)

#### Variabili Globali
```basic
' Gestione Socket
Dim server As ServerSocket
Dim socket_ricezione_dati As Socket    ' Client → Bouncer
Dim socket_invio_dati As Socket       ' Bouncer → IRC Server

' Gestione Stream
Dim datisocket_ricezione As AsyncStreams
Dim datisocket_ricezione_irc As AsyncStreams

' Stato Connessione
Dim statesocket As Boolean
Dim IRClient As Boolean
Dim joinpasswd As Boolean

' Configurazione
Dim serverPort As String
Dim MyIP As String

' Gestione Canali e Messaggi
Dim joinchannel As List
Dim Topichannel As List
Dim MessageQuery As List

' Gestione Nick
Dim Nickconnessione As String
Dim AwayNick As String
Dim NormalNick As String

' Timer
Dim Timerserver As Timer
Dim PingTimer As Timer
```

#### Funzioni Principali

##### Gestione Connessioni
- `Server_NewConnection()` - Gestisce nuove connessioni client
- `socket_invio_dati_Connected()` - Gestisce connessione al server IRC
- `TimerServer_Tick()` - Monitora e ripristina connessioni

##### Parsing IRC
- `Ricezione_Server()` - Parsing completo dei messaggi IRC dal server
- `ClientInvio()` - Gestione comandi dal client
- `WriteSocket()` / `WriteSocketIrc()` - Invio dati ai socket

##### Gestione Dati
- `ReadFile()` / `WriteFile()` - I/O file di configurazione
- `SaveTopic()` - Salvataggio topic dei canali
- `GeneraDAtaUnix()` - Generazione timestamp Unix

### 2. Activity Principal (main.bas)

#### Interfaccia Utente
```basic
' Controlli UI
Dim Button1 As Button      ' Avvia servizio
Dim Button2 As Button       ' Aggiorna IP
Dim EditText1 As EditText   ' Porta server
Dim EditText2 As EditText   ' IP dispositivo
Dim TimerIP As Timer       ' Timer per IP
```

#### Funzionalità
- **Configurazione WiFi**: Disattivazione sleep policy WiFi
- **Gestione Servizio**: Avvio/controllo del service bouncer
- **Visualizzazione IP**: Mostra l'IP del dispositivo per connessioni client

### 3. Client di Test (irc connect/)

#### Implementazione IRC Base
```basic
' Connessione IRC
Sub Button_Click
    socket_invio_dati.Initialize("socket_invio_dati")
    socket_invio_dati.Connect("irc.azzurra.org","6667",0)
End Sub

' Gestione PING/PONG
Sub datisocket_ricezione_irc_NewData (buffer() As Byte)
    If PingString(0) = "PING " Then
        tw.WriteLine("PONG "&PingString(1)&Chr(13))
    End If
End Sub
```

## Protocollo IRC Implementato

### Comandi Supportati

#### Dal Client al Bouncer
- `CAP LS` - Capabilities negotiation
- `NICK nickname` - Impostazione nickname
- `USER user host * :realname` - Informazioni utente
- `PASS password` - Autenticazione bouncer
- `QUIT :message` - Disconnessione (mantiene bouncer attivo)

#### Dal Server IRC
- `PING` / `PONG` - Keep-alive
- `001` - Welcome message
- `376` - End of MOTD
- `433` - Nickname in use
- `PRIVMSG` - Messaggi privati
- `JOIN` / `PART` - Gestione canali
- `TOPIC` - Gestione topic
- `NICK` - Cambio nickname
- `KICK` - Rimozione da canale

### Gestione Messaggi Privati

```basic
' Salvataggio messaggi privati
If NumeroRaw(1) = "PRIVMSG" AND joinpasswd = False Then
    Dim TildeChan As String 
    TildeChan = NumeroRaw(2).SubString2(0,1)
    If TildeChan <> "#" AND TildeChan <> "&" Then
        ' Salva messaggio privato
        MessageQuery.AddAll(Array As String(RealDate&" :("&SoloVhost(1)&")"& " " &MessageText))
    End If
End If
```

## Gestione dello Stato

### Stati del Sistema

1. **Inizializzazione**
   - Creazione socket server
   - Configurazione timer
   - Inizializzazione liste

2. **Connessione Client**
   - Autenticazione richiesta
   - Configurazione server IRC
   - Stabilimento connessione IRC

3. **Operativo**
   - Proxy bidirezionale
   - Gestione messaggi
   - Mantenimento stato

4. **Disconnessione Client**
   - Mantenimento connessione IRC
   - Salvataggio stato
   - Gestione nick away

### Persistenza Dati

#### File di Configurazione (`psybnc.conf`)
```
Linea 1: USER user host * :realname
Linea 2: PASSWD password
Linea 3: server hostname:port
```

#### Strutture Dati in Memoria
- `joinchannel` - Lista canali attivi
- `Topichannel` - Topic dei canali
- `MessageQuery` - Messaggi privati in attesa

## Gestione Errori e Reconnessione

### Timer di Monitoraggio
```basic
Sub TimerServer_Tick
    ' Verifica connessione server IRC
    If socket_invio_dati.Connected = False Then
        ' Ripristina connessione
        socket_invio_dati.Connect(StringConnection(0), StringConnection(1), 1000)
    End If
End Sub
```

### Gestione PING/PONG
```basic
Sub PingTimer_Tick
    If AutoPing = True Then
        WriteSocketIrc("PING :TIMEOUTCHECK"&Chr(10))
        AutoPing = False
    End If
End Sub
```

## Configurazione Android

### AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

<service android:name=".psy"/>
```

### Configurazioni Specifiche
- **Min SDK**: 4 (Android 1.6)
- **Target SDK**: 14
- **Orientamento**: Non specificato
- **Installazione**: Solo memoria interna

## Modalità DCC Implementate

### Modalità SAVE (Predefinita)
- **Comportamento**: File salvati sul bouncer per download successivo
- **Vantaggi**: File disponibili anche offline, backup automatico
- **Utilizzo**: Ideale per bouncer persistenti
- **Implementazione**: `HandleDCCSave()` con salvataggio locale

### Modalità FORWARD
- **Comportamento**: File inoltrati direttamente al client connesso
- **Vantaggi**: Trasferimento in tempo reale, nessun utilizzo spazio
- **Utilizzo**: Ideale per connessioni dirette
- **Implementazione**: `HandleDCCForward()` con inoltro diretto

### Configurazione DCC
```basic
' Variabili di configurazione DCC
Dim DCCMode As String          ' "SAVE" o "FORWARD"
Dim DCCAutoAccept As Boolean  ' Auto-accetta file DCC
Dim DCCMaxFileSize As Long    ' Dimensione massima file (bytes)
Dim DCCAllowedTypes As List   ' Tipi di file permessi
```

### Controlli di Sicurezza
- **Filtro tipi file**: Solo estensioni permesse
- **Controllo dimensioni**: Limite massimo configurabile
- **Validazione input**: Controllo parametri DCC

## Limitazioni Tecniche

### Architetturali
- **Single Client**: Un solo client alla volta
- **Single Server**: Un server IRC per sessione
- **Memory Based**: Dati in memoria (non persistenti)
- **Basic4Android**: Limitazioni del framework

### Performance
- **Threading**: Gestione asincrona tramite AsyncStreams
- **Memory**: Gestione manuale delle liste
- **Network**: Socket TCP standard

### Sicurezza
- **Autenticazione**: Password in chiaro
- **Crittografia**: Non implementata
- **Validazione**: Input limitato

## Estensioni Possibili

### Funzionalità Aggiuntive
1. **Multi-client**: Supporto connessioni multiple
2. **Multi-server**: Connessioni a più server IRC
3. **Persistenza**: Database per messaggi e configurazioni
4. **Crittografia**: SSL/TLS per connessioni sicure
5. **Web Interface**: Interfaccia web per gestione

### Miglioramenti Tecnici
1. **Threading**: Gestione thread dedicati
2. **Memory Management**: Gestione memoria ottimizzata
3. **Error Handling**: Gestione errori robusta
4. **Logging**: Sistema di log completo
5. **Configuration**: File di configurazione avanzato

## Conclusioni

psyBNC rappresenta un'implementazione funzionale di IRC Bouncer per Android, dimostrando la fattibilità di soluzioni proxy IRC su dispositivi mobili. L'architettura modulare e l'uso di Basic4Android rendono il progetto accessibile per sviluppatori con background Basic/VB.

Le limitazioni attuali (single client, gestione memoria manuale, autenticazione semplice) rappresentano aree di miglioramento per versioni future, ma il core funzionale è solido e dimostra i concetti fondamentali di un IRC Bouncer.

---

**Nota Tecnica**: Questo progetto utilizza Basic4Android (B4A), un framework che compila codice Basic in Java per Android. Il codice generato è visibile nella directory `Objects/src/` e rappresenta la traduzione automatica del codice Basic in Java.
