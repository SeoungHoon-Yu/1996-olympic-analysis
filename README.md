# 올림픽 메달 예측 repository입니다.

oly92_96은 기존에 출판되어 있던 논문을 기반으로 분석한것이고 <br/>
2018_winter는 2018년 평창올림픽 메달을 예측한것입니다.

--- 2018.01.29 --- </br>
기온데이터의 활용을 위해 작성한 코드들을 추가했습니다 </br>

--- 2018.02.17 --- </br>
최종본을 위한 final 폴더를 추가했습니다. </br>
일단은 처음 세웠던 </br>
share_14 ~ share_10 + pop_14 + gdp_14 의 식으로 완성한 oly_2018을 업로드 했습니다. </br>
아직 2018년 동계 올림픽의 총 메달 개수를 파악하지 못하여 예측된 share만 나와있는 상황입니다. </br>
</br>
추가적으로 보충해야할 사항</br> 
1. 기후데이터를 추가해서 다시 돌리는 것. </br>
2. 1992년부터 있었던 모든 동계 올림픽의 기록을 싹 묶어서 돌리는 것 </br>
</br>
활용 모델 </br>
1. Linear Regression </br>
2. Tobit Regression (Package : AER, VGAM) </br>
3. Random Forest (Package : RandomForest, H2o) </br>
