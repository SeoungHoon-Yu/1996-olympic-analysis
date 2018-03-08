climate<\br>
--- 2018.01.30 --- 
올림픽 메달 예측에 기온 데이터를 추가합니다. 
진행 중 제시된 아이디어이기에 따로 폴더를 만들어 추가했습니다. 
데이터의 출처는 university of east angila 라는 학교입니다. 

Olympic_medal
--- 2018.01.11 --- 
두개의 코드를 업로드했습니다. 
oly_final은 전처리부터 분석까지 한 코드입니다. 
oly_web_scrap은 필요한 인구(pop)나 경제(gdp) 데이터를 웹에서 크롤링 한 코드입니다. 
분석 코드는 완료되면 업로드하도록 하겠습니다. 

--- 2018.01.15 --- 
분석 코드(medal_share)를 업로드합니다. 
vgam, aer 두 패키지로 tobit 회귀모델을 사용했고,
h2o와 randomforest 패키지로 randomforest를 돌렸습니다.
데이터에 있는 NA값에 대해서는 DMwR으로 knn을 활용해 채워넣고 
randomforest 패키지로 돌렸습니다. 
randomforest의 mtry 파라미터는 caret 패키지로 최적의 mtry를 찾아 활용했습니다.
다만 Observation이 너무 적어서 
Random Forest는 학습한 데이터의 일부를 test data로 활용한것이 맹점입니다. 

RMSE 
tobit 0.005417229 
h2o_rf 0.005215634 
ran_rf 0.005791654 
knn_rf 0.005516859 


--- 2018.01.21 --- 
작성한 코드에 문제가 있어 수정후 업로드합니다. 
최종본은 model_share_log.R 입니다. 

RMSE 
tobit 0.005380266 
h2o_rf 0.005185071 
ran_rf 0.005792481 
knn_rf 0.005618576 
