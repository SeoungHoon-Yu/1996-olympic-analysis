pkgs <- c('dplyr','stringr','tidyr','data.table',
          'rvest','RCurl','XML')
sapply(pkgs,require,character.only = TRUE)

url <- 'https://en.wikipedia.org/wiki/2018_Winter_Olympics_medal_table'
crawl_2018 <- read_html(url) %>% 
  html_nodes(.,css = 'table.wikitable.sortable') %>%
  html_table(fill = TRUE) %>% data.frame()

crawl_2018 <- crawl_2018[1:30,c(2,6)]
crawl_2018$share_now <- crawl_2018$Total / sum(crawl_2018$Total)

url2 <- 'https://en.wikipedia.org/wiki/2018_Winter_Olympics'
test <- read_html(url2) %>%
  html_nodes(.,css = 'table.wikitable.collapsible') %>%
  html_table(fill = TRUE)

count_ath <- data.frame(test[[2]])

# korea(cor) with 35 ath == women's ice hockey.
# north 12
# south 23
count_ath <- count_ath[-which(count_ath$IOC.Code == "COR"),]
idx <- which(count_ath$IOC.Code %in% c('KOR','PRK'))
count_ath$Country <- str_replace_all(count_ath$Country,"\\[a\\]|\\[b\\]","")
count_ath$Athletes[idx] <- count_ath$Athletes[idx] + c(23,12)

# crawl_2018
crawl_2018 <- separate(crawl_2018,NOC,sep = '\\(',into = c('country','code'))
crawl_2018$code <- str_replace_all(crawl_2018$code,'\\)','')
crawl_2018$country <- str_replace_all(crawl_2018$country," ","[sp]")
crawl_2018$country <- str_replace_all(crawl_2018$country,"[:space:]","")
crawl_2018$country <- str_replace_all(crawl_2018$country,"\\[sp\\]"," ")