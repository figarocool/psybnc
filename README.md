# psyBNC - IRC Bouncer per Android

## Descrizione del Progetto

**psyBNC** è un IRC Bouncer (proxy IRC) sviluppato in Basic4Android (B4A) che permette di mantenere una connessione persistente ai server IRC anche quando il client non è attivo. Il progetto include sia il server bouncer che un client di esempio per testare le connessioni IRC.

## Caratteristiche Principali

### Server Bouncer (psy.bas)
- **Connessione persistente**: Mantiene la connessione al server IRC anche quando il client si disconnette
- **Gestione messaggi privati**: Salva e riproduce i messaggi privati ricevuti durante l'assenza
- **Gestione canali**: Mantiene la lista dei canali e dei topic
- **Sistema di autenticazione**: Password per l'accesso al bouncer
- **Gestione nick alternativi**: Supporto per nick "away" quando l'utente è offline
- **Supporto DCC completo**: Trasferimento file e chat dirette
- **Comandi amministrativi**: Comandi per gestire server, messaggi e configurazioni

### Client di Esempio (irc connect/)
- **Connessione IRC base**: Esempio di client IRC per testare le connessioni
- **Gestione PING/PONG**: Implementazione del protocollo IRC standard
- **Interfaccia semplice**: UI per testare la connessione ai server IRC

## Architettura del Sistema

### Componenti Principali

1. **Service (psy.bas)**: Il core del bouncer che gestisce:
   - Connessioni socket in entrata (client)
   - Connessioni socket in uscita (server IRC)
   - Parsing dei comandi IRC
   - Gestione dello stato delle connessioni

2. **Activity (main.bas)**: Interfaccia utente per:
   - Configurazione della porta del server
   - Visualizzazione dell'IP del dispositivo
   - Controllo del servizio bouncer

3. **Client di Test**: Applicazione separata per testare le connessioni IRC

### Flusso di Funzionamento

```
Client IRC → psyBNC Server → Server IRC
     ↓              ↓            ↓
  Disconnesso    Persistente   Sempre connesso
```

## Comandi Supportati

### Comandi Amministrativi
- `/QUOTE ADDSERVER hostname:port` - Aggiunge un server IRC
- `/QUOTE LISTSERVERS` - Lista i server configurati
- `/QUOTE DELSERVER 1` - Rimuove un server
- `/QUOTE SETAWAYNICK nick` - Imposta il nick quando offline
- `/QUOTE PLAYPRIVATELOG` - Riproduce i messaggi privati
- `/QUOTE ERASEPRIVATELOG` - Cancella i messaggi privati
- `/QUOTE DCCSTATUS` - Mostra stato connessioni DCC
- `/QUOTE DCCFILES` - Lista file DCC in attesa
- `/QUOTE DCCMODE SAVE/FORWARD` - Imposta modalità DCC
- `/QUOTE DCCCONFIG` - Mostra configurazione DCC
- `/QUOTE BHELP` - Mostra l'help

### Gestione Connessioni
- **PASS password** - Autenticazione al bouncer
- **NICK nickname** - Imposta il nickname
- **USER user host * :realname** - Informazioni utente
- **QUIT :message** - Disconnessione (mantiene il bouncer attivo)

### Supporto DCC
- **DCC SEND** - Trasferimento file con due modalità:
  - **SAVE**: File salvati sul bouncer per download successivo
  - **FORWARD**: File inoltrati direttamente al client
- **DCC CHAT** - Chat dirette tra client
- **DCC RESUME** - Ripresa trasferimenti interrotti
- **Configurazione dinamica** - Cambio modalità in tempo reale
- **Controllo sicurezza** - Filtro tipi file e dimensioni
- **Notifiche** - Avvisi per file ricevuti

## Configurazione

### File di Configurazione
Il sistema utilizza un file `psybnc.conf` per memorizzare:
- Informazioni di autenticazione
- Lista dei server IRC
- Configurazioni utente

### Permessi Android
- `INTERNET` - Connessioni di rete
- `ACCESS_NETWORK_STATE` - Stato della rete
- `CHANGE_WIFI_STATE` - Gestione WiFi
- `ACCESS_WIFI_STATE` - Stato WiFi
- `WRITE_EXTERNAL_STORAGE` - Scrittura file

## Tecnologie Utilizzate

- **Basic4Android (B4A)** - Framework di sviluppo
- **Java** - Codice generato per Android
- **Socket TCP** - Comunicazione di rete
- **AsyncStreams** - Gestione asincrona dei dati
- **Timer** - Gestione temporizzata delle connessioni

## Struttura del Progetto

```
psybnc/
├── psy.bas                    # Service principale del bouncer (con supporto DCC)
├── psybnc.b4a                 # File progetto principale
├── Files/
│   └── frmprincipale.bal      # Layout interfaccia principale
├── irc connect/               # Client di esempio
│   ├── main.bal              # Layout client
│   └── ircExemple.b4a        # Progetto client
├── Objects/                   # File compilati Android
│   ├── AndroidManifest.xml   # Manifesto Android
│   └── src/                  # Codice Java generato
├── utility/
│   └── wirc507s.exe          # Utility aggiuntive
├── README.md                  # Documentazione principale
├── DOCUMENTAZIONE_TECNICA.md  # Analisi tecnica dettagliata
└── DCC_SUPPORT.md            # Documentazione supporto DCC
```

## Installazione e Utilizzo

### Prerequisiti
- Basic4Android (B4A) per la compilazione
- Dispositivo Android con API level 4+
- Connessione di rete

### Compilazione
1. Aprire il progetto in B4A
2. Configurare le librerie necessarie
3. Compilare per Android

### Configurazione Iniziale
1. Avviare l'applicazione
2. Impostare la porta del server bouncer
3. Avviare il servizio
4. Connettersi con un client IRC all'IP del dispositivo

### Utilizzo
1. Connettersi al bouncer con un client IRC
2. Autenticarsi con `/QUOTE PASS password`
3. Aggiungere server IRC con `/QUOTE ADDSERVER server:port`
4. Il bouncer manterrà la connessione anche se il client si disconnette

## Limitazioni e Note

- **Versione**: 0.1 (prototipo)
- **Linguaggio**: Basic4Android (B4A)
- **Target**: Android 1.6+ (API 4)
- **Connessioni**: Supporta una connessione client alla volta
- **Server IRC**: Un server IRC per sessione

## Sviluppo e Contributi

Questo progetto rappresenta un prototipo di IRC Bouncer per Android. Per contribuire o segnalare problemi, si prega di:

1. Analizzare il codice sorgente
2. Identificare aree di miglioramento
3. Proporre soluzioni compatibili con B4A

## Licenza

Progetto di esempio per scopi educativi e di ricerca.

---

**Nota**: Questo progetto utilizza Basic4Android, un framework di sviluppo per Android che genera codice Java. Il codice sorgente principale è in formato .bas (Basic) e viene compilato in Java per l'esecuzione su Android.
