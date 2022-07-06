# About R(-squared) values in football & sports analytics

## Introduction

My name is Timo Riske and I've actively been doing football analytics since 2017 and I've been a data scientist for PFF since 2019. The following article


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
