library(ggplot2)
cars <- datasets::cars

# 문11. datasets::cars데이터 셋을 이용하여 속도에 대한 제동거리의 산점도와 적합도(신뢰구간 그래프)를 나타내시오
#      (단, 속도가 5부터 20까지 제동거리 0부터 100까지만 그래프에 나타내시오).
ggplot(cars, aes(x = speed, y = dist)) +
  geom_point() +
  coord_cartesian(xlim = c(5, 20), ylim = c(0, 100)) +
  geom_smooth(method = "lm")

ggsave('outData/ex11.png')

# 문12. gapminder::gapminder 데이터 셋을 이용하여 1인당국내총생산에 대한 기대수명의 산점도를 대륙별 다른 색으로 나타내시오.
gapminder <- gapminder::gapminder
head(gapminder)

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(col = continent))

ggsave('outData/ex12.jpg')

# 문13. gapminder::gapminder 데이터 셋을 이용하여 기대 수명이 70을 초과하는 데이터에 대해 대륙별 데이터 개수
gapminder %>%
  group_by(continent) %>% 
  filter(lifeExp > 70) %>% 
  summarise(cnt = n()) %>% 
  ggplot(aes(x = continent, y = cnt)) +
  geom_col(aes(fill = continent)) +
  labs(title = "연습문제 13", subtitle = "기대수명이 70을 초과하는 데이터 빈도(대륙별)",
       x = "대륙", y = "빈도")

ggsave('outData/ex13.jpg')

# 문14. gapminder::gapminder 데이터 셋을 이용하여 기대수명이 70을 초과하는 데이터에 대해 대륙별 나라 갯수.
gapminder %>%
  group_by(continent, country) %>% 
  filter(lifeExp > 70) %>% 
  summarise(cnt = n()) %>%
  group_by(continent) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x = continent, y = n)) +
  geom_bar(aes(fill = continent), stat = "identity") +
  labs(title = "연습문제 14", subtitle = "기대수명이 70을 초과하는 대륙별 나라 빈도",
       x = "대륙", y = "나라 빈도")

ggsave('outData/ex14.jpg')

# 문15. gapminder::gapminder 데이터 셋을 이용하여 대륙별 2007년도(저번에 이부분 뺌) 기대수명의 사분위수를 시각화
gapminder %>% 
  group_by(continent) %>% 
  filter(year == 2007) %>% 
  summarise(sqrt = sqrt(lifeExp)) %>% 
  ggplot(aes(x = continent, y = sqrt, col = continent)) +
  geom_boxplot() +
  labs(title = "연습문제 15", subtitle = "대륙별 기대수명의 사분위수",
       x = "continent", y = "lifeExp")

ggsave('outData/ex15.jpg')

# 문16. gapminder::gapminder 데이터 셋을 이용하여 년도별로 gdp와 기대수명과의 관계를 산점도로 나타내고
#       대륙별 점의 색상을 달리 시각화
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, col = continent)) +
  geom_point(alpha = 0.3) +
  facet_wrap(~ year) +
  labs(title = "연습문제 16", subtitle = "GDP와 기대수명과의 관계",
       x = "gdpPercap", y = "lifeExp") +
  scale_color_manual(values = rainbow(5)) +
  coord_cartesian(xlim = c(0, 50000))

ggsave('outData/ex16.jpg')
  
# 문17. gapminder::gapminder 데이터 셋에서 북한과 한국의 년도별 GDP 변화를 산점도로 시각화하시오
#       (북한:Korea, Dem. Rep. 한국:Korea, Rep. substr(str, start, end)함수 이용)
gapminder %>% 
  group_by(year) %>% 
  filter(country == 'Korea, Rep.' | country == 'Korea, Dem. Rep.') %>%
  ggplot(aes(x = year, y = gdpPercap)) +
  geom_point(aes(col = country, shape = country)) +
  theme(legend.position = c(0.2, 0.85)) +
  labs(title = "연습문제 17", subtitle = "GDP의 변화(한국과 북한)",
       x = "year", y = "gdpPercap")

ggsave('outData/ex17.jpg')

# 문18. gapminder::gapminder 데이터 셋을 이용하여 한중일 4개국별 GDP 변화를 산점도와 추세선으로 시각화 하시오.
gapminder %>% 
  group_by(country) %>% 
  filter(country %in% c('China', 'Japan', 'Korea, Rep.', 'Korea, Dem. Rep.')) %>% 
  ggplot(aes(x = year, y = gdpPercap)) +
  geom_point(aes(col = country)) +
  labs(title = "연습문제 18", subtitle = "한중일 4개국의 GDP변화의 산점도와 추세선",
       x = "year", y = "gdpPercap")+
  geom_line(aes(col = country))

ggsave('outData/ex18.jpg')

# 문19. gapminder::gapminder 데이터 셋에서 한중일 4개국별 인구변화 변화를 산점도와 추세선으로 시각화 하시오
#       (scale_y_continuous(labels = scales::comma)추가시 우측처럼)
gapminder %>% 
  group_by(country) %>% 
  filter(country %in% c('China', 'Japan', 'Korea, Rep.', 'Korea, Dem. Rep.')) %>% 
  ggplot(aes(x = year, y = pop, col = country)) +
  geom_point() +
  geom_line(aes(col = country)) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "연습문제 19", subtitle = "한중일 4개국의 인구변화의 산점도와 추세선",
       x = "year", y = "pop")

ggsave('outData/ex19.jpg')

# 문20. Ggplot2::economic 데이터 셋의 개인 저축률(psavert)가 시간에 따라 어떻게 변해 왔는지 알아보려 한다.
#       시간에 따른 개인 저축률의 변화를 나타낸 시계열 그래프와 추세선을 시각화하시오
economics <- ggplot2::economics
head(economics)

ggplot(economics, aes(x = date, y = psavert)) +
  geom_line(col = 'red', lwd = 2) +
  geom_smooth(method = "loess", col = 'red') +
  labs(title = "연습문제 20", subtitle = "개인저축률과 실업률 시계열 그래프",
       x = "date", y = "psavert")

ggsave('outData/ex20.jpg')

# 문21 및 시계열 데이터를 인터렉티브한 시계열 그래프로 시각화
library(ggplot2)
data(economics, package = "ggplot2")
economics = ggplot2::economics
head(economics)

ggplot(economics, aes(x = date, y = unemploy)) +
  geom_line()

install.packages("dygraphs")
library(dygraphs)
library(xts)
? dygraph
? xts

str(economics)
eco <- xts(economics$unemploy, order.by = economics$date)
dygraph(eco)
dygraph(eco) %>% dyRangeSelector()

head(economics[, c('psavert', 'unemploy')])

# 여러 값을 표현한 인터랙티브 시계열 그래프
eco_a <- xts(economics$unemploy, order.by = economics$date)
eco_b <- xts(economics$psavert, order.by = economics$date)

eco2 <- cbind(eco_a, eco_b)
colnames(eco2) <- c('psavert', 'unemploy')
head(eco2)

dygraph(eco2)