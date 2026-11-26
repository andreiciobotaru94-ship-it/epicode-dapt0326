-- Staging fatture: una riga per fattura, con la data come vera data.
select
    InvoiceId                           as id_fattura,
    CustomerId                          as id_cliente,
    date(InvoiceDate)                   as data_fattura,
    BillingCountry                      as paese_fatturazione,
    BillingCity                         as citta_fatturazione,
    Total                               as totale_fattura
from {{ source('chinook', 'Invoice') }}
