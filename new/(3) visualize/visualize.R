pkgs <- c('dplyr','ggplot2')
sapply(pkgs, require, character.only = TRUE)

load('D:/승훈/Data/Olympic analysis/my_new/(2) wrangle/wrangle_data.RData')

# explore.
glimpse(olym)

