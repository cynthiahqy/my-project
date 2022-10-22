## based on: https://github.com/davidsjoberg/ggbump#tutorial

library(ggbump)

df <- tibble(country = c("India", "India", "India", "Sweden", "Sweden", "Sweden", "Germany", "Germany", "Germany", "Finland", "Finland", "Finland"),
             year = c(2011, 2012, 2013, 2011, 2012, 2013, 2011, 2012, 2013, 2011, 2012, 2013),
             value = c(492, 246, 246, 369, 123, 492, 246, 369, 123, 123, 492, 369))

df_rank <- df %>%
  group_by(year) %>%
  mutate(rank = rank(value, ties.method = "random")) %>%
  ungroup()

ggplot(df_rank, aes(year, rank, color = country)) +
  geom_bump()

df_edit <- edit(df_rank)

ggplot(df_edit, aes(year, rank, color = country)) +
  geom_bump()

## styling

if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, cowplot, wesanderson)

ggplot(df_rank, aes(year, rank, color = country)) +
  geom_point(size=7) +
  geom_bump(size=2, smooth = 10) +
  # start and end labels
  geom_text(data = filter(df_rank, year == min(year)),
            aes(x = year - .1, label = country), size = 5, hjust = 1) +
  geom_text(data = filter(df_rank, year == max(year)),
            aes(x = year + .1, label = country), size = 5, hjust = 0) +
  # add padding for labels
  scale_x_continuous(limits = c(2010.6, 2013.4),
                     breaks = seq(2011, 2013, 1)) +
  labs(y = "RANK", x = NULL) +
  scale_y_reverse() +
  ## remove background grid and modify colour palette
  theme_minimal_grid(font_size = 14, line_size = 0) +
  theme(legend.position = "none",
        panel.grid.major = element_blank()) +
  scale_color_manual(values = wes_palette(n = 4, name = "GrandBudapest2"))


