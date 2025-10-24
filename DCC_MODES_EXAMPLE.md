# Esempi di Utilizzo Modalità DCC in psyBNC

## Panoramica delle Modalità

psyBNC supporta due modalità per la gestione dei file DCC:

1. **SAVE** (Predefinita) - File salvati sul bouncer
2. **FORWARD** - File inoltrati direttamente al client

## Modalità SAVE (Salvataggio sul Bouncer)

### Quando Usare
- **Bouncer persistente**: Quando il client si disconnette frequentemente
- **Backup file**: Per mantenere una copia dei file ricevuti
- **Download differito**: Per scaricare i file quando si riconnette

### Comportamento
```
Client A → Server IRC → psyBNC → Salvataggio Locale
    ↓           ↓         ↓           ↓
  DCC SEND   Forward   Process    Save File
```

### Esempio di Utilizzo
```
/QUOTE DCCMODE SAVE
:-psyBNC PRIVMSG psyBNC DCC mode set to: SAVE

# Quando ricevi un file:
:-psyBNC NOTICE psybnc :DCC SEND offer received for: document.pdf (SAVE mode)
:-psyBNC NOTICE psybnc :DCC file received: dcc_received_20241201_143022.dat
```

### Vantaggi
- ✅ File disponibili anche offline
- ✅ Backup automatico dei file ricevuti
- ✅ Gestione centralizzata dei file
- ✅ Compatibile con bouncer tradizionali

## Modalità FORWARD (Inoltro Diretto)

### Quando Usare
- **Connessione stabile**: Quando il client rimane sempre connesso
- **Trasferimento immediato**: Per ricevere file in tempo reale
- **Risparmio spazio**: Per non occupare spazio sul bouncer

### Comportamento
```
Client A → Server IRC → psyBNC → Client B
    ↓           ↓         ↓        ↓
  DCC SEND   Forward   Process  Receive
```

### Esempio di Utilizzo
```
/QUOTE DCCMODE FORWARD
:-psyBNC PRIVMSG psyBNC DCC mode set to: FORWARD

# Quando ricevi un file:
:-psyBNC NOTICE psybnc :DCC SEND offer forwarded to client: document.pdf (FORWARD mode)
```

### Vantaggi
- ✅ Trasferimento in tempo reale
- ✅ Nessun utilizzo spazio bouncer
- ✅ Esperienza utente diretta
- ✅ Compatibile con client IRC standard

## Comandi di Configurazione

### Impostare Modalità DCC
```
/QUOTE DCCMODE SAVE      # Imposta modalità salvataggio
/QUOTE DCCMODE FORWARD   # Imposta modalità inoltro
```

### Visualizzare Configurazione
```
/QUOTE DCCCONFIG
```

**Risposta:**
```
DCC Configuration:
Mode: SAVE
Auto-Accept: False
Max File Size: 10485760 bytes
Allowed Types: txt, jpg, png, pdf, zip, doc, docx
DCC Server Port: 12345
```

### Monitorare Stato DCC
```
/QUOTE DCCSTATUS
```

**Risposta:**
```
DCC Status:
Active Connections: 2
Pending Files: 1
DCC Server Port: 12345
DCC Server IP: 192.168.1.100
```

### Lista File DCC
```
/QUOTE DCCFILES
```

**Risposta:**
```
Pending DCC Files:
1. document.pdf (1048576 bytes) [SAVE]
2. image.jpg (512000 bytes) [FORWARD]
```

## Scenari di Utilizzo

### Scenario 1: Bouncer Persistente
**Situazione**: Client si disconnette frequentemente, vuoi ricevere file anche offline

**Configurazione**:
```
/QUOTE DCCMODE SAVE
```

**Risultato**: I file vengono salvati sul bouncer e puoi scaricarli quando ti riconneti.

### Scenario 2: Trasferimento Immediato
**Situazione**: Client sempre connesso, vuoi ricevere file direttamente

**Configurazione**:
```
/QUOTE DCCMODE FORWARD
```

**Risultato**: I file vengono inoltrati direttamente al tuo client IRC.

### Scenario 3: Configurazione Mista
**Situazione**: Vuoi cambiare modalità in base alle circostanze

**Configurazione**:
```
# Per file importanti (salva sul bouncer)
/QUOTE DCCMODE SAVE

# Per file temporanei (inoltra direttamente)
/QUOTE DCCMODE FORWARD
```

## Controlli di Sicurezza

### Tipi di File Permessi
**Predefiniti**: txt, jpg, png, pdf, zip, doc, docx

**Comportamento**:
- File con estensioni non permesse vengono rifiutati
- Notifica: `DCC file type not allowed: filename.exe`

### Dimensione Massima File
**Predefinita**: 10MB (10485760 bytes)

**Comportamento**:
- File troppo grandi vengono rifiutati
- Notifica: `DCC file too large: filename (size bytes)`

## Esempi Pratici

### Esempio 1: Ricezione Documento (Modalità SAVE)
```
1. Utente invia: /dcc send psybnc document.pdf
2. psyBNC: Rileva DCC SEND in modalità SAVE
3. psyBNC: Salva file come dcc_received_20241201_143022.dat
4. Notifica: :-psyBNC NOTICE psybnc :DCC file received: dcc_received_20241201_143022.dat
5. File disponibile per download dal bouncer
```

### Esempio 2: Ricezione Immagine (Modalità FORWARD)
```
1. Utente invia: /dcc send psybnc image.jpg
2. psyBNC: Rileva DCC SEND in modalità FORWARD
3. psyBNC: Inoltra offerta al client connesso
4. Notifica: :-psyBNC NOTICE psybnc :DCC SEND offer forwarded to client: image.jpg (FORWARD mode)
5. Client riceve file direttamente
```

### Esempio 3: Cambio Modalità Dinamico
```
# Inizialmente in modalità SAVE
/QUOTE DCCMODE SAVE
/QUOTE DCCCONFIG
# Risposta: Mode: SAVE

# Cambio a modalità FORWARD
/QUOTE DCCMODE FORWARD
/QUOTE DCCCONFIG
# Risposta: Mode: FORWARD

# Verifica file in attesa
/QUOTE DCCFILES
# Mostra file con modalità corrente
```

## Troubleshooting

### Problema: File Non Ricevuti
**Causa**: Modalità non configurata correttamente
**Soluzione**: Verificare modalità con `/QUOTE DCCCONFIG`

### Problema: File Rifiutati
**Causa**: Tipo file non permesso o dimensione eccessiva
**Soluzione**: Controllare configurazione con `/QUOTE DCCCONFIG`

### Problema: Connessioni DCC Non Funzionano
**Causa**: Porte bloccate o configurazione di rete
**Soluzione**: Verificare stato con `/QUOTE DCCSTATUS`

## Best Practices

### Per Bouncer Persistente
1. Usa modalità **SAVE** per file importanti
2. Configura tipi file permessi appropriati
3. Imposta limite dimensione ragionevole
4. Monitora spazio disponibile

### Per Trasferimenti Diretti
1. Usa modalità **FORWARD** per file temporanei
2. Mantieni client connesso durante trasferimenti
3. Verifica connessione di rete stabile
4. Monitora connessioni DCC attive

---

**Nota**: Le modalità DCC possono essere cambiate in qualsiasi momento senza riavviare il bouncer. La configurazione viene applicata immediatamente ai nuovi trasferimenti DCC.
