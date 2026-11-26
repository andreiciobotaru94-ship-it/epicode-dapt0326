-- Staging righe fattura: una riga per brano venduto.
-- L'importo della riga si calcola qui una sola volta, così lo riusano tutti.
select
    InvoiceLineId                       as id_riga,
    InvoiceId                           as id_fattura,
    TrackId                             as id_brano,
    UnitPrice                           as prezzo_unitario,
    Quantity                            as quantita,
    UnitPrice * Quantity                as importo_riga
from {{ source('chinook', 'InvoiceLine') }}
