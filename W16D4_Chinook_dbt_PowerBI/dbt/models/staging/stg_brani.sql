-- Staging brani: il brano con genere, album e artista già collegati.
select
    t.TrackId                           as id_brano,
    t.Name                              as nome_brano,
    al.Title                            as album,
    ar.Name                             as artista,
    g.Name                              as genere,
    t.Milliseconds / 60000.0            as durata_minuti,
    t.UnitPrice                         as prezzo_listino
from {{ source('chinook', 'Track') }}  t
left join {{ source('chinook', 'Album') }}  al on al.AlbumId  = t.AlbumId
left join {{ source('chinook', 'Artist') }} ar on ar.ArtistId = al.ArtistId
left join {{ source('chinook', 'Genre') }}  g  on g.GenreId   = t.GenreId
