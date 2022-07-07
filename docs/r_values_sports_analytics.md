# About R(-squared) values in American football & sports analytics

## Introduction

My name is Timo Riske and I've actively been doing American football analytics since 2017 and I've been a data scientist for PFF since 2019. My academic background is more of a theoretic nature, as I've graduated in commutative algebra and algebraic geometry. The following article is about practicing in football and sports analytics, but it's too theoretical for an article about football on my employer's site (https://pff.com), hence I'm publishing it through GitHub.

If you're practicing sports analytics, and that's especially true for American football analytics, and have talked to other stats people about models that try to predict future performance with past information, you might have heard the following response: "All I see is dramatically low R-squared values, nothing of this means anything".

Indeed, predictive models on a play-level often come with a R-squared value in the range of only `0.01`. This sounds ridiculously low compared to the models you considered in university. Thus...this person is right and your work is useless and bad?

Here is the thing: This person couldn't be more wrong. This person was either not paying attention or understands less about stats than he/she might think.

To elaborate on this, we will talk about the relationship between R-squared values on the play-, game- and season-level. Imagine you've developed to a metric to evaluate a wide receiver and you want to use this metric to predict what happens on a given play. Ideally, you choose something tangible, something which matters as the target metric. Given that we chose wide receivers for our thought experiment, think about earning a target, catching a ball or the amount of yards caught on that route. For pass rushers, this could be generating pressure or a sack, for quarterbacks it could be generating EPA or avoiding a sack and for linebackers it could be making a stop in the run game. Which R-squared values can you expect when predicting such a target metric?

There is definitely an upper bound for R-squared values on the season-level, as findings in NFL analytics have shown that it is very rare to even get to a R-squared value of `0.5` when predicting performance. First of all there is always natural variance when it comes to the performance of a human being and that's even true in sports in which the individual success of a participant depends almost only on that individual's skill and form on the day, such as track & field or skiing. Now, we have to consider that football is a much more complex sport in which an individual player's success also depends on his teammates, his opponents, the scheme he is playing in, the chess match between his and his opponent's coaches and other factors not in his control. Nowadays, with tracking and charting data being available, we can partially account for these things, but here are some simple truths that can never be broken:

* Opponent adjustments on the player level are possible by now, e understand a lot about how teammates can help each other's statistics on the field and we can even describe how coaches can influence a player's performance, we will never be able to *fully* disentangle a player from his surroundings, that is his opponents, his teammates and the scheme of the offense and defense. All of this leads to further variance in performance of the same player.
* Even if we could fully disentangle a player from his surroundings, it's notable that his surroundings are also subject to natural variance, enhancing the effect of the natural variance of the player himself.

Hence, while it's certainly possible to asymptotically increase the R-squared values of performance-predicting models, there is definitely an upper bound we cannot break through. And this bound is probably lower than we wished it were. The good news: This doesn't mean that analytics is useless. NFL teams, coaches and general manager get evaluations wrong all the time when it comes to predicting future production. A well-known finding in American football is that a drafted player is better than the next-drafted player at the same position at a rate of only `53%`, just a tad better than a coin flip. And even for players with at least a four-year sample size in the NFL (which is usually the case for every free agents), teams get it wrong fairly often, as indicated by expensive players with mediocre production or by cheap players with good production (in which case all other 31 teams got the evaluation wrong).

**Always remember: The goal of analytics isn't to be perfect, the goal of analytics is to improve upon the decisions/evaluations that are made without an analytical framework.**

After coming to grips with the fact that we will always deal with fairly low R-squared values on the season-level, what does this mean for the game- or even play-level?

It's notable that the R-squared values of a linear model `Y~X` is obviously related to the residual variance `Var(E) = Var(Y-X)`. This is easily seen through the definition.

![equation](https://latex.codecogs.com/png.latex?R^2=1-\frac{\sum_{i}(y_i-x_i)^2}{\sum_{i}(y_i-\overline{y})^2})

With `E = Y-X`, note that the numerator is `N * Var(E)` and the denominator is `N * Var(Y)`, hence we get

![equation](https://latex.codecogs.com/png.latex?R^2=1-\frac{\operatorname{Var}(E)}{\operatorname{Var}(Y)})

For the sake of normalization, let's assume ![equation](https://latex.codecogs.com/png.latex?\operatorname{Var}(X)=1) and define ![equation](https://latex.codecogs.com/png.latex?\operatorname{Var}(E)=\sigma^2) 

We obtain (assuming the residuals are independent of `X`, which is one of the basic assumptions for the usability of a linear model)

![equation](https://latex.codecogs.com/png.latex?R^2=1-\frac{\operatorname{Var}(E)}{\operatorname{Var}(Y)}=1-\frac{\sigma^2}{1+\sigma^2}=\frac{1+\sigma^2-\sigma^2}{1+\sigma^2}=\frac{1}{1+\sigma^2})

In particular, the R-squared values increases asymptotically towards `1` when the residual variance approaches zero and it approaches zero when the residual variances becomes large.

We can test this formular in R. To get back to football, there are roughly 20,000 passing plays per season, thus there are run roughly 60,000 wide receiver routes (11 personnel being dominant in today's game). Assume you have developed a wide receiver metric, standardized it to z-scores (thus `X` is centered around zero and has variance `1`) and predict yards gained on a route run. The following R code is a simplification of your data on the play-level for one season with a hypothetical play-level residual variance of `100`. According to our computations, it should lead to a R-squared value of `1/101` or roughly `0.01` according to our computation.

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

We've learned that if the predictors come with constant variance (which is usually roughly the case), the R-squared value is just a codified version of the residual variance. What happens with variance if we repeat a random experiment multiple times? It get's smaller. How is this derived mathematically?

We have a random variable `T` with real values and observe it `n` times in an indepenent way and build the mean of the observations, in other words we consider a new random variable ![equation](https://latex.codecogs.com/png.latex?\frac{\sum_i^nT_i}{n}) with the `T_i` being i.i.d copies of `T`. Let's compute the variance, using the independency assumption:

![equation](https://latex.codecogs.com/png.latex?\operatorname{Var}\left(\frac{\sum\limits_{i=1}^nT_i}{n}\right)=\frac{\sum\limits_{i=1}^n\operatorname{Var}(T_i)}{n^2}=\frac{n\operatorname{Var}(T)}{n^2}=\frac{\operatorname{Var}(T)}{n}.)

