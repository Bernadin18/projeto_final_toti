# -*- coding: utf-8 -*-
"""Python_ProjetoFinal_BaseUnificada

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/16kfTQ345HEHqlOnkht4FFJ26Nlm1wKNg
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

#Leitura dos dados em .CSV

df= pd.read_csv('/content/Base_Unificada_ProjetoFinal.csv', sep=';')

df.describe()

df

df.head()

#Leituras dos dados
Hospital_df=pd.read_excel('/content/Base_(02).xlsx')

Hospital_df

# para ver as caracteristicas dos dados
print(Hospital_df.columns.values)

# para ver as 10 primeiras linhas dessa base de dados
Hospital_df.head(10)

# Vizualizando as ultimas linhas da base de dados
Hospital_df.tail(10)

"""**Classificação das variaveis por tipo**
. cod de paciente: quantitativa continua
. nome de paciente:qualitativa nominal
. sala            :quantitativa continua
. Andar           :quantitativa continua
.cod de andar     :quantitativa continua
.cod da enfermeira:quantitativa continua
.Nome da enfermeira:qualitativa nominal
.cargo da infermeira:qualitativa nominal
.Nome do médico:qualitativa nominal
.cargo do médico:qualitativa nominal
.endereço do paciente:qualitativa nominal
.Região:qualitativa nominal
.Inicio Agendamento:quantitativa continua
.Fim Agendamento:quantitativa continua
.Inicio tratamento:quantitativa continua
.Fim  tratamento:quantitativa continua
.Inicio chamada:quantitativa continua
.Fim chamada:quantitativa continua
"""

#para ver os tipos dos dados
Hospital_df.info()

"""# As tabelas de frquencias"""

# tabela de frequencias absolutas para cago do medico
tab1 = pd.crosstab(index=Hospital_df['Cargo do Médico'], columns ='count')

tab1

# tabela de frequencias absolutas para o nome do medico
tab2 = pd.crosstab(index=Hospital_df['Nome do Médico'], columns ='count')
tab2

# tabela de frequencias absolutas para a região
tab3 = pd.crosstab(index=Hospital_df['Região'], columns ='count')
tab3

# tabela de frequencias absolutas para o nome do procedimento
tab4 = pd.crosstab(index=Hospital_df['Nome do Procedimento'], columns ='count')
tab4

# tabela de frequencias absolutas para o endereço do paciente
tab5 = pd.crosstab(index=Hospital_df['Endereço do Paciente'], columns ='count')
tab5

# tabela de frequencias relativas para cago do medico
tab1 = pd.crosstab(index=Hospital_df['Cargo do Médico'], columns ='count')
tab1/tab1.sum()

# tabela de frequencias relativas para o nome do medico
tab2 = pd.crosstab(index=Hospital_df['Nome do Médico'], columns ='count')
tab2/tab2.sum()

"""# Medidas de variavéis"""

# Média
Hospital_df['Andar'].mean()

# Média do valor do procedimento
Hospital_df['Valor do Procedimento'].mean()

# Média por agrupamento
Hospital_df.groupby('Cargo do Médico')['Andar'].mean()

# Média por agrupamento
Hospital_df.groupby('Cargo do Médico')['Valor do Procedimento'].mean()

Hospital_df.groupby('Cargo do Médico')['Sala'].mean()

Hospital_df.groupby('Nome do Paciente')['Andar'].mean()

# Moda para cargo do médico(mais frequente/comum)
import statistics
statistics.mode(Hospital_df['Cargo do Médico'])

# Moda para endereço do paciente
import statistics
statistics.mode(Hospital_df['Endereço do Paciente'])

# Moda para o nome do procedimento
import statistics
statistics.mode(Hospital_df['Nome do Procedimento'])

# Moda para endereço a região
import statistics
statistics.mode(Hospital_df['Região'])

# Ordenação de dados
import numpy as np
np.sort(Hospital_df['Valor do Procedimento'])

# Quantis de 95% e 25% (95%  procedimento tem um valor de 10000)
np.percentile(Hospital_df['Valor do Procedimento'], 95)

# Quantis de 95% e 25%
np.percentile(Hospital_df['Valor do Procedimento'], 25)

sns.displot(Hospital_df['Valor do Procedimento'], bins = 10)

"""Estatística descritvas dos **dados**

"""

# para obter as estatísticas co o média, ect.
Hospital_df

# para tirar as colunas não desejadas para esse calculo(variaveis qualitativas)
Hospital_df.loc[:,Hospital_df.columns != 'ID.Seguro'].describe()

"""Vizualização de algumas variaveis"""

tab1 = pd.crosstab(index=Hospital_df['Cargo do Médico'], columns ='count')
tab1/tab1.sum()

tab1

plot1 = tab1.plot.pie(y = 'count')

plot2 = tab2.plot.pie(y = 'count')

plot3 = tab3.plot.pie(y = 'count')

plot4 = tab4.plot.pie(y = 'count')



"""Graficos de barra"""

tab1.plot.bar()
plt.legend(title = 'Cargo do Médico')
plt.show()

tab2.plot.bar()
plt.legend(title = 'Nome do Medico')
plt.show()

tab3.plot.bar()
plt.legend(title = 'Região')
plt.show()

tab4.plot.bar()
plt.legend(title = 'Nome do procedimento')
plt.show()

#Fazendo um boxplot
sns.boxplot(x = Hospital_df['Valor do Procedimento'], orient = 'h')

#Fazendo um boxplot
sns.boxplot(x = Hospital_df['Dose'], orient = 'h')

# Histograma

"""#**Criando gráfico de barras empilhadas com peso no eixo y e a variável de empilhamento sendo gênero**

"""

#primeiro agrupar os dados por site e por sexo e depois calcular o total
by_site_sex = df.groupby([ 'Sexo'])
site_sex_count = by_site_sex['Valor do Procedimento'].sum()
site_sex_count

#.unstack()os dados agrupados para entender como o peso total de cada sexo
by_site_sex = df.groupby(['Cod.Paciente', 'Sexo'])
site_sex_count = by_site_sex['Valor do Procedimento'].sum()
site_sex_count.unstack()

#Resultado gráfico de barras empilhado dos dados em que o peso para cada gênero

by_site_sex = df.groupby([ 'Cod.Paciente', 'Sexo'])
site_sex_count = by_site_sex['Valor do Procedimento'].sum()
spc = site_sex_count.unstack()
s_plot = spc.plot(kind='bar',stacked=True,title="Total Facturamento por Sexo")
s_plot.set_ylabel("'Valor do Procedimento'")
s_plot.set_xlabel("Sexo")

# Graficar datos apilados de modo que las columnas 'one' y 'two' estén apiladas

grouped_data = df.groupby(['Valor do Procedimento', 'Sexo']) 
grouped_data.mean(['Valor do Procedimento']).sum()
grouped_data.plot(kind='bar',stacked=True,title="Total Sexo Facturamento")
s_plot.set_ylabel("Total")
s_plot.set_xlabel("Sexo")

# Graficar datos apilados de modo que las columnas 'one' y 'two' estén apiladas
grouped_data = df.groupby(['Valor do Procedimento', 'Sexo']) 
grouped_data.mean().sum
grouped_data.plot(kind='bar',stacked=True,title="Total Sexo Facturamento")
s_plot.set_ylabel("Total")
s_plot.set_xlabel("Sexo")

#unbiased skew, Normalized by N-1 en un dataframe
df.skew()

# unbiased kurtosis over requested axis using Fisher's definition
# en un dataframe
df.kurtosis()

"""##**Gráficos de conjuntos de dados, fazendo um gráfico de dispersão e uma regressão linear**"""

# Commented out IPython magic to ensure Python compatibility.
import pandas as pd # libreria manipulacion de datos
import seaborn as sns # Libreria graficas
import numpy as np

# %matplotlib inline

#Calcular os valores da mídia e a variação de cada conjunto de dados
agg = df.groupby('Sala').agg([np.mean, np.var])
agg

#Calcular a correlação
corr = [g.corr()['Valor do Procedimento'][1] for _, g in df.groupby('Sala')]
corr

"""**Gráficos de conjuntos de dados, fazendo um gráfico de dispersão e uma regressão linear**"""

# Grafica Usando seaborn
sns.set(style="ticks")
sns.lmplot(x="Cod.Paciente", y="Valor do Procedimento", col="Sala", hue="Sala", data=df,
               col_wrap=2, ci=None, palette="muted", height=4,
               scatter_kws={"s": 50, "alpha": 1});

#Grafico Área

#df.plot(kind='area',alpha = 0.4)

df.plot.area(alpha=0.4);

"""**Correlação**"""

#Todo o DataFrame
data_corr = df.corr()

data_corr

fig, ax = plt.subplots(figsize=(12, 10))
sns.heatmap(data_corr, annot=True);

pd.crosstab(df['Sexo'], df['Cod.Procedimento'])

pd.crosstab( df['Cod.Médico'], df['Sexo'])

"""**Gráfico de dispersão**

"""

fig, ax = plt.subplots(figsize=(12, 8))

plt.scatter( df['Cod.Médico'], df['Cod.Procedimento'],  s=450)

plt.xlabel('Cod.Médico')
plt.ylabel('Cod.Procedimento')


plt.show()

from mpl_toolkits.mplot3d import Axes3D

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

x =df['Cod.Médico']
y =df['Cod.Procedimento']
z =df['Dose']

ax.scatter(x, y, z, c='r', marker='o')

ax.set_xlabel('X Label')
ax.set_ylabel('Y Label')
ax.set_zlabel('Z Label')

plt.show()

fig = plt.figure()
fig.suptitle("Pacientes ")
df['Nome do Paciente'].value_counts().plot(kind='bar')

"""##**Outro Modelo**
*DataFrame que criamos ao importar um arquivo de dados:*
"""

#Codificação do caminho do arquivo 
 #Indicaremos também aos Pandas as colunas que contêm as data

modelo_df = pd.read_csv('/content/Base_Unificada_ProjetoFinal.csv', sep=(';'), 
                        parse_dates=['Inicio Tratamento' ,	'Fim Tratamento']
                        )
                      
modelo_df.head()

list(enumerate(modelo_df.columns))

periodo = modelo_df['Fim Tratamento'] - modelo_df['Inicio Tratamento']

periodo

fig = plt.figure()
fig.suptitle("Data Promedio")
periodo.value_counts().plot(kind='bar')

"""**Tipo de dados da coluna 'Data' é objeto, ou seja, string. Agora vamos convertê-lo para o formato datetime usando a função pd.to_datetime(). **"""

modelo_df['Inicio do Agendamento']= pd.to_datetime(modelo_df['Inicio do Agendamento'])
modelo_df.info()

modelo_df['Fim do Agendamento']= pd.to_datetime(modelo_df['Fim do Agendamento'])
modelo_df.info()

modelo_df['Fim Chamada']= pd.to_datetime(modelo_df['Fim Chamada'])
modelo_df.info()

import plotnine as p9
myplot = (p9.ggplot(data= df,
                    mapping=p9.aes(x='Inicio do Agendamento', y='Fim do Agendamento')) +
              p9.geom_point())

# convierte el output de plotnine a un objeto de matplotlib
my_plt_version = myplot.draw()

# Realiza más ajustes al gráfico con matplotlib:
p9_ax = my_plt_version.axes[0] # cada subgráfico es un ítem en una lista
p9_ax.set_xlabel("Inicio do Agendamento")
p9_ax.tick_params(labelsize=8, pad=8)
p9_ax.set_title('Analise do Tempo', fontsize=15)
plt.show() # esto no es necesario en Jupyter Notebooks

modelo_df.set_index('Inicio do Agendamento').rolling(3).mean().head().hist()

