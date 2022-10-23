# https://jtr13.github.io/cc21fall2/ggalluvial-cheatsheet.html

library(dplyr)
library(ggplot2)
library(ggalluvial)
df <- data.frame(from = c("A","B","C","A","A","A","B"),
                 to = c("X","X","X","Y","Y","Y","Y"),
                 #x3 = c("1","2","3","3","3","3","3"),
                 #Freq = c(1,2,3,4,5,6,7)
                 freq = rep(1, 7)
                 )

ggplot(df, aes(axis1 = from, axis2 = to, y = freq)) +
  geom_alluvium() +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = paste(after_stat(stratum))))

df_ctr <- tibble::tribble(~from, ~to, ~weighted,
                          "BLX", "BEL", 0.5,
                          "BLX", "LUX", 0.5,
                          "E.GER", "DEU", 1,
                          "W.GER", "DEU", 1,
                          "AUS", "AUS", 1) |>
  mutate(freq = 1)

ggplot(df_ctr, aes(axis1 = from, axis2 = to, y = freq)) +
  geom_alluvium(curve_type = "linear", colour = "blue") +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = paste(after_stat(stratum))))

ggsave("ggalluvial.png")
