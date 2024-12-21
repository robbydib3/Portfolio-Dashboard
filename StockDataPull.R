# Volume - Amount of trades on that specific stock over a given time

# Adjusted - Adjusted closing prices are the stock's closing prices that 
# have been modified to reflect corporate actions such as dividends, 
# stock splits, and other factors that may affect the stock's value over time.
# This is a more consistent price to look at.

library(tidyquant)
library(quantmod)
library(lubridate)
library(tidyverse)
library(tibble)

options("getSymbols.warning4.0"=FALSE)
options("getSymbols.yahoo.warning"=FALSE)

current_date <- Sys.Date()
start_date <- "2024-03-21"

CURRENT_STOCKS <- read.csv('C:/Users/rober/Documents/Portfolio-Dashboard/CURRENT STOCKS.csv',check.names = FALSE) %>% 
  mutate(`Acquistion Date` = as.Date(`Acquistion Date`,'%m/%d/%Y'))

stock_pull <- function(ticker,aquisition_date){
   data <- getSymbols(ticker, from = aquisition_date,
                    to = current_date,warnings = FALSE,
                    auto.assign = FALSE) 

   return(data)
}

return_fun <- function(data,initial_price,shares){
  
  purchase_price_per_share <- initial_price
  number_of_shares <- shares
  
  return_in_dollars <- c()

  colnames(data) <- sapply(colnames(data), function(x) strsplit(x, "\\.")[[1]][2])
  
  for(price in data$Close){
    current_price_per_share <-price    

    initial_investment <- purchase_price_per_share * number_of_shares
    current_value <- current_price_per_share * number_of_shares
    return_in_dollars <- c(return_in_dollars,round(current_value - initial_investment,2))
  }
  
  data$Initial_Price <- initial_price
  data$Return <- return_in_dollars
  
  return(data)
}





stock_data <- lapply(1:nrow(CURRENT_STOCKS), function(n) {
  return_fun(stock_pull(CURRENT_STOCKS$Ticker[n],CURRENT_STOCKS$`Acquistion Date`[n]),CURRENT_STOCKS$`Initial Price`[n],CURRENT_STOCKS$Shares[n])
})

## Export
final <- data.frame()

for(name in 1:nrow(CURRENT_STOCKS)){
  data <- stock_data[name] %>% data.frame() 
  #colnames(data) <- sapply(colnames(data), function(x) strsplit(x, "\\.")[[1]][2])
  data <- tibble::rownames_to_column(data, var = "Date") %>% 
    mutate(Ticker = CURRENT_STOCKS$Ticker[name])
   final <- rbind(final,data)
}

write.csv(final,'C:/Users/rober/Documents/Portfolio-Dashboard/All_Stock_Data.csv')

print('DATA REFRESHED')
