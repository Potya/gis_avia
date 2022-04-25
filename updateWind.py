import requests
import os
from datetime import datetime, timedelta


def downloadFile(url, file):
    r = requests.get(url, allow_redirects=True)
    open(file, 'wb').write(r.content)


def loadHpa(date, hour, hpa, type, when):
    filename = type + str(hpa) + ".grib2"
    print("start downloading")
    print("https://dd.weather.gc.ca/model_gem_global/15km/grib2/lat_lon/" + when + "/" + hour + "/CMC_glb_" + type.upper() + "GRD_ISBL_" + str(
            hpa) + "_latlon.15x.15_" + date + "12_P" + hour + ".grib2")
    downloadFile(
        "https://dd.weather.gc.ca/model_gem_global/15km/grib2/lat_lon/" + when + "/" + hour + "/CMC_glb_" + type.upper() + "GRD_ISBL_" + str(
            hpa) + "_latlon.15x.15_" + date + "12_P" + hour + ".grib2", filename)
    print("start raster")
    os.system('raster2pgsql -t 200x200 -M -a ' + filename + ' > ' + filename + '.sql')
    print("start truncate")
    os.system('sudo -u postgres psql -c "truncate ' + type + str(hpa) + '" -d avia')
    print("start -f")
    os.system('sudo -u postgres psql -f ' + filename + '.sql -d avia')
    print("start recalc")
    os.system('sudo -u postgres psql -c "call recalc1(\'' + type + str(hpa) + '\')" -d avia')
    print("start rm")
    os.system('rm ' + filename)
    os.system('rm ' + filename + '.sql')


hpas = [500, 400, 350, 300, 275, 250, 225, 200, 175, 150, 100]
when = "12"
now = datetime.now()
hour = (now.hour // 3) * 3
if hour < 6:
    when = "12"
    hour = '0' + str(24 + hour)
    now = datetime.today() - timedelta(1)
elif hour < 10:
    hour = '00' + str(hour)
elif hour >= 18:
    when = "12"
    hour = '12' + str(hour)
else:
    hour = '0' + str(hour)
date = now.strftime("%Y%m%d")
print(date)

for hpa in hpas:
    loadHpa(date, "021", hpa, 'u', when)
    loadHpa(date, "021", hpa, 'v', when)

#loadHpa(date, hour, 350, 'u')
#CMC_glb_UGRD_ISBL_500_latlon.15x.15_2022042412_P21.grib2