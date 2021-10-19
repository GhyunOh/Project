getwd()
library(dplyr)
library(ggplot2)
library(gapminder)

t_trade <- read.csv('t_total.csv')

### 1번 그래프 ###
t_g <- t_trade %>%
    group_by(구,계약연도) %>% 
    ggplot(aes(계약연도,거래금액)) + 
    geom_point(stat='identity',alpha=0.2, position='jitter')
t_g


t_g_b <- t_trade %>%
    group_by(구,계약연도) %>% 
    ggplot(aes(계약연도,거래금액,group=구,col=구)) + 
    geom_bar(stat='identity', position='dodge',aes(fill=구)) 
t_g_b

### 2번 그래프 ###

t_trade %>% 
    group_by(계약연도,구) %>% 
    summarise(avg_t_trade = mean(거래금액)) %>% 
    ggplot(aes(계약연도,avg_t_trade))  +
    geom_line(aes(color=구))  +
    ylab("평균거래가") +
    labs(title = '지역구별 평균거래가격 추이')
