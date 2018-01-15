setwd("D:/승훈/Data/Olympic analysis")
oly3 <- read.csv('oly3.csv')
oly3 <- oly3[,-1]

pkgs <- c("tidyverse","caret")
sapply(pkgs, require, character.only = TRUE)

# tobit
library(VGAM)
md <- vglm(Total96 ~ Total92 + log(gdp_92) + log(X1992), data = oly3, family = "tobit")
md2 <- vglm(Total96 ~ Total92 + log(gdp_92) + log(X1992), data = oly3,tobit(Lower = 0))

# making test data.
# ?
set.seed(20180110)
rand_pop <- data.frame(rand = rnorm(100,mean(log(oly3$X1992),na.rm = TRUE),
                                    sd(log(oly3$X1992),na.rm = TRUE)))

table(round(rand_pop$rand,2) %in% round(log(oly3$X1992),2))

rand_pop$up <- round(rand_pop$rand,2)
oly3$pop_join <- round(log(oly3$X1992),2)
pre_data <- full_join(rand_pop,oly3, by = c("up" = "pop_join"))
pre_data <- pre_data[!is.na(pre_data$Country),]
pre_data <- pre_data %>% select("Total96","Total92","gdp_92","X1992")
pre_data <- sample_n(pre_data,size = 60)

# other algorithms.
# random forest in h2o
library(h2o)
h2o.init(max_mem_size = "8G")
holy <- oly3[,c("Total96","Total92","gdp_92","X1992")]
hsample <- sample_n(holy,size = 60)
hx <- names(holy[,c(2,3,4)])
oly_rf <- h2o.randomForest(x = hx,
                           y = "Total96",
                           training_frame = as.h2o(holy),
                           ntrees = 5000,
                           nfolds = 10)

(rf_train_rmse <- h2o.rmse(oly_rf, train = TRUE))
(rf_valid_rmse <- h2o.rmse(oly_rf, xval = TRUE))
(rf_test_perfor <- h2o.performance(oly_rf, as.h2o(hsample)))
(rf_test_rmse <- h2o.rmse(rf_test_perfor))

# randomforset package
library(randomForest)
(rf <- randomForest(Total96 ~ Total92 + gdp_92 + X1992,
                    data = oly3, ntree = 5000, na.action = na.omit))

# fill na with kmeans algorithm.
library(DMwR)
ds <- knnImputation(holy[,c(2,3,4)],5)
ds <- cbind("Total96" = holy[,1],ds)

(ds_rf <- randomForest(Total96 ~ Total92 + gdp_92 + X1992,
                       data = ds, ntree = 5000))

# random forest accuracy
"for(i in 1:5){
idx <- createDataPartition(y = holy$Total96, p = 0.3, list = FALSE)
ssample <- holy[idx,]
tem <- round(predict(ds_rf, ssample),0)
ssample$rightpred <- tem == ssample$Total96
t <- table(pre = tem,
           rea = ssample$Total96)
print(t)
accuracy <- sum(ssample$rightpred,na.rm = TRUE) / nrow(ssample)
print(accuracy)
}"

# with log?
oly3$log_gdp92 <- log(oly3$gdp_92)
oly3$log_pop92 <- log(oly3$X1992)
(rf_oly <- randomForest(Total96 ~ Total92 + log_gdp92 + log_pop92,
                        data = oly3, ntree = 5000, na.action = na.omit))

log_ds <- knnImputation(oly3[,c("Total92","log_gdp92","log_pop92")],5)
log_ds <- cbind("Total96" = oly3$Total96, log_ds)
(rf_ds<- randomForest(Total96 ~ Total92 + log_gdp92 + log_pop92,
                      data = log_ds, ntree = 5000))
