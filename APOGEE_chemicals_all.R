require(plyr)
require(dplyr)

data <- read.csv("data.csv")

na_report <- function(df) {
    apply(df,2, function(x) mean(is.na(x)))
}
prop_na <- daply(data,~cluster,na_report)

write.csv(prop_na, file = "na_report.csv"simulate.cluster <- function(cluster.mean, cluster.variance, cluster.n) {
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
)

d = data %>%
    group_by(cluster) %>%
    summarize(
        ch.m = mean(ch, na.rm = TRUE),
        nh.m = mean(nh, na.rm = TRUE),
        oh.m = mean(oh, na.rm = TRUE),
        nah.m = mean(nah, na.rm = TRUE),
        mgh.m = mean(mgh, na.rm = TRUE),
        alh.m = mean(alh, na.rm = TRUE),
        sih.m = mean(sih, na.rm = TRUE),
        sh.m = mean(sh, na.rm = TRUE),
        kh.m = mean(kh, na.rm = TRUE),
        cah.m = mean(cah, na.rm = TRUE),
        tih.m = mean(tih, na.rm = TRUE),
        vh.m = mean(vh, na.rm = TRUE),
        mnh.m = mean(mnh, na.rm = TRUE),
        feh.m = mean(feh, na.rm = TRUE),
        nih.m = mean(nih, na.rm = TRUE),
        ch.sd = mean(ch, na.rm = TRUE),
        nh.sd = mean(nh, na.rm = TRUE),
        oh.sd = mean(oh, na.rm = TRUE),
        nah.sd = mean(nah, na.rm = TRUE),
        mgh.sd = mean(mgh, na.rm = TRUE),
        alh.sd = mean(alh, na.rm = TRUE),
        sih.sd = mean(sih, na.rm = TRUE),
        sh.sd = mean(sh, na.rm = TRUE),
        kh.sd = mean(kh, na.rm = TRUE),
        cah.sd = mean(cah, na.rm = TRUE),
        tih.sd = mean(tih, na.rm = TRUE),
        vh.sd = mean(vh, na.rm = TRUE),
        mnh.sd = mean(mnh, na.rm = TRUE),
        feh.sd = mean(feh, na.rm = TRUE),
        nih.sd = mean(nih, na.rm = TRUE)
    )

#write cluster summary
write.csv(d, "cluster_summary.csv")

######PREMIUM DP
require(PReMiuM)
require(reshape2)
require(ggplot2)

#get dataset without background
data_small <- data %>%
    filter(cluster != "background")

##see what kind of outliers we have

#visualize by cluster and response
data_small_long <- melt(data_small, value.name = "value", measure.vars = names(data)[3:17], id.vars = c("cluster","long","lat"))
ggplot(data_small_long, aes(x = value)) + geom_histogram(fill = "white", color = "black") + facet_grid(variable ~ cluster) #TAKES FOREVER

covs <- names(data)[3:17]
a <- profRegr(covNames = covs,
              data = data_small,
              output = "apogee",
              excludeY = TRUE,
              yModel = "Categorical",
              xModel = "Normal",
              varSelectType = "Continuous")
b = calcDissimilarityMatrix(a)
d = calcOptimalClustering(b)
e = calcAvgRiskAndProfile(d)
f = plotRiskProfile(e,"summary.png")

df = data.frame(cbind(d$clustering,data_small$cluster))
names(df) <- c("predicted","real")

ureal <- max(df$real)
upredicted <- max(df$predicted)
counts <- matrix(0,ureal,upredicted)
for (i in 1:nrow(df)) {
    counts[df[i,"real"],df[i,"predicted"]] = counts[df[i,"real"],df[i,"predicted"]] + 1
}
counts


####with outcome
a <- profRegr(covNames = covs,
              outcome = "cluster",
              data = data_small,
              output = "apogee",
              yModel = "Categorical",
              xModel = "Normal")
b = calcDissimilarityMatrix(a)
d = calcOptimalClustering(b)
e = calcAvgRiskAndProfile(d)
f = plotRiskProfile(e,"summary.png")

