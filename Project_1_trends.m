%Importovat Adj Close jako column vector
data = AdjClose(1:end);

MA20 = movmean(data, 20);

trends = [];
start = NaN;
for i = 1:length(MA20)-3
    if MA20(i+1) > MA20(i)
        if isnan(start)
            start = i;
        end
    else
        if ~isnan(start) && i - start >= 3
            trends = [trends; start i];
        end
        start = NaN;
    end
end
if ~isnan(start) && length(MA20) - start >= 3
    trends = [trends; start length(MA20)];
end

df = table(trends(:,1), trends(:,2), 'VariableNames', {'Start', 'End'});
disp(df)
