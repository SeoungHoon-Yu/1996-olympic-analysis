pkgs <- c('dplyr','stringr')
sapply(pkgs,require,character.only=TRUE)

setwd('C:/Users/rsh15/Desktop/seunghuni/github_refact/Olympic_medal/2021/data')
df <- read.csv('df.csv')
climate <- read.csv('climate_named.csv')

