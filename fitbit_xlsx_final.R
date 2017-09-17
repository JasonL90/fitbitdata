library("fitbitScraper")
library("ggplot2") 
library(stringr)
library(xlsx)

cookie <- login(email="calloponia@gmail.com", password="2wjdgnsdlek!") 


fit_id <- read.xlsx2("fitbit_lung.xlsx",sheetIndex = 23, header = F)

i <- 14

id <- as.character(fit_id[i,9])
password <- as.character(fit_id[i,10])
#password <- paste0("00000",str_extract_all(id,"[0-9]+"))
start <- as.character(fit_id[i,11])
end <- as.character(fit_id[i,12])
output_file_name <- as.character(fit_id[i,13])
cookie <- login(email=id, password=password, rememberMe = T)  

diff <- as.numeric(as.Date(end) - as.Date(start)) + 1 

date <- seq(as.Date(start), as.Date(end), by = "1 day")
intraday_data <- 0

for ( x in 1:diff){
  intraday <- get_intraday_data(cookie, what = "steps", date = as.character(date[x]))
  intraday_data <- cbind(intraday_data,intraday)
}


intraday_data <- intraday_data[,-c(1,seq(to = diff*2, by = 2) +1)]

intraday_data <- rbind(as.character(date),intraday_data)

daily_data <- get_daily_data(cookie, what = "steps", start_date = start, end_date = end)
daily_data <- daily_data[,-c(1)]
daily_data
intraday_data <- rbind(intraday_data,daily_data)

write.csv(intraday_data,paste0(output_file_name,".csv"))







