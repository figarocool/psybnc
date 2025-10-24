# Test del Supporto DCC in psyBNC

## Come Testare il Supporto DCC

### 1. Preparazione del Test

#### Prerequisiti
- psyBNC in esecuzione su dispositivo Android
- Client IRC (mIRC, HexChat, etc.) configurato per connettersi al bouncer
- Connessione di rete stabile

#### Configurazione Iniziale
1. Avviare psyBNC sul dispositivo Android
2. Notare l'IP del dispositivo mostrato nell'interfaccia
3. Configurare il client IRC per connettersi all'IP del dispositivo sulla porta configurata

### 2. Test di Connessione DCC

#### Verifica Stato DCC
```
/QUOTE DCCSTATUS
```
**Risposta attesa:**
```
DCC Status:
Active Connections: 0
Pending Files: 0
DCC Server Port: [porta casuale]
DCC Server IP: [IP del dispositivo]
```

#### Verifica File DCC
```
/QUOTE DCCFILES
```
**Risposta attesa:**
```
No pending DCC files.
```

### 3. Test Trasferimento File

#### Scenario 1: Ricezione File
1. **Da un altro utente IRC:**
   ```
   /dcc send [nickname] [filepath]
   ```

2. **psyBNC dovrebbe:**
   - Rilevare l'offerta DCC SEND
   - Salvare il file automaticamente
   - Inviare notifica:
   ```
   :-psyBNC NOTICE [nickname] :DCC file received: dcc_received_[timestamp].dat
   ```

3. **Verificare:**
   - File salvato nella directory interna dell'app
   - Notifica ricevuta nel client IRC

#### Scenario 2: Invio File
1. **Dal client connesso al bouncer:**
   ```
   /dcc send [nickname] [filepath]
   ```

2. **psyBNC dovrebbe:**
   - Inoltrare l'offerta DCC al server IRC
   - Gestire la connessione DCC
   - Permettere il trasferimento

### 4. Test Chat DCC

#### Scenario: Chat Diretta
1. **Offerta chat DCC:**
   ```
   /dcc chat [nickname]
   ```

2. **psyBNC dovrebbe:**
   - Gestire la connessione DCC CHAT
   - Inoltrare i messaggi tra i client
   - Mantenere la connessione attiva

### 5. Test Comandi Amministrativi

#### Test Help DCC
```
/QUOTE BHELP
```
**Dovrebbe includere:**
```
BHELP   DCCSTATUS       - Shows DCC connections status
BHELP   DCCFILES        - Lists pending DCC files
```

#### Test Stato DCC
```
/QUOTE DCCSTATUS
```
**Risposta attesa:**
```
DCC Status:
Active Connections: [numero]
Pending Files: [numero]
DCC Server Port: [porta]
DCC Server IP: [IP]
```

### 6. Test di Robustezza

#### Test Connessioni Multiple
1. Avviare più trasferimenti DCC simultanei
2. Verificare che psyBNC gestisca correttamente le connessioni multiple
3. Controllare che i file vengano salvati correttamente

#### Test Interruzioni
1. Interrompere un trasferimento DCC
2. Verificare che psyBNC pulisca le connessioni chiuse
3. Testare il comando DCC RESUME se supportato

#### Test Memoria
1. Eseguire molti trasferimenti DCC
2. Verificare che psyBNC non accumuli connessioni chiuse
3. Controllare la pulizia automatica delle connessioni

### 7. Debugging e Troubleshooting

#### Log di Debug
Per debug avanzato, monitorare:
- Connessioni DCC attive
- File ricevuti
- Errori di connessione
- Pulizia automatica

#### Problemi Comuni
1. **File non salvati**: Verificare permessi di scrittura
2. **Connessioni non chiuse**: Controllare pulizia automatica
3. **Porte bloccate**: Verificare configurazione firewall
4. **Notifiche mancanti**: Controllare parsing messaggi DCC

### 8. Esempi di Utilizzo Pratico

#### Esempio 1: Ricezione Documento
```
Utente A invia: /dcc send psybnc document.pdf
psyBNC riceve e salva: dcc_received_20241201_143022.dat
Notifica: :-psyBNC NOTICE psybnc :DCC file received: dcc_received_20241201_143022.dat
```

#### Esempio 2: Chat Privata
```
Utente A: /dcc chat psybnc
psyBNC: Gestisce connessione DCC CHAT
Chat diretta attiva tra i client
```

#### Esempio 3: Monitoraggio Stato
```
/QUOTE DCCSTATUS
Risposta:
DCC Status:
Active Connections: 2
Pending Files: 1
DCC Server Port: 12345
DCC Server IP: 192.168.1.100
```

### 9. Verifica Funzionalità

#### Checklist Funzionalità DCC
- [ ] Rilevamento messaggi DCC
- [ ] Gestione connessioni DCC
- [ ] Salvataggio file automatico
- [ ] Notifiche utente
- [ ] Comandi amministrativi
- [ ] Pulizia connessioni
- [ ] Supporto RESUME/ACCEPT
- [ ] Gestione chat DCC

#### Checklist Robustezza
- [ ] Connessioni multiple
- [ ] Gestione errori
- [ ] Pulizia memoria
- [ ] Reconnessione automatica
- [ ] Gestione timeout

### 10. Risultati Attesi

#### Funzionalità Base
- psyBNC rileva e gestisce messaggi DCC
- File vengono salvati automaticamente
- Notifiche vengono inviate all'utente
- Comandi amministrativi funzionano

#### Funzionalità Avanzate
- Supporto connessioni multiple
- Gestione chat DCC
- Pulizia automatica connessioni
- Monitoraggio stato in tempo reale

---

**Nota**: Questi test verificano l'implementazione completa del supporto DCC in psyBNC. Il sistema dovrebbe gestire tutti gli scenari descritti seguendo lo standard DCC IRC.
