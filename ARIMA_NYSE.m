load Data_EquityIdx
T = height(DataTimeTable)

%Removing missing values
DTT = rmmissing(DataTimeTable,DataVariables="NYSE");
T_DTT = height(DTT)
%Making sure that the data is regular and sorted or it wont work
areTimestampsRegular = isregular(DTT,"days")
areTimestampsSorted = issorted(DTT.Time)

%Data is not regular and we make regular by making it weekly data
DTTW = convert2weekly(DTT,Aggregation="mean");
areTimestampsRegular = isregular(DTTW,"weeks")
T_DTTW = height(DTTW)
%Ploting the data that is regular and sorted
figure
plot(DTTW.Time,DTTW.NYSE)
title("NYSE Weekly Closing Prices: 1990 - 2001")

Mdl = arima(1,1,1);
Mdl.SeriesName = "NYSE";

numpreobs = Mdl.P;
numperiods = 15; % Forecast horizon
DTTW0 = DTTW(1:numpreobs,:); %n presample
DTTW1 = DTTW((numpreobs+1):(end-numperiods),:); %estimation sample
DTTW2 = DTTW((end-numperiods+1):end,:); %forecast sample
EstMdl = estimate(Mdl,DTTW1,Presample=DTTW0,PresampleResponseVariable="NYSE");
Tbl2 = forecast(EstMdl,numperiods,DTTW2)

Tbl2.NYSE_Lower = Tbl2.NYSE_Response - 1.96*sqrt(Tbl2.NYSE_MSE);
Tbl2.NYSE_Upper = Tbl2.NYSE_Response + 1.96*sqrt(Tbl2.NYSE_MSE);

figure
h1 = plot([DTTW1.Time((end-75):end); DTTW2.Time], ...
    [DTTW1.NYSE((end-75):end); DTTW2.NYSE],Color=[.7,.7,.7]);
hold on
h2 = plot(Tbl2.Time,Tbl2.NYSE_Response,"k",LineWidth=2);
h3 = plot(Tbl2.Time,Tbl2{:,["NYSE_Lower" "NYSE_Upper"]},"r:",LineWidth=2);
legend([h1 h2 h3(1)],"Observations","Forecasts","95% forecast intervals", ...
    Location="NorthWest")
title("NYSE Weekly Average Closing Price")
hold off