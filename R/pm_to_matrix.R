pm_to_matrix <- function(pm, to, weights){
  edges_wide <- pm |>
    tidyr::pivot_wider(names_from={{to}}, values_from={{weights}})
  mtx_rows <- nrow(edges_wide)
  mtx <-
    edges_wide[, -1] |>
    data.table::nafill(fill=0) |>
    unlist() |>
    Matrix::Matrix(nrow=mtx_rows)
  dimnames(mtx) <- list(edges_wide$from, names(edges_wide[, -1]))

  return(mtx)
}
