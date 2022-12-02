library(ggraph)
library(tidygraph)
library(dplyr)
library(tidyr)

edges <- tribble(~from, ~to, ~weighted,
                 "BEL-LUX", "BEL", 0.5,
                 "BEL-LUX", "LUX", 0.5)

nodes <- pivot_longer(edges[, 1:2], from:to, values_to = "country") |>
  distinct(country)

graph <- tidygraph::tbl_graph(nodes = nodes, edges = edges)

## https://mr.schochastics.net/material/netVizR/

graph |>
  ggraph(layout = "tree") +
  geom_node_point(size = 10, color = "grey40") +
  geom_node_text(aes(label = country)) +
  geom_edge_link()  +
  theme_graph()
