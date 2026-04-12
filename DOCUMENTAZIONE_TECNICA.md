# Documentazione Tecnica - psyBNC Android (C/NDK)

## Panoramica del Sistema

psyBNC è un IRC Bouncer scritto in C, compilato tramite Android NDK e incapsulato in
un'applicazione Android nativa. Il sistema è composto da due layer distinti:

1. **Core nativo C** — il vero psyBNC originale, compilato per ARM/x86 tramite NDK
2. **Wrapper Android** (Java) — gestisce il lifecycle del processo nativo su Android

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Client IRC    │◄──►│   psyBNC (C)    │◄──►│   Server IRC    │
│  (mIRC, Hex...) │    │  processo nativo│    │  (qualsiasi)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              ▲
                              │ avvia / monitora
                       ┌──────┴──────┐
                       │ PsybncService│
                       │    (Java)    │
                       └─────────────┘
```

---

## 1. Core Nativo C

### Struttura sorgenti (`src/`)

| File | Ruolo |
|------|-------|
| `psybnc.c` | Entry point principale, loop eventi |
| `p_client.c` | Gestione connessioni client |
| `p_server.c` | Gestione connessioni server IRC |
| `p_socket.c` | Astrazione socket (TCP, IPv4/IPv6) |
| `p_network.c` | Gestione rete e routing |
| `p_parse.c` | Parsing messaggi IRC |
| `p_peer.c` | Gestione peer e linking tra bouncer |
| `p_link.c` | Protocollo di link psyBNC-psyBNC |
| `p_intnet.c` | IRCD interno (IntNet) |
| `p_uchannel.c` | Gestione canali utente |
| `p_userfile.c` | Persistenza configurazione utenti |
| `p_inifunc.c` | Parsing file `.conf` |
| `p_log.c` | Sistema di logging |
| `p_dcc.c` | Trasferimento file e chat DCC |
| `p_script.c` | Sistema di scripting |
| `p_blowfish.c` | Cifratura Blowfish |
| `p_idea.c` | Cifratura IDEA |
| `p_crypt.c` | Wrapper crittografia |
| `p_hash.c` | Tabelle hash interne |
| `p_memory.c` | Gestione memoria dinamica |
| `p_string.c` | Utility stringhe |
| `p_sysmsg.c` | Messaggi di sistema |
| `p_topology.c` | Topologia rete interna |
| `p_translate.c` | Modulo traduzione (BabelFish proxy) |
| `p_dns.c` | Wrapper DNS (c-ares) |
| `match.c` | Pattern matching wildcard |
| `snprintf.c` | Implementazione snprintf portabile |
| `bsd-setenv.c` | Compatibilità BSD setenv |
| `c-ares/` | Libreria DNS asincrona (resolver) |

### Funzionalità principali

- Multi-user (configurabile tramite `MAXUSER`)
- Multi-network: connessioni a più server IRC per utente
- SSL/TLS per connessioni client e server
- IPv6 nativo
- DCC SEND/GET/CHAT con modalità SAVE e FORWARD
- Blowfish e IDEA encryption per messaggi
- Sistema di scripting
- Linking tra istanze psyBNC (Partyline)
- IRCD interno (IntNet)
- Logging traffico, messaggi privati, connessioni
- Proxy SOCKS/Wingate
- Supporto VHOST
- Traduzione automatica messaggi (BabelFish)
- Oltre 200 comandi `/b` di amministrazione

### Compilazione NDK

La compilazione è controllata da `android/jni/Android.mk` e `android/jni/Application.mk`.

**Android.mk** — definisce modulo, flag e sorgenti:
```makefile
LOCAL_MODULE    := psybnc
LOCAL_CFLAGS    := -DHAVE_CONFIG -DHAVE_CONFIG_H -DANDROID -DIPV6 -std=gnu89
LOCAL_LDLIBS    := -llog -lm
```

**Application.mk** — definisce le ABI target:
- `arm64-v8a`
- `armeabi-v7a`
- `x86`
- `x86_64`

Il binario prodotto viene copiato in `android/app/src/main/assets/bin/<abi>/psybnc`
e in `android/app/src/main/jniLibs/<abi>/libpsybnc.so` dal task Gradle `copyPsybncAssets`.

### Variabili d'ambiente Android

Il wrapper Java passa le seguenti variabili all'ambiente del processo nativo:

| Variabile | Valore |
|-----------|--------|
| `PSYBNC_NOFORK` | `1` — disabilita il fork (richiesto su Android) |
| `PSYBNC_BASE_DIR` | Path della directory runtime (`getFilesDir()/runtime`) |
| `PSYBNC_CONFIG_FILE` | Path assoluto del `psybnc.conf` |
| `PSYBNC_DOWNLOAD_DIR` | Directory download DCC |
| `PSYBNC_LOG_FILE` | Path del file di log |
| `PSYBNC_PID_FILE` | Vuoto (nessun PID file su Android) |
| `HOME` | Uguale a `PSYBNC_BASE_DIR` |

---

## 2. Layer Android (Java)

### Componenti

#### `PsybncService.java` — Foreground Service
Gestisce l'intero lifecycle del processo nativo psyBNC:

- **`startServer()`** — prepara il runtime, estrae il binario, genera `psybnc.conf` se
  assente, avvia il `Process` nativo con `ProcessBuilder`
- **`stopServer()`** — distrugge il processo, invia `SIGKILL` ai processi residui,
  rilascia il WakeLock
- **`resetConfig()`** — ferma il server, cancella preferenze e directory runtime
- **`prepareRuntime()`** — crea la struttura di directory e copia gli asset (lang, scripts)
- **`extractBinary()`** — estrae il binario dalla `nativeLibraryDir` (priorità) o dagli
  assets APK, imposta il flag eseguibile
- **`writeConfig()`** — genera `psybnc.conf` con porta, host di bind e HOSTALLOWS per
  reti locali (127.x, 10.x, 192.168.x, 172.16–31.x, IPv6 ULA/link-local)
- **`startDownloadMonitor()`** — avvia un thread che monitora `psybnc.log` e invia
  notifiche Android al completamento dei download DCC
- **`updateState()`** — aggiorna SharedPreferences e notifica la UI tramite Broadcast

**WakeLock**: `PowerManager.PARTIAL_WAKE_LOCK` — mantiene la CPU attiva per la
connessione IRC persistente anche a schermo spento.

**Foreground Service**: richiede tipo `dataSync` (AndroidManifest), necessario per
Android 8+ (Oreo).

#### `MainActivity.java` — UI principale

- Configurazione porta (default `31337`, range 1024–65535)
- Scelta dell'indirizzo di bind tramite dialog (tutte le interfacce di rete disponibili,
  incluse IPv4 e IPv6)
- Selezione cartella download DCC (SAF + percorsi predefiniti interni/esterni)
- Abilitazione notifiche completamento download
- Reset configurazione completo
- Visualizzazione stato, IP corrente, ultimo log

### Struttura runtime su disco

```
getFilesDir()/runtime/
├── psybnc.conf          ← generato automaticamente al primo avvio
├── log/
│   └── psybnc.log       ← log nativo psyBNC
├── lang/
│   ├── english.lng      ← copiato dagli assets
│   └── italiano.lng     ← copiato dagli assets
├── scripts/
│   └── DEFAULT.SCRIPT   ← copiato dagli assets
└── bin/
    └── psybnc           ← binario nativo (fallback se nativeLibraryDir non disponibile)
```

### Configurazione generata (`psybnc.conf`)

```ini
PSYBNC.SYSTEM.PORT1=<porta>
PSYBNC.SYSTEM.HOST1=<bind_host>
PSYBNC.SYSTEM.ME=android-psybnc
PSYBNC.SYSTEM.LOGFILE=log/psybnc.log
PSYBNC.SYSTEM.LANGUAGE=english
PSYBNC.HOSTALLOWS.ENTRY0=127.*;*
PSYBNC.HOSTALLOWS.ENTRY1=10.*;*
PSYBNC.HOSTALLOWS.ENTRY2=192.168.*;*
... (RFC1918 + IPv6 ULA)
```

---

## 3. Sistema di Build

### Prerequisiti

- Android SDK (compileSdkVersion 35)
- Android NDK 26.1.10909125
- Java 17

### Processo di build completo

```
gradlew assembleDebug
    │
    ├── copyPsybncAssets
    │       │
    │       └── buildPsybncBinaries
    │               └── ndk-build (Android.mk)
    │                   → libs/<abi>/psybnc
    │
    ├── copia binari in assets/bin/<abi>/
    ├── copia binari in jniLibs/<abi>/libpsybnc.so
    ├── copia lang/*.lng in assets/lang/
    └── copia scripts/DEFAULT.SCRIPT in assets/scripts/
```

### Comandi

```bash
# Build debug (da android/)
./gradlew assembleDebug

# Build release
./gradlew assembleRelease

# Solo binari nativi
ndk-build
```

---

## 4. Permessi Android

| Permesso | Scopo |
|----------|-------|
| `INTERNET` | Connessioni IRC |
| `FOREGROUND_SERVICE` | Servizio in foreground |
| `FOREGROUND_SERVICE_DATA_SYNC` | Tipo servizio (Android 14+) |
| `POST_NOTIFICATIONS` | Notifiche download DCC (Android 13+) |
| `WAKE_LOCK` | Mantenere connessione attiva |
| `READ/WRITE_EXTERNAL_STORAGE` | Accesso storage (Android ≤ 12) |
| `MANAGE_EXTERNAL_STORAGE` | Accesso storage completo (Android 11+) |

---

## 5. Gestione DCC su Android

Il DCC è gestito interamente dal codice C nativo (`p_dcc.c`). Il layer Java:

1. Imposta `PSYBNC_DOWNLOAD_DIR` prima di avviare il processo
2. Monitora `psybnc.log` (tramite `RandomAccessFile` tail-like) cercando righe
   del tipo `File <nome> from <nick> received.`
3. Invia una notifica Android con il nome del file e la cartella di destinazione

La cartella download è configurabile dall'utente tramite:
- SAF (`ACTION_OPEN_DOCUMENT_TREE`) per qualsiasi cartella inclusa microSD
- Percorsi predefiniti interni/esterni (`getFilesDir()`, `getExternalFilesDir()`)
