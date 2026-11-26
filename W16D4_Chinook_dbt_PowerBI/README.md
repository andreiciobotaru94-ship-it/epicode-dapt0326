# W16D4 – Chinook con dbt e Power BI

In questo progetto ho lavorato sul database di un negozio di musica (Chinook): prima ho pulito e preparato i dati con dbt, poi ho costruito un report in Power BI.

## Cosa c'è nella cartella
- `dbt/` il progetto dbt (modelli staging, tabella dei fatti, test)
- `Chinook_tabelle.xlsx` le tabelle del database in Excel, usate come fonte in Power BI
- `Chinook_Report.pbix` il report Power BI (4 pagine)
- `python_visual/` gli script Python per i grafici e le loro anteprime

## Cosa ho fatto
**dbt:** ho creato 4 modelli staging (clienti, fatture, righe fattura, brani) che rendono i dati più puliti, e una tabella `fct_vendite` che unisce righe e fatture. Ho aggiunto dei test (valori unici, non nulli, relazioni tra tabelle e un controllo che il totale della fattura sia uguale alla somma delle righe). Risultato: 5 modelli creati e 16 test passati.

**Power BI:** ho importato i dati, creato le tabelle Vendite, Clienti, Brani e Calendario e le ho collegate (schema a stella). Poi ho scritto le misure DAX (totale vendite, numero fatture, ticket medio, confronto con l'anno prima, ecc.) e costruito 4 pagine: Panoramica, Analisi vendite, Analisi clienti, Documentazione.

## Risultati principali
- Vendite totali: 2.328,60 $ su 412 fatture
- Ticket medio: 5,65 $
- Clienti: 59
- Il paese che vende di più sono gli USA e il genere più venduto è il Rock

## Risposte alle domande
**Cos'è dbt e a cosa serve?**
dbt è uno strumento che permette di trasformare i dati direttamente dentro il database usando solo SQL. Invece di avere tante query sparse, ho dei modelli ordinati: ognuno è un file SQL che parte da un altro con `ref()`. Così il lavoro è più pulito, si può ripetere e si possono fare dei test sui dati.

**Che differenza c'è tra staging e mart?**
Gli staging sono il primo passaggio: prendo le tabelle originali e le sistemo (nomi chiari, valori mancanti gestiti, calcolo dell'importo). Il mart invece è la tabella finale già pronta per l'analisi, in questo caso `fct_vendite`, che unisce righe fattura e fatture.

**A cosa servono i test in dbt?**
Servono a controllare che i dati siano giusti: per esempio che gli id non siano ripetuti o vuoti, che ogni riga fattura abbia una fattura collegata e che il totale della fattura corrisponda alla somma delle righe. Se qualcosa non va, il test fallisce e me ne accorgo subito.

**Cos'è Power BI Service e che differenza c'è con Power BI Desktop?**
Power BI Desktop è il programma che uso sul PC per costruire il report (importare dati, modello, DAX, grafici). Power BI Service è la versione online: lì pubblico il report, lo condivido con altre persone, imposto l'aggiornamento automatico dei dati e posso creare dashboard.

**Perché ho usato uno schema a stella?**
Perché ho una tabella centrale con i numeri (Vendite) e intorno le tabelle descrittive (Clienti, Brani, Calendario). È più semplice, più veloce e i filtri funzionano meglio, e le misure DAX danno risultati corretti.

**Note**
I grafici Python sono nella pagina "Visual Python" del report (vendite mensili, vendite per genere, vendite per paese, confronto anno per anno). Per vederli servono Python 3.13 con `pandas` e `matplotlib` (`pip install pandas matplotlib`) e Python selezionato in Opzioni > Script Python. Gli script sono anche in `python_visual/`, con le anteprime dei grafici.
