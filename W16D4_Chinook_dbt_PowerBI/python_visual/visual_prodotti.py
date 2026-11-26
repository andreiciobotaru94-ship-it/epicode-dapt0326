# Python Visual - AREA PRODOTTI
# Campi da trascinare nel visual: Brani[Genere], [Totale Vendite]
import matplotlib.pyplot as plt

dati = dataset.groupby("Genere", as_index=False)["Totale Vendite"].sum()
dati = dati.sort_values("Totale Vendite", ascending=False).head(10)
dati = dati.sort_values("Totale Vendite")   # per avere il maggiore in alto

plt.figure(figsize=(10, 5))
plt.barh(dati["Genere"], dati["Totale Vendite"], color="#1f3a5f")
plt.title("Il Rock è il genere che vende di più")
plt.xlabel("Vendite ($)")
plt.tight_layout()
plt.show()
