require(plyr)
require(dplyr)
require(mvtnorm)
require(corpcor)
require(ggplot2)

data.cols <- c("ch","nh","oh","nah","mgh","alh","sih","sh","kh","cah","tih","vh","mnh","feh","nih")
data <- read.csv("data.csv") #NAs have already been created form -9999

#get cluster names
clusters = as.character(clusters)

stripna <- function(row) {
    if (sum(is.na(row)) > 0) {
        TRUE
    } else {
        FALSE
    }
}
data.na = data
data.na$na = apply(data,1,stripna)
#data.nona = data[data.na$na == FALSE,]
data = data[data.na$na == FALSE,]

clus_summary = data %>%
    group_by(cluster) %>%
    summarize(n = n()) %>%
    arrange(desc(n))

#M3 or M5
m3 = data %>%
    filter(cluster == "M3")

m5 = data %>%
    filter(cluster == "M5")


m3.mean = apply(m3[,data.cols],2,function(x) mean(x, na.rm=TRUE))
m5.mean = apply(m5[,data.cols],2,function(x) mean(x, na.rm=TRUE))

#m3.cov = var(m3[,data.cols], na.rm = TRUE)
#m5.cov = var(m5[,data.cols], na.rm = TRUE)
m3.cov = cov.shrink(m3[,data.cols])
m5.cov = cov.shrink(m5[,data.cols])


get.info.by.cluster <- function(df, clustername) {
    df.new = data %>%
        filter(cluster == clustername)

    m = apply(df.new[,data.cols],2,function(x) mean(x, na.rm=TRUE))
    cov = cov.shrink(df[,data.cols])
    l = list(mean = m, covariance = cov)
    l
}

##not tested
simulate.cluster <- function(cluster.mean, cluster.variance, cluster.n) {
    # if cluster.n is a string named cluster, then this function will use the original sample size of the cluster instead of the supplied sample size.
    if (is.numeric(cluster.n) == FALSE) {
        #refers to global
        if (sum( cluster.n == clusters ) == 1) {
            selected.cluster = clusters[which(clusters == cluster.n)]
            d = data %>%
                select(cluster == selected.cluster) %>%
                summarize(n = n())
            cluster.n = d$n
        }
    }
    m3.rand = rmvnorm(cluster.n, mean = cluster.mean, sigma = cluster.variance)
}

n = 1000
m3.rand = rmvnorm(1000, mean = m3.mean, sigma = m3.cov)
m5.rand = rmvnorm(1000, mean = m5.mean, sigma = m5.cov)
output = rbind(m3.rand, m5.rand)
save(output, file = "simclusters.Rdata")

pr = princomp(output)
#kmeans(pr)
pr.red = pr$scores[,1:2]
pr.red = data.frame(pr.red)
pr.red$clus = c(rep("m3",1000),rep("m5",1000))

ggplot(pr.red,aes(x = Comp.1, y = Comp.2, color = clus)) + geom_point()


k = kmeans(pr.red[,c(1,2)], 2)
pr.red$kmeans =  k$cluster
ggplot(pr.red,aes(x = Comp.1, y = Comp.2, color = kmeans)) + geom_point()
