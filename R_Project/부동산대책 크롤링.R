# 부동산대책 크롤링 2017-01-15~2020-12-14 (한달단위)
library(rvest) 
library(stringr)
library(dplyr)
sum <- c()
keyword <- "부동산대책"
keyword <- URLencode(iconv(keyword, to='UTF-8'))
base_url <- "https://search.daum.net/search?nil_suggest=btn&w=news&DA=STC&cluster=y&q="
address1 <- "&sd="
address2 <- "15000000&ed="
address3 <- "14235959&period=u"
years_vec <- c("2017","2018","2019","2020","2021")
months_vec <- c('01','02','03','04','05','06','07','08','09',
                '10','11','12','13')
for(year in 1:6){
  for(month in 1:12){

    monthFrom <- months_vec[month]
    monthTo <- ifelse(months_vec[month+1] != '13',months_vec[month+1] ,'01')
    yearFrom <- years_vec[year]
    yearTo <- ifelse(months_vec[month+1] != '13',years_vec[year],years_vec[year+1])
    if(yearTo == "2021" ){
      break
    }
    url <- paste0(base_url,keyword,address1,yearFrom,monthFrom,
                address2,yearTo,monthTo,address3)
    html <- read_html(url)
    num <- html %>% html_nodes("div.coll_tit")%>% html_text()
    num <- unlist(str_split(num[1], '/'))
    num <- str_trim(num[2])
    num <- unlist(str_split(num, ' '))      
    num <- gsub(",","",num[2])
    num <- gsub("건","",num)
    num <- as.integer(num)
    sum <- c(sum, num)
  }
} 

sum
