import pandas as pd
import numpy as np
import yfinance as yf
import statsmodels.api as sm
import matplotlib.pyplot as plt

tickers = ['SPY', 'AAPL', 'MSFT']
for ticker in tickers:
    data = yf.download(tickers, '2015-01-01')['Adj Close']
    returns = data.pct_change().dropna()

bitcoin_data = yf.download('BTC-USD', '2015-01-01')['Adj Close']
data_with_bitcoin = data.join(bitcoin_data, how = 'left').rename(columns = {'Adj Close': 'BTC'})
returns_with_bitcoin = data_with_bitcoin.pct_change()

mean_daily_returns = returns.mean()
cov_matrix = returns.cov()

mean_daily_returns_with_bitcoin = returns_with_bitcoin.mean()
cov_matrix_with_bitcoin = returns_with_bitcoin.cov()

num_portfolios = 10000

portfolio_returns = np.zeros(num_portfolios)
portfolio_volatility = np.zeros(num_portfolios)
portfolio_returns_with_bitcoin = np.zeros(num_portfolios)
portfolio_volatility_with_bitcoin = np.zeros(num_portfolios)

for i in range(num_portfolios):
    weights = np.random.random(len(data.columns))
    weights /= np.sum(weights)
    portfolio_returns[i] = mean_daily_returns.dot(weights)
    portfolio_volatility[i] = np.sqrt(np.dot(weights.T, np.dot(cov_matrix, weights)))
    
for i in range(num_portfolios):
    weights = np.random.random(len(data_with_bitcoin.columns))
    weights /= np.sum(weights)
    portfolio_returns_with_bitcoin[i] = mean_daily_returns_with_bitcoin.dot(weights)
    portfolio_volatility_with_bitcoin[i] = np.sqrt(np.dot(weights.T, np.dot(cov_matrix_with_bitcoin, weights)))

min_volatility_index = np.argmin(portfolio_volatility)

yield_with_minimal_risk = portfolio_returns[min_volatility_index]

print("Yield with minimal risk:", yield_with_minimal_risk)

plt.figure(figsize=(10, 6))
plt.scatter(portfolio_volatility, portfolio_returns, label='Without Bitcoin', color='red', alpha=0.5)
plt.scatter(portfolio_volatility_with_bitcoin, portfolio_returns_with_bitcoin, label='With Bitcoin', color='lightblue', alpha=0.5)
plt.scatter(portfolio_volatility[min_volatility_index], portfolio_returns[min_volatility_index], color='green', marker='*', s=100, label='Minimal Risk')
plt.xlabel('Volatility')
plt.ylabel('Return')
plt.title('Efficient Frontiers with and without Bitcoin')
plt.legend()
plt.show()

