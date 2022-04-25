import datetime
from operator import itemgetter
import json
import urllib.request
import pandas as pd
from math import sqrt, cos, sin, radians
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker


def getAircrafts():
    #aircrafts = pd.read_csv(r'data/aircrafts.csv')
    aircrafts = pd.read_csv(r'data/aircraftDatabase-2022-04.csv')[['manufacturericao', 'icao24', 'typecode']]
    value_list = ['BOEING', 'AIRBUS', 'RAYTHEON', 'EMBRAER', 'LEARJET']
    boolean_series = aircrafts.manufacturericao.isin(value_list)
    aircrafts = aircrafts[boolean_series][['icao24', 'typecode']]
    return aircrafts

def getAircraftSpeed(aircrafts):
    aircraftModelSpeeds = pd.read_csv(r'data/speed.csv')
    aircraftSpeeds = pd.merge(aircrafts, aircraftModelSpeeds, on="typecode")
    speedDict = dict()
    typeDict = dict()
    for a in aircraftSpeeds.to_dict('records'):
        speedDict[a['icao24']] = a['speed']
        typeDict[a['icao24']] = a['typecode']
    return speedDict, typeDict

levels = {500: 5570,
          400: 7180,
          350: 8110,
          300: 9160,
          275: 9740,
          250: 10360,
          225: 11030,
          200: 11770,
          175: 12590,
          150: 13500,
          100: 15790}

def getLevel(z):
    plev = 0
    phpa = 1000
    for hpa, lev in levels.items():
        if lev > z:
            return hpa, phpa, float(z - plev) / (lev - plev)
        phpa = hpa
        plev = lev
    return 350, 300, 1

def loadStates():
    data = urllib.request.urlopen("https://opensky-network.org/api/states/all").read()
    with open('temp.json', 'wb') as file:
        file.write(data)
    #with open('temp.json', 'rb') as fin:
    #    data = fin.read()
    output = json.loads(data)
    states = output["states"]
    return states

def getVelocityFromDB(conn, x, y, z):
    point = f"ST_MakePoint({x}, {y})"
    l1, l2, d = getLevel(z)
    #    print(z, l1, levels[l1], l2, levels[l2], d)
    result_set = conn.execute(
        f"""with d as (
select ua.rid as ua, ub.rid as ub, va.rid as va, vb.rid as vb
from u{l1} ua join u{l2} ub using (minx, miny, maxx, maxy)
join v{l1} va using (minx, miny, maxx, maxy)
join v{l2} vb using (minx, miny, maxx, maxy)
where {x}>=minx and {x}<=maxx and {y}>=miny and {y}<=maxy
)
select ST_Value(ua.rast, {point}),
ST_Value(va.rast, {point}),
ST_Value(ub.rast, {point}),
ST_Value(vb.rast, {point})
from d
join u{l1} ua on ua.rid=ua
join v{l1} va on va.rid=va
join u{l2} ub on ub.rid=ub
join v{l2} vb on vb.rid=vb""")
    for r in result_set:
        return r[0] * d + r[2] * (1 - d), r[1] * d + r[3] * (1 - d)
        # sqrt(r[0] * r[0] + r[1] * r[1]) * d + sqrt(r[0] * r[0] + r[1] * r[1]) * (1 - d)
    return None, None

def saveInfo(conn, info):
    s = "insert into planes2 (t, z, planeVelocity, planeDirection, expectedSpeed, windX, windY, error, geom, typ) values "
    first = True
    for state in info:
        if first:
            first = False
        else:
            s += ",\n"
        s += "('" + str(state[0]) + "'::timestamp, " + str(state[3]) + ", " + str(state[4]) + ", " + str(
            state[5]) + ", " + str(state[6]) + ", " + str(state[7]) + ", " + str(state[8]) + ", " + str(state[9]) + ", ST_MakePoint(" + str(
            state[1]) + "," + str(state[2]) + "), '" + state[10] + "')"
    print(s)
    var = conn.execute(s)
    return var

def calcPlaneSpeed(windX, windY, velocity, deg, speed):
    fx = velocity * cos(radians(90 - deg)) - windX
    fy = velocity * sin(radians(90 - deg)) - windY
    w = sqrt(fx * fx + fy * fy)
    return w-speed

def getTable(states, speedDict, t, typeDict):
    cnt = 0
    requestCount = 0
    cntGood = 0
    listVel = []
    db = create_engine("postgresql://avia:q@localhost:5433/avia")
    info = []
    print(speedDict)
    with db.connect() as conn:
        for state in states:
            icao = state[0]
            #print(icao)
            x = state[5]
            y = state[6]
            z = state[13]
            velocity = state[9]  # m/s
            deg = state[10]
            speed = speedDict.get(icao)
            cnt = cnt + 1
            #print("xyz", x, y, z, velocity, deg, speed)
            if x is None or y is None or z is None or velocity is None or deg is None or speed is None or z < 8000:
                continue
            speed = speed / 3.6  # m/s
            cntGood = cntGood + 1
            windVelocity = velocity - speed  # m/s

            prognosisVelocityX, prognosisVelocityY = getVelocityFromDB(conn, x, y, z)
            print("prognosis", prognosisVelocityX, prognosisVelocityY)
            if prognosisVelocityX is not None and prognosisVelocityY is not None:
                typ = typeDict.get(icao)
                errorWindVelocity = calcPlaneSpeed(prognosisVelocityX, prognosisVelocityY, velocity, deg, speed)
                if errorWindVelocity is not None:
                    listVel.append(errorWindVelocity)
                    info.append([t, x, y, z, velocity, deg, speed, prognosisVelocityX, prognosisVelocityY, errorWindVelocity, typ]);
            requestCount += 1
            if requestCount % 100 == 0:
                print(requestCount)
        print(info)
        saveInfo(conn, info)

t = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
print(t)

aircrafts = getAircrafts()
speedDict, typeDict = getAircraftSpeed(aircrafts)
#print(speedDict)
#print(typeDict)
#speedDict = getAircraftSpeed(aircrafts)
states = loadStates()
#print(states)

states = filter(lambda state: state[13], states)
states = sorted(states, key=itemgetter(13))
#print(states)

getTable(states, speedDict, t, typeDict)
print("end")