# ToysGroup · Esercitazione finale · Modulo 4

Analisi dei dati di vendita di ToysGroup, un'azienda che distribuisce giocattoli tramite una rete di rivenditori in vari paesi europei. Tutto il lavoro è nel notebook `Esercitazione_finale_ToysGroup.ipynb`.

## Dati

| File | Cosa contiene |
|---|---|
| `products.csv` | i 12 prodotti (ProductID, ProductName, Category, ListPrice) |
| `regions.xlsx` | i 9 stati e la regione di vendita (RegionID, State, SalesRegion) |
| `sales.json` | 2.000 vendite, con alcuni valori mancanti in Quantity e SalesAmount |
| `resellers.csv` | 300 rivenditori, con la colonna Churn (1 = non riordina da oltre 6 mesi) |

## Cosa c'è nel notebook

- **Task 1**: Python di base (liste, dizionari, set, cicli, funzioni)
- **Task 2**: lettura e ispezione dei dati con Pandas e NumPy
- **Task 3a, 3b, 3c**: valori mancanti, filtri, merge, groupby, concat, serie temporali
- **Task 4**: grafici con Matplotlib, Seaborn e Plotly
- **Task 5**: correlazione e regressione lineare del fatturato mensile
- **Task 6a**: previsione del churn con la regressione logistica
- **Task 6b**: segmentazione dei rivenditori con K-Means
- **Task 7**: correzione di 4 pezzi di codice con un assistente AI

## Risultati principali

- Il fatturato cresce del 21% nel 2025 e il picco è a maggio 2025.
- La categoria che fattura di più è Outdoor; lo stato che fattura di più è l'Austria.
- Il churn è legato soprattutto ai giorni dall'ultimo ordine.
- Con la soglia 0,3 il modello trova circa il 71% dei rivenditori che poi se ne vanno.
- K-Means divide i rivenditori in 4 segmenti; quello "A rischio" ha il 51% di churn.

## Come eseguirlo

1. Metti il notebook e i quattro file di dati nella stessa cartella.
2. Apri il notebook con JupyterLab (da Anaconda Navigator).
3. Menu *Kernel → Restart Kernel and Run All Cells*.

Servono pandas, numpy, matplotlib, seaborn, plotly, scikit-learn e openpyxl.

## Commit

1. Aggiungo i file di dati e il README
2. Aggiungo il notebook con i Task 1-4
3. Completo il notebook con i Task 5-7
