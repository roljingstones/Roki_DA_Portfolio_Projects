# -*- coding: utf-8 -*-
"""DA Project 4_Correlation in Python.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1NHQP5vjV-e1E9aucFHikp31Iy2wKGMYw
"""

#DA Project 4: Korelacija koristenjem Pythona

# Commented out IPython magic to ensure Python compatibility.
#Import biblioteka

import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

# %matplotlib inline
matplotlib.rcParams['figure.figsize'] = (12,8)

pd.options.mode.chained_assignment = None

#Import fajla u Google Colab
#Referenca: https://stackoverflow.com/questions/68630198/unable-to-read-csv-file-in-google-colab
from google.colab import files
uploaded = files.upload()
#nakon ovoga pronadjes lokaciju gdje se nalazi fajl i sacekas da se fajl 100% ucita

#Ucitavanje fajla u dataframe
df = pd.read_csv('movies.csv')

#Provjera da vidimo da li se sve ok ucitalo
df.head()

#Ciscenje podataka

#Da vidimo ima li nedostajucih podataka
for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col,round(pct_missing * 100)))

#Ne trebaju nam NA ili NULL podaci tako da cemo obrisati sve NA ili NULL podatke
df = df.dropna()

#Da vidimo kojeg su tipa podaci
df.dtypes

#Mijenjamo tip podatka u odredjenim kolonama
df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')

df.head()

#Takodje se vidi da u kolonama released i year ponekad godine ne odgovaraju
# moze se provjerom ustanoviti da je tacniji podatak za godinu u koloni released
#Kreiracemo novu kolonu tako sto cemo pokupiti godinu iz polja released
df['yearcorrect'] = df['released'].str.extract(pat = '([0-9]{4})').astype(int)

#Provjera
df

#Sortiranje po velicini bruto zarade
df.sort_values(by = ['gross'], inplace = False, ascending = False)

#Zelimo da pregled podataka bude takav da se moze skrolom proci kroz sve podatke
pd.set_option('display.max_rows',None)

#Sad ponovo pustamo
df.sort_values(by = ['gross'], inplace = False, ascending = False)

#Kad bismo izbacili duplikate
df['company'].drop_duplicates().sort_values(ascending = False)

# Sad prelazimo na analizu

#Pretpostavka je  da je budzet ulozen u film u vezi sa prihodom filma
#takodje bi mogao na prihod uticatli i ime kompanije koja realizuje film

#Kreiracemo scatter plot budget vs gross revenue

plt.scatter(x = df['budget'], y = df['gross'] )
plt.show()

df.head()

#dodacemo title
plt.scatter(x = df['budget'], y = df['gross'] )

plt.title('Budzet vs. Gross')

plt.xlabel('Budget')
plt.ylabel('Gross ear')

plt.show()

#izgleda da ima korelacije ali to moramo potvrditi

#Regresioni prikaz
#Crtamo budget vs gross koristenjem seaborna

sns.regplot(x = 'budget', y = 'gross', data = df)

#kako bi bilo uocljivilje
sns.regplot(x = 'budget', y = 'gross', data = df, scatter_kws = {"color":"red"}, line_kws = {"color":"blue"})

#Vidimo da postoji korelacija, ali ne znamo kolika

df.corr()

#Postoji vise tipova korelacija
#Pearsonov koeficijent, Kendalov, Spearmanov koeficijent

#difoltni je Pearsonov koeficijent (to je koa ovo gore)
df.corr(method = 'pearson')

#sad da probamo Kendallov
df.corr(method = 'kendall')

#i Spearmanov
df.corr(method = 'spearman')

#drzacemo se difoltnog, Pearsonovog koeficijenta

#vidimo da postoji jaka korelacija izmedju budzeta i zarade

#Sad cemo vizualizovati korelacionu matricu preko heatmape

correlation_matrix = df.corr(method = 'pearson')
sns.heatmap(correlation_matrix, annot = True)
plt.show()

#sto je svjetlije polje veca je korelacija

#Sad cemo i ovdje malo dodati informacija
correlation_matrix = df.corr(method = 'pearson')
sns.heatmap(correlation_matrix, annot = True)
plt.title('Korelaciona matrica za numericke varijable')

plt.xlabel('Movie features x')
plt.ylabel('Movie features y')
plt.show()

#Sad cemo gledati po filmskim kompanijama
#medjutim kompanije nisu numericke varijable pa cemo to promijeniti
#svaku od kolona koje su tipa opisne varijable (object) stavicemo da bude kategorijska varijabla

df_numerized = df
for col_name in df_numerized.columns:
    if df_numerized[col_name].dtype == 'object':
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes #dodijeli im neki kod

df_numerized.head()

#Sad cemo nad ovim pustiti korelacionu matricu
correlation_matrix = df_numerized.corr(method = 'pearson')
sns.heatmap(correlation_matrix, annot = True)
plt.title('Korelaciona matrica za numericke varijable')

plt.xlabel('Movie features x')
plt.ylabel('Movie features y')
plt.show()

#ovo je super, ali zelimo da se bolje vidi gdje je najveca korelacija
df_numerized.corr()

#radimo tzv. unstacking
correlation_mat = df_numerized.corr()
corr_pairs = correlation_mat.unstack()
corr_pairs

#sad to sortiramo
sorted_pairs = corr_pairs.sort_values()
sorted_pairs

type(sorted_pairs)

#Hocemo samo one koji imaju visoku korelaciju
high_corr = sorted_pairs[sorted_pairs > 0.5]
high_corr

#Vidimo da budzet i glasovi imaju najvecu korelaciju sa gross zaradom
#Ime kompanije se ne cini bitnim za zaradu