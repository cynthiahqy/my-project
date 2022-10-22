library(tibble)
library(dplyr)

df_x <- tribble(~y, ~yend, ~label_y, ~label_yend,
                1, 1.5, "BEL-LUX", "BEL",
                1, 0.5, "BEL-LUX", "LUX",
                2, 2.5, "E.GER", "DEU",
                3, 2.5, "W.GER", "DEU",
                4, 4, "AUS", "AUS") |>
  dplyr::mutate(x = 0, xend = 5,
                   idx = row_number())

ggplot(df_x, aes(x = x, xend = xend, y = y, yend = yend, group = idx)) +
  geom_sigmoid(size = 5) +
  geom_text(aes(label = label_y, x = x - 0.4)) +
  geom_text(aes(x = xend + 0.4, y = yend, label = label_yend))

### add weights & case

df_x |>
  mutate(weight = case_when(label_y == "BEL-LUX" ~ 0.5,
                            TRUE ~ 1)) |>
  mutate(map_case = case_when(weight == 1 ~ "one-to-one",
                              weight < 1 ~ "one-to-many",
                              T ~ "ERROR")) |>
  ggplot(data = _, aes(x = x, xend = xend, y = y, yend = yend, group = idx)) +
  geom_point() +
  geom_sigmoid(aes(size = I(weight), color = map_case)) +
  geom_text(aes(label = label_y, x = x - 0.4)) +
  geom_text(aes(x = xend + 0.4, y = yend, label = label_yend)) +
  theme_minimal_grid(font_size = 14, line_size = 0) +
  theme(legend.position = "bottom",
        panel.grid.major = element_blank())
