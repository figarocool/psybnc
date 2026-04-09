# psyBNC - IRC Bouncer per Android

## Descrizione del Progetto

**psyBNC** è lo storico e potentissimo IRC Bouncer (proxy IRC) originariamente scritto in C, ora completamente portato e ottimizzato per **Android**.
Grazie all'uso di Android NDK, questa applicazione fa girare il vero e proprio cuore nativo (core) di psyBNC direttamente sul tuo smartphone o tablet, garantendo le stesse prestazioni, affidabilità e set di comandi di un server Linux tradizionale.

Questo porting Android include un'interfaccia grafica (UI) nativa e un servizio in background (Foreground Service) studiato per evitare che il sistema operativo uccida il processo, mantenendo così la tua presenza su IRC attiva 24/7 anche quando chiudi l'app.

*Nota: Questo repository contiene la nuova versione nativa C/Java. Se stai cercando la vecchia versione sperimentale scritta in Basic4Android (B4A), la trovi nel branch `b4a-legacy`.*

---

## Caratteristiche Principali del Porting Android

- **Core Nativo C (NDK)**: Non è un emulatore, è il vero codice sorgente di psyBNC compilato per processori ARM (arm64-v8a, armeabi-v7a) e x86.
- **Foreground Service con WakeLock**: Mantiene la connessione persistente in background sopravvivendo allo "swipe" dell'app e alle politiche di risparmio energetico di Android.
- **Gestione DNS Ottimizzata**: Il resolver integrato (`c-ares`) è stato patchato per comunicare correttamente con i DNS nativi di Android.
- **Supporto Storage Access Framework (SAF)**: Permette di scegliere comodamente qualsiasi cartella (inclusa la microSD) per salvare i file scaricati tramite DCC.
- **Notifiche Android**: Avvisi in tempo reale (anche a UI chiusa) al completamento dei download DCC.
- **Configurazione Intelligente**: Generazione automatica del `psybnc.conf` e delle regole `HOSTALLOWS` per permettere la connessione immediata in localhost o LAN.

## Funzionalità Storiche di psyBNC (tutte supportate!)

- **Gestione messaggi privati**: Salva e riproduce i messaggi privati ricevuti durante l'assenza
- **Gestione canali**: Mantiene la lista dei canali e dei topic
- **Supporto DCC completo**: Trasferimento file (DCC SEND/GET) e chat dirette
- **Multi-client e Multi-server**: Più client connessi simultaneamente e connessione a più server IRC
- **Sistema di performance**: Monitoraggio del traffico di rete e dei socket attivi
- **Gestione VHOST e PROXY**: Supporto virtual host e proxy
- **Comandi amministrativi**: Oltre 200 comandi interni (usando `/b` o `/QUOTE`) per la gestione completa del bouncer

## Come si usa l'App

1. **Avvia l'applicazione** e scegli la cartella dove vuoi che vengano salvati i download DCC.
2. **Scegli IP e Porta**: L'app ti mostrerà gli IP disponibili sul tuo dispositivo (es. localhost o l'IP della tua rete Wi-Fi).
3. **Premi "Avvia Server"**: psyBNC si avvierà in background e vedrai una notifica fissa nel menu a tendina di Android.
4. **Connettiti con un Client IRC** (es. AndroIRC, Revolution IRC, o dal PC se sei nella stessa rete LAN):
   - IP: Quello mostrato nell'app (es. `127.0.0.1`)
   - Porta: Quella scelta (es. `31337`)
   - Password: La prima password che invierai diventerà automaticamente quella dell'amministratore!
5. Usa il comando `/b help` dal tuo client IRC per vedere la lista di tutti i comandi disponibili.

## Comandi IRC Principali

Una volta connesso al bouncer, puoi impartire i comandi inviandoli direttamente a psyBNC:

- `/b addserver irc.server.com :porta` - Aggiunge un server IRC a cui connettersi
- `/b listservers` - Lista i server configurati
- `/b bhelp` - Mostra la guida interna completa
- `/b playprivatelog` - Legge i messaggi ricevuti mentre eri offline
- `/b dccstatus` - Mostra lo stato dei trasferimenti file in corso
- `/b sockstat` - Mostra le connessioni e i socket attivi

## Compilazione dal Sorgente

Se vuoi compilare il progetto da solo usando Android Studio:

1. Assicurati di avere installato l'**Android NDK** e **CMake** tramite l'SDK Manager di Android Studio.
2. Apri la cartella `android/` con Android Studio.
3. Il progetto usa Gradle per invocare `ndk-build`. Il codice C originale si trova nella cartella principale `src/`.
4. Compila l'APK come un normale progetto Android.

## Crediti e Licenza

**Porting Android realizzato da:**
8byte di Stefano Basile
Email: info@8byte.it
Web: https://8byte.it

**Licenza:**
Il codice sorgente originale di psyBNC e le modifiche apportate per questo porting Android sono rilasciate sotto licenza **GNU General Public License v2 (GPLv2)**. Consulta il file `COPYING` per i dettagli completi.
