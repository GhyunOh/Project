# 코로나 크롤링 2020-02-15~2021-03-14 (한달단위)
library(rvest) 
library(stringr)
library(dplyr)
sum <- c()
keyword <- "코로나"
base_url <- "https://search.daum.net/search?nil_suggest=btn&w=news&DA=STC&cluster=y&q="
address1 <- "&sd=202"
address2 <- "15000000&ed=202"
address3 <- "14235959&period=u"
months_vec <- c('002','003','004','005','006','007','008','009',
                '010','011','012','101','102','103')
for(month in 1:13){
  monthFrom <- months_vec[month]
  monthTo <- months_vec[month+1]
    keyword <- URLencode(iconv(keyword, to='UTF-8'))
    url <- paste0(base_url,keyword,address1,monthFrom,
                  address2,monthTo,address3)
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
sum