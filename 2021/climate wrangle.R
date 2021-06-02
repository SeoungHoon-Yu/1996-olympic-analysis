# this code is to set country name between climate - olympic data.
# result is saved in climate_named.csv
pkgs <- c('dplyr','stringr')
sapply(pkgs,require,character.only = TRUE)
setwd('C:/Users/rsh15/Desktop/seunghuni/github_refact/Olympic_medal/')

df <- read.csv('2021/data/df.csv',stringsAsFactors = FALSE)
climate <- read.csv('2018/old/climate/climate.csv',stringsAsFactors = FALSE)

unique(df$Country[!df$Country %in% climate$country])

climate$country <- str_replace_all(climate$country,'_',' ')
climate$country[climate$country=='Puerto Rica'] = 'Puerto Rico'
climate$country[climate$country=='USA'] = 'United States'
climate$country[climate$country=='Virgin Isl'] = 'Virgin Islands'
climate$country[climate$country=='Samoa'] = 'American Samoa'
climate$country[climate$country=='Grand Cayman'] = 'Cayman Islands'
