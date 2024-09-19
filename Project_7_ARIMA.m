%Importovat Adj Close jako column vector
model = arima(1,1,1);
fit = estimate(model, AdjClose);

[Y, E] = simulate(fit, 500, 'NumPaths',100, 'Y0',AdjClose);
[YF,YMSE] = forecast(fit,500,'Y0',AdjClose);

Ylower = YF - 1.96*sqrt(YMSE);
Yupper = YF + 1.96*sqrt(YMSE);

figure;
plot(AdjClose);
hold on;
plot((length(AdjClose)+1):(length(AdjClose)+500), Y);
title('ARIMA (1,1,1) Simulation')
xlabel('Time')
ylabel('Price')
hold off;

figure;
plot(AdjClose);
hold on;
plot((length(AdjClose)+1):(length(AdjClose)+500), YF, 'k--', "LineWidth",2);
plot((length(AdjClose)+1):(length(AdjClose)+500), Ylower, 'r:',"LineWidth",2);
plot((length(AdjClose)+1):(length(AdjClose)+500), Yupper, 'r:',"LineWidth",2);
legend('AdjClose', 'Mean', '95% Intervals');
title('ARIMA (1,1,1) Forecast');
xlabel('Time');
ylabel('Price');
hold off;
