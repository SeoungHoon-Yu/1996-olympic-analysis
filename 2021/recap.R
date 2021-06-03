pkgs <- c('dplyr','tidyr','stringr','rlist',
          'DMwR','reshape2','caret')
sapply(pkgs,require,character.only=TRUE)

# read df
# already crawled from webpage
# crawling code is in new\(1) df_crawl\code
setwd('C:/Users/rsh15/Desktop/seunghuni/github_refact/Olympic_medal/2018/new/(1) data_crawl/data')

country <- read.csv('country.csv',stringsAsFactors = FALSE)[,2:4]
medal   <- read.csv('medal.csv',stringsAsFactors = FALSE)[,2:6]
vote    <- read.csv('vote.csv',stringsAsFactors = FALSE)[,2:4]
gdp     <- read.csv('world_bank/gdp.csv',stringsAsFactors = FALSE)
pop     <- read.csv('world_bank/pop.csv',stringsAsFactors = FALSE)

# name check in country, medal
table(medal$country %in% country$Country)
table(vote$country %in% country$Country)

# 서독과 동독은 1990년에 통일하면서 1992년 동계올림픽에
# 1964년 동계올림픽 이후 28년만에 처음으로 단일팀으로 참가.
# 그러나 1992년의 올림픽 개최지 선정을 위한 투표는 1986년에 이루어졌음.
# 그래서 West Germany로 되어있는것을 Germany로.
vote[vote$country=='West Germany','country'] <- 'Germany'

# join data
df <- left_join(country,medal,by=c('Country'='country','year'='year'))
df <- left_join(df,vote,by=c('Country'='country','year'='year'))
df[is.na(df['code']),'code'] <- 'NA'
df[,'host_country'] <- as.numeric(sapply(df['code'],str_detect,'[*]'))
df['on_final_vote'] <- ifelse(is.na(df[,'final_vote']),0,1)
df[,c('Total','rank','final_vote')] <- lapply(df[,c('Total','rank','final_vote')],function(x)
                                                ifelse(is.na(x),0,x))
df <- df[,!(colnames(df) %in% 'code')]

# making index
idxx <- unique(df['year'])[[1]]
gdp_mean <- list()
pop_mean <- list()
for(k in 1:length(idxx)){
  a <- paste0('X',as.character((idxx[k]-5):(idxx[k]-1)))
  gdp_mean[[k]] <- rowMeans(gdp[,a])
  pop_mean[[k]] <- rowMeans(pop[,a])
}

gdp_mean_df <- data.frame(list.cbind(gdp_mean))
gdp_mean_df$Country <- gdp$Country
pop_mean_df <- data.frame(list.cbind(pop_mean))
pop_mean_df$Country <- pop$Country
gdp_pop <- left_join(pop_mean_df,gdp_mean_df,by='Country',suffix=c('_pop','_gdp'))

# check names & correct
df$Country[!df$Country %in% gdp_pop$Country]
df$Country <- str_trim(df$Country,side='both')
df$Country[df$Country=='Czechoslovakia'] = "Czech Republic"
df$Country[df$Country=='Netherlands Antilles'] = 'Netherlands'
df$Country[df$Country=='East Timor'] = 'Timor-Leste'

# unified team gdp pop with world mean
# north korea
gdp_pop[str_detect(gdp_pop$Country,'Dem'),'Country'] = 'North Korea'

# unified team
mean_cols <- startsWith(colnames(gdp_pop),'X')
unifies <- c('Russia','Estonia','Latvia','Lithuania','Armenia','Belarus','Georgia',
             'Kazakhstan','Kyrgyzstan','Moldova','Ukraine','Uzbekistan','Azerbaijan',
             'Tajikistan','Turkmenistan')
gdp_pop[(nrow(gdp_pop)+1),mean_cols] <- colMeans(gdp_pop[gdp_pop$Country %in% unifies,mean_cols],na.rm = TRUE)
gdp_pop[(nrow(gdp_pop)),'Country'] <- 'Unified Team'

# yugoslavia
yugos <- c('Slovenia','Croatia','Bosnia and Herzegovina',
           'Serbia', 'Montenegro','Macedonia','Kosovo')
gdp_pop[(nrow(gdp_pop)+1),mean_cols] <- colMeans(gdp_pop[gdp_pop$Country %in% yugos,mean_cols],
                                                 na.rm = TRUE)
gdp_pop[(nrow(gdp_pop)),'Country'] <- 'Yugoslavia'

# serbia and montenegro
gdp_pop[(nrow(gdp_pop)+1),mean_cols] <- colMeans(gdp_pop[gdp_pop$Country %in% c('Serbia','Montenegro'),mean_cols],na.rm = TRUE)
gdp_pop[(nrow(gdp_pop)),'Country'] <- 'Serbia and Montenegro'

# make empty data with chinese taipei
gdp_pop[(nrow(gdp_pop)+1),'Country'] <- 'Chinese Taipei'

# knn imp
gdp_pop[,mean_cols] <- knnImputation(gdp_pop[mean_cols],5)

# melt data frame
gdp_cols <- colnames(gdp_pop)[endsWith(colnames(gdp_pop),'gdp')] %>% append('Country')
pop_cols <- colnames(gdp_pop)[endsWith(colnames(gdp_pop),'pop')] %>% append('Country')
gdp_melt <- melt(gdp_pop[,gdp_cols],id='Country',value.name = 'gdps')
gdp_melt$variable <- as.character(gdp_melt$variable)
pop_melt <- melt(gdp_pop[,pop_cols],id='Country',value.name = 'pops')
pop_melt$variable <- as.character(pop_melt$variable)

for(k in 1:length(idxx)){
  gdp_melt['variable'] <- replace(gdp_melt['variable'],
                                  gdp_melt['variable']==paste0('X',k,'_gdp'),idxx[k])
  pop_melt['variable'] <- replace(pop_melt['variable'],
                                  pop_melt['variable']==paste0('X',k,'_pop'),idxx[k])
}

gdp_pop_melt <- inner_join(gdp_melt,pop_melt,by=c('Country','variable'))
gdp_pop_melt$variable <- as.integer(gdp_pop_melt$variable)

df_final <- left_join(df,gdp_pop_melt,by=c('Country'='Country',
                                           'year'='variable'))

write.csv(df_final,'C:/Users/rsh15/Desktop/seunghuni/github_refact/Olympic_medal/2021/data/df.csv')