pkgs <- c('dplyr','stringr','tidyr')
sapply(pkgs, require, character.only = TRUE)

wd <- 'D:/승훈/Data/Olympic analysis/my_new/(1) data_crawl/data'
setwd(wd)
options(stringsAsFactors = FALSE)

medal <- read.csv('medal.csv')[,-1]
ath <- read.csv('country.csv')[,-1]
colnames(ath) <- tolower(colnames(ath))

# participation summary
(summ <- ath %>% group_by(year) %>%
          summarise(nation = n(),
                    ath_su = sum(ath))) 

# join
olym <- right_join(medal,ath,by = c('country','year'))
olym <- left_join(olym,summ,by = 'year')
remove(medal,ath)

# gdp
gdp <- read.csv('world_bank/gdp.csv')[,-1]
gdp <- gather(gdp,'year','gdp',2:58)
gdp$year <- as.integer(str_sub(gdp$year,2,5))

# pop
pop <- read.csv('world_bank/pop.csv')[,-1]
pop <- gather(pop,'year','pop',2:58)
pop$year <- as.integer(str_sub(pop$year,2,5))

# join gdp & pop
gdpop <- left_join(gdp,pop,by = c('Country','year'))
colnames(gdpop) <- tolower(colnames(gdpop))

table(olym$country %in% gdpop$country)
unique(olym$country[!(olym$country %in% gdpop$country)])

olym <- left_join(olym,gdpop,by = c('country','year'))
remove(gdp,pop,gdpop)

olym$Total[is.na(olym$Total)] <- 0

# ath portion?
olym$ath_por <- olym$ath / olym$ath_su

# rank na_replace, top5 in last olym?
olym$rank[is.na(olym$rank)] <- 99
temp <- olym[,c('country','year','rank')]
temp$top5 <- ifelse(temp$rank <= 5,1,0)
olym <- merge(olym,temp,by = c('country','year'),all.x = TRUE)
remove(temp)