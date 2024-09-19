data = AdjClose;
returns = price2ret(data);
returns = rmmissing(returns);

model = garch(1,1);
fit = estimate(model, returns);
co = fit.Constant;
ga = fit.GARCH{1};
ar = fit.ARCH{1};
model = garch('Constant',co', 'GARCH',ga', 'ARCH', ar');

[V,Y] = simulate(model, 3000, "NumPaths",4);

figure;

Y1 = [returns; Y(:,1)];
Y2 = [returns; Y(:,2)];
Y3 = [returns; Y(:,3)];
Y4 = [returns; Y(:,4)];

subplot(4,1,1);
plot(Y1);
title('Simulation 1');
xline(length(returns), "LineWidth",1)

subplot(4,1,2);
plot(Y2);
title('Simulation 2');
xline(length(returns), "LineWidth",1)

subplot(4,1,3);
plot(Y3);
title('Simulation 3');
xline(length(returns),"LineWidth",1)

subplot(4,1,4);
plot(Y4);
title('Simulation 4');
xline(length(returns),"LineWidth",1)