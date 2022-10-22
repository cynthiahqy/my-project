pacman::p_load(tibble, dplyr, tidyr, ggplot2, ggbump)

edges <- tribble(~from, ~to, ~weighted,
                 "BLX", "BEL", 0.5,
                 "BLX", "LUX", 0.5,
                 "E.GER", "DEU", 1,
                 "W.GER", "DEU", 1,
                 "AUS", "AUS", 1)

nodes <- pivot_longer(edges[, 1:2], from:to, values_to = "country") |>
  distinct(country)

## calculate positions for nodes
from_nodes <- distinct(edges, from) |> mutate(from_y = row_number())
to_nodes <- distinct(edges, to) |> mutate(to_y = row_number() - 1 + 0.5)

## generate df for ggplot
df <- edges |> group_by(from) |> mutate(n_dest = n()) |>
  ungroup() |>
  group_by(to) |> mutate(n_origin = n()) |>
  ungroup() |>
  mutate(value_case = case_when(n_dest == 1 ~ "one-to-one",
                               n_dest > 1 ~ "one-to-many")) |>
  left_join(tribble(~value_case, ~line_type,
                    "one-to-one", "solid",
                    "one-to-many", "dashed"),
            by = "value_case") |>
  mutate(map_case = case_when(n_origin > 1 & n_dest > 1 ~ "many-from-many",
                              n_origin == 1 & n_dest > 1 ~ "many-from-one",
                              n_origin > 1 & n_dest == 1 ~ "one-from-many",
                              n_origin == 1 & n_dest == 1 ~ "one-from-one")) |>
  ## add y-coordinates
  left_join(from_nodes, by = "from") |>
  left_join(to_nodes, by = "to") |>
  ## add x-coordinates
  mutate(from_x = 0,
         to_x = 5) |>
  ## give each from-out instruction a unique id
  mutate(idx = row_number())

plt_uw <- df |>
  ggplot(aes(x = from_x, xend = to_x, y = from_y, yend = to_y, group = idx)) +
  geom_sigmoid(aes(linetype = I(line_type))) +
  scale_y_reverse() +
  geom_text(aes(x = from_x - 0.5, label=from)) +
  geom_label(aes(x = to_x + 0.5, y = to_y, label=to, fill  = map_case)) +
  scale_fill_manual(values = wesanderson::wes_palette(n = 4, name = "GrandBudapest2")) +
  cowplot::theme_minimal_grid(font_size = 14, line_size = 0) +
  theme(legend.position = "bottom",
        panel.grid.major = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_blank(),
        plot.background = element_rect(fill = "white")) +
  labs(x = NULL, y = NULL, fill = "Output Relation")

plt_uw +
  geom_label(data = filter(df, value_case == "one-to-many"),
             aes(x = (((from_x + to_x) / 2) + to_x) / 2,
                y = to_y,
                label = weighted)) +
  geom_label(data = filter(df, value_case == "one-to-one"),
             aes(x = (from_x + to_x) / 4,
                 y = from_y,
                 label = weighted))

ggsave("ggbump-sigmoid-graph-edges.jpg", dpi=1000)
