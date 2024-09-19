clc;clear;
numPaths = 5000;
numDays = 100;
A = [2, 10, 3, 7, 1];

paths = zeros(numDays, numPaths);

for i = 2:numDays
    for j = 1:numPaths
        A_value = A(ceil(j/1000));
        step = randn() * A_value;
        paths(i, j) = paths(i-1, j) + step;
    end
end

figure;
plot(paths)
title('Paths Over Time')
xlabel('Time (Days)')
ylabel('Position')

dfittool(paths(end, :))

disp(['Kurtosis: ', num2str(kurtosis(paths(end, :)))])

VaR_90 = prctile(paths(end, :), 10);
VaR_95 = prctile(paths(end, :), 5);
VaR_99 = prctile(paths(end, :), 1);

disp(['90% VaR: ', num2str(VaR_90)])
disp(['95% VaR: ', num2str(VaR_95)])
disp(['99% VaR: ', num2str(VaR_99)])