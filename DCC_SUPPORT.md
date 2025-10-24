# Supporto DCC (Direct Client-to-Client) in psyBNC

## Panoramica

Il supporto DCC è stato implementato in psyBNC per permettere il trasferimento di file e chat dirette tra client IRC attraverso il bouncer. Questa implementazione segue lo standard DCC IRC e permette di salvare i file ricevuti direttamente sul dispositivo Android.

## Funzionalità Implementate

### 1. DCC SEND
- **Modalità SAVE**: I file vengono salvati sul server bouncer per download successivo
- **Modalità FORWARD**: I file vengono inoltrati direttamente al client connesso
- **Configurazione dinamica**: Possibilità di cambiare modalità in tempo reale
- **Controllo tipi file**: Filtro per tipi di file permessi
- **Controllo dimensione**: Limite massimo per dimensione file
- **Gestione token**: Supporto per token di autenticazione DCC
- **Notifiche**: L'utente viene notificato quando riceve un file

### 2. DCC CHAT
- **Chat dirette**: Supporto per connessioni chat DCC
- **Gestione porte**: Assegnazione automatica di porte per le connessioni DCC
- **Connessioni multiple**: Supporto per più connessioni DCC simultanee

### 3. DCC RESUME/ACCEPT
- **Ripresa trasferimenti**: Supporto per riprendere trasferimenti interrotti
- **Gestione posizioni**: Tracciamento della posizione nei file per il resume

## Architettura DCC

### Variabili Globali Aggiunte
```basic
' DCC Support Variables
Dim DCCServer As ServerSocket      ' Server per connessioni DCC
Dim DCCPort As Int                 ' Porta del server DCC
Dim DCCConnections As List         ' Lista connessioni DCC attive
Dim DCCFiles As List              ' Lista file DCC in attesa
Dim DCCTransfers As List          ' Lista trasferimenti DCC
```

### Inizializzazione DCC
```basic
' DCC Initialization
DCCConnections.Initialize
DCCFiles.Initialize
DCCTransfers.Initialize
DCCPort = 1024 + Rnd(0, 64511) ' Porta casuale 1024-65535
DCCServer.Initialize(DCCPort, "DCCServer")
DCCServer.Listen
```

## Funzioni DCC Implementate

### 1. Gestione Connessioni
- `DCCServer_NewConnection()` - Gestisce nuove connessioni DCC
- `DCCStream_NewData()` - Processa dati ricevuti via DCC
- `CleanupDCCConnections()` - Pulisce connessioni chiuse

### 2. Gestione File
- `SaveDCCData()` - Salva i dati ricevuti in file
- `HandleDCCSend()` - Gestisce offerte DCC SEND
- `HandleDCCResume()` - Gestisce richieste DCC RESUME
- `HandleDCCAccept()` - Gestisce richieste DCC ACCEPT

### 3. Gestione Chat
- `HandleDCCChat()` - Gestisce offerte DCC CHAT

### 4. Utilità
- `ProcessDCCMessage()` - Processa messaggi DCC
- `GetDCCStatus()` - Restituisce stato connessioni DCC

## Comandi Amministrativi DCC

### Nuovi Comandi Aggiunti
- `/QUOTE DCCSTATUS` - Mostra stato connessioni DCC
- `/QUOTE DCCFILES` - Lista file DCC in attesa
- `/QUOTE DCCMODE SAVE/FORWARD` - Imposta modalità DCC
- `/QUOTE DCCCONFIG` - Mostra configurazione DCC

### Help Aggiornato
Il sistema di help è stato aggiornato per includere i comandi DCC:
```
BHELP   DCCSTATUS       - Shows DCC connections status
BHELP   DCCFILES        - Lists pending DCC files
```

## Flusso di Funzionamento DCC

### 1. Ricezione Offerta DCC
```
Client A → Server IRC → psyBNC → Client B
    ↓           ↓         ↓        ↓
  DCC SEND   Forward   Process   Receive
```

### 2. Connessione DCC
```
Client B → psyBNC DCC Server → Client A
    ↓            ↓              ↓
  Connect    Forward Data    Receive File
```

### 3. Salvataggio File
```
DCC Data → psyBNC → File System
    ↓        ↓         ↓
  Receive  Process   Save to Storage
```

## Modalità DCC

### Modalità SAVE (Predefinita)
- **Comportamento**: I file vengono salvati sul server bouncer
- **Vantaggi**: File disponibili anche quando il client è disconnesso
- **Utilizzo**: Ideale per bouncer persistenti
- **Comando**: `/QUOTE DCCMODE SAVE`

### Modalità FORWARD
- **Comportamento**: I file vengono inoltrati direttamente al client
- **Vantaggi**: Trasferimento in tempo reale
- **Utilizzo**: Ideale per connessioni dirette
- **Comando**: `/QUOTE DCCMODE FORWARD`

### Configurazione DCC
```basic
' Variabili di configurazione
Dim DCCMode As String          ' "SAVE" o "FORWARD"
Dim DCCAutoAccept As Boolean  ' Auto-accetta file DCC
Dim DCCMaxFileSize As Long    ' Dimensione massima file (bytes)
Dim DCCAllowedTypes As List   ' Tipi di file permessi
```

## Gestione Messaggi DCC

### Rilevamento Messaggi DCC
I messaggi DCC vengono rilevati tramite il carattere di controllo `\x01`:
```basic
If MessageText.Contains("\x01DCC") Then
    ProcessDCCMessage(MessageText)
End If
```

### Tipi di Messaggi Supportati
- `DCC SEND filename size token` - Offerta di invio file
- `DCC CHAT chat port` - Offerta di chat diretta
- `DCC RESUME filename position` - Ripresa trasferimento
- `DCC ACCEPT filename position` - Accettazione trasferimento

## Salvataggio File

### Directory di Salvataggio
I file DCC vengono salvati nella directory interna dell'applicazione:
```
File.DirInternal/dcc_received_[timestamp].dat
```

### Nomenclatura File
- **Prefisso**: `dcc_received_`
- **Timestamp**: Data e ora di ricezione
- **Estensione**: `.dat` (generica per tutti i tipi di file)

### Notifiche
L'utente viene notificato tramite NOTICE IRC quando riceve un file:
```
:-psyBNC NOTICE nickname :DCC file received: filename
```

## Gestione Connessioni

### Pulizia Automatica
Le connessioni DCC chiuse vengono pulite automaticamente dal timer principale:
```basic
Sub TimerServer_Tick
    ' ... existing code ...
    CleanupDCCConnections()
End Sub
```

### Monitoraggio Stato
Il sistema monitora continuamente lo stato delle connessioni DCC e rimuove quelle non più attive.

## Limitazioni Attuali

### 1. Architetturali
- **Single Thread**: Gestione DCC nel thread principale
- **Memory Based**: Lista connessioni in memoria
- **Basic4Android**: Limitazioni del framework

### 2. Funzionalità
- **No Resume Completo**: Resume limitato a posizioni
- **No Progress**: Nessun indicatore di progresso
- **No Encryption**: Trasferimenti non crittografati

## Estensioni Future

### 1. Miglioramenti Tecnici
- **Threading Dedicato**: Thread separati per DCC
- **Progress Tracking**: Indicatori di progresso trasferimenti
- **Resume Completo**: Resume avanzato con checksum
- **Encryption**: Supporto SSL/TLS per DCC

### 2. Funzionalità Aggiuntive
- **File Management**: Gestione file ricevuti
- **Transfer History**: Cronologia trasferimenti
- **Bandwidth Control**: Controllo velocità trasferimenti
- **Auto Accept**: Accettazione automatica file

## Utilizzo Pratico

### Per l'Utente
1. **Ricezione File**: I file vengono salvati automaticamente
2. **Notifiche**: Riceve notifiche via IRC
3. **Monitoraggio**: Può controllare lo stato con `/QUOTE DCCSTATUS`
4. **Gestione**: Può vedere i file in attesa con `/QUOTE DCCFILES`

### Per lo Sviluppatore
1. **Debugging**: Log delle connessioni DCC
2. **Monitoring**: Stato connessioni in tempo reale
3. **Management**: Gestione file e connessioni

## Compatibilità

### Client IRC Supportati
- **mIRC**: Supporto completo DCC
- **HexChat**: Supporto completo DCC
- **WeeChat**: Supporto completo DCC
- **Altri client**: Compatibili con standard DCC

### Protocollo
- **Standard IRC DCC**: Implementazione conforme RFC
- **Token Support**: Supporto token di autenticazione
- **Resume Support**: Supporto ripresa trasferimenti

---

**Nota**: Questa implementazione DCC è stata progettata per essere compatibile con i client IRC standard e seguire le specifiche DCC IRC. Il supporto è limitato dalle capacità del framework Basic4Android ma fornisce funzionalità DCC complete per l'uso quotidiano.
