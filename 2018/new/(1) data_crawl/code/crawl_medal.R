pkgs <- c('dplyr','stringr','tidyr',
          'data.table','rvest')
sapply(pkgs,require,character.only = TRUE)

# 1992 winter olympics crawl.
url <- 'https://en.wikipedia.org/wiki/1992_Winter_Olympics_medal_table'
crawl_1992 <- read_html(url) %>% 
  html_nodes(.,css = 'table.wikitable.sortable') %>%
  html_table(fill = TRUE) %>% data.frame()

crawl_1992 <- separate(crawl_1992,NOC,sep = '\\(',into = c('country','code'))
crawl_1992$code <- str_replace_all(crawl_1992$code,'\\)','')
crawl_1992$country <- str_replace_all(crawl_1992$country," ","[sp]")
crawl_1992$country <- str_replace_all(crawl_1992$country,"[:space:]","")
crawl_1992$country <- str_replace_all(crawl_1992$country,"\\[sp\\]"," ")
crawl_1992$share <- crawl_1992$Total / crawl_1992$Total[nrow(crawl_1992)]
crawl_1992 <- crawl_1992[1:nrow(crawl_1992)-1,
                         c("code","country","Total","share")]
crawl_1992 <- crawl_1992[order(crawl_1992$share,decreasing = TRUE),]
crawl_1992$rank <- 1:nrow(crawl_1992)

# 1994 winter olympics crawl
url <- 'https://en.wikipedia.org/wiki/1994_Winter_Olympics_medal_table'
crawl_1994 <- read_html(url) %>% 
  html_nodes(.,css = 'table.wikitable.sortable') %>%
  html_table(fill = TRUE) %>% data.frame()

crawl_1994 <- separate(crawl_1994,NOC,sep = '\\(',into = c('country','code'))
crawl_1994$code <- str_replace_all(crawl_1994$code,'\\)','')
crawl_1994$country <- str_replace_all(crawl_1994$country," ","[sp]")
crawl_1994$country <- str_replace_all(crawl_1994$country,"[:space:]","")
crawl_1994$country <- str_replace_all(crawl_1994$country,"\\[sp\\]"," ")
crawl_1994$share <- crawl_1994$Total / crawl_1994$Total[nrow(crawl_1994)]
crawl_1994 <- crawl_1994[1:nrow(crawl_1994)-1,
                         c("code","country","Total","share")]
crawl_1994 <- crawl_1994[order(crawl_1994$share,decreasing = TRUE),]
crawl_1994$rank <- 1:nrow(crawl_1994)

# 1998 winter olympics crawl
url <- 'https://en.wikipedia.org/wiki/1998_Winter_Olympics_medal_table'
crawl_1998 <- read_html(url) %>% 
  html_nodes(.,css = 'table.wikitable.sortable') %>%
  html_table(fill = TRUE) %>% data.frame()

crawl_1998 <- separate(crawl_1998,NOC,sep = '\\(',into = c('country','code'))
crawl_1998$code <- str_replace_all(crawl_1998$code,'\\)','')
crawl_1998$country <- str_replace_all(crawl_1998$country," ","[sp]")
crawl_1998$country <- str_replace_all(crawl_1998$country,"[:space:]","")
crawl_1998$country <- str_replace_all(crawl_1998$country,"\\[sp\\]"," ")
crawl_1998$share <- crawl_1998$Total / crawl_1998$Total[nrow(crawl_1998)]
crawl_1998 <- crawl_1998[1:nrow(crawl_1998)-1,
                         c("code","country","Total","share")]
crawl_1998 <- crawl_1998[order(crawl_1998$share,decreasing = TRUE),]
crawl_1998$rank <- 1:nrow(crawl_1998)

# 2002 winter olympics crawl
url <- 'https://en.wikipedia.org/wiki/2002_Winter_Olympics_medal_table'
crawl_2002 <- read_html(url) %>% 
  html_nodes(.,css = 'table.wikitable.sortable') %>%
  html_table(fill = TRUE) %>% data.frame()

crawl_2002 <- separate(crawl_2002,NOC,sep = '\\(',into = c('country','code'))
crawl_2002$code <- str_replace_all(crawl_2002$code,'\\)','')
crawl_2002$country <- str_replace_all(crawl_2002$country," ","[sp]")
crawl_2002$country <- str_replace_all(crawl_2002$country,"[:space:]","")
crawl_2002$country <- str_replace_all(crawl_2002$country,"\\[sp\\]"," ")
crawl_2002$share <- crawl_2002$Total / crawl_2002$Total[nrow(crawl_2002)]
crawl_2002 <- crawl_2002[1:nrow(crawl_2002)-1,
                         c("code","country","Total","share")]
crawl_2002 <- crawl_2002[order(crawl_2002$share,decreasing = TRUE),]
crawl_2002$rank <- 1:nrow(crawl_2002)

# 2006 winter olympics crawl
url <- 'https://en.wikipedia.org/wiki/2006_Winter_Olympics_medal_table'
crawl_2006 <- read_html(url) %>% 
  html_nodes(.,css = 'table.wikitable.sortable') %>%
  html_table(fill = TRUE) %>% data.frame()

crawl_2006 <- separate(crawl_2006,NOC,sep = '\\(',into = c('country','code'))
crawl_2006$code <- str_replace_all(crawl_2006$code,'\\)','')
crawl_2006$country <- str_replace_all(crawl_2006$country," ","[sp]")
crawl_2006$country <- str_replace_all(crawl_2006$country,"[:space:]","")
crawl_2006$country <- str_replace_all(crawl_2006$country,"\\[sp\\]"," ")
crawl_2006$share <- crawl_2006$Total / crawl_2006$Total[nrow(crawl_2006)]
crawl_2006 <- crawl_2006[1:nrow(crawl_2006)-1,
                         c("code","country","Total","share")]
crawl_2006 <- crawl_2006[order(crawl_2006$share,decreasing = TRUE),]
crawl_2006$rank <- 1:nrow(crawl_2006)

# 2010 winter olympics crawl
url <- 'https://en.wikipedia.org/wiki/2010_Winter_Olympics_medal_table'
crawl_2010 <- read_html(url) %>% 
  html_nodes(.,css = 'table.wikitable.sortable') %>%
  html_table(fill = TRUE) %>% data.frame()

crawl_2010 <- separate(crawl_2010,NOC,sep = '\\(',into = c('country','code'))
crawl_2010$code <- str_replace_all(crawl_2010$code,'\\)','')
crawl_2010$country <- str_replace_all(crawl_2010$country," ","[sp]")
crawl_2010$country <- str_replace_all(crawl_2010$country,"[:space:]","")
crawl_2010$country <- str_replace_all(crawl_2010$country,"\\[sp\\]"," ")
crawl_2010$share <- crawl_2010$Total / crawl_2010$Total[nrow(crawl_2010)]
crawl_2010 <- crawl_2010[1:nrow(crawl_2010)-1,
                         c("code","country","Total","share")]
crawl_2010 <- crawl_2010[order(crawl_2010$share,decreasing = TRUE),]
crawl_2010$rank <- 1:nrow(crawl_2010)

# 2014 winter olympics crawl
url <- 'https://en.wikipedia.org/wiki/2014_Winter_Olympics_medal_table'
crawl_2014 <- read_html(url) %>% 
  html_nodes(.,css = 'table.wikitable.sortable') %>%
  html_table(fill = TRUE) %>% data.frame()

crawl_2014 <- separate(crawl_2014,NOC,sep = '\\(',into = c('country','code'))
crawl_2014$code <- str_replace_all(crawl_2014$code,'\\)','')
crawl_2014$country <- str_replace_all(crawl_2014$country," ","[sp]")
crawl_2014$country <- str_replace_all(crawl_2014$country,"[:space:]","")
crawl_2014$country <- str_replace_all(crawl_2014$country,"\\[sp\\]"," ")
crawl_2014$share <- crawl_2014$Total / crawl_2014$Total[nrow(crawl_2014)]
crawl_2014 <- crawl_2014[1:nrow(crawl_2014)-1,
                         c("code","country","Total","share")]
crawl_2014 <- crawl_2014[order(crawl_2014$share,decreasing = TRUE),]
crawl_2014$rank <- 1:nrow(crawl_2014)

# bind
medal <- rbind(crawl_1992,crawl_1994,crawl_1998,
               crawl_2002,crawl_2006,crawl_2010,crawl_2014)
year <- ls()[startsWith(ls(),"crawl")] %>%
  str_replace_all(.,'\\D','')
medal$year <- rep(year,c(20,22,24,24,26,26,26))
medal$rank_g <- ifelse(medal$rank <= 5,1,0)

# write.csv(medal,'medal.csv')
