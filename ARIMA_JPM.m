clc;clear;
TT = readtimetable('JPM.csv');

DTT = rmmissing(TT,DataVariables="AdjClose");
T_DTT = height(DTT);
%Making sure that the data is regular and sorted or it wont work
areTimestampsRegular = isregular(DTT,"days");
areTimestampsSorted = issorted(DTT.Date);

%Data is not regular and we make regular by making it weekly data
DTTW = convert2weekly(DTT,Aggregation="mean");
areTimestampsRegular = isregular(DTTW,"weeks");
T_DTTW = height(DTTW);
%Ploting the data that is regular and sorted
figure
plot(DTTW.Date,DTTW.AdjClose)
title("JPM Weekly Closing Prices: 2019 - 2024")

Mdl = arima(1,1,1);
Mdl.SeriesName = "AdjClose";

numpreobs = Mdl.P;
numperiods = 30; %Forecast Horizon
DTTW0 = DTTW(1:numpreobs,:); 
DTTW1 = DTTW((numpreobs+1):(end-numperiods),:); 
DTTW2 = DTTW((end-numperiods+1):end,:);
EstMdl = estimate(Mdl,DTTW1,Presample=DTTW0,PresampleResponseVariable="AdjClose");
Tbl2 = forecast(EstMdl,numperiods,DTTW2)

Tbl2.AdjClose_Lower = Tbl2.AdjClose_Response - 1.96*sqrt(Tbl2.AdjClose_MSE);
Tbl2.AdjClose_Upper = Tbl2.AdjClose_Response + 1.96*sqrt(Tbl2.AdjClose_MSE);

figure
h1 = plot([DTTW1.Date((end-180):end); DTTW2.Date], ...
    [DTTW1.AdjClose((end-180):end); DTTW2.AdjClose],Color=[.2,.2,.2]);
hold on
h2 = plot(Tbl2.Date,Tbl2.AdjClose_Response,"k",LineWidth=2);
h3 = plot(Tbl2.Date,Tbl2{:,["AdjClose_Lower" "AdjClose_Upper"]},"r:",LineWidth=2);
legend([h1 h2 h3(1)],"Historical Data","Forecast mean","95% forecast intervals", ...
    Location="NorthWest")
title("JPM Closing Price Forecast")
hold off