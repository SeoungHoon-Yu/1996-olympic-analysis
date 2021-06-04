pkgs <- c('dplyr','stringr','rlist','caret','AER',
          'VGAM')
sapply(pkgs,require,character.only=TRUE)

setwd('C:/Users/rsh15/Desktop/seunghuni/github_refact/Olympic_medal/2021/data')
df <- read.csv('df.csv')
climate <- read.csv('climate_named.csv')

unique_years <- unique(df$year)
years_list <- list()
for(k in 1:length(unique_years)){
  tmp_vec <- (unique_years[k]-5):(unique_years[k]-1)
  tmp_dff <- climate[climate$YEAR %in% tmp_vec,]
  tmp_dff$YEAR = unique_years[k]
  years_list[[k]] <- tmp_dff %>% group_by(country) %>% summarise_all('mean')
}
climate_years <- list.rbind(years_list)

df <- subset(df,select=-c(X))
climate_years <- subset(climate_years,select=-c(X))

col_years <- colnames(climate_years)
climate_summ  <- climate_years %>%
  group_by(country,YEAR) %>%
  summarize(winter_temperature = mean(DEC,JAN,FEB) %>% round(3),
            min_temperature    = min(JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC) %>% round(3),
            max_temperature    = max(JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC) %>% round(3))

df_final <- left_join(df,climate_summ,
                      by = c('Country'='country','year'='YEAR'))

numeric_cols <- c('ath','Total','final_vote','gdps','pops','winter_temperature','min_temperature','max_temperature')
df_final[,numeric_cols] <- apply(df_final[,numeric_cols],2,
                                 function(x)(x-min(x))/(max(x)-min(x)))

# modeling
oly_formula <- as.formula('Total ~ ath + final_vote + host_country + on_final_vote + gdps + pops + winter_temperature')
aer_tobit <- AER::tobit(oly_formula,left = 0, right = Inf,data = df_final)
summary(aer_tobit)
