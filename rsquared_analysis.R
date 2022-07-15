# player_seasons <- tibble(player_season_id = 1:500) %>%
#   tidyr::crossing(sim_id = 1:1000)
# player_seasons <- player_seasons %>% mutate(
#   x = rnorm(nrow(player_seasons), sd = 1),
#   N = round(rnorm(nrow(player_seasons), mean = 500, sd = 50))
# )
# MAX_PLAYS <- player_seasons %$% max(N)
# player_seasons <- player_seasons %>%
#   tidyr::crossing(play_in_season = 1:MAX_PLAYS) %>%
#   filter(play_in_season <= N)
# 
# player_seasons <- player_seasons %>% mutate(y = x + rnorm(nrow(player_seasons), sd = sqrt(500)),
#                                             y2 = x + rnorm(nrow(player_seasons), sd = sqrt(400)))
# player_season_agg <- player_seasons %>% group_by(player_season_id,sim_id,N,x) %>%
#   summarise(y = mean(y), y2 = mean(y2)) %>% ungroup()


player_games <- tibble(player_game_id = 1:(17*500), player_season_id = rep(1:500, each = 17)) %>%
  tidyr::crossing(sim_id = 1:1000) %>% arrange(sim_id, player_season_id, player_game_id)
player_games <- player_games %>% mutate(
  x = rep(rnorm(nrow(player_games)/17, sd = 1), each = 17),
  N = round(rnorm(nrow(player_games), mean = 500/17, sd = 50/17))
)
player_games <- player_games %>% group_by(player_season_id,sim_id) %>% mutate(x0_season = x[1]) %>% ungroup()
MAX_PLAYS <- player_games %$% max(N)
player_games <- player_games %>%
  tidyr::crossing(play_in_game = 1:MAX_PLAYS) %>%
  filter(play_in_game <= N)

player_games <- player_games %>% mutate(y = x + rnorm(nrow(player_games), sd = sqrt(500)),
                                        y2 = x + rnorm(nrow(player_games), sd = sqrt(400)))
player_games_agg <- player_games %>% group_by(player_game_id,sim_id,N,x) %>%
  summarise(y = mean(y), y2 = mean(y2)) %>% ungroup()
player_seasons_agg <- player_games %>% group_by(player_season_id,sim_id,x) %>%
  summarise(N = sum(N), y = mean(y), y2 = mean(y2)) %>% ungroup()

df_r2_seasons <- player_seasons_agg %>% group_by(sim_id) %>%
  summarise(
    r2_500=cor(y,x)^2,
    r2_400=cor(y2,x)^2
  ) %>% ungroup()
df_r2_seasons %$% mean(r2_500)
df_r2_seasons %$% sd(r2_500)
df_r2_seasons %$% mean(r2_500)/df_r2_seasons %$% sd(r2_500)
df_r2_seasons %$% mean(r2_400)
df_r2_seasons %$% sd(r2_400)
df_r2_seasons %$% mean(r2_400)/df_r2_seasons %$% sd(r2_400)
df_r2_seasons %$% mean(r2_500 > r2_400)
df_r2_seasons %$% mean(r2_500 > df_r2_seasons %$% mean(r2_400))

df_r2_games <- player_games_agg %>% group_by(sim_id) %>%
  summarise(
    r2_500=cor(y,x)^2,
    r2_400=cor(y2,x)^2
  ) %>% ungroup()
df_r2_games %$% mean(r2_500)
df_r2_games %$% sd(r2_500)
df_r2_games %$% mean(r2_500)/df_r2_games %$% sd(r2_500)
df_r2_games %$% mean(r2_400)
df_r2_games %$% sd(r2_400)
df_r2_games %$% mean(r2_400)/df_r2_games %$% sd(r2_400)
df_r2_games %$% mean(r2_500 > r2_400)
df_r2_games %$% mean(r2_500 > df_r2_games %$% mean(r2_400))

df_r2_plays <- player_games %>% group_by(sim_id) %>%
  summarise(
    r2_500=cor(y,x)^2,
    r2_400=cor(y2,x)^2
  ) %>% ungroup()
df_r2_plays %$% mean(r2_500)
df_r2_plays %$% sd(r2_500)
df_r2_plays %$% mean(r2_500)/df_r2_plays %$% sd(r2_500)
df_r2_plays %$% mean(r2_400)
df_r2_plays %$% sd(r2_400)
df_r2_plays %$% mean(r2_400)/df_r2_plays %$% sd(r2_400)
df_r2_plays %$% mean(r2_500 > r2_400)
df_r2_plays %$% mean(r2_500 > df_r2_plays %$% mean(r2_400))

a <- df_r2_seasons %>% ggplot() + fte_theme() + theme(legend.position = "top") +
  geom_density(aes(x = r2_500, fill = "500"), alpha = 0.6, color = "black") +
  geom_density(aes(x = r2_400, fill = "400"), alpha = 0.6, color = "black") +
  scale_fill_colorblind(name = "Play-level variance") +
  labs(x = "R^2 value", y = "Density",
       title = "R-squared values come with uncertainty",
       subtitle = "Simulation of R^2 values in 1000 parallel universes of two metrics with different predictive power",
       caption = "Predicted seasons: 5 | Players per season: 100 | Plays per season: 500")
ggsave(glue("../git_repo/public_stuff/viz/r_squared_distribution_season_true.png"),a,dpi = 600, width = 10, height = 6)


a <- df_r2_games %>% ggplot() + fte_theme() + theme(legend.position = "top") +
  geom_density(aes(x = r2_500, fill = "500"), alpha = 0.6, color = "black") +
  geom_density(aes(x = r2_400, fill = "400"), alpha = 0.6, color = "black") +
  scale_fill_colorblind(name = "Play-level variance") +
  labs(x = "R^2 value", y = "Density",
       title = "R-squared values come with less uncertainty on the game-level",
       subtitle = "Simulation of R^2 values in 1000 parallel universes of two metrics with different predictive power",
       caption = "Predicted games: 5*17 | Players per game: 100 | Plays per game: 500/17")
ggsave(glue("../git_repo/public_stuff/viz/r_squared_distribution_game_true.png"),a,dpi = 600, width = 10, height = 6)

a <- df_r2_plays %>% ggplot() + fte_theme() + theme(legend.position = "top") +
  geom_density(aes(x = r2_500, fill = "500"), alpha = 0.6, color = "black") +
  geom_density(aes(x = r2_400, fill = "400"), alpha = 0.6, color = "black") +
  scale_fill_colorblind(name = "Play-level variance") +
  labs(x = "R^2 value", y = "Density",
       title = "R-squared values come with less uncertainty on the play-level",
       subtitle = "Simulation of R^2 values in 1000 parallel universes of two metrics with different predictive power",
       caption = "Predicted plays: 500*500")
ggsave(glue("../git_repo/public_stuff/viz/r_squared_distribution_play_true.png"),a,dpi = 600, width = 10, height = 6)


# player_plays <- tibble(play_id = 1:(500*500)) %>%
#   tidyr::crossing(sim_id = 1:1000)
# player_plays <- player_plays %>% mutate(
#   x = rnorm(nrow(player_plays), sd = 1)
# )
# 
# player_plays <- player_plays %>% mutate(y = x + rnorm(nrow(player_plays), sd = sqrt(500)),
#                                         y2 = x + rnorm(nrow(player_plays), sd = sqrt(400)))

