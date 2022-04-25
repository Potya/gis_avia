import datetime
from datetime import datetime
import os
from operator import itemgetter
import json
import urllib.request
from time import sleep
from geopy import distance

import numpy as np
import pandas as pd
from math import sqrt, cos, sin, radians
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker


class PlanePosition:
    def __init__(self, X, Y, Z, time, deg, velocity, speed):
        self.X = X
        self.Y = Y
        self.Z = Z
        self.time = time
        self.deg = deg
        self.velocity = velocity
        self.speed = speed

cruise_levels = {500: 5570,
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


def getAircrafts():
    # aircrafts = pd.read_csv(r'data/aircrafts.csv')
    aircrafts = pd.read_csv(r'data/aircraftDatabase-2022-04.csv')[['manufacturericao', 'icao24', 'typecode']]
    value_list = ['BOEING', 'AIRBUS', 'RAYTHEON', 'LEARJET']
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

def generateHeightsEast():
    tmp = list(range(29000, 43001, 2000))
    tmp = [x / 3.281 for x in tmp]
    return tmp

def generateHeightsWest():
    tmp = list(range(30000, 42001, 2000))
    tmp = [x / 3.281 for x in tmp]
    return tmp

def getLevel(z):
    plev = 0
    phpa = 1000
    for hpa, lev in cruise_levels.items():
        if lev > z:
            return hpa, phpa, float(z - plev) / (lev - plev)
        phpa = hpa
        plev = lev
    return 350, 300, 1

def getCurrentLevel(z, heights):
    prev = 0
    curr = 1
    while (curr < len(heights) and heights[curr] <= z):
        curr += 1
        prev += 1
    return prev, curr

def getVelocityFromDB(conn, x, y, h):
    point = f"ST_MakePoint({x}, {y})"
    l1, l2, d = getLevel(h)
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

def calWithWind(windX, windY, speed, deg):
    fx = speed * cos(radians(90 - deg)) + windX
    fy = speed * sin(radians(90 - deg)) + windY
    return sqrt(fx * fx + fy * fy)

def dynamicCalcPath(mtr):
    h, w = mtr.shape # 70 8
    path = np.zeros((mtr.shape))
    sum = np.zeros((mtr.shape))
    for i in range(w):
        path[0][i] = -1
        sum[0][i] = mtr[0][i]

    for i in range(1, h):
        for j in range(w):
            upper = min(w - 1, j + 1)
            central = j
            lowest = max(0, j - 1)
            if (max(sum[i - 1][upper], sum[i - 1][central], sum[i - 1][lowest]) == sum[i - 1][upper]):
                path[i][j] = upper
                sum[i][j] = mtr[i][j] + sum[i - 1][upper]
            if (max(sum[i - 1][upper], sum[i - 1][central], sum[i - 1][lowest]) == sum[i - 1][central]):
                path[i][j] = central
                sum[i][j] = mtr[i][j] + sum[i - 1][central]
            if (max(sum[i - 1][upper], sum[i - 1][central], sum[i - 1][lowest]) == sum[i - 1][lowest]):
                path[i][j] = lowest
                sum[i][j] = mtr[i][j] + sum[i - 1][lowest]
    res = mtr[h - 1].argmin()
    #print(res)
    result = []
    for i in range(h - 1, -1, -1):
        result.append(res)
        res = int(path[i][res])
        #print(res)
    #print(result)
    return result



def constructBestRoute(route):
    cruise = getCruisePart(route)
    heights = None
    if (0 <= route[0].deg < 180):
        print("Flying towards EAST: 29 000 ft + 2 000 ft vertical separation ")
        heights = generateHeightsEast()
    else:
        print("Flying towards WEST: 30 000 ft + 2 000 ft vertical separation")
        heights = generateHeightsWest()

    mtr = []
    db = create_engine("postgresql://avia:q@localhost:5433/avia")
    with db.connect() as conn:
        for point in cruise:
            tmp = []
            for h in heights:
                prognosisVelocityX, prognosisVelocityY = getVelocityFromDB(conn, point.Y, point.X, h)
                #print(prognosisVelocityX, prognosisVelocityY, point.deg)
                tmp.append(calWithWind(prognosisVelocityX, prognosisVelocityY, point.speed, point.deg))
            mtr.append(tmp)
    winds = np.array(mtr)
    print("During cruise flight aircraft located in", winds.shape[0], "points.")
    print("Start calculating custom path...")
    bestRoute = []
    #prev, curr = getCurrentLevel(route[0].z, heights)
    newAltitude = [cruise[0].Z]

    dyn = dynamicCalcPath(winds)
    custom_path = []
    real_path = []
    print("Comparing of altitude:")
    print("CUSTOM    REAL")
    for i in range(len(dyn)):
        custom_path.append(heights[dyn[i]])
        real_path.append(cruise[i].Z)
        print("{:6.2f}".format(heights[dyn[i]]), "{:6.2f}".format(cruise[i].Z))
    print("Calculating time difference...")
    real_time = 0
    custom_time = 0
    for i in range(len(cruise) - 1):
        real_start = distance.lonlat(cruise[i].Y, cruise[i].X)
        real_finish = distance.lonlat(cruise[i + 1].Y, cruise[i + 1].X)
        custom_start = distance.lonlat(cruise[i].Y, cruise[i].X)
        custom_finish = distance.lonlat(cruise[i + 1].Y, cruise[i + 1].X)

        distCustomToTravel = sqrt(distance.distance(custom_start, custom_finish).m ** 2 + (custom_path[i] - custom_path[i + 1]) ** 2)
        distRealToTravel = sqrt(distance.distance(real_start, real_finish).m ** 2 + (cruise[i].Z - cruise[i + 1].Z) ** 2)
        real_time += distCustomToTravel / winds[i][dyn[i]]
        custom_time += distRealToTravel / cruise[i].velocity
    print("Custom better than Real for sec.: ", str(real_time - custom_time))




    '''for i in range(len(winds) - 1):
        tmp = []
        print("Modeling on altitude", newAltitude[i], "with real altitude", cruise[i].Z)
        prev, curr = getCurrentLevel(newAltitude[i], heights)
        print("Its separation:", heights[prev], heights[curr])
        upper = min(curr + 2, len(heights))
        lowest = max(0, prev - 2)
        choise = winds[i + 1][lowest : upper]
        print("Possible speeds for next iteration:", choise)
        next = choise.argmax()
        print("Choosed speed:", winds[i + 1][lowest + next], "at altitude", heights[lowest + next] - 10)
        print("-------------------")
        newAltitude.append(heights[lowest + next] - 10)
        #print(heights[winds[i].argmax()], route[i].Z, winds[i].max(), route[i].velocity)
        tmp.append(heights[winds[i].argmax()])
        tmp.append(cruise[i].Z)
        tmp.append(heights[lowest + next] - 10)
        #for j in range(len(winds[i])):
        #    print(mtr[i][j], " ", end="")
        bestRoute.append(tmp)'''
    return custom_path, real_path


def findFlightRoute(flight):
    i = 0
    while (i + 1 < len(flight) and (not (flight[i].Z <= 5000 and flight[i + 1].Z > 5000))):
        i += 1
    if (i + 1 == len(flight)):
        #print(" cant find start")
        return None, None
    start = i
    #print(start, flight[start].Z, flight[start + 1].Z)
    while (i + 1 < len(flight) and (not (flight[i].Z >= 5000 and flight[i + 1].Z < 5000))):
        i += 1
    if (i + 1 == len(flight)):
        #print(" cant find finish")
        return None, None
    finish = i
    #print(start, finish)
    return start, finish

def getCruisePart(route):
    cruise = []
    for point in route:
        #print(point.Z)
        if point.Z > 8800:
            cruise.append(point)
    return cruise


def getLowPlanes(aircrafts, speedDict):
    directory = os.fsencode("planes22")
    flights = {}


    for file in os.listdir(directory):
        filename = "planes22/" + os.fsdecode(file)
        # output = json.loads("planes21/2022-04-21_17:21:25.json")
        data = [json.loads(line) for line in open(filename, 'r')]
        # print(data[0]["states"])
        planes = data[0]["states"]
        for plane in planes:
            # print(plane[0])
            if (plane[1] is not None and plane[0] in aircrafts and plane[0] in speedDict.keys()):
                if (plane[1] not in flights):
                    if (plane[8] is False and plane[13] is not None):
                        tmp = PlanePosition(plane[6], plane[5], plane[13], plane[3], plane[10], plane[9], speedDict[plane[0]])
                        flights[plane[1]] = [tmp]
                else:
                    if (plane[13] is not None):
                        flights[plane[1]].append(PlanePosition(plane[6], plane[5], plane[13], plane[3], plane[10], plane[9], speedDict[plane[0]]))
    return flights


aircrafts = getAircrafts()
#print(aircrafts)
speedDict, typeDict = getAircraftSpeed(aircrafts)
#print(speedDict)
flights = getLowPlanes(set(aircrafts['icao24'].values), speedDict)
full_flights = {}
for flight in flights:
    #print(flight)
    flights[flight].sort(key=lambda x: x.time)
    if (len(flights[flight]) > 80):
        full_flights[flight] = flights[flight]


#for flight in full_flights:
#    print('\n', flight)
#    for tm in flights[flight]:
#        print(tm.Z, end=',')

print(len(full_flights))

for flight in full_flights:
    start, finish = findFlightRoute(full_flights[flight])
    if (finish):
        print("Find flight route for |" + flight + "|:")
        print("Start:", datetime.utcfromtimestamp(full_flights[flight][start].time).strftime('%Y-%m-%d %H:%M:%S'))
        print("Finish:", datetime.utcfromtimestamp(full_flights[flight][finish].time).strftime('%Y-%m-%d %H:%M:%S'))
        print("--------------")

selected_flight = "TOM9JY  "
if (selected_flight is None):
    selected_flight = input()
print("Flight |" + selected_flight + "|", sep="")
#for point in flights[selected_flight]:
    #print(point.X, point.Y, point.Z, datetime.utcfromtimestamp(point.time).strftime('%Y-%m-%d %H:%M:%S'))
custom_path, real_path = constructBestRoute(full_flights[selected_flight])
