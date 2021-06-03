# this code is to set country name between climate - olympic data.
# result is saved in climate_named.csv
pkgs <- c('rvest','dplyr','data.table','caret','readxl',
          'stringr','xml2','tidyr','pbmcapply')
sapply(pkgs, require, character.only = TRUE)
setwd('C:/Users/rsh15/Desktop/seunghuni/github_refact/Olympic_medal/')

url <- "https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_3.23/crucy.1506241137.v3.23/countries/tmp/"
re_url <- read_html(url)
namees <- html_attr(html_nodes(re_url,"a"),"href")
file_name <- namees[endsWith(namees,".per")]
url_final <- paste0(url,file_name)

pboptions(type = "txt",style = 3, char = "=")
dd <- pblapply(url_final,
               function(x) read.table(x,skip = 3,header = TRUE))  
climate <- rbindlist(dd)

# add country_name
file_name <- data.frame(file_name)
colnames(file_name) <- "a"

country_name <- separate(file_name,a,into = paste0("aa",seq(1,8)),sep = "\\.")
country_name <- country_name$aa6
country_name <- rep(country_name,each = 114)
climate$country <- country_name

# climate data wrangling.
colnames(climate)
climate <- climate %>% select("country","YEAR","JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")
df <- read.csv('2021/data/df.csv',stringsAsFactors = FALSE)

climate$country <- str_replace_all(climate$country,'_',' ')
climate$country[climate$country=='Puerto Rica'] = 'Puerto Rico'
climate$country[climate$country=='USA'] = 'United States'
climate$country[climate$country=='Virgin Isl'] = 'Virgin Islands'
climate$country[climate$country=='Samoa'] = 'American Samoa'
climate$country[climate$country=='Grand Cayman'] = 'Cayman Islands'
climate$country[climate$country=='United Kingdom'] = 'Great Britain'
climate$country[climate$country=='Bosnia-Herzegovinia'] = 'Bosnia and Herzegovina'
climate$country[climate$country=='Moldavia'] = 'Moldova'

unique(df$Country[!df$Country %in% climate$country])

# virgin islandas -> british virgin islands
virgin_tmp <- climate[climate$country=='Virgin Islands',
                      c("YEAR","country","JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")] %>% data.frame()
virgin_tmp['country'] = 'British Virgin Islands'

# unified teams
unifies <- c('Russia','Estonia','Latvia','Lithuania','Armenia','Belarus','Georgia',
             'Kazakhstan','Kyrgyzstan','Moldova','Ukraine','Uzbekistan','Azerbaijan',
             'Tajikistan','Turkmenistan')
unifi_tmp <- climate[climate$country %in% unifies,
                     c("YEAR","country","JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")] %>% data.frame()
unifi_tmp['country'] = 'Unified Team'
unifi_tmp <- unifi_tmp %>% group_by(YEAR,country) %>% summarise_all('mean')

# timor means
timors <- c('Papua New Guinea','Australia','Indonesia')
timors_tmp <- climate[climate$country %in% timors,
                      c("YEAR","country","JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")] %>% data.frame()
timors_tmp['country'] = 'Timor-Leste'
timors_tmp <- timors_tmp %>% group_by(YEAR,country) %>% summarise_all('mean')

# serbia, montenegro, serbia and montenegro
serbia_tmp = climate[climate$country == 'Yugoslavia',
                     c("YEAR","country","JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")] %>% data.frame()
monten_tmp = climate[climate$country == 'Yugoslavia',
                     c("YEAR","country","JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")] %>% data.frame()
sermon_tmp = climate[climate$country == 'Yugoslavia',
                     c("YEAR","country","JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")] %>% data.frame()
serbia_tmp['country'] = 'Serbia'
monten_tmp['country'] = 'Montenegro'
sermon_tmp['country'] = 'Serbia and Montenegro'

# chinese taipei
taipei_tmp = climate[climate$country == 'China',
                     c("YEAR","country","JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")] %>% data.frame()
taipei_tmp['country'] = 'Chinese Taipei'

climate_final <- rbind(climate,virgin_tmp,unifi_tmp,timors_tmp,
                       serbia_tmp,monten_tmp,sermon_tmp,taipei_tmp)

unique(df$Country[!df$Country %in% climate_final$country])

write.csv(climate_final, '2021/data/climate_named.csv')
