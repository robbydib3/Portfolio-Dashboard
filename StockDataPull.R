library(tidyquant)
library(quantmod)

options("getSymbols.warning4.0"=FALSE)
options("getSymbols.yahoo.warning"=FALSE)
# Downloading Apple price using quantmod

AAPL <- getSymbols("AAPL", from = '2017-01-01',
           to = "2018-03-01",warnings = FALSE,
           auto.assign = FALSE)


chart_Series(AAPL)

# Volume - Amount of trades on that specific stock over a given time

# Adjusted - Adjusted closing prices are the stock's closing prices that 
# have been modified to reflect corporate actions such as dividends, 
# stock splits, and other factors that may affect the stock's value over time.
# This is a more consistent price to look at.