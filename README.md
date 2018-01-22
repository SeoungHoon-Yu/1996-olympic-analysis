# Olympic_medal

--- 2018.01.11 --- <br/>
두개의 코드를 업로드했습니다. <br/>
oly_final은 전처리부터 분석까지 한 코드입니다. <br/>
oly_web_scrap은 필요한 인구(pop)나 경제(gdp) 데이터를 웹에서 크롤링 한 코드입니다. <br/>
분석 코드는 완료되면 업로드하도록 하겠습니다. <br/>


--- 2018.01.15 --- <br/>
분석 코드(medal_share)를 업로드합니다. <br/>
vgam, aer 두 패키지로 tobit 회귀모델을 사용했고,<br/>
h2o와 randomforest 패키지로 randomforest를 돌렸습니다.</br>
데이터에 있는 NA값에 대해서는 DMwR으로 knn을 활용해 채워넣고 <br/>
randomforest 패키지로 돌렸습니다. <br/>
randomforest의 mtry 파라미터는 caret 패키지로 최적의 mtry를 찾아 활용했습니다.<br/>
다만 Observation이 너무 적어서 <br/>
Random Forest는 학습한 데이터의 일부를 test data로 활용한것이 맹점입니다. <br/> 
<br/>
              RMSE <br/>
tobit  0.005417229 <br/>
h2o_rf 0.005215634 <br/>
ran_rf 0.005791654 <br/>
knn_rf 0.005516859 <br/>
<br/>

--- 2018.01.21 --- <br/>
작성한 코드에 문제가 있어 수정후 업로드합니다. <br/>
최종본은 model_share_log.R 입니다. <br/>
              RMSE <br/>
tobit  0.005380266 <br/>
h2o_rf 0.005185071 <br/>
ran_rf 0.005792481 <br/>
knn_rf 0.005618576 <br/>



