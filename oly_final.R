# olympic wrap up.
pkgs <- c("tidyverse","caret")
sapply(pkgs,require,character.only = TRUE) 

dir <- 'D:/승훈/Data/Olympic analysis'
setwd(dir)

WEB <- read.csv('df9296.csv')

WEB <- WEB[,c(2,3,4,8,9,13)]
WEB$Country <- as.character(WEB$Country)
WEB2 <- WEB

# 독립국가연합(구소련)
uni <- c("Russia", "Moldova", "Belarus", "Armenia", "Azerbaijan", "Uzbekistan", "Ukraine"
         , "Georgia", "Kyrgyzstan", "Kazakhstan", "Tajikistan", "Turkmenistan")
uni_t <- WEB2[(WEB2$Country %in% uni == TRUE), ]
uni_t <- uni_t[,c(1,4)]
uni_t2 <- uni_t %>% mutate(portion96 = round(Total96 / 842,2)) %>%
  mutate(pre92 = round(815 * portion96))
WEB2[which(WEB2$Country %in% uni),6] <- uni_t2$pre92

# 독립참가 선수단(독립국가 연합과는 다름)
ind <- c("Slovenia", "Croatia", "Bosnia and Herzegovina", "Serbia and Montenegro", 
         "Macedonia")
ind_t <- WEB2[(WEB2$Country %in% ind == TRUE), ]
ind_t <- ind_t[,c(1,4)]
ind_t2 <- ind_t %>% mutate(portion96 = round(Total96 / 842,2)) %>%
  mutate(pre92 = round(815 * portion96))
WEB2[which(WEB2$Country %in% ind),6] <- ind_t2$pre92

# 체코슬로바키아(체코, 슬로바키아)
cs <- c("Czech Republic","Slovakia")
cze_slo <- WEB2[WEB2$Country %in% cs,] 
cze_slo_t <- cze_slo[,c(1,3)]
cze_slo_t <- cze_slo %>% mutate(portion96 = round(Total96 / 842,2)) %>%
  mutate(pre92 = round(815 * portion96))
WEB2[which(WEB2$Country %in% cs),6] <- cze_slo_t$pre92

# 크롤링의 최종 결과물인 gdp_join
gdp_join <- read.csv('gpd_scrap.csv',stringsAsFactors = FALSE)

# 이름 다른국가 수정
# 메달 1개 이상인 국가들 중 차이니즈 타이페이, 북한, 영국, 쿠바가 gdp_join에 없음.

# 없는 이름 수정하기
# 이름 변경
gdp_join[gdp_join$Country == "United Kingdom",1] <- "Great Britain"

oly <- left_join(WEB2,gdp_join, by = c("Country" = "Country"))
oly[oly$Country %in% c("Chinese Taipei","North Korea","Cuba"),"gdp_96"] <- c(292700000000,25017300000,0)
oly[oly$Country %in% c("Chinese Taipei","North Korea","Cuba"),"gdp_92"] <- c(223100000000,22085858243.2,0)
oly[oly$Country == "Iran","gdp_92"] <- 48900000000
oly[oly$Country == "American Samoa",c("gdp_96","gdp_92")] <- c(300000000,200000000)
oly[oly$Country == "Andorra",c("gdp_96","gdp_92")] <- c(1223945356.6,1210013651.9)
oly[oly$Country == "Bosnia and Herzegovina","gdp_92"] <- 1055802469.1
oly[oly$Country == "Zaire",c("gdp_92","gdp_96")] <- c(8206227134.0,5771454939.6)
oly[oly$Country == "Liechtenstein",c("gdp_92","gdp_96")] <-  c(1631197909.3,2504033252.4)
oly[oly$Country == "Monaco",c("gdp_92","gdp_96")] <-  c(2737066955.9,3137848783.1)
oly[oly$Country == "Serbia and Montenegro",c("gdp_96")] <- 20948677839.9
oly[oly$Country == "The Gambia",c("gdp_92","gdp_96")] <- c(714255460.5,848237108.6)
oly[oly$Country == "Virgin Islands",c("gdp_92","gdp_96")] <- c(1770899968.0,2632500000)
  
POP <- read.csv('world_pop.csv',skip = 4,stringsAsFactors = FALSE)
POP <- POP[,c("Country.Name","X1992","X1996")]
oly[oly$Country %in% POP$Country.Name == FALSE,]

POP$Country.Name[POP$Country.Name == "Bahamas, The"] <- "Bahamas"
POP$Country.Name[POP$Country.Name == "Congo, Dem. Rep."] <- "Congo"
POP$Country.Name[POP$Country.Name == "Egypt, Arab Rep."] <- "Egypt"
POP$Country.Name[POP$Country.Name == "United Kingdom"] <- "Great Britain"
POP$Country.Name[POP$Country.Name == "Hong Kong SAR, China"] <- "Hong Kong"
POP$Country.Name[POP$Country.Name == "Iran, Islamic Rep."] <- "Iran"
POP$Country.Name[POP$Country.Name == "Kyrgyz Republic"] <- "Kyrgyzstan"
POP$Country.Name[POP$Country.Name == "Macedonia, FYR"] <- "Macedonia"
POP$Country.Name[192] <- "North Korea"
POP$Country.Name[POP$Country.Name == "Russian Federation"] <- "Russia"
POP$Country.Name[POP$Country.Name == "St. Vincent and the Grenadines"] <- "Saint Vincent and the Grenadines"
POP$Country.Name[POP$Country.Name == "Slovak Republic"] <- "Slovakia"
POP$Country.Name[POP$Country.Name == "Korea, Rep."] <- "South Korea"
POP$Country.Name[POP$Country.Name == "Syrian Arab Republic"] <- "Syria"
POP$Country.Name[POP$Country.Name == "Gambia, The"] <- "The Gambia"
POP$Country.Name[POP$Country.Name == "Venezuela, RB"] <- "Venezuela"
POP$Country.Name[POP$Country.Name == "Virgin Islands"] <- "Virgin Islands (U.S.)"
POP$Country.Name[POP$Country.Name == "Yemen, Rep."] <- "Yemen"
POP$Country.Name[POP$Country.Name == "Congo, Rep."] <- "Zaire"
POP$Country.Name[POP$Country.Name == "Brunei Darussalam"] <- "Brunei"
POP$Country.Name[POP$Country.Name == "Cabo Verde"] <- "Cape Verde"
POP$Country.Name[POP$Country.Name == "Lao PDR"] <- "Laos"
POP$Country.Name[POP$Country.Name == "West Bank and Gaza"] <- "Palestine"
POP$Country.Name[POP$Country.Name == "St. Kitts and Nevis"] <- "Saint Kitts and Nevis"
POP$Country.Name[POP$Country.Name == "St. Lucia"] <- "Saint Lucia"
POP$Country.Name[POP$Country.Name == "Cote d'Ivoire"] <- "Ivory Coast"

oly[oly$Country == "Cook Islands",c("gdp_92","gdp_96")] <- c(75000000,110000000)
oly[oly$Country == "Netherlands Antilles",c("gdp_92","gdp_96")] <- c(200000000,290000000) 
oly[oly$Country == "Serbia and Montenegro","gdp_92"] <- 42500000000
oly[oly$Country == "Palestine",c("gdp_92","gdp_96")] <- c(1900000000,4300000000)

oly[oly$Country %in% POP$Country.Name == FALSE,]
oly2 <- left_join(oly,POP,by = c("Country" = "Country.Name"))


# medal to share
# 92년도 메달 815개, 96년도 메달 842개
sum(oly2$Total92,na.rm = TRUE)
sum(oly2$Total96)

oly3 <- oly2 %>% mutate(Share_92 = Total92 / 815,
                        Share_96 = Total96 / 842)
oly3 <- oly3[is.na(oly3$Total92) == FALSE,]
oly3[oly3$Country == "Chinese Taipei",c("X1992","X1996")] <- c(20353000,21471000)
oly3[oly3$Country == "Serbia and Montenegro",c("X1992","X1996")] <- c(9702957+617174,9851957+619696)
oly3[oly3$Country == "Kuwait","X1992"] <- 1909096
oly3[oly3$Country == "North Korea",c("gdp_92","gdp_96")] <- c(917431.19 * 31108,26882 * 917431.19)
# write.csv(oly3,'oly3.csv')

# tobit
library(VGAM)
md <- vglm(Share_96 ~ Share_92 + log(gdp_92) + log(X1992), data = oly3, family = "tobit")
md2 <- vglm(Share_96 ~ Share_92 + log(gdp_92) + log(X1992), data = oly3,tobit(Lower = 0))

# predict chat function.
ask <- function(){
 country <- readline("Enter your Country Name:")
 medal <- as.numeric(readline("Enter your medal in 1992 olympic:"))
 gdp <- as.numeric(readline("Enter 1992 GDP($):"))
 pop <- as.numeric(readline("Enter 1992 Population:"))
 newdf <- data.frame(Share_92 = medal / 815,
                     gdp_92 = gdp,
                     X1992 = pop)
 pre <- data.frame(predict(md,newdf))
 print(paste("Your Country:",country))
 ifelse(pre[1,1] < 0, print(paste("Predicted 1996 medal:",842 * pre[1,1])),
        print("Your predicted medal is zero. so sad..."))
 print(paste("Error of your prediction:",842 * pre[1,2]))
}

ask()

# making test data.
rand_pop <- data.frame(rand = rnorm(100,mean(log(oly3$X1992),na.rm = TRUE),
                             sd(log(oly3$X1992),na.rm = TRUE)))

table(round(rand_pop$rand,2) %in% round(log(oly3$X1992),2))

rand_pop$up <- round(rand_pop$rand,2)
oly3$pop_join <- round(log(oly3$X1992),2)
pre_data <- full_join(rand_pop,oly3, by = c("up" = "pop_join"))
pre_data <- pre_data[!is.na(pre_data$Country),]
pre_data <- pre_data %>% select("Share_96","Share_92","gdp_92","X1992")
pre_data <- sample_n(pre_data,size = 60)

# other algorithms.
# random forest in h2o
library(h2o)
h2o.init(max_mem_size = "8G")
holy <- oly3[,c("Share_96","Share_92","gdp_92","X1992")]
hsample <- sample_n(holy,size = 60)
hx <- names(holy[,c(2,3,4)])
oly_rf <- h2o.randomForest(x = c("Share_92","gdp_92","X1992"),
                           y = "Share_96",
                           training_frame = as.h2o(holy),
                           ntrees = 5000,
                           nfolds = 10)

(rf_train_rmse <- h2o.rmse(oly_rf, train = TRUE))
(rf_valid_rmse <- h2o.rmse(oly_rf, xval = TRUE))
(rf_test_perfor <- h2o.performance(oly_rf, as.h2o(pre_data)))
(rf_test_rmse <- h2o.rmse(rf_test_perfor))

ab <- h2o.predict(oly_rf, newdata = as.h2o(pre_data))
ab <- as.data.frame(ab)
table(ab$predict)
