# Example of data available
df_data_in <- dplyr::tribble(~source_code, ~value_in,
                             "x1111", 100,
                             "x2222", 30,
                             "x3333", 20,
                             "x4444", 80,
                             "x5555", 30,
                             "x6666", 40,
                             "x7777", 15
)

df_concordance <- dplyr:: tribble(~source_code, ~ target_code,
                                  "x1111", "A1",
                                  "x2222", "B2",
                                  "x2222", "B3",
                                  "x3333", "C5",
                                  "x4444", "C5",
                                  "x5555", "D6",
                                  "x5555", "D7",
                                  "x6666", "D6",
                                  "x6666", "D7",
                                  "x7777", "D6"
)

df_pm <- conformr::make_panel_map_equal(
  code_dict = df_concordance,
  code_in = source_code,
  code_out = target_code,
  .weights_to = "weight")

source("R/pm_to_matrix.R")

df_mtx_long <- df_pm |>
  dplyr::transmute(from = source_code,
                   to = target_code,
                   weight=weight) |>
  pm_to_matrix(to=to, weights=weight) |>
  as.data.frame.array() |>
  tibble::as_tibble(rownames = "from") |>
  tidyr::pivot_longer(cols=c(-from), values_to="weight", names_to="to")

## plots
library(ggplot2)

gg <- df_mtx_long |>
  dplyr::mutate(src_case = dplyr::case_when(weight==1 ~ "one-to-one",
                                            weight==0 ~ "NA",
                                            weight < 1 ~ "one-to-many")) |>
  ggplot(aes(x=to, y=from)) +
  geom_tile(aes(fill=src_case), col="grey") +
  scale_y_discrete(limits=rev) +
  scale_fill_brewer() +
  coord_fixed()  +
  labs(x = element_blank(), y = element_blank(), fill=element_blank()) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("concordance table as matrix") +
  theme(legend.position = "bottom")

gg +
  geom_text(data = dplyr::filter(df_mtx_long, weight !=0), aes(label=weight)) +
  ggtitle("with equal weights added")

## transform data

## --- encode your transformation --- ##
df_pm <-
   read_csv("your-panel-map.csv") |>
   conformr::validate_panel_map()

## --- prepare source data --- ##
df_data_in <-
   read_csv("your-source-data.csv") |>
   drop_na() |>
   conformr::validate_coverage()

## --- apply (valid) transformation --- ##
conformr::use_panel_map(map = df_pm,
                        data = df_data_in,
                        values_from = value_in,
                        from_code = source_code,
                        to_code = target_code,
                        weights = weight,
                        .suffix = "_out")



