setwd("D:/승훈/Data/Olympic analysis")
oly3 <- read.csv('oly3.csv')
oly3 <- oly3[,-1]

pkgs <- c("tidyverse","caret")
sapply(pkgs, require, character.only = TRUE)

# tobit
# package 1. vgam
library(VGAM)
tob_vgam <- vglm(Share_96 ~ Share_92 + log(gdp_92) + log(X1992),
                 data = oly3, family = "tobit")
summary(tob_vgam)

# package 2. AER
library(AER)
tob_aer <- tobit(Share_96 ~ Share_92 + log(gdp_92) + log(X1992), left = 0, 
               right = Inf, data = oly3)
summary(tob_aer)

# other algorithms.
# random forest in h2o
library(h2o)
h2o.init(max_mem_size = "8G")
holy <- oly3[,c("Share_96","Share_92","gdp_92","X1992")]
hsample <- sample_n(holy,size = 60)
hx <- names(holy[,c(2,3,4)])
oly_rf <- h2o.randomForest(x = hx,
                           y = "Share_96",
                           training_frame = as.h2o(holy),
                           ntrees = 5000,
                           nfolds = 10)

(rf_train_rmse <- h2o.rmse(oly_rf, train = TRUE))
(rf_valid_rmse <- h2o.rmse(oly_rf, xval = TRUE))
(rf_test_perfor <- h2o.performance(oly_rf, as.h2o(hsample)))
(rf_test_rmse <- h2o.rmse(rf_test_perfor))

# randomforset package
library(randomForest)
(rf <- randomForest(Share_96 ~ Share_92 + gdp_92 + X1992, data = oly3,
             ntree = 5000, mtry = 1,na.action = na.omit))

# fill na with kmeans algorithm.
library(DMwR)
ds <- knnImputation(holy[,c(2,3,4)],5)
ds <- cbind("Share_96" = holy[,1],ds)

(ds_rf <- randomForest(Share_96 ~ Share_92 + gdp_92 + X1992, data = ds,
                      ntree = 5000, mtry = 1, proximity = TRUE))

# random forest accuracy
tem <- predict(ds_rf, hsample)
hsample$rightpred <- tem == hsample$Share_96
t <- table(tem,hsample$Share_96)
accuracy <- sum(hsample$rightpred) / nrow(hsample)

