# Python Visual - AREA CLIENTI
# Campi da trascinare nel visual: Clienti[Paese], [Totale Vendite]
import matplotlib.pyplot as plt

dati = dataset.groupby("Paese", as_index=False)["Totale Vendite"].sum()
dati = dati.sort_values("Totale Vendite", ascending=False).head(10)
dati = dati.sort_values("Totale Vendite")

plt.figure(figsize=(10, 5))
plt.barh(dati["Paese"], dati["Totale Vendite"], color="#b08d57")
plt.title("Gli USA sono il paese con più vendite")
plt.xlabel("Vendite ($)")
plt.tight_layout()
plt.show()
