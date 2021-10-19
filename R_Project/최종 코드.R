library(rvest) 
library(stringr)
library(dplyr)
library(ggplot2)
library(gapminder)
library(lubridate)

# 코로나 크롤링 2020-01-01~2021-01-01 (한달단위)
cSum <- c()
keyword <- "코로나"
base_url <- "https://search.daum.net/search?nil_suggest=btn&w=news&DA=STC&cluster=y&q="
address1 <- "&sd=202"
address2 <- "01000000&ed=202"
address3 <- "01235959&period=u"
months_vec <- c('001','002','003','004','005','006','007','008',
                '009','010','011','012','101')
for(month in 1:12){
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
  cSum <- c(cSum, num)
}
cSum


# 부동산대책 크롤링 2016 ~2020 (일년단위)
sum <- 0
lSum <- c()
keyword <- "부동산대책"
keyword <- URLencode(iconv(keyword, to='UTF-8'))
base_url <- "https://search.daum.net/search?nil_suggest=btn&w=news&DA=STC&cluster=y&q="
address1 <- "&sd="
address2 <- "01000000&ed="
address3 <- "01235959&period=u"
years_vec <- c("2016","2017","2018","2019","2020","2021")
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
    if(is.na(num) == T){
      sum <- sum +950
    } else {
      sum <- sum + num
    }
  }
  if(year == 6){
    break
  }
  lSum <- c(lSum, sum)
} 
lSum

# 부동산대책 크롤링 2019-11 ~2020-10 (월단위)
sum <- 0
l2Sum <- c()
keyword <- "부동산대책"
keyword <- URLencode(iconv(keyword, to='UTF-8'))
base_url <- "https://search.daum.net/search?nil_suggest=btn&w=news&DA=STC&cluster=y&q="
address1 <- "&sd=20"
address2 <- "01000000&ed=20"
address3 <- "01235959&period=u"
months_vec <- c('1911','1912','2001','2002','2003','2004','2005','2006','2007',
                '2008','2009','2010','2011')
for(month in 1:12){
  monthFrom <- months_vec[month]
  monthTo <- months_vec[month+1]
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
    if(is.na(num) == T){
      l2Sum <- c(l2Sum,950)
    } else {
      l2Sum <- c(l2Sum,num)
    }
  }

l2Sum

# 그래프 #
t_trade <- read.csv('t_total.csv')
## 매매가 형성 산점도 그래프 ##



t_g <- t_trade %>%
  filter(계약연도!=2021) %>% 
  group_by(구,계약연도) %>% 
  ggplot(aes(계약연도,거래금액,color=구)) + 
  geom_point(stat='identity',alpha=0.2, position='jitter') +
  labs(title = "연도별 매매가 형성 산점도 그래프")
t_g

## 매매가 형성 바 그래프 ##

t_g_b <- t_trade %>%
  group_by(구,계약연도) %>% 
  ggplot(aes(계약연도,거래금액)) + 
  geom_bar(stat='identity', position='dodge',aes(fill=구)) +
  labs(title = "연도별 구별 최고 매매가 형성 막대 그래프")
t_g_b

## 평균매매가 변화량 추이 그래프 ##

t_trade %>% 
  group_by(계약연도,구) %>% 
  summarise(avg_t_trade = mean(거래금액)) %>% 
  ggplot(aes(계약연도,avg_t_trade))  +
  geom_line(aes(color=구),size=2)  +
  ylab("평균거래가") +
  labs(title = '지역구별 평균거래가격 추이')

## 연도별 거래 변화량 추이 그래프##

t_volume <- t_trade %>%
  filter(계약연도 != 2021) %>% 
  group_by(계약연도,구) %>% 
  summarise(num_kind=n()) %>% 
  ggplot(aes(계약연도,num_kind)) +
  geom_bar(stat='identity', position='dodge',aes(fill=구)) +
  ylab("계약건수") + labs(title = "연도별 구별 거래량 추이 막대 그래프")
t_volume

## 검색 트래픽과 주택가격 변화량의 상관관계 그래프 ##
covidSum <- cSum / 10
t_trade$계약월 <- as.integer(t_trade$계약월)
t_trade$계약월 <- sprintf("%02d",t_trade$계약월)
t_trade <- t_trade %>% 
  mutate(코로나 = ifelse(t_trade$계약연도 == 2020 &t_trade$계약월 == '01',covidSum[1],
                  ifelse(t_trade$계약연도 == 2020 &t_trade$계약월 == '02',covidSum[2],
                  ifelse(t_trade$계약연도 == 2020 &t_trade$계약월 == '03',covidSum[3], 
                  ifelse(t_trade$계약연도 == 2020 &t_trade$계약월 == '04',covidSum[4],
                  ifelse(t_trade$계약연도 == 2020 &t_trade$계약월 == '05',covidSum[5], 
                  ifelse(t_trade$계약연도 == 2020 &t_trade$계약월 == '06',covidSum[6], 
                  ifelse(t_trade$계약연도 == 2020 &t_trade$계약월 == '07',covidSum[7], 
                  ifelse(t_trade$계약연도 == 2020 &t_trade$계약월 == '08',covidSum[8],
                  ifelse(t_trade$계약연도 == 2020 &t_trade$계약월 == '09',covidSum[9],
                  ifelse(t_trade$계약연도 == 2020 &t_trade$계약월 == '10',covidSum[10], 
                  ifelse(t_trade$계약연도 == 2020 &t_trade$계약월 == '11',covidSum[11],
                         covidSum[12]))))))))))))
t_graph <- t_trade %>% 
  filter(계약연도==2020) %>% 
  group_by(계약월,구,코로나) %>% 
  summarise(avg_t_trade = mean(거래금액),코로나평균=mean(코로나)) %>% 
  ggplot(aes(계약월,avg_t_trade))+ 
  geom_bar(stat='identity',position='dodge', aes(fill=구))+
  geom_line(aes(계약월,코로나평균,group=1),size=1.5) +
  scale_y_continuous(sec.axis = sec_axis(~.,name="코로나 검색 트래픽 * 10")) +
  ylab("평균거래가") + xlab("2020년") + 
  labs(title = '2020년 검색 트래픽(코로나)과 주택가격 변화량의 상관관계 그래프')
t_graph
# 연도별 거래량 그래프 bar(거래량) + line(부동산대책)
ltvSum <- lSum / 100
t_trade$계약월 <- as.integer(t_trade$계약월)
t_trade$계약월 <- sprintf("%02d",t_trade$계약월)
t_trade <- t_trade %>% 
  mutate(부동산 = ifelse(t_trade$계약연도 == '2016',ltvSum[1],
                  ifelse(t_trade$계약연도 == '2017',ltvSum[2],
                  ifelse(t_trade$계약연도 == '2018',ltvSum[3], 
                  ifelse(t_trade$계약연도 == '2019',ltvSum[4],
                         ltvSum[5])))))
t_volume <- t_trade %>%
  filter(계약연도!=2021) %>% 
  group_by(계약연도) %>% 
  summarise(num_kind=n(),부동산평균=mean(부동산)) %>% 
  ggplot(aes(계약연도,num_kind)) +
  geom_bar(stat='identity') +
  geom_line(aes(계약연도,부동산평균,group=1),size=2,color="red") +
  scale_y_continuous(sec.axis = sec_axis(~.,name="부동산대책 검색 트래픽 * 100")) + 
  ylab("거래량") + labs(title = '검색 트래픽과 주택가격 변화량의 상관관계 그래프')
t_volume

# 2019~2020 월별 거래량 그래프 bar(거래량) + lines(부동산대책)
l2Sum <- l2Sum / 100
t_trade$거래일자 <- format(as.Date(as.character(t_trade$거래일자),"%Y%m%d"),"%Y-%m")
t_trade <- t_trade %>% 
  mutate(부동산 = ifelse(t_trade$거래일자 == "2019-11",l2Sum[1],
                  ifelse(t_trade$거래일자 == "2020-12",l2Sum[2],
                  ifelse(t_trade$거래일자 == "2020-01",l2Sum[3], 
                  ifelse(t_trade$거래일자 == "2020-02",l2Sum[4],
                  ifelse(t_trade$거래일자 == "2020-03",l2Sum[5],
                  ifelse(t_trade$거래일자 == "2020-04",l2Sum[6],
                  ifelse(t_trade$거래일자 == "2020-05",l2Sum[7], 
                  ifelse(t_trade$거래일자 == "2020-06",l2Sum[8],
                  ifelse(t_trade$거래일자 == "2020-07",l2Sum[9],
                  ifelse(t_trade$거래일자 == "2020-08",l2Sum[10],
                  ifelse(t_trade$거래일자 == "2020-09",l2Sum[11],
                         l2Sum[12]))))))))))))
t_volume <- t_trade %>%
  filter(거래일자 >= "2019-11"& 거래일자 <= "2020-10") %>% 
  group_by(거래일자) %>% 
  summarise(num_kind=n(),부동산평균=mean(부동산)) %>% 
  ggplot(aes(거래일자,num_kind)) +
  geom_bar(stat='identity') +
  geom_line(aes(거래일자,부동산평균,group=1),size=2,color="red") +
  scale_y_continuous(sec.axis = sec_axis(~.,name="부동산대책 검색 트래픽 * 100")) + 
  ylab("거래량") + labs(title = '검색 트래픽과 주택가격 변화량의 상관관계 그래프')
t_volume