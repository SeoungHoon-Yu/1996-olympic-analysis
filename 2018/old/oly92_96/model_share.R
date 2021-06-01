setwd("D:/승훈/Data/Olympic analysis")
oly3 <- read.csv('oly3.csv')
oly3 <- oly3[,-1]

pkgs <- c("tidyverse","caret")
sapply(pkgs, require, character.only = TRUE)

# tobit
# package 1. vgam
library(VGAM)
tob_vgam <- vglm(Share_96 ~ Share_92 + log(gdp_96) + log(X1996),
                 data = oly3, family = "tobit")
summary(tob_vgam)

# package 2. AER
# na를 알아서 날린다. 10개.
library(AER)
tob_aer <- tobit(Share_96 ~ Share_92 + log(gdp_96) + log(X1996),
                 left = 0, right = Inf, data = oly3)
summary(tob_aer)
idx <- c(which(is.na(oly3$gdp_96)), which(is.na(oly3$X1996)))
aer_rmse <- sqrt(mean((tob_aer$linear.predictors - oly3$Share_96[-idx])^2))

# other algorithms.
# fill na with kmeans algorithm.
library(DMwR)
holy <- oly3[,c("Share_96","Share_92","gdp_96","X1996")]
ds <- knnImputation(holy[,c(2,3,4)],5)
ds <- cbind("Share_96" = holy[,1],ds)

# find best mtry with caret.
fitControl <- trainControl(method = "repeatedcv",number = 10, repeats = 5)
train(Share_96 ~ Share_92 + gdp_96 + X1996, data = ds,
      trControl = fitControl, verbose = F)

# random forest in h2o
library(h2o)
h2o.init(max_mem_size = "8G")
hsample <- sample_n(holy,size = 60)
hx <- names(holy[,c(2,3,4)])
oly_rf <- h2o.randomForest(x = hx,
                           y = "Share_96",
                           training_frame = as.h2o(holy),
                           ntrees = 5000,
                           nfolds = 10,
                           mtries = 3)

(rf_train_rmse <- h2o.rmse(oly_rf, train = TRUE))
(rf_valid_rmse <- h2o.rmse(oly_rf, xval = TRUE))
(rf_test_perfor <- h2o.performance(oly_rf, as.h2o(hsample)))
(rf_test_rmse <- h2o.rmse(rf_test_perfor))

# randomforset package
library(randomForest)
(rf <- randomForest(Share_96 ~ Share_92 + gdp_96 + X1996, data = oly3,
             ntree = 5000, mtry = 3,na.action = na.omit))
randomf_rmse <- sqrt(mean(rf$mse))

(ds_rf <- randomForest(Share_96 ~ Share_92 + gdp_96 + X1996, data = ds,
                      ntree = 5000, mtry = 3, proximity = TRUE))
knnrandom_rmse <- sqrt(mean(ds_rf$mse))

# conclusion. Accuracy
acc <- t(data.frame(tobit = aer_rmse,
                    h2o_rf = rf_train_rmse,
                    ran_rf = randomf_rmse,
                    knn_rf = knnrandom_rmse))
colnames(acc) <- "RMSE"
acc
