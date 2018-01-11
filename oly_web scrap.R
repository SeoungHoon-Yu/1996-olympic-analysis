pkgs <- c('rvest', 'dplyr','data.table','stringr')
lapply(pkgs, require, character.only = TRUE)

# 1992
url <- "http://en.classora.com/reports/t24369/ranking-of-the-worlds-richest-countries-by-gdp?id=243&groupCount=50&startIndex=1&version=1992"
re_url <- read_html(url)
info <- html_table(html_nodes(re_url,css = 'table'))
info <- info[[1]]

url <- "http://en.classora.com/reports/t24369/ranking-of-the-worlds-richest-countries-by-gdp?id=243&groupCount=50&startIndex=51&version=1992"
re_url <- read_html(url)
info2 <- html_table(html_nodes(re_url,css = 'table'))
info2 <- info2[[1]]

url <- "http://en.classora.com/reports/t24369/ranking-of-the-worlds-richest-countries-by-gdp?id=243&groupCount=50&startIndex=101&version=1992"
re_url <- read_html(url)
info3 <- html_table(html_nodes(re_url,css = 'table'))
info3 <- info3[[1]]

url <- "http://en.classora.com/reports/t24369/ranking-of-the-worlds-richest-countries-by-gdp?id=243&groupCount=50&startIndex=151&version=1992"
re_url <- read_html(url)
info4 <- html_table(html_nodes(re_url,css = 'table'))
info4 <- info4[[1]]

gdp92 <- rbind(info,info2,info3,info4)
gdp92 <- gdp92[,c(1,3,5)]
names(gdp92) <- c("Rank","Country","GDP")
gdp92$GDP <- as.numeric(str_replace_all(gdp92$GDP,",",""))
remove(info,info2,info3,info4)

# 1996
url <- "http://en.classora.com/reports/t24369/general/ranking-of-the-worlds-richest-countries-by-gdp?edition=1996"
re_url <- read_html(url)
gdp96_1 <- html_table(html_nodes(re_url, css = 'table'))
gdp96_1 <- gdp96_1[[1]]

url <- "http://en.classora.com/reports/t24369/general/ranking-of-the-worlds-richest-countries-by-gdp?id=243&groupCount=50&startIndex=51&version=1996"
re_url <- read_html(url)
gdp96_2 <- html_table(html_nodes(re_url, css = 'table'))
gdp96_2 <- gdp96_2[[1]]

url <- "http://en.classora.com/reports/t24369/general/ranking-of-the-worlds-richest-countries-by-gdp?id=243&groupCount=50&startIndex=101&version=1996"
re_url <- read_html(url)
gdp96_3 <- html_table(html_nodes(re_url, css = 'table'))
gdp96_3 <- gdp96_3[[1]]

url <- "http://en.classora.com/reports/t24369/general/ranking-of-the-worlds-richest-countries-by-gdp?id=243&groupCount=50&startIndex=151&version=1996"
re_url <- read_html(url)
gdp96_4 <- html_table(html_nodes(re_url, css = 'table'))
gdp96_4 <- gdp96_4[[1]]

gdp96 <- rbind(gdp96_1,gdp96_2,gdp96_3,gdp96_4)
gdp96 <- gdp96[,c(1,3,5)]
names(gdp96) <- c("Rank","Country","GDP")
gdp96$GDP <- as.numeric(str_replace_all(gdp96$GDP,",",""))
remove(gdp96_1,gdp96_2,gdp96_3,gdp96_4)

gdp_join <- full_join(gdp96,gdp92,by = c("Country" = "Country"))
gdp_join <- gdp_join[,c(2,3,5)]
names(gdp_join) <- c("Country","gdp_96","gdp_92")
write.csv(gdp_join,'gpd_scrap.csv')
# 최종 결과물인 gdp_join을 활용.