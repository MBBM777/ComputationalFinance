%Importovat Adj Close jako column vector
data = AdjClose;
returns = price2ret(data);
returns_dropna = rmmissing(returns);
sigma = std(returns_dropna);
r = mean(returns_dropna);
S0 = AdjClose(length(AdjClose));
T = 90; 
dt = 1; 

N = T/dt;

S = zeros(N+1, 1000);
S(1, :) = S0;
for i = 1:N
    dW = sqrt(dt) * randn(1, 1000);
    dS = r .* S(i, :) .* dt + sigma .* S(i, :) .* dW;
    S(i+1, :) = S(i, :) + dS;
end

figure(101);
hold on;
for i = 1:1000 
    shifted_time = linspace(T, T+T/N*(N+1), N+1); 
    plot(shifted_time, S(:, i))
end
plot(linspace(0, T, length(AdjClose)), AdjClose)
hold off;
xlabel('Time')
ylabel('Stock Price')
title('1000 Paths of GBM on a JPM stock')

