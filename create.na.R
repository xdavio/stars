#creates NA from -9999 and saves as data.csv

data <- read.csv("APOGEE_chemicals_all.csv")
names(data) <- c("long","lat","ch","nh","oh","nah","mgh","alh","sih","sh","kh","cah","tih","vh","mnh","feh","nih","cluster")
levels(data$cluster) <- as.vector(sapply(levels(data$cluster), function(x) unlist(strsplit(x, " "))[2]))
data[data==-9999] <- NA #make the NAs show up correctly

write.csv(data, file = "data.csv")
