# About R(-squared) values in football & sports analytics

## Introduction

My name is Timo Riske and I've actively been doing football analytics since 2017 and I've been a data scientist for PFF since 2019. The following article


```r
x <- rnorm(20*10^3, sd = 1)
y <- x + rnorm(length(x), sd = 10)
lm(y ~ x) %>% summary
```
