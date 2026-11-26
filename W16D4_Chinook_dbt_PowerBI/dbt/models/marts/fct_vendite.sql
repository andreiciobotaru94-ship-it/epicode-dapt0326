-- Tabella dei fatti: una riga per riga di fattura, con i dati della fattura.
-- Riusa gli staging con ref(): se cambio uno staging, cambia anche questa.
select
    r.id_riga,
    r.id_fattura,
    r.id_brano,
    f.id_cliente,
    f.data_fattura,
    f.paese_fatturazione,
    r.quantita,
    r.importo_riga
from {{ ref('stg_righe_fattura') }} r
join {{ ref('stg_fatture') }}       f on f.id_fattura = r.id_fattura
