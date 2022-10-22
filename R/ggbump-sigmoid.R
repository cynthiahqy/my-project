## https://github.com/davidsjoberg/ggbump/wiki/geom_sigmoid

pacman::p_load(ggplot2, tibble, dplyr, hablar, ggbump, patchwork)

df_x <- tibble(
  yend = c(2,2,4,4,4),
  y = 1:5,
  xend = 3,
  x = 0,
  group = c("Flour", "Milk", "Eggs", "Salt", "Butter")
)

p1 <- ggplot(df_x) +
  geom_sigmoid(aes(x = x, y = y, xend = xend, yend = yend, group = factor(group)),
               direction = "x", color = "white", size = 1.2, smooth = 6) +
  geom_text(aes(x = x, y = y, label = group), size = 6, nudge_x = -.05, color = "white", hjust = 1) +
  geom_label(data = tibble(x = 3, y = 2, label = "pancakes"),
             aes(x, y, label = label), inherit.aes = F, size = 8, color = "steelblue", fill = "white", fontface = "bold") +
  geom_label(data = tibble(x = 3, y = 4, label = "omlette"),
             aes(x, y, label = label), inherit.aes = F, size = 8, color = "steelblue", fill = "white", fontface = "bold") +
  coord_cartesian(clip = "off") +
  scale_y_reverse() +
  theme_void() +
  theme(panel.background = element_rect(fill = "steelblue", color = "transparent"),
        plot.background = element_rect(fill = "steelblue", color = "transparent"),
        plot.margin = margin(1, 2.5, 1, 1.5, "cm"))

p1
