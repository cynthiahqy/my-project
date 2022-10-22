library(tidygraph)
library(tidyverse)

## based on: https://www.rpubs.com/Steven_Surya/tidygraph-ggraph
## based on: https://dgarcia-eu.github.io/SocialDataScience/4_SNA/045_Tidygraph/tidygraph.html

edges <- tribble(~from, ~to, ~weighted,
                 "BEL-LUX", "BEL", 0.5,
                 "BEL-LUX", "LUX", 0.5)

nodes <- pivot_longer(edges[, 1:2], from:to, values_to = "country") |>
  distinct(country)

graph <- tidygraph::tbl_graph(nodes = nodes, edges = edges)

plot(graph)
