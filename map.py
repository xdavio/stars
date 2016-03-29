import pandas as pd
import numpy as np
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
import copy


#from latlong.latlong import distance_on_sphere_numpy as dist

def no_unique(cl):
    return len(unique(cl))

###read data
df = pd.read_csv('nobackground.csv')
df = df.iloc[:,2:]
dfun = df.iloc[:,range(df.shape[1]-1)] #unsupervised

###imput missing values with median
#nimp = Imputer(strategy = 'median')
##dfun = imp.fit_transform(dfun)

#nearest neighbors
ll = dfun.iloc[:,0:2] #latlong
#conn = kg(ll, n_neighbors = 200, include_self = False, mode = 'distance')
ll = np.array(ll, dtype = np.float32)

#conn = dist(ll)
fig = plt.figure()

themap = Basemap(projection='gall',
              llcrnrlon = -300,              # lower-left corner longitude
              llcrnrlat = -90,               # lower-left corner latitude
              urcrnrlon = 100,               # upper-right corner longitude
              urcrnrlat = 90,               # upper-right corner latitude
              resolution = 'l',
              area_thresh = 100000.0,
              )

themap.drawcoastlines()
themap.drawcountries()
themap.fillcontinents(color = 'gainsboro')
themap.drawmapboundary(fill_color='steelblue')

x, y = themap(ll[:,0],ll[:,1])
themap.plot(x, y, 
            'o',                    # marker shape
            color='Indigo',         # marker colour
            markersize=4            # marker size
            )

#plt.show()
fig.savefig("fig.pdf")
#plt.savefig("fig.pdf")


