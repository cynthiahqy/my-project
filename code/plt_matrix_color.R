require(ggplot2)
b_pm <- b_mtx |>
  as.data.frame.array() |>
  tibble::as_tibble(rownames = "from") |>
  tidyr::pivot_longer(cols=c(-from), values_to="weight", names_to="to")

b_pm |>
  dplyr::mutate(src_case = dplyr::case_when(weight==1 ~ "one-to-one",
                                     weight==0 ~ "NA",
                                     weight < 1 ~ "one-to-many")) |>
  ggplot(aes(x=to, y=from)) +
  geom_tile(aes(fill=src_case), col="grey") +
  #geom_text(data = dplyr::filter(b_pm, weights !=0), aes(label=weights)) +
  scale_y_discrete(limits=rev) +
  scale_fill_brewer() +
  coord_fixed()  +
  labs(x = element_blank(), y = element_blank()) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  ## square gridline
