pkgs <- c('rvest','dplyr','data.table','caret',
          'stringr','xml2','tidyr','pbapply')
sapply(pkgs, require, character.only = TRUE)

setwd("D:/승훈/Data/Olympic analysis/climate_temp")

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
# 1995 temperature average.
climate <- climate %>% filter(YEAR == 1995) %>%
  mutate(avg_tem = rowMeans(climate[which(climate$YEAR == 1995),2:13]))
climate <- climate[,c("YEAR","country","avg_tem")]

# remove no use.
remove(file_name,re_url,country_name,namees,url,url_final)

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
a <- left_join(a,climate,by = c("cou1" = "country"))
a <- left_join(a,climate,by = c("cou2" = "country"))
# 여기 국가명 확인 할 필요있음