library(ggsankey)
library(dplyr)
library(ggplot2)

df <- mtcars %>%
  make_long(cyl, vs)

ggplot(df, aes(x = x,
               next_x = next_x,
               node = node,
               next_node = next_node,
               fill = factor(node))) +
  geom_sankey()

## ctr

edges <- tribble(~from, ~to, ~weighted,
                 "BLX", "BEL", 0.5,
                 "BLX", "LUX", 0.5,
                 "E.GER", "DEU", 1,
                 "W.GER", "DEU", 1,
                 "AUS", "AUS", 1)

df_ctr <- edges %>%
  make_long(from, to, value = weighted)

df_ctr %>%
  ggplot(., aes(x = x,
                next_x = next_x,
                node = node,
                next_node = next_node,
                fill = factor(node),
                label = node,
                value = value
                )) +
  geom_sankey(space = 0.2) +
  geom_sankey_label(color = "white", fill = "gray40") +
  scale_fill_viridis_d()

ggsave("ggsankey.png")
