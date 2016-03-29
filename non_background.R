require(dplyr)
df = read.csv("data.csv")
df.new <- df %>%
    filter(cluster != "background")
write.csv(df.new, "nobackground.csv")
