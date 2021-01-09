pkgs <- c('h2o','dplyr')
sapply(pkgs,require,character.only = TRUE)

wd <- 'C:/Users/rsh15/Desktop/seunghuni/github_refact/Olympic_medal/new/(2) wrangle'
setwd(wd)

load('wrangle_data.RData')
md_lm = lm('Total ~ ath + gdp + pop',data=olym)
summary(md_lm)
