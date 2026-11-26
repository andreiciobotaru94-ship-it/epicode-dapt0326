# Python Visual - AREA TEMPORALE
# Campi da trascinare nel visual: Calendario[AnnoMese], [Totale Vendite]
import matplotlib.pyplot as plt

dati = dataset.groupby("AnnoMese", as_index=False)["Totale Vendite"].sum()
dati["Anno"] = dati["AnnoMese"].str[:4]
dati["Mese"] = dati["AnnoMese"].str[5:].astype(int)
tabella = dati.pivot(index="Mese", columns="Anno", values="Totale Vendite")

plt.figure(figsize=(10, 4))
for anno in tabella.columns:
    plt.plot(tabella.index, tabella[anno], marker="o", label=str(anno))
plt.title("Confronto delle vendite mese per mese, anno per anno")
plt.xlabel("Mese")
plt.ylabel("Vendite ($)")
plt.xticks(range(1, 13))
plt.legend(title="Anno")
plt.grid(alpha=0.3)
plt.tight_layout()
plt.show()
