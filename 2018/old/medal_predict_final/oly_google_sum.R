pkgs <- c("dplyr","stringr","tidyr","lubridate",
          "caret","ggplot2","data.table")
sapply(pkgs,require,character.only = TRUE)
setwd("D:/승훈/Data/Olympic analysis/google_drive")
(lf <- list.files()[startsWith(list.files(),"winter") &
                   !endsWith(list.files(),"2018.csv")])

datas <- lapply(lf,read.csv,stringsAsFactors = FALSE)
df <- rbindlist(datas)
df <- df[,c("Country","athletes","Total",
              "POP","GDP")]

(year <- str_extract(lf,"([0-9])+"))
df$year <- factor(rep(year,sapply(datas, nrow)), levels = year)

# climate data.
climate <- read.csv('D:/승훈/Data/Olympic analysis/climate_temp/climate_crawl.csv',
                    stringsAsFactors = FALSE)

m_name <- toupper(str_sub(month.name,1,3))
climate <- climate[,colnames(climate) %in% c("country","YEAR")
                   | colnames(climate) %in% m_name]

table(df$Country %in% climate$country)

climate$country <- climate$country %>% str_replace_all("Isl","Islands") %>%
                                       str_replace_all("_"," ")

table(df$Country %in% climate$country)
unique(df$Country[-which(df$Country %in% climate$country)])

climate$country[which(climate$country == "United Kingdom")] <- "Great Britain"
climate$country[which(climate$country == "Puerto Rica")] <- "Puerto Rico"
climate$country[which(climate$country == "USA")] <- "United States"
climate$country[which(climate$country == "Samoa")] <- "American Samoa"
climate$country[which(climate$country == "Moldavia")] <- "Moldova"
climate$country[which(climate$country == "Grand Cayman")] <- "Cayman Islands"
climate$country[which(climate$country == "Bosnia-Herzegovinia")] <- "Bosnia and Herzegovina"
climate$country[which(climate$country == "Lesotho")] <- "Timor-Leste"
