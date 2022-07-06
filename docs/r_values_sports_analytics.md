# About R(-squared) values in American football & sports analytics

## Introduction

My name is Timo Riske and I've actively been doing American football analytics since 2017 and I've been a data scientist for PFF since 2019. My academic background is more of a theoretic nature, as I've graduated in commutative algebra and algebraic geometry. The following article is about practicing in football and sports analytics, but it's too theoretical for an article about football on my employer's site https://pff.com, hence I'm publishing it through GitHub.

If you're practicing sports analytics, and that's especially true for American football analytics, and have talked to other stats people about models that try to predict future performance with past information, you might have heard the following response: "All I see is dramatically low R-squared values, nothing of this means anything".

Indeed, predictive models on a play-level often come with a R-squared value of `0.01`. This sounds ridiculously low compared to the models you considered in university. Thus...this person is right and your work is useless and bad?

Here is the thing: This person is not right. This person was either not paying attention or understand less about stats than he/she might think.


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

