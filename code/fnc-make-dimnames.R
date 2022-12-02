make_dimnames <- function(mtx){
  list(letters[1:nrow(mtx)],
       paste0(LETTERS[1:ncol(mtx)], LETTERS[1:ncol(mtx)]))
}
