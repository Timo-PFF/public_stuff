# About R(-squared) values in American football & sports analytics

## Introduction

My name is Timo Riske and I've actively been doing American football analytics since 2017 and I've been a data scientist for PFF since 2019. My academic background is more of a theoretic nature, as I've graduated in commutative algebra and algebraic geometry. The following article is about practicing in football and sports analytics, but it's too theoretical for an article about football on my employer's site https://pff.com, hence I'm publishing it through GitHub.

If you're practicing sports analytics, and that's especially true for American football analytics, and have talked to other stats people about models that try to predict future performance with past information, you might have heard the following response: "All I see is dramatically low R-squared values, nothing of this means anything".

Indeed, predictive models on a play-level often come with a R-squared value in the range of only `0.01`. This sounds ridiculously low compared to the models you considered in university. Thus...this person is right and your work is useless and bad?

Here is the thing: This person couldn't be more wrong. This person was either not paying attention or understands less about stats than he/she might think.

To elaborate on this, we will talk about the relationship between R-squared values on the play-, game- and season-level. Imagine you've developed to a metric to evaluate a wide receiver and you want to use this metric to predict what happens on a given play. Ideally, you choose something tangible, something which matters as the target metric. Given that we chose wide receivers for our thought experiment, think about earning a target, catching a ball or the amount of yards caught on that route. For pass rushers, this could be generating pressure or a sack, for quarterbacks it could be generating EPA or avoiding a sack and for linebackers it could be making a stop in the run game. Which R-squared values can you expect when predicting such a target metric?

There is definitely an upper bound for R-squared values on the season-level, as findings in NFL analytics have shown that it is very rare to even get to a R-squared value of `0.5` when predicting performance. First of all there is always natural variance when it comes to the performance of a human being and that's even true in sports in which the individual success of a participant depends almost only on that individual's skill and form on the day, such as track & field or skiing. Now, we have to consider that football is a much more complex sport in which an individual player's success also depends on his teammates, his opponents, the scheme he is playing in, the chess match between his and his opponent's coaches and other factors not in his control. Nowadays, with tracking and charting data being available, we can partially account for these things, but here are some simple truths that can never be broken:

* Opponent adjustments on the player level are possible by now, e understand a lot about how teammates can help each other's statistics on the field and we can even describe how coaches can influence a player's performance, we will never be able to *fully* disentangle a player from his surroundings, that is his opponents, his teammates and the scheme of the offense and defense. All of this leads to further variance in performance of the same player.
* Even if we could fully disentangle a player from his surroundings, it's notable that his surroundings are also subject to natural variance, enhancing the effect of the natural variance of the player himself.


```r
x <- rnorm(20*10^3, sd = 1)
y <- x + rnorm(length(x), sd = 10)
lm(y ~ x) %>% summary
```

```
Call:
lm(formula = y ~ x)

Residuals:
    Min      1Q  Median      3Q     Max 
-37.430  -6.762   0.066   6.728  41.699 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) -0.02260    0.07069   -0.32    0.749    
x            1.01957    0.07127   14.30   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 9.996 on 19998 degrees of freedom
Multiple R-squared:  0.01013,	Adjusted R-squared:  0.01008 
F-statistic: 204.6 on 1 and 19998 DF,  p-value: < 2.2e-16
```

inline <img src="https://latex.codecogs.com/png.latex?X%20=%20\sum%20\frac{X_i}{n}"> latex

inline ![equation](https://latex.codecogs.com/png.latex?X%20=%20\sum%20\frac{X_i}{n}) latex

