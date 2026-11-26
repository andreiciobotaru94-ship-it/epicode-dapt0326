-- Test personalizzato: se restituisce righe, il test fallisce.
-- Il totale di ogni fattura deve essere uguale alla somma delle sue righe.
select
    f.id_fattura
from {{ ref('stg_fatture') }} f
join {{ ref('stg_righe_fattura') }} r on r.id_fattura = f.id_fattura
group by f.id_fattura, f.totale_fattura
having abs(f.totale_fattura - sum(r.importo_riga)) > 0.005
