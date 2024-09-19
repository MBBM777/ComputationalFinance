clc;
clear;
years_to_maturity = input('Enter maturity in years: ');
CouponRate = input('Enter the coupon rate (in decimal): ');
Yield = input('Enter the yield to maturity (YTM) (in decimal): ');
Settle = '14-Jun-2020';
Period = 2; 
Basis = 0; 

maturity_date = datetime(Settle) + years(years_to_maturity);


time_period = maturity_date - datetime(Settle);
days_to_maturity = ceil(days(time_period)); % Round up to nearest integer
clean_bond_prices = zeros(days_to_maturity, 1);
accrued_interest = zeros(days_to_maturity, 1);
dirty_bond_prices = zeros(days_to_maturity, 1);
days_elapsed = zeros(days_to_maturity, 1);

for i = 1:days_to_maturity
    maturity_date_temp = datetime(Settle) + days(i);
    [clean_bond_prices(i), accrued_interest(i)] = bndprice(Yield, CouponRate, Settle, maturity_date_temp, Period, Basis);
    dirty_bond_prices(i) = clean_bond_prices(i) + accrued_interest(i);
    days_to_maturity(i) = i;
end

plot(days_to_maturity, clean_bond_prices, '-b');
hold on;

plot(days_to_maturity, dirty_bond_prices, '-r');
hold off;

legend('Clean Bond Price', 'Dirty Bond Price');
xlabel('Days until maturity');
ylabel('Price');
title('Bond price development over time');
