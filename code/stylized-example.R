require(Matrix)

## define source (x-to-x) cases
one_to_one <- diag(1, 2, 2)
many_to_one <- matrix(
  c(1, 1, 1, 1, 0, 0,
    0, 0, 0, 0, 1, 1), ncol = 2)
one_to_many <- matrix(
  c(0.5, 0.5, 0, 0, 0, 0, 0, 0.3, 0.3, 0.4), nrow = 2,
  byrow=TRUE
)

## block diagonal sparse matrix // incidence matrix
bdiag_match <- Matrix::bdiag(many_to_one, one_to_one, one_to_many)
dimnames(bdiag_match) <- list(letters[1:nrow(bdiag_match)],
                              LETTERS[1:ncol(bdiag_match)])

## validation check
bdiag_match %*% rep_len(1, ncol(bdiag_match))

## directed bipartite graph
bdiag_graph <- igraph::graph_from_incidence_matrix(bdiag_match,
                                                   directed = TRUE,
                                                   mode = "out",
                                                   weighted = TRUE)
plot(bdiag_graph)

## as panel map
bdiag_pm <- igraph::get.data.frame(bdiag_graph)


## define source (x-to-x) violations
one_to_more <- c(0.5, 0.7)
one_to_less <- c(0.3, 0.8)
to_bad <- bdiag(one_to_one, t(one_to_more), t(one_to_less))
dimnames(to_bad) <- list(letters[1:4], LETTERS[1:6])

## validation check
sum_weights <- to_bad %*% rep_len(1, ncol(to_bad))
sum_bool <- as.vector(sum_weights == 1)
rownames(to_bad[!sum_bool, ])

## additional target (x-from-x) cases
# start with same edges
mix <- bdiag_match
# add new one-to-many row across existing to nodes
one_across_many <- rep_len(0, ncol(bdiag_match))
fracs <- c(0.2, 0.4, 0.4)
one_across_many[1] <- fracs[1]
one_across_many[3] <- fracs[2]
one_across_many[5] <- fracs[3]

mix_mtx <- rbind(bdiag_match, k=one_across_many)

mix_graph <- igraph::graph_from_incidence_matrix(mix_mtx,
                                                 directed = TRUE,
                                                 mode = "out",
                                                 weighted = TRUE)

plot(mix_graph)
ggraph::ggraph(tidygraph::as_tbl_graph(mix_graph))
mix_pm <- igraph::get.data.frame(mix_graph)





