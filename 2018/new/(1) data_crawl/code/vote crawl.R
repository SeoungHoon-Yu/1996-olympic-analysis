pkgs <- c('dplyr','rvest','RCurl',
          'data.table','stringr')
sapply(pkgs, require, character.only = TRUE)

# 1992
url <- 'https://en.wikipedia.org/wiki/1992_Winter_Olympics'
vote_1992 <- read_html(url) %>% 
  html_nodes(.,css = '.wikitable.collapsible') %>%
  html_table(fill = TRUE) %>% data.frame()
vote_1992 <- vote_1992[,-9]
colnames(vote_1992) <- vote_1992[1,]
vote_1992 <- vote_1992[-1,c(2,8)]

# 1994
url <- 'https://en.wikipedia.org/wiki/1994_Winter_Olympics'
vote_1994 <- read_html(url,encoding = 'latin1') %>%
  html_node(css = 'table.wikitable.plainrowheaders') %>%
  html_table(fill = TRUE) %>% data.frame()
(vote_1994 <- vote_1994[,c(2,5)])

# 1998
url <- 'https://en.wikipedia.org/wiki/1998_Winter_Olympics'
vote_1998 <- read_html(url) %>%
  html_nodes(.,css = '.wikitable.collapsible') %>%
  html_table(fill = TRUE) %>% data.frame()
colnames(vote_1998) <- vote_1998[1,]
vote_1998 <- vote_1998[-1,c(2,7)]

# 2002
url <- 'https://en.wikipedia.org/wiki/2002_Winter_Olympics'
vote_2002 <- read_html(url) %>%
  html_node(.,css = '.wikitable.collapsible') %>%
  html_table(fill = TRUE)
colnames(vote_2002) <- vote_2002[1,]
vote_2002 <- vote_2002[-1,c(2,3)]

# 2006
url <- 'https://en.wikipedia.org/wiki/2006_Winter_Olympics'
vote_2006 <- read_html(url) %>%
  html_node(.,css = '.wikitable.collapsible') %>%
  html_table(fill = TRUE)
colnames(vote_2006) <- vote_2006[1,]
vote_2006 <- vote_2006[-1,c(2,3)]

# 2010
url <- 'https://en.wikipedia.org/wiki/2010_Winter_Olympics'
vote_2010 <- read_html(url,encoding = 'latin1') %>%
  html_node(.,css = '.wikitable') %>%
  html_table(fill = TRUE)
colnames(vote_2010) <- vote_2010[1,]
vote_2010 <- vote_2010[-1,c(2,4)]

# 2014
url <- 'https://en.wikipedia.org/wiki/2014_Winter_Olympics'
vote_2014 <- read_html(url,encoding = 'latin1') %>%
  html_node(.,css = '.wikitable') %>%
  html_table(fill = TRUE)
colnames(vote_2014) <- vote_2014[1,]
vote_2014 <- vote_2014[-1,c(2,4) ]

# 2018
url <- 'https://en.wikipedia.org/wiki/2018_Winter_Olympics'
vote_2018 <- read_html(url,encoding = 'latin1') %>%
  html_node(.,css = '.wikitable') %>%
  html_table(fill = TRUE)
colnames(vote_2018) <- vote_2018[1,]
vote_2018 <- vote_2018[-1,c(2,3)]

year <- str_sub(ls()[startsWith(ls(),'vote_')],6,9)
vote <- list(vote_1992,vote_1994,vote_1998,vote_2002,
             vote_2006,vote_2010,vote_2014,vote_2018)
year <- rep(year,sapply(vote,nrow))
vote <- rbindlist(vote)
vote$year <- year
names(vote) <- c('country','final_vote','year')

# convert final vote
Encoding(vote$final_vote) <- 'UTF-8'
iconv(vote$final_vote, "UTF-8", "ASCII", sub="")
vote$final_vote[!str_detect(vote$final_vote,'[:digit:]')] <- "0"
vote$final_vote

# save
write.csv(vote,'vote.csv')
