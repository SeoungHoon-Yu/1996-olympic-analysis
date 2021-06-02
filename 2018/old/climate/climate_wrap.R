pkgs <- c('rvest','dplyr','data.table','caret','readxl',
          'stringr','xml2','tidyr','pbapply')
sapply(pkgs, require, character.only = TRUE)

setwd("C:/Users/rsh15/Desktop/seunghuni/github_refact/Olympic_medal/2018/old/climate")

url <- "https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_3.23/crucy.1506241137.v3.23/countries/cld/"
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
climate <- climate %>% select(c('country','YEAR','DJF','MAM','JJA','SON'))

# remove no use.
remove(file_name,re_url,country_name,namees,url,url_final)
#write.csv(climate,'climate.csv')

# 1992년부터 1996년까지 기온의 평균?
# 처리해서 평균내고 차이까지 구해봤는데,
# 1995년 평균 기온과 큰 차이가 없음.

# 기후데이터 추가한 oly4
oly3 <- read.csv('D:/승훈/Data/Olympic analysis/oly3.csv',stringsAsFactors = FALSE)

# underbar wrangle
climate$country <- str_replace_all(climate$country,"_"," ")
climate$country <- str_replace_all(climate$country,"-"," and ")
climate$country <- str_replace_all(climate$country,"Isl$","Islands")

table(oly3$Country %in% climate$country)
oly3[-which(oly3$Country %in% climate$country),"Country"]

climate$country[which(climate$country == "Grand Cayman")] <- "Cayman Islands"
climate$country[which(climate$country == "Central African Rep")] <- "Central African Republic"
climate$country[which(climate$country == "United Kingdom")] <- "Great Britain"
climate$country[which(climate$country == "Moldavia")] <- "Moldova"
climate$country[which(climate$country == "Puerto Rica")] <- "Puerto Rico"
climate$country[which(climate$country == "Surinam")] <- "Suriname"
climate$country[which(climate$country == "Gambia")] <- "The Gambia"
climate$country[which(climate$country == "USA")] <- "United States"
climate$country[which(climate$country == "Vanatu")] <- "Vanuatu"

# country connected in medal data.
table(oly3$Country %in% climate$country)
a <- oly3[-which(oly3$Country %in% climate$country),"Country"]
a <- data.frame(a[str_detect(a," and ")])
a <- separate(a,colnames(a),into = c("cou1","cou2"), sep = " and ")

climate$country[which(climate$country == "Bosnia and Herzegovinia")] <- "Bosnia and Herzegovina"
climate$country[which(climate$country == "St Vincent")] <- "Saint Vincent and the Grenadines"
climate2 <- climate[-which(climate$country %in% c("Antigua","Barbuda")),]
climate2 <- rbind(climate2,c(290,1995,"Antigua and Barbuda",
                             mean(climate$avg_tem[which(climate$country %in% c("Antigua","Barbuda"))])))

oly4 <- left_join(oly3,climate,by = c("Country" = "country"))
oly4 <- oly4[,c(1:14,17)]

# analysis
# 1. regression
md <- lm(Share_96 ~ Share_92 + log(gdp_96) + log(X1996) + avg_tem,data = oly4)
summary(md)

# 2. tobit
library(VGAM)
tob_md <- vglm(Share_96 ~ Share_92 + log(gdp_96) + log(X1996) + avg_tem,
               data = oly4, family = "tobit")
summary(tob_md)

library(AER)
tob_aer <- tobit(Share_96 ~ Share_92 + log(gdp_96) + log(X1996) + avg_tem,
                 data = oly4, left = 0,right = Inf)
summary(tob_aer)
