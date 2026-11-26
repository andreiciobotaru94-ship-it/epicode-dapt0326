# Python Visual - AREA VENDITE
# Campi da trascinare nel visual: Calendario[AnnoMese], [Totale Vendite]
import matplotlib.pyplot as plt

dati = dataset.groupby("AnnoMese", as_index=False)["Totale Vendite"].sum()
dati = dati.sort_values("AnnoMese")

plt.figure(figsize=(10, 4))
plt.plot(dati["AnnoMese"], dati["Totale Vendite"], marker="o", color="#1f3a5f")
plt.title("Le vendite mensili oscillano intorno ai 39 $ al mese")
plt.xlabel("Mese")
plt.ylabel("Vendite ($)")
plt.xticks(dati["AnnoMese"][::6], rotation=45)
plt.grid(alpha=0.3)
plt.tight_layout()
plt.show()
