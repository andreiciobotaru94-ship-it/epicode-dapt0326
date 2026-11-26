-- Staging clienti: stessi dati della tabella originale, ma con nomi chiari
-- e un nome completo già pronto. Nessun filtro, nessun calcolo di business.
select
    CustomerId                          as id_cliente,
    FirstName || ' ' || LastName        as nome_cliente,
    coalesce(Company, 'Privato')        as azienda,
    City                                as citta,
    coalesce(State, 'N/D')              as stato,
    Country                             as paese,
    Email                               as email,
    SupportRepId                        as id_dipendente_supporto
from {{ source('chinook', 'Customer') }}
