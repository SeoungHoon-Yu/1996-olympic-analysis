pkgs <- c("dplyr","tidyr","stringr","DMwR",
          "caret")
sapply(pkgs,require,character.only = TRUE)

setwd("D:/승훈/Data/Olympic analysis/google_drive")

# read data.
oly_14 <- read.csv('winter_df2014.csv', stringsAsFactors = FALSE) 
oly_10 <- read.csv('winter_df2010.csv', stringsAsFactors = FALSE)

glimpse(oly_14)
glimpse(oly_10)

oly_14 <- oly_14[,c("Country","athletes","Total",
                    "POP","GDP")]
oly_10 <- oly_10[,c("Country","athletes","Total",
                    "POP","GDP")]

# matching names?
table(oly_10$Country %in% oly_14$Country)
oly_10[!oly_10$Country %in% oly_14$Country,"Country"]

table(oly_14$Country %in% oly_10$Country)
oly_14[!oly_14$Country %in% oly_10$Country,"Country"]

# join first, fill na with knn
# real medal 10 258 / 14 284
# when knn   10 259 / 14 282
oly <- full_join(oly_10,oly_14,by = c("Country" = "Country"))

oly_impute <- knnImputation(oly[,2:9],k = 5)
oly_impute$country <- oly$Country

names(oly_impute) <- c("ath_10" ,"total_10","pop_10","gdp_10",
                       "ath_14","total_14","pop_14","gdp_14",
                       "country")

# round and take log in numeric datas.
for(i in c(1,2,5,6)){
  oly_impute[,i] <- round(oly_impute[,i])
  remove(i)
  }

for(i in c(3,4,7,8)){
  oly_impute[,i] <- log(oly_impute[,i])
  remove(i)
}

# total to share
oly_impute$share_10 <- oly_impute$total_10 / 258
oly_impute$share_14 <- oly_impute$total_14 / 282

# data for comfort
(oly_formula <- as.formula(paste("share_14 ~ ",
          paste(names(oly_impute)[c(10,7,8)],collapse = "+"))))

# linear model
md_lm <- lm(oly_formula, data = oly_impute)
summary(md_lm)

# tobit regression
library(AER)
md_tb <- tobit(oly_formula,
               left = 0, right = Inf,
               data = oly_impute)
summary(md_tb)

library(VGAM)
md_tb2 <- vglm(oly_formula, data = oly_impute,
               family = "tobit")
summary(md_tb2)

# let's predict!
oly_18 <- read.csv('winter_df2018.csv',stringsAsFactors = FALSE)
glimpse(oly_18)
names(oly_18) <- c("a","country","pop_14","gdp_14")
table(oly_18$country %in% oly_impute$country)
oly_new <- oly_18[which(oly_18$country %in% oly_impute$country),]
oly_new <- left_join(oly_new,oly_impute[,c("country","share_14")],
                     by = c("country" = "country"))
oly_new <- oly_new[,3:5]
names(oly_new) <- c("pop_14","gdp_14","share_10")

# take logs.
oly_new$pop_14 <- log(oly_new$pop_14)
oly_new$gdp_14 <- log(oly_new$gdp_14)

# prediction.
options(scipen = 100)
md_lm_pre <- predict(md_lm, newdata = oly_new)
md_tb_pre <- predict(md_tb, newdata = oly_new)
md_tb2_pre <- predict(md_tb2, newdata = oly_new)[,1]

# may be random forest?
library(randomForest)
md_rf <- randomForest(oly_formula,
                      data = oly_impute,
                      ntree = 5000,
                      nfold = 10)
md_rf
md_rf_pre <- predict(md_rf, newdata = oly_new)

# h2o rf.
library(h2o)
h2o.init(max_mem_size = "7G")

v <- oly_impute[,c(10,7,8)]
x <- names(oly_impute[,c(10,7,8)])
md_rf2 <- h2o.randomForest(y = "share_14",
                           x = x,
                           training_frame = as.h2o(oly_impute),
                           ntrees = 5000,
                           nfolds = 10)
(rf2_val1 <- h2o.rmse(md_rf2,xval = TRUE))
(rf2_val2 <- h2o.rmse(md_rf2,train = TRUE))
(rf2_val3 <- h2o.predict(md_rf2,newdata = as.h2o(v)))
rf2_predict <- h2o.getFrame(attributes(rf2_val3)[[2]])
rf2_predict <- as.data.frame(rf2_predict)
