import pandas as pd
import numpy as np
import copy
from sklearn.externals import joblib
from sklearn.cluster import KMeans, DBSCAN, AffinityPropagation, SpectralClustering, AgglomerativeClustering, Birch
from sklearn.preprocessing import Imputer
from sklearn.neighbors import kneighbors_graph as kg

from latlong.latlong import distance_on_sphere_numpy as dist

CLNO = 21

def no_unique(cl):
    return len(unique(cl))



###read data
df = pd.read_csv('nobackground.csv')
df = df.iloc[:,2:]
dfun = copy.copy(df.iloc[:,range(df.shape[1]-1)]) #unsupervised

###imput missing values with median
imp = Imputer(strategy = 'median')
dfun = imp.fit_transform(dfun)

#nearest neighbors
ll = copy.copy(dfun[:,0:2]) #latlong
#conn = kg(ll, n_neighbors = 200, include_self = False, mode = 'distance')

conn = dist(ll)
conn[isnan(conn)] = 100
conn = conn / 10000.


#strip ll out of dfun
dfun = dfun[:,2:]

#kmeans
km = KMeans(n_clusters = CLNO)
km_fit = km.fit(dfun)
km_clusters = km.labels_.tolist()
print no_unique(km_clusters)

#affinity propagation
ap = AffinityPropagation()
ap_fit = ap.fit(dfun)
ap_clusters = ap.labels_.tolist()
print no_unique(ap_clusters)

#spectral clustering
sc = SpectralClustering(CLNO)
sc_fit = sc.fit(dfun)
sc_clusters = sc.labels_.tolist()
print "spectral", no_unique(sc_clusters)

#ward

ac = AgglomerativeClustering(CLNO, connectivity = conn, linkage = 'ward')
ac_fit = ac.fit(dfun)
ac_clusters = ac.labels_.tolist()
print no_unique(ac_clusters)

#output pd
data = {"km":km_clusters, "ap":ap_clusters, "sc":sc_clusters, "ac":ac_clusters}
df_cl = pd.DataFrame(data = data)
df_cl.to_csv("clusters.csv")


