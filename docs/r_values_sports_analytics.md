# About R(-squared) values in American football analytics

## Introduction

My name is Timo Riske and I've actively been doing American football analytics since 2017 and I've been a data scientist for PFF since 2019. Many of you probably know me only (if at all) through my work in football that I present on my twitter account [@PFF_Moo](https://twitter.com/PFF_Moo) or at [PFF](https://pff.com). In fact, my academic background is more of a theoretic nature, as I've graduated in commutative algebra and algebraic geometry. The following article is about practicing in football and sports analytics, but it's too theoretical for an article about football on my employer's site, hence I'm publishing it through GitHub.

If you're practicing sports analytics, and that's especially true for American football analytics, and have talked to other stats people about models that try to predict future performance with past information, you might have heard the following response: "All I see is dramatically low R-squared values, nothing of this means anything".

Indeed, predictive models on a play-level often come with a R-squared value in the range of only `0.01` or even lower. This sounds ridiculously low compared to the models you considered in university. Thus...this person is right and your work is useless and bad?

Here is the thing: This person couldn't be more wrong. This person was either not paying attention or understands less about stats than he/she might think.

To elaborate on this, we will talk about the relationship between R-squared values on the play-, game- and season-level. Imagine you've developed to a metric to evaluate a wide receiver and you want to use this metric to predict what happens on a given play. Ideally, you choose something tangible, something which matters as the target metric. Given that we chose wide receivers for our thought experiment, think about earning a target, catching a ball or the amount of yards caught on that route. For pass rushers, this could be generating pressure or a sack, for quarterbacks it could be generating EPA or avoiding a sack and for linebackers it could be making a stop in the run game. Which R-squared values can you expect when predicting such a target metric?

There is definitely an upper bound for R-squared values on the season-level, as findings in NFL analytics have shown that it is very rare to even get to a R-squared value of `0.5` when predicting performance. First of all there is always natural variance when it comes to the performance of a human being and that's even true in sports in which the individual success of a participant depends almost only on that individual's skill and form on the day, such as track & field or skiing. Now, we have to consider that football is a much more complex sport in which an individual player's success also depends on his teammates, his opponents, the scheme he is playing in, the chess match between his and his opponent's coaches and other factors not in his control. Nowadays, with tracking and charting data being available, we can partially account for these things, but here are some simple truths that can never be broken:

* Opponent adjustments on the player level are possible by now, we understand a lot about how teammates can help each other's statistics on the field and we can even describe how coaches can influence a player's performance, but we will never be able to *fully* disentangle a player from his surroundings, that is his opponents, his teammates and the scheme of the offense and defense. All of this leads to further variance in performance of the same player.
* Even if we could fully disentangle a player from his surroundings, it's notable that his surroundings are also subject to natural variance, enhancing the effect of the natural variance of the player himself.

Hence, while it's certainly possible to asymptotically increase the R-squared values of performance-predicting models, there is definitely an upper bound we cannot break through. And this bound is probably lower than we wished it were. The good news: This doesn't mean that analytics is useless when it comes to player evaluation. NFL teams, coaches and general managers get evaluations wrong all the time when it comes to predicting future production. A well-known finding in American football is that a drafted player is better than the next-drafted player at the same position at a rate of only `53%`, just a tad better than a coin flip. And even for players with at least a four-year sample size in the NFL (which is usually the case for free agents), teams get it wrong fairly often, as indicated by expensive players with mediocre production or by cheap players with good production (in which case all other 31 teams got the evaluation wrong).

**Always remember: The goal of analytics isn't to be perfect, the goal of analytics is to improve upon the decisions/evaluations that are made without an analytical framework.**

After coming to grips with the fact that we will always deal with fairly low R-squared values on the season-level, what does this mean for the game- or even play-level?

It's notable that the R-squared value of a linear model ![equation](https://latex.codecogs.com/png.latex?Y={\alpha}X+\beta+E) is obviously related to the residual variance ![equation](https://latex.codecogs.com/png.latex?\operatorname{Var}(E)=\operatorname{Var}(Y-{\alpha}X-\beta)). This is easily seen through the definition. Note that the R-squared value is independent of linear re-scaling, hence we can assume ![equation](https://latex.codecogs.com/png.latex?\alpha=1) and ![equation](https://latex.codecogs.com/png.latex?\beta=0). By defintion, we have

![equation](https://latex.codecogs.com/png.latex?R^2=1-\frac{\sum\limits_{i}(y_i-x_i)^2}{\sum\limits_{i}(y_i-\overline{y})^2})

With `E = Y-X`, note that the numerator is `N * Var(E)` and the denominator is `N * Var(Y)` (with `N` being the number of observations), hence we get

![equation](https://latex.codecogs.com/png.latex?R^2=1-\frac{\operatorname{Var}(E)}{\operatorname{Var}(Y)}.)

For the sake of normalization, let's assume ![equation](https://latex.codecogs.com/png.latex?\operatorname{Var}(X)=1) (again, linear re-scaling doesn't change the R-squared value) and define ![equation](https://latex.codecogs.com/png.latex?\operatorname{Var}(E)=\sigma^2.) 

We obtain (assuming the residuals are independent of `X`, which is one of the basic assumptions for the usability of a linear model)

![equation](https://latex.codecogs.com/png.latex?R^2=1-\frac{\operatorname{Var}(E)}{\operatorname{Var}(Y)}=1-\frac{\sigma^2}{1+\sigma^2}=\frac{1+\sigma^2-\sigma^2}{1+\sigma^2}=\frac{1}{1+\sigma^2})

This essentially means that after linearly re-scaling `X` and `Y` such that ![equation](https://latex.codecogs.com/png.latex?\alpha=1), ![equation](https://latex.codecogs.com/png.latex?\beta=0) and ![equation](https://latex.codecogs.com/png.latex?\operatorname{Var}(X)=1) hold, the R-squared value can immediately be derived from only the residual variance. In particular, the R-squared value increases asymptotically towards `1` when the residual variance approaches zero and it approaches zero when the residual variances becomes large.

We can test this formula in R. To get back to football, there are roughly 20,000 passing plays per season, thus there are run roughly 60,000 wide receiver routes (11 personnel being dominant in today's game). Assume you have developed a wide receiver metric, standardized it to z-scores (thus `X` is centered around zero and has variance `1`) and predict yards gained on a route run. The following R code is a simplification of your data on the play-level for one season with a hypothetical play-level residual variance of `100`. According to our computations, it should lead to a R-squared value of `1/101` or roughly `0.01`.

```r
x <- rnorm(60*10^3, sd = 1)
y <- x + rnorm(length(x), sd = 10)
lm(y ~ x) %>% summary
```
And indeed...

```
Call:
lm(formula = y ~ x)

Residuals:
    Min      1Q  Median      3Q     Max 
-42.004  -6.719  -0.002   6.784  40.261 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.04242    0.04102   1.034    0.301    
x            0.97874    0.04070  24.049   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 10.05 on 59998 degrees of freedom
Multiple R-squared:  0.009548,	Adjusted R-squared:  0.009531 
F-statistic: 578.4 on 1 and 59998 DF,  p-value: < 2.2e-16
```

Note that our computation didn't depend on the residuals being normally distributed, they could even be discrete (Think of predicting a sack/pressure).

```r
x <- rnorm(60*10^3, sd = 1)
y <- x + 2*rbinom(length(x), size = 1, prob = 0.5)
lm(y ~ x) %>% summary
```
The residual term has a variance of `1`, hence we expect an R-squared value of `1/2` and indeed...

```
Call:
lm(formula = y ~ x)

Residuals:
    Min      1Q  Median      3Q     Max 
-1.0019 -0.9981 -0.9953  1.0019  1.0056 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 0.998134   0.004083   244.5   <2e-16 ***
x           0.999009   0.004094   244.0   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1 on 59998 degrees of freedom
Multiple R-squared:  0.4981,	Adjusted R-squared:  0.4981 
F-statistic: 5.954e+04 on 1 and 59998 DF,  p-value: < 2.2e-16
```

We've learned that if the predictors come with constant variance (which is usually roughly the case), the R-squared value is just a codified version of the residual variance, scaled by scalars inherent to the model like the variance of the predictors as well as the size of the linear coefficients. What happens with variance if we repeat a random experiment multiple times? It get's smaller. How is this to be understood in a precise way and how is it derived mathematically?

We have a random variable `T` with real values and observe it `n` times in an indepenent way and build the mean of the observations, in other words we consider a new random variable ![equation](https://latex.codecogs.com/png.latex?\frac{\sum_i^nT_i}{n}) with the `T_i` being i.i.d copies of `T`. Let's compute the variance, using the independency assumption:

![equation](https://latex.codecogs.com/png.latex?\operatorname{Var}\left(\frac{\sum\limits_{i=1}^nT_i}{n}\right)=\frac{\sum\limits_{i=1}^n\operatorname{Var}(T_i)}{n^2}=\frac{n\operatorname{Var}(T)}{n^2}=\frac{\operatorname{Var}(T)}{n}.)

This is what we mean when we say that variance gets smaller with a larger sample size. We actually mean that the variance of the mean observation gets smaller (by the factor `1/n`).

In football terms, assume a wide receiver's true skill level is `X_0` and the residual variance when predicting the metric of interest `Y` on the play-level is ![equation](https://latex.codecogs.com/png.latex?\sigma^2). As we've already established, we can assume ![equation](https://latex.codecogs.com/png.latex?Y=X_0+E) with ![equation](https://latex.codecogs.com/png.latex?\operatorname{Var}(E)=\sigma^2.)

If said wide-receiver plays `n` snaps (in a game or in a season) and we observe ![equation](https://latex.codecogs.com/png.latex?Y_1,\dots,Y_n) as i.i.d copies of `Y`, we obtain (note that `X_0` is a scalar):

![equation](https://latex.codecogs.com/png.latex?\left(\frac{\sum\limits_{i=1}^nY_i}{n}\right)=X_0+\frac{\sum\limits_{i=1}^nE_i}{n}.)

This shows that the residual variance of the mean of `Y` over the `n` snaps is

![equation](https://latex.codecogs.com/png.latex?\operatorname{Var}\left(\frac{\sum\limits_{i=1}^nE_i}{n}\right)=\frac{\operatorname{Var}(E)}{n}=\frac{\sigma^2}{n})

and the R-squared value when predicting this mean will be

![equation](https://latex.codecogs.com/png.latex?R^2=\frac{1}{1+\frac{\sigma^2}{n}}=\frac{n}{n+\sigma^2}.)

No matter how large ![equation](https://latex.codecogs.com/png.latex?\operatorname{Var}(E)=\sigma^2.), this will eventually approach `1` when `n` becomes large enough. Obviously, this is not happening in practice, so the practice, of course, violates an assumption we made and that's the independency of the residuals as well as the fixed nature of `X_0`. Over the course of a season or even a longer timeframe, our understanding of a player's ability changes and so does the true ability itself through development, aging or injuries (think of playing banged up). Obviously, a change of a player's ability will cause the residuals to change in a systematic way (instead of independently), thus the independency assumption is hurt. Changings to a player's surroundings (change of quarterback, change of role or just the change of the opposing cornerback from game to game) will also cause the residuals not to be perfectly independent.

Before accounting for this issue, let us verify our formula nevertheless. Since we are considering wide receivers and 11 personnel dominates the NFL nowadays, we have a sample of roughly 100 players per season and let's assume we have ten seasons of data, i.e. `1000` player season worth of data. Assuming that a player's ability didn't change over the course of a season, here is code which simulates how our data would looke like if we loosely assume the sample size for each season is a normal distribution around `500`:

```r
player_seasons <- tibble(player_season_id = 1:1000,
			 x = rnorm(1000, sd = 1),
			 N = round(rnorm(1000, mean = 500, sd = 50))) %>%
		  tidyr::crossing(play_in_season = 1:5000) %>%
		  filter(play_in_season <= N)
				  
player_seasons <- player_seasons %>% mutate(y = x + rnorm(nrow(player_seasons), sd = 10))
player_season_agg <- player_seasons %>% group_by(player_season_id,N,x) %>%
					summarise(y = mean(y)) %>% ungroup()
lm(data = player_season_agg, y ~ x) %>% summary
```

The residual variance on the play-level is `100` hence - with an average of `500` plays per season - , we expect on R-squared value of `500/(500 + 100) = 5/6 = 0.833...` and indeed...


```
Call:
lm(formula = y ~ x, data = player_season_agg)

Residuals:
     Min       1Q   Median       3Q      Max 
-1.43097 -0.31278 -0.00408  0.30525  1.33517 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 0.009052   0.014326   0.632    0.528    
x           0.988144   0.014092  70.122   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.4529 on 998 degrees of freedom
Multiple R-squared:  0.8313,	Adjusted R-squared:  0.8311 
F-statistic:  4917 on 1 and 998 DF,  p-value: < 2.2e-16
```

Let's use a play-by-play residual variance of `500` (leading to a play-level R-squared of `~0.002`).

```r
player_seasons <- tibble(player_season_id = 1:1000,
		         x = rnorm(1000, sd = 1),
			 N = round(rnorm(1000, mean = 500, sd = 50))) %>%
		  tidyr::crossing(play_in_season = 1:5000) %>%
		  filter(play_in_season <= N)
				  
player_seasons <- player_seasons %>% mutate(y = x + rnorm(nrow(player_seasons), sd = sqrt(500)))
player_season_agg <- player_seasons %>% group_by(player_season_id,N,x) %>%
                     summarise(y = mean(y)) %>% ungroup()
lm(data = player_season_agg, y ~ x) %>% summary
```

Our expected R-squared on the season level is `500/(500 + 500) = 0.5` and indeed...

```
Call:
lm(formula = y ~ x, data = player_season_agg)

Residuals:
    Min      1Q  Median      3Q     Max 
-3.5601 -0.6955  0.0235  0.7153  3.2148 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.05037    0.03324   1.515     0.13    
x            1.04986    0.03263  32.174   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1.051 on 998 degrees of freedom
Multiple R-squared:  0.5091,	Adjusted R-squared:  0.5087 
F-statistic:  1035 on 1 and 998 DF,  p-value: < 2.2e-16
```

Now let us investigate what happens if we acknowledge that `X` changes over time throughout the season in a random, but non-independent way. We do that by randomly assigning a variable `season_tendency` to each player season. After each play, we randomly shift his prior (`X`) in the direction of this tendency and we also skew the residuals by making them centered around this tendency instead of zero. In other words, over the course of the season some players get better than we initially thought (`X_0`) and some players get worse than we initially thought. The magnitude of the `season_tendency` variable is chosen such that the extreme cases improve or get worse by roughly a standard deviation over the course of a season.

Finally, we, of course, predict the mean observation of each player with just the initial prior `X_0`, because that's the information we had prior to the season.

```r
player_seasons <- tibble(player_season_id = 1:1000,
                         x0 = rnorm(1000, sd = 1),
			 season_tendency = rnorm(1000, sd = 0.4),
                         N = round(rnorm(1000, mean = 500, sd = 50))) %>%
		  tidyr::crossing(play_in_season = 1:5000) %>%
		  filter(play_in_season <= N)

player_seasons <- player_seasons %>% group_by(player_season_id) %>%
                  mutate(x = lag(x0) + rnorm(n(), mean = season_tendency, sd = 0.05)) %>%
		  mutate(x = ifelse(is.na(x), x0, x)) %>%
		  mutate(x_final = last(x)) %>%
		  ungroup()
				  
player_seasons %>% filter(play_in_season==1) %>%
     ggplot(aes(x = x_final - x0)) +
     geom_histogram()

player_seasons <- player_seasons %>% mutate(y = x + rnorm(nrow(player_seasons),
                                                          mean = season_tendency,
							  sd = sqrt(500)))
player_seasons_agg <- player_seasons %>%
                      group_by(player_season_id,N,x0,x_final) %>%
		      summarise(y = mean(y)) %>% ungroup()
lm(data = player_seasons_agg, y ~ x0) %>% summary
```

```
Call:
lm(formula = y ~ x0, data = player_season_agg)

Residuals:
    Min      1Q  Median      3Q     Max 
-4.0583 -0.9149 -0.0277  0.9275  4.5650 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.07089    0.04261   1.664   0.0965 .  
x0           0.96485    0.04283  22.527   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1.347 on 998 degrees of freedom
Multiple R-squared:  0.3371,	Adjusted R-squared:  0.3364 
F-statistic: 507.5 on 1 and 998 DF,  p-value: < 2.2e-16
```

We miss the theoretical mark of `0.5`.

Let's simulate three seasons, i.e. `1500` plays.


```r
player_seasons <- tibble(player_season_id = 1:1000,
                         x0 = rnorm(1000, sd = 1),
			 season_tendency = rnorm(1000, sd = 0.4),
                         N = round(rnorm(1000, mean = 1500, sd = 50))) %>%
		  tidyr::crossing(play_in_season = 1:5000) %>%
		  filter(play_in_season <= N)

player_seasons <- player_seasons %>% group_by(player_season_id) %>%
                  mutate(x = lag(x0) + rnorm(n(), mean = season_tendency, sd = 0.05)) %>%
		  mutate(x = ifelse(is.na(x), x0, x)) %>%
		  mutate(x_final = last(x)) %>%
		  ungroup()
				  
player_seasons %>% filter(play_in_season==1) %>%
     ggplot(aes(x = x_final - x0)) +
     geom_histogram()

player_seasons <- player_seasons %>% mutate(y = x + rnorm(nrow(player_seasons),
                                                          mean = season_tendency,
							  sd = sqrt(500)))
player_seasons_agg <- player_seasons %>%
                      group_by(player_season_id,N,x0,x_final) %>%
		      summarise(y = mean(y)) %>% ungroup()
lm(data = player_seasons_agg, y ~ x0) %>% summary
```

The theoretical R-squared is `1500 / (1500 + 500) = 0.75` and we notice that we miss that mark even more

```
Call:
lm(formula = y ~ x0, data = player_season_agg)

Residuals:
    Min      1Q  Median      3Q     Max 
-3.1803 -0.6921  0.0555  0.6951  2.7053 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.03368    0.02996   1.124    0.261    
x0           0.96891    0.03054  31.727   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.9476 on 998 degrees of freedom
Multiple R-squared:  0.5021,	Adjusted R-squared:  0.5016 
F-statistic:  1007 on 1 and 998 DF,  p-value: < 2.2e-16
```

Summarising, we learned the following: Assuming the "true" expectation of a player wouldn't change over the course of a season, a `0.002` play-level R-squared number leads to a year-to-year R-squared number of `0.5` if a season consists of of roughly `500` plays for each player. However, in reality, the expectation of a player changes over the course of a longer timefame for several reasons, hence to actual year-to-year R-squared is a bit lower. This effect becomes more stronger when looking at longer timeframes.

This shows us two things:
* Play-to-play R-squared must be tiny. If not, they would lead to unrealistic year-to-year R-squared numbers that we will never see.
* Looking at longer timeframes increases the R-squared number, but the effect that the initial expectation gets more wrong over time sets a cap for the R-squared number.

Whenever someone complains about tiny R-squared numbers on the play level, you can refer to this article.

If you ran my code examples in your own R console, you might have noticed  that you got slightly different R-squared numbers. In fact, I had to run these example three or four times until falling on a R-squared number close enough to the theoretical mark. What does this mean? Well, it mostly means what should make us all very cautious when reporting R-squared numbers:

**R-squared numbers come with uncertainty!**

In other words, if we could've run the last ten NFL seasons in 1000 parallel universes, the year-to-year R-squared number of every metric would be different in each of these universes. But how large are these differences? Is the uncertainty large? And since we can observe only one reality, how meaningful is an observed difference of R-squared numbers between two metrics?

*This* is where this article is about to get really interesting.

Let's re-run the code which simulates the theoretical R-squared number of a metric with a play-level R-squared number of `0.002` (residual variance `500`), but let's change two things:
* We add another metric with a play-level R-squared number of `0.0025` (residual variance `400`) to the mix.
* We simulate the reality in a `1000` parellel universes.

Note that for the sake of runtime and memory, we lower to a sample size of five seasons, i.e. we have the following set up:
* Players per season: `100`
* Number of seasons: `5` (In reality that means at least `6` years of data, because you need a year to get priors)
* Plays per player and season: `500` on average, i.e. each player season's number of players is a normal distribution around `500`.

The following code implements this and computes the season-level R-squared number for both metrics in each parallel universe. For reasons that will become apparent very soon, we simulate the seasons from the game-level, i.e. we simulate the plays of the 17 games of each season.

```r
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
player_seasons_agg <- player_games %>% group_by(player_season_id,sim_id,x) %>%
  summarise(N = sum(N), y = mean(y), y2 = mean(y2)) %>% ungroup()
df_r2_seasons <- player_seasons_agg %>% group_by(sim_id) %>%
  summarise(
    r2_500=cor(y,x)^2,
    r2_400=cor(y2,x)^2
  ) %>% ungroup()
```

First of all, let's check the mean R-squared numbers among all parallel universes. (pipe from `library(magrittr)` required)

```
> df_r2_seasons %$% mean(r2_500)
[1] 0.4992166
> df_r2_seasons %$% mean(r2_400)
[1] 0.5547872
```

These are very close to the theoretical values `500/(500 + 500)` and `500/(500 + 400)`.

The much more interesting part: How wide is the distribution of these values? The standard deviations are roughly `0.03`
```
> df_r2_seasons %$% sd(r2_500)
[1] 0.03129579
> df_r2_seasons %$% sd(r2_400)
[1] 0.03009743
```
![Uncertainty of season-level R-squared values](https://raw.githubusercontent.com/Timo-PFF/public_stuff/main/viz/r_squared_distribution_season_true.png)
There is quite an overlap. How likely is it that in a given universe (our *single* observed reality), the R-squared number of the more volatile metric (play-level variance of `500`) actually yields a higher year-to-year R-squared number?
```
> df_r2_seasons %$% mean(r2_500 > r2_400)
[1] 0.065
```
There is a `6.5%` chance that when we compute the year-to-year R-squared numbers of these metrics in our single reality, we actually observe that the more volatile metric would be more stable.

Now, let us repeat the same on the game level, i.e. we use the following set up:

Note that for the sake of runtime and memory, we lower to a sample size of five seasons, i.e. we have the following set up:
* Players per game: `100`
* Number of games: `5*17` (I.e. the same underlying data as `5` season)
* Plays per player and game: `500/17` on average, i.e. each player games's number of plays is a normal distribution around `500/17`.

Note that we have already implemented this above, i.e. we use the same simulated data, but this time we aggregate on the game-level:
```r
player_games_agg <- player_games %>% group_by(player_game_id,sim_id,N,x) %>%
  summarise(y = mean(y), y2 = mean(y2)) %>% ungroup()
df_r2_games <- player_games_agg %>% group_by(sim_id) %>%
  summarise(
    r2_500=cor(y,x)^2,
    r2_400=cor(y2,x)^2
  ) %>% ungroup()
```
First of all, let's check the mean R-squared numbers among all parallel universes. (pipe from `library(magrittr)` used)
```
> df_r2_games %$% mean(r2_500)
[1] 0.05477705
> df_r2_games %$% mean(r2_400)
[1] 0.06766693
```
These are very close to the theoretical values `500/17 / (500/17 + 500)` and `500/17 / (500/17 + 400)`.

The standard deviations are obviously smaller,
```
> df_r2_games %$% sd(r2_500)
[1] 0.005719208
> df_r2_games %$% sd(r2_400)
[1] 0.00650888
```
but that's not the point. The question is: How large is overlap compared to the season-level and what's the probability that we observe the more volatile metric as more stable?

```
> df_r2_games %$% mean(r2_500 > r2_400)
[1] 0.030
```
It turns out that the probability is only `3.0%`. Visually that means that the overlap is visibly smaller.

![Uncertainty of season-level R-squared values](https://raw.githubusercontent.com/Timo-PFF/public_stuff/main/viz/r_squared_distribution_game_true.png)


Let's go a step further and go to the play-level, i.e. we use the same simulated data and directly compute the R-squared values on the play-level.

```
df_r2_plays <- player_games %>% group_by(sim_id) %>%
  summarise(
    r2_500=cor(y,x)^2,
    r2_400=cor(y2,x)^2
  ) %>% ungroup()
 ```
The R-squared values are, of course, `1/501` and `1/401`, as expected
```
> df_r2_plays %$% mean(r2_500)
[1] 0.001986829
> df_r2_plays %$% mean(r2_400)
[1] 0.002488648
```
The interesting part: The probability that we directionally observe the wrong order of volatility has become even smaller than on the game-level, as the chance is only `2.7%`:
```
> df_r2_plays %$% mean(r2_500 > r2_400)
[1] 0.027
```
The difference is small enough to not be easily seen visually, but here is the plot nevertheless:
![Uncertainty of season-level R-squared values](https://raw.githubusercontent.com/Timo-PFF/public_stuff/main/viz/r_squared_distribution_play_true.png)

