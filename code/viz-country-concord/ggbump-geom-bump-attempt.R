df_rank <- tribble(
  ~code_in, ~scheme, ~code_out, ~rank,
  "BEL-LUX", 10, "LUX", 3,
  "BEL-LUX", 10, "BEL", 1,
  "BEL-LUX", 0,   "BEL",2,
  "BEL-LUX", 0,   "LUX",2,
  "E.GER", 0, "DEU", 4,
  "W.GER", 0, "DEU", 5,
  "E.GER", 10, "DEU", 4.5,
  "W.GER", 10, "DEU", 4.5,
  "AUS", 0, "AUS", 3.5,
  "AUS", 10, "AUS", 3.5
)

ggplot(df_rank, aes(scheme, rank, color = code_out, group=code_in)) +
  geom_bump() +
  geom_point(size=5) +
  ## remove background grid
  theme_minimal_grid(font_size = 14, line_size = 0) +
  theme(legend.position = "none",
        panel.grid.major = element_blank()) +
  geom_text(data = filter(df_rank, scheme == min(scheme)),
            aes(x = scheme - .1, label = code_in), size = 5, hjust = 1) +
  geom_text(data = filter(df_rank, scheme == max(scheme)),
            aes(x = scheme + .1, label = code_out), size = 5, hjust = 0)
