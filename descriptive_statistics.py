import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
import seaborn as sns

print('start!')

data = pd.read_csv('Spain/dairy.csv', index_col = None)

data.plot(y='MILK',x='COWS',style='.')
data[['MILK','COWS','LAND','LABOR','FEED']].corr()
sns.heatmap(data[['MILK','COWS','LAND','LABOR','FEED']].corr(), annot=True)

########
# WITHIN VARIANCE
out = []
tag = 'MILK'
sum_i = 0
for i in data.FARM.unique():
    df = data.loc[data.FARM.values == i, :]
    av_i = df[tag].mean()
    sum_t = 0
    for t in df.YEAR.unique():
        sum_t = sum_t + (df.loc[df.YEAR.values == t, tag].values[0] - av_i) ** 2

    sum_i = sum_i + sum_t
sum_i = sum_i * (1 / (247 * 6 - 1));
print(sum_i)
#############

########
# BETWEEN VARIANCE
out = []
tag = 'MILK'
av_tot = data[tag].mean()
sum_i = 0
for i in data.FARM.unique():
    df = data.loc[data.FARM.values == i, :]
    av_i = df[tag].mean()
    sum_i = sum_i + (av_i-av_tot)**2

sum_i = sum_i * (1 / (247  - 1));
print(sum_i)
#############


print('end!')

