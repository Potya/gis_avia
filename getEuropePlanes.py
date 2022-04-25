import datetime
from operator import itemgetter
import json
import urllib.request
from time import sleep
import pandas as pd
from math import sqrt, cos, sin, radians
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker



def loadStatesInSquare():
    data = urllib.request.urlopen("https://opensky-network.org/api/states/all?lamin=28.3043807&lomin=-31.4648438&lamax=73.0738435&lomax=58.5351563").read()
    t = datetime.datetime.now().strftime("%Y-%m-%d_%H:%M:%S")
    t += ".json"
    print(t)
    with open("planes25/" + t, 'wb') as file:
        file.write(data)

while (1):
    loadStatesInSquare()
    sleep(120)
