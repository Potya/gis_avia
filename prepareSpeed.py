import pandas as pd


def loadData():
    df = pd.read_csv(r'data/aircraftDatabase-2022-04.csv')
    value_list = ['BOEING', 'AIRBUS', 'RAYTHEON', 'EMBRAER', 'LEARJET']
    boolean_series = df.manufacturericao.isin(value_list)
    df = df[boolean_series]
    return df

def printManufacturerStat(df):
    v = df[['manufacturericao', 'icao24']] \
        .groupby('manufacturericao') \
        .count() \
        .sort_values("icao24", ascending=False)
    v = v.loc[v["icao24"] > 100]
    print(len(v))
    print(v.head(20))

def printListModels(df):
    v = df[['manufacturericao','typecode', 'icao24']] \
        .groupby(['manufacturericao','typecode']) \
        .count() \
        .sort_values("icao24", ascending=False)
    print(v)
    # print(v.head(20))
    spd = df[['manufacturericao', 'typecode']] \
        .groupby(['manufacturericao', 'typecode']) \
        .count()
    spd['speed'] = 800
    spd.to_csv('data/speed.csv')
    for a in v.index.sort_values():
        print(a[0], a[1], sep=',', end=',800\n')
    v.to_csv("data/aircrafts.csv")


df = loadData()
print(df)
printListModels(df)
#df.to_csv("aircrafts.csv")