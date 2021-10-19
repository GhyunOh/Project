library(dplyr)
library(lubridate)
data <- read.csv("t_total.csv") 

# 행합치기
data <- rbind(data1,data2,data3)

# "일" 앞에 0입력
data$계약일 <- as.numeric(data$계약일)
data$계약일 <- sprintf("%02d",data$계약일)

# 거래일자 변수명 추가
data <- mutate(data,거래일자=paste0(data$계약연도,data$계약일))

# 계약연월 변수명 추가
data <- mutate(data,계약연월=data$계약연도)


# 계약연도 수정
data$계약연도 <- year(format(as.Date(data$거래일자,"%Y")))

# 계약월 생성
data <- mutate(data,계약월=NA)
as.Date.character(data$거래일자,"%Y")
data$계약월 <- month(as.Date(data$거래일자,"%Y"))
View(data)

write.csv(data,"최종통합.csv")
data$거래금액 <- as.numeric(data$거래금액)

plot(data$전용면적,data$거래금액)
