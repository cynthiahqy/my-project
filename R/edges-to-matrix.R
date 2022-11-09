source("R/edges.R")

## matrix
edges_wide <- edges |>
  tidyr::pivot_wider(names_from=to, values_from=weighted)
mtx_rows <- nrow(edges_wide)
mtx <-
  edges_wide[, -1] |>
  data.table::nafill(fill=0) |>
  unlist() |>
  matrix(nrow=mtx_rows)
dimnames(mtx) <- list(edges_wide$from, names(edges_wide[, -1]))

return(mtx)
