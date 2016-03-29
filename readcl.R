
#preprocess all this shit
df = read.csv("clusters.csv")
df.orig = read.csv("nobackground.csv")
df$cl = df.orig$cluster
df$X <- NULL
require(plyr)
foo <- function(df) {
    f <- function(x) {
        length(unique(x))
    }
    ac = f(df$ac)
    ap = f(df$ap)
    km = f(df$km)
    sc = f(df$sc)
    df.new = data.frame(ac = ac, ap = ap, km = km, sc = sc)
    df.new
}

ddply(df, ~cl, foo)
