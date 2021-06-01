pkgs <- c('dplyr','tidyr','stringr','rlist')
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

# 
df$Country[!df$Country %in% gdp_mean_df$Country]
