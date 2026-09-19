
--  PROGETTO FINALE SQL - ToysGroup
--  In questo file ci sono tutte le query del progetto, numerate
--  come gli esercizi della traccia. Prima di ogni query scrivo
--  a cosa serve e cosa voglio tirare fuori.
--  Lo schema ER e lo schema logico li ho fatti su diagrams.net.

--  TASK 1a - Schema concettuale (vedi file Task1a concettuale)

--  Ho individuato 3 entità:
--    Product -> chiave ProductID, poi ProductCode, ProductName, Category
--    Region  -> chiave RegionID, poi State, SalesRegion
--    Sales   -> chiave SalesID, poi SalesDate, Quantity, SalesAmount
--  Le relazioni sono tutte 1:N verso Sales:
--    un prodotto può avere tante vendite (o zero), una vendita ha un solo prodotto
--    una regione può avere tante vendite (o zero), una vendita ha una sola regione
--  Le gerarchie le ho messe dentro le entità:
--    Category sta in Product (AUTO-01 e AUTO-02 sono Auto)
--    State sta in Region (Italia e Spagna sono Sud)

--  TASK 1b - Schema logico (vedi file Task1b_schema_logico)
--  Product
--    ProductID    INT           PK
--    ProductCode  VARCHAR(20)   attributo, univoco
--    ProductName  VARCHAR(100)  attributo
--    Category     VARCHAR(50)   attributo
--  Region
--    RegionID     INT           PK
--    State        VARCHAR(50)   attributo, univoco
--    SalesRegion  VARCHAR(50)   attributo
--  Sales
--    SalesID      INT           PK
--    ProductID    INT           FK verso Product (N:1)
--    RegionID     INT           FK verso Region (N:1)
--    SalesDate    DATE          attributo
--    Quantity     INT           attributo
--    SalesAmount  DECIMAL(10,2) attributo
--  La categoria sta solo in Product e la regione solo in Region,
--  in Sales tengo solo le due chiavi esterne. Così niente ridondanza.

--  TASK 2 - Creo le tabelle

-- Creo il database da zero
DROP DATABASE IF EXISTS ToysGroup;
CREATE DATABASE ToysGroup;
USE ToysGroup;

--  Product. Metto UNIQUE sul codice così non posso inserire due volte lo stesso prodotto
CREATE TABLE Product (
    ProductID   INT          NOT NULL AUTO_INCREMENT,
    ProductCode VARCHAR(20)  NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Category    VARCHAR(50)  NOT NULL,
    PRIMARY KEY (ProductID),
    UNIQUE KEY uq_product_code (ProductCode)
);

-- Region. Stesso discorso, uno stato non può comparire due volte
CREATE TABLE Region (
    RegionID    INT         NOT NULL AUTO_INCREMENT,
    State       VARCHAR(50) NOT NULL,
    SalesRegion VARCHAR(50) NOT NULL,
    PRIMARY KEY (RegionID),
    UNIQUE KEY uq_region_state (State)
);

--  Sales. Una riga per transazione, con le due FK verso Product e Region.
--     PK e FK sono tutte INT, quindi stesso tipo come chiede la traccia
CREATE TABLE Sales (
    SalesID     INT           NOT NULL AUTO_INCREMENT,
    ProductID   INT           NOT NULL,
    RegionID    INT           NOT NULL,
    SalesDate   DATE          NOT NULL,
    Quantity    INT           NOT NULL,
    SalesAmount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (SalesID),
    CONSTRAINT fk_sales_product FOREIGN KEY (ProductID) REFERENCES Product (ProductID),
    CONSTRAINT fk_sales_region  FOREIGN KEY (RegionID)  REFERENCES Region  (RegionID)
);

--  TASK 3 - Inserisco i dati
--  6 prodotti su 3 categorie. PALLA-01 lo lascio apposta senza vendite,
--     mi serve dopo per la query sugli invenduti
INSERT INTO Product (ProductCode, ProductName, Category) VALUES
    ('AUTO-01',  'Macchinina rossa',    'Auto'),
    ('AUTO-02',  'Macchinina blu',      'Auto'),
    ('BAMB-01',  'Bambola piccola',     'Bambole'),
    ('BAMB-02',  'Bambola grande',      'Bambole'),
    ('PALLA-01', 'Pallone da calcio',   'Palloni'),
    ('PALLA-02', 'Pallone da basket',   'Palloni');

--  4 stati su 3 regioni di vendita
INSERT INTO Region (State, SalesRegion) VALUES
    ('Italia',    'Sud'),
    ('Spagna',    'Sud'),
    ('Germania',  'Nord'),
    ('Messico',   'America');

--  14 vendite spalmate su 2024, 2025 e 2026 così posso confrontare gli anni.
--     Uso solo ProductID e RegionID che esistono davvero nelle altre tabelle
INSERT INTO Sales (ProductID, RegionID, SalesDate, Quantity, SalesAmount) VALUES
    (1, 1, '2024-03-15',  3, 450.00),
    (2, 2, '2024-06-20',  2, 600.00),
    (3, 3, '2024-09-05', 10, 250.00),
    (1, 4, '2024-11-30',  4, 620.00),
    (4, 1, '2025-01-10',  5, 200.00),
    (2, 3, '2025-04-22',  3, 930.00),
    (6, 2, '2025-07-18',  8, 160.00),
    (3, 4, '2025-10-02', 12, 300.00),
    (1, 2, '2026-02-14',  6, 900.00),
    (4, 3, '2026-03-30',  7, 280.00),
    (6, 1, '2026-05-12',  4,  80.00),
    (2, 4, '2026-08-25',  1, 320.00),
    (3, 1, '2026-09-01', 15, 375.00),
    (1, 3, '2026-09-05',  2, 300.00);

--  Controllo che sia entrato tutto
SELECT * FROM Product;
SELECT * FROM Region;
SELECT * FROM Sales;

--  TASK 4a - Integrità e JOIN

-- 4a Controllo che le PK siano univoche. Confronto il conteggio delle righe
--      con il conteggio dei valori distinti della chiave: se sono uguali è ok
SELECT 'Product' AS tabella, COUNT(*) AS righe, COUNT(DISTINCT ProductID) AS chiavi_distinte,
       CASE WHEN COUNT(*) = COUNT(DISTINCT ProductID) THEN 'OK' ELSE 'DUPLICATI' END AS esito
FROM Product;

SELECT 'Region' AS tabella, COUNT(*) AS righe, COUNT(DISTINCT RegionID) AS chiavi_distinte,
       CASE WHEN COUNT(*) = COUNT(DISTINCT RegionID) THEN 'OK' ELSE 'DUPLICATI' END AS esito
FROM Region;

SELECT 'Sales' AS tabella, COUNT(*) AS righe, COUNT(DISTINCT SalesID) AS chiavi_distinte,
       CASE WHEN COUNT(*) = COUNT(DISTINCT SalesID) THEN 'OK' ELSE 'DUPLICATI' END AS esito
FROM Sales;

-- 4a Elenco di tutte le vendite con codice prodotto, categoria, stato, regione e data
-- 4a In più aggiungo la colonna oltre_180_giorni: 1 se sono passati più di
--      180 giorni dalla vendita, 0 altrimenti
SELECT
    s.SalesID,
    p.ProductCode,
    p.Category,
    r.State,
    r.SalesRegion,
    s.SalesDate,
    DATEDIFF(CURDATE(), s.SalesDate) > 180 AS oltre_180_giorni
FROM Sales AS s
INNER JOIN Product AS p ON p.ProductID = s.ProductID
INNER JOIN Region  AS r ON r.RegionID  = s.RegionID
ORDER BY s.SalesID;

-- 4a Verifico che la JOIN non mi abbia perso righe: i due numeri devono coincidere
SELECT
    (SELECT COUNT(*) FROM Sales) AS righe_sales,
    (SELECT COUNT(*)
     FROM Sales s
     INNER JOIN Product p ON p.ProductID = s.ProductID
     INNER JOIN Region  r ON r.RegionID  = s.RegionID) AS righe_join;


--  TASK 4b - Aggregazioni e raggruppamenti

-- 4b Fatturato totale per prodotto e per anno. L'anno lo prendo con YEAR()
SELECT
    ProductID,
    YEAR(SalesDate)  AS anno,
    SUM(SalesAmount) AS fatturato_totale
FROM Sales
GROUP BY ProductID, YEAR(SalesDate)
ORDER BY ProductID, anno;

-- 4b Fatturato totale per stato e per anno, ordinato per anno e poi per fatturato decrescente
SELECT
    r.State,
    YEAR(s.SalesDate)  AS anno,
    SUM(s.SalesAmount) AS fatturato_totale
FROM Sales AS s
INNER JOIN Region AS r ON r.RegionID = s.RegionID
GROUP BY r.State, YEAR(s.SalesDate)
ORDER BY anno, fatturato_totale DESC;

-- 4b La categoria più richiesta, cioè quella con più pezzi venduti in totale.
--      Ordino per quantità decrescente e tengo solo la prima
SELECT
    p.Category,
    SUM(s.Quantity) AS quantita_totale
FROM Sales AS s
INNER JOIN Product AS p ON p.ProductID = s.ProductID
GROUP BY p.Category
ORDER BY quantita_totale DESC
LIMIT 1;

-- 4b Esempio con HAVING: stati che hanno fatturato più di 1000 in totale.
--      Il filtro è su una SUM quindi va in HAVING, con WHERE non funzionerebbe
SELECT
    r.State,
    SUM(s.SalesAmount) AS fatturato_totale
FROM Sales AS s
INNER JOIN Region AS r ON r.RegionID = s.RegionID
GROUP BY r.State
HAVING SUM(s.SalesAmount) > 1000
ORDER BY fatturato_totale DESC;

--  TASK 4c - Subquery e CTE
--  L'ultimo anno censito lo ricavo con MAX(YEAR(SalesDate)),
--  non lo scrivo a mano

-- 4c Quantità media venduta per prodotto nell'ultimo anno.
--      Prima sommo i pezzi per prodotto, poi faccio la media di quei totali
SELECT AVG(tot.quantita_prodotto) AS media_ultimo_anno
FROM (
    SELECT ProductID, SUM(Quantity) AS quantita_prodotto
    FROM Sales
    WHERE YEAR(SalesDate) = (SELECT MAX(YEAR(SalesDate)) FROM Sales)
    GROUP BY ProductID
) AS tot;

-- 4c Prodotti che hanno venduto più della media del punto 1.
--      Riuso la stessa subquery come soglia dentro HAVING
SELECT
    p.ProductCode,
    SUM(s.Quantity) AS totale_venduto
FROM Sales AS s
INNER JOIN Product AS p ON p.ProductID = s.ProductID
GROUP BY p.ProductCode
HAVING SUM(s.Quantity) > (
    SELECT AVG(tot.quantita_prodotto)
    FROM (
        SELECT ProductID, SUM(Quantity) AS quantita_prodotto
        FROM Sales
        WHERE YEAR(SalesDate) = (SELECT MAX(YEAR(SalesDate)) FROM Sales)
        GROUP BY ProductID
    ) AS tot
)
ORDER BY totale_venduto DESC;

-- 4c Stessa cosa ma con le CTE: spezzo il calcolo in tre pezzi con un nome,
--      si legge meglio e il risultato è identico a quello sopra
WITH ultimo_anno AS (
    SELECT MAX(YEAR(SalesDate)) AS anno FROM Sales
),
totali_ultimo_anno AS (
    SELECT ProductID, SUM(Quantity) AS quantita_prodotto
    FROM Sales
    WHERE YEAR(SalesDate) = (SELECT anno FROM ultimo_anno)
    GROUP BY ProductID
),
media AS (
    SELECT AVG(quantita_prodotto) AS media_ultimo_anno
    FROM totali_ultimo_anno
)
SELECT
    p.ProductCode,
    SUM(s.Quantity) AS totale_venduto
FROM Sales AS s
INNER JOIN Product AS p ON p.ProductID = s.ProductID
GROUP BY p.ProductCode
HAVING SUM(s.Quantity) > (SELECT media_ultimo_anno FROM media)
ORDER BY totale_venduto DESC;

--  TASK 4d - Window functions
--  Qui non uso GROUP BY: devo tenere una riga per ogni transazione
--  e aggiungere le colonne calcolate a fianco

-- 4d Classifica dei prodotti per fatturato dentro la propria categoria.
--      Nella subquery calcolo il totale per prodotto con SUM() OVER,
--      fuori assegno la posizione con DENSE_RANK partizionato per categoria
SELECT
    t.SalesID,
    t.ProductCode,
    t.Category,
    t.SalesDate,
    t.SalesAmount,
    t.fatturato_prodotto,
    DENSE_RANK() OVER (PARTITION BY t.Category ORDER BY t.fatturato_prodotto DESC) AS posizione_in_categoria
FROM (
    SELECT
        s.SalesID, p.ProductCode, p.Category, s.SalesDate, s.SalesAmount,
        SUM(s.SalesAmount) OVER (PARTITION BY s.ProductID) AS fatturato_prodotto
    FROM Sales AS s
    INNER JOIN Product AS p ON p.ProductID = s.ProductID
) AS t
ORDER BY t.Category, posizione_in_categoria, t.SalesDate;

-- 4d Totale progressivo del fatturato per regione, riga per riga in ordine di data
SELECT
    s.SalesID,
    r.SalesRegion,
    r.State,
    s.SalesDate,
    s.SalesAmount,
    SUM(s.SalesAmount) OVER (
        PARTITION BY r.SalesRegion
        ORDER BY s.SalesDate, s.SalesID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS totale_progressivo_regione
FROM Sales AS s
INNER JOIN Region AS r ON r.RegionID = s.RegionID
ORDER BY r.SalesRegion, s.SalesDate, s.SalesID;

-- 4d Confronto ogni vendita con quella precedente della stessa regione.
--      Con LAG prendo il fatturato della riga prima e calcolo la differenza
SELECT
    s.SalesID,
    r.SalesRegion,
    s.SalesDate,
    s.SalesAmount,
    LAG(s.SalesAmount) OVER (PARTITION BY r.SalesRegion ORDER BY s.SalesDate, s.SalesID) AS fatturato_precedente,
    s.SalesAmount - LAG(s.SalesAmount) OVER (PARTITION BY r.SalesRegion ORDER BY s.SalesDate, s.SalesID) AS differenza
FROM Sales AS s
INNER JOIN Region AS r ON r.RegionID = s.RegionID
ORDER BY r.SalesRegion, s.SalesDate, s.SalesID;
--  TASK 4e - Prodotti invenduti e viste

-- 4e Prodotti mai venduti, primo modo: LEFT JOIN e tengo solo le righe
--      dove non c'è corrispondenza in Sales
SELECT p.ProductID, p.ProductCode, p.ProductName, p.Category
FROM Product AS p
LEFT JOIN Sales AS s ON s.ProductID = p.ProductID
WHERE s.SalesID IS NULL;

-- 4e Secondo modo: NOT EXISTS. Deve uscire lo stesso prodotto di sopra (PALLA-01)
SELECT p.ProductID, p.ProductCode, p.ProductName, p.Category
FROM Product AS p
WHERE NOT EXISTS (
    SELECT 1 FROM Sales AS s WHERE s.ProductID = p.ProductID
);
-- 4e Vista sui prodotti con codice, nome e categoria già pronti
CREATE OR REPLACE VIEW vw_product_denorm AS
SELECT
    p.ProductID,
    p.ProductCode  AS codice_prodotto,
    p.ProductName  AS nome_prodotto,
    p.Category     AS nome_categoria
FROM Product AS p;

-- 4e Vista geografica per chi analizza le vendite per area
CREATE OR REPLACE VIEW vw_region_geo AS
SELECT
    r.RegionID,
    r.State        AS stato,
    r.SalesRegion  AS regione_vendita
FROM Region AS r;

-- Controllo che si leggano con una SELECT * senza join
SELECT * FROM vw_product_denorm;
SELECT * FROM vw_region_geo;

--  GOVERNANCE & PRIVACY
--  Per ogni caso scrivo cosa non va e come lo sistemerei.
--  Gli esempi della traccia sono in SQL Server, io li riscrivo
--  in MySQL (per esempio TEXT al posto di VARCHAR(MAX))
-- Caso 1 - vista pubblica per i rivenditori
-- Il problema: la vista espone PurchaseCost, cioè quanto paghiamo noi il
-- prodotto. È un dato interno, un rivenditore non lo deve vedere.
-- Una vista pubblica deve mostrare solo quello che serve davvero.
-- Sistemo togliendo la colonna
CREATE OR REPLACE VIEW vw_prodotti_rivenditori AS
SELECT ProductID, ProductName, Category
FROM Product;
-- Caso 2 - scheda fornitori condivisa col marketing
-- Il problema: il telefono è un dato personale. Il marketing non ne ha
-- bisogno per il suo lavoro, quindi non ha senso dargli accesso alla tabella
-- intera. Tengo i contatti in una tabella riservata e al marketing do solo
-- una vista senza il telefono, con i permessi assegnati per ruolo
CREATE TABLE SupplierContact (
    SupplierID INT         NOT NULL,
    Phone      VARCHAR(20) NOT NULL,
    PRIMARY KEY (SupplierID)
);
CREATE OR REPLACE VIEW vw_supplier_marketing AS
SELECT SupplierID FROM SupplierContact;
-- GRANT SELECT ON ToysGroup.vw_supplier_marketing TO 'marketing_role';
-- (sulla tabella SupplierContact il marketing non ha nessun permesso)

-- Caso 3 - vista commerciale con il margine
-- Il problema: una vista "commerciale" di uso generale fa vedere costo di
-- acquisto e margine, che sono dati riservati. In più PurchaseCost dentro
-- Sales è anche una ridondanza, perché il costo dipende dal prodotto.
-- Sistemo lasciando nella vista commerciale solo il fatturato; il margine
-- va in una vista a parte visibile solo a chi si occupa dei conti
CREATE OR REPLACE VIEW vw_sales_commerciale AS
SELECT SalesID, ProductID, RegionID, SalesDate, Quantity, SalesAmount
FROM Sales;
-- CREATE VIEW vw_sales_margine_riservata AS ...   con GRANT solo a 'finance_role'

-- Caso 4 - log degli accessi ai report
-- Il problema: due cose. Non c'è nessuna scadenza, quindi il log cresce
-- per sempre. E QueryText salva il testo intero delle query, che dentro
-- può avere dati sensibili. Tengo solo il nome del report, aggiungo una
-- data di scadenza e ogni tanto cancello quello che è scaduto
CREATE TABLE ReportAccessLog (
    LogID       INT          NOT NULL AUTO_INCREMENT,
    UserID      INT          NOT NULL,
    ReportName  VARCHAR(100) NOT NULL,     -- invece del testo completo della query
    AccessDate  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    RetainUntil DATE         NOT NULL,     -- per esempio AccessDate + 12 mesi
    PRIMARY KEY (LogID)
);
