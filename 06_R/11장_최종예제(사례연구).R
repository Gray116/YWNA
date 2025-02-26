####################################
##### 11장. 최종예제(사례연구) #####
####################################
### 0. 패키지 설치 및 로드
install.packages("foreign")
library(foreign) # spss파일 불러오기
library(dplyr) # 전처리1
library(doBy) # 전처리2
library(ggplot2) # 시각화
library(readxl) # 엑셀파일 불러오기
rm(list = ls(all.names = T)) # R환경 초기화

### 문1. ‘한국복지패널데이터’(SPSS, koweps_hpc10_2015_beta5.sav)를 로드한 후 필요한 데이터 변수만을 select하여 변
#        수명을 변경하시오. 단 필요한 필드로 성별은 gender, 태어난 연도는 birth, 혼인상태는 marriage, 종교는
#        religion, 월평균임금은 income, 직업코드는 code_job, 지역코드는 code_region로 필드명을 변경한다.
## 1-1) 필요한 데이터를 다운받아 data.frame으로 load하시오.
##      SPSS파일을 데이터 프레임으로 불러오기
raw_Welfare <- read.spss(file = 'D:\\Gray_Bigdata\\Downloads\\14_sharedBigdata\\Koweps\\Koweps_hpc10_2015_beta1.sav',
                         to.data.frame = T)
View(raw_Welfare)

raw_welfare <- read.spss(file = 'D:\\Gray_Bigdata\\Downloads\\14_sharedBigdata\\Koweps\\Koweps_hpc10_2015_beta6.sav',
                         to.data.frame = T, reencode = 'utf-8')
dim(raw_welfare)

## 1-2) 필요한 필드만 조회
welfare <- raw_welfare[, c('h10_g3', 'h10_g4', 'h10_g10', 'h10_g11', 'h10_eco9',
                       'p1002_8aq1', 'h10_reg7')]
head(welfare)

## 1-3) 필드의 변수명을 변경
welfare <- rename(welfare, gender = h10_g3,
                  birth = h10_g4,
                  marriage = h10_g10,
                  religion = h10_g11,
                  code_job = h10_eco9,
                  income = p1002_8aq1,
                  code_region = h10_reg7)
head(welfare)
table(is.na(welfare)) # 전체 데이터 결측치
colSums(is.na(welfare)) # 열별 데이터 결측치


### 문2. 1번 문제의 결과인 data.frame변수를 이용하여 성별에 따른 월급 차이가 있는지를 분석하시오.
# 2-1) gender 필드 변수의 이상치가 있는지 확인하고 이상치 값 처리를 한다.
table(welfare$gender, useNA = 'ifany')

# 2-2) gender 필드 변수의 결측치를 확인한다.
table(is.na(welfare$gender))

# 2-3) gender의 값이 1은 male로 2는 female로 변경하고 gender의 타입을 factor로 변경한다.
welfare$gender <- ifelse(welfare$gender == 1, "male", "female")
welfare$gender <- factor(welfare$gender, levels = c('male', 'female'))

table(welfare$gender)

# 2-4) 성별 비율을 도표로 나타내고 그래프로 시각화한다.
gender.ratio <- welfare %>% 
  group_by(gender) %>% 
  summarise(ratio = n() / nrow(welfare) * 100)

pie(gender.ratio$ratio, labels = paste(gender.ratio$gender,
                                       round(gender.ratio$ratio, 1),
                                       '%'), clockwise = T, col = c('blue', 'hotpink'))

ggplot(gender.ratio, aes(x = gender, y = ratio, fill = gender)) +
  geom_col(width = 0.5) +
  theme(legend.position = c(0.3, 0.8),
        legend.title = element_text(face = 3, color = 'red')) +
  scale_x_discrete(limits = c('female', 'male')) + # x축의 순서를 바꾼다.
  scale_fill_discrete(limits = c('female', 'male')) # 범례 순서 변경

ggplot(gender.ratio, aes(x = "", y = ratio, fill = gender)) +
  geom_col() +
  coord_polar("y")

# 2-5) income의 최소값, 1분위수, 중위수, 3분위수, 최대값, 결측치 등을 탐색하고, boxplot과 월급의 빈
#      도그래프를 시각화한다.
summary(welfare$income)
boxplot(welfare$income)

ggplot(welfare, aes(y = income)) +
  geom_boxplot()

ggplot(welfare, aes(income)) +
  geom_histogram() + # 연속적인 자료 income을 계급으로 나누어 계급별 빈도 그래프를 그린다.
  coord_cartesian(xlim = c(0, 1200))

# 2-6) income이 0인 데이터는 이상치로 정하고, 이상치를 결측 처리한다.
b <- boxplot(welfare$income)$stat
table(welfare$income <= b[1])

welfare$income <- ifelse(welfare$income <= b[1], NA, welfare$income)
table(welfare$income <= b[1])
table(welfare$income <= b[5], useNA = 'ifany')
table(welfare$income > b[5], exclude = NULL) # 상위 이상치보다 큰 값 약 5%가량되어 이상치는 처리하지 않음.

# 2-7) 결측치를 제외한 데이터를 이용하여 성별에 따른 월급차이가 있는지를 분석한다.
temp <- welfare[, c('gender', 'income')]
m <- tapply(temp$income, temp$gender, median, na.rm = T) # 결측치를 제외한 데이터 추출
temp$income <- ifelse(is.na(temp$income), m[temp$gender], temp$income) 

summaryBy(income ~ gender, data = welfare, FUN = c(mean, sd), na.rm = T) # income을 gender로 나눠서...

welfare %>%
  group_by(gender) %>% 
  summarise(income.mean = mean(income, na.rm = T)) %>% 
  ggplot(aes(x = gender, y = income.mean, fill = gender)) +
  geom_bar(stat = "identity", width = 0.5) +
  theme(legend.position = "none")

ggplot(welfare, aes(x = gender, y = income)) +
  geom_point(position = 'jitter', col = 'brown', alpha = 0.3) +
  geom_violin() +
  geom_boxplot(aes(col = gender), fill = 'lightyellow',
               width = 0.3, notch = T) +
  coord_cartesian(ylim = c(0, 1000))

t.test(income ~ gender, data = welfare) # p-value가 0.05 미만으로 성별에 따른 월급차이가 없다는
                                        # 귀무가설을 기각한다. (통계적으로 유의미하다)


### 문3. 1번 문제의 결과인 data.frame변수를 이용하여 나이와 월급의 관계를 분석하여 몇 살 때 월급을 가장 많이 받
#        는지 시각화하시오.
# 3-1) birth, income 필드 변수의 이상치와 결측치를 확인한다.
table(welfare$birth, useNA = 'ifany')
table(is.na(welfare$birth))

table(welfare$income, useNA = 'ifany')
table(is.na(welfare$income))

boxplot(welfare$birth)

# 3-2) birth변수를 이용하여 나이를 계산하고 이 값을 age 필드로 추가한다.
welfare$age <- 2015 - welfare$birth + 1

boxplot(welfare$age)$stat

ggplot(data = welfare, aes(age)) +
  geom_bar()

# 3-3) x축을 나이, y축을 월급으로 지정하고 나이에 따른 월급의 변화가 표현되도록 막대그래프나 선 그
#      래프로 시각화한다.
age_income <- welfare %>% 
  filter(!is.na(welfare$income)) %>% 
  group_by(age) %>% 
  summarise(income.mean = mean(income),
            income.sd   = sd(income))

ggplot(age_income, aes(x=age, y=income.mean)) +
  geom_col() # 막대그래프
ggplot(age_income, aes(x=age, y=income.mean)) +
  geom_line() # 선그래프

# 3-4) 나이에 따른 월급의 차이가 있는지 관계를 분석한다.
fit <- lm(income ~ age, data = welfare)
anova(fit)

# 3-5) 가장 월급이 많은 나이
head(age_income[order(-age_income$income.mean), ], 1)


### 문4. 1번 문제의 결과인 data.frame변수를 이용하여 연령대에 따른 월급의 차이가 있는지, 있으면 어떤 연령대가
#        월급이 가장 많은지 분석하시오. 단, 연령대는 30세 이하는 young, 31~60세는 middle, 61세 이상은 old로 분류한다.
# 4-1) 파생변수 agegrade를 필드로 추가한다.
welfare$agegrade <- factor(welfare$agegrade, levels = c('young', 'middle', 'old'))
welfare$agegrade <- ifelse(welfare$age <= 30, 'young', ifelse(welfare$age > 30 & welfare$age < 61, 'middle', 'old'))

head(welfare, 10)

# 4-2) agegrade 의 분포를 도표와 그래프로 시각화한다.
ggplot(welfare, aes(agegrade)) +
  geom_bar(width = 0.5)

# 4-3) 연령대 별 월급의 boxplot을 시각화한다.
ggplot(welfare, aes(x = agegrade, y = income, na.rm = T)) +
  geom_boxplot()

# 4-4) 실제로 연령대에 따른 월급 차이가 있는지 분석한다.
# 도표
summaryBy(income ~ agegrade, data = welfare, FUN = c(mean, sd), na.rm = T)

# 통계분석
fit <- lm(income ~ agegrade, data = welfare)
anova(fit)


### 문5. 1번 문제의 결과인 data.frame변수를 이용하여 성별에 따른 월급의 차이는 연령대 별로 다른지 분석하시오.
# 5-1) 성별, 연령대, 월급 데이터의 결측치를 확인한다(3점).
table(is.na(welfare$gender))
table(is.na(welfare$agegrade))
table(is.na(welfare$income))

# 5-2) 연령대별, 성별 월급의 평균과 표준편차, 빈도를 출력한다(3점)
welfare %>% 
  group_by(agegrade) %>% 
  summarise(agegrade_mean = mean(income, na.rm = T),
            agegrade_sd = sd(income, na.rm = T),
            agegrade_cnt = n())

welfare %>% 
  group_by(gender) %>% 
  summarise(gender_mean = mean(income, na.rm = T),
            gender_sd = sd(income, na.rm = T),
            gender_cnt = n())

# 5-3) 성별에 따른 월급의 차이가 연령대별로 다른지 시각화 한다(4점)
library(ggplot2)
ggplot(welfare, aes(x = agegrade, y = income, na.rm = T)) +
  geom_col(aes(fill = gender), width = 0.5, position = position_dodge())


### 문6. 1번 문제의 결과인 data.frame변수를 이용하여 나이에 따른 월급 변화를 성별을 분리하여 시각화 하시오.
# 6-1) 나이와 성별로 group_by하여 월급평균, 월급표준편차, 월급중앙값, 최소값과 최대값, 빈도을 산출한다.
library(dplyr)
table(is.na(welfare$income))

gender_age_income <- welfare %>%
  group_by(age, gender) %>% 
  summarise(mean = mean(income, na.rm = TRUE),
            sd = sd(income, na.rm = TRUE),
            median = median(income, na.rm = TRUE),
            min = min(income, na.rm = TRUE),
            max = max(income, na.rm = TRUE),
            cnt = n())

# 6-2) 나이에 따른 월급평균의 추이를 아래와 같은 그래프를 시각화하고, 아래의 그래프를 파일로도 출력한다.
welfare %>% 
  group_by(age) %>% 
  summarise(income_mean = mean(income, na.rm = T)) %>% 
  ggplot(aes(x = age, y = income_mean)) +
  geom_line()

ggsave(filename = 'D:\\Gray_Bigdata\\src\\06_R\\cap.png')

ggplot(gender_age_income, aes(x = age, y = mean, col = gender)) +
  geom_line() +
  scale_color_discrete(limits=c('female','male')) # 범례 순서 바꾸기

dev.off()


### 문7. 1번 문제의 결과인 data.frame변수를 이용하여 직업별 월급의 차이가 나는지 분석하고, 만약 월급의 차이가
#        나면 어떤 직업이 월급이 가장 많은지 상위 10개 직업군만 시각화하시오. 
# 7-1) 직업별 월급 평균, 표준편차, 빈도를 평균월급 순으로 정렬하여 출력하여 직업별 월급의 추이를 분석한다.
job_xlsx <- read_xlsx('D:\\Gray_Bigdata\\Downloads\\14_sharedBigdata\\Koweps\\Koweps_Codebook.xlsx', sheet = 2)
head(job_xlsx)

welfare <- left_join(welfare, job_xlsx, by = "code_job") # left join은 데이터프레임들끼리 가능

welfare %>% group_by(job) %>% 
  summarise(income_mean = mean(income, na.rm = T),
            income_sd = sd(income, na.rm = T),
            income_cnt = n()) %>% 
  arrange(income_mean)

# 7-2) 직업별 월급의 차이를 분석한 후, 상위 소득 10개 직업군을 도표로 출력하고, 아래와 같은 그래프로 시각화한다.
#      시각화한 그래프는 ggsave함수를 이용하여 top10.png라는 그림파일로 저장한다.
welfare %>% 
  group_by(job) %>% 
  summarise(income_mean = mean(income, na.rm = T)) %>% 
  arrange(desc(income_mean)) %>%
  head(10) %>% 
  ggplot(aes(x = income_mean, y = reorder(job, income_mean), fill = job)) +
  geom_col() +
  theme(legend.position = 'none') +
  labs(x = '평균 소득', y = '직업')

ggsave(filename = 'D:\\Gray_Bigdata\\src\\06_R\\top10.png')

# 7-3) 하위 소득 10개 직업군도 도표로 출력하고 시각화한다.
welfare %>% 
  group_by(job) %>% 
  summarise(income_mean = mean(income, na.rm = T)) %>% 
  arrange(income_mean) %>%
  tail(10) %>% 
  ggplot(aes(x = income_mean, y = reorder(job, income_mean), fill = job)) +
  geom_col() +
  theme(legend.position = 'none') +
  labs(x = '평균 소득', y = '직업')


### 문8. 1번 문제의 결과인 data.frame변수를 이용하여 성별로 어떤 직업이 가장 많을지 분석하시오
# 8-1) 여성 최빈 직업 상위 10를 추출한다.
welfare %>%
  filter(welfare$gender == 2) %>% 
  group_by(code_job) %>% 
  summarise(cnt = n()) %>% 
  arrange(desc(cnt)) %>% 
  head(10)

# 8-2) 남성 최빈 직업 상위 10을 추출한다.
welfare %>%
  filter(welfare$gender == 1) %>% 
  group_by(code_job) %>% 
  summarise(cnt = n()) %>% 
  arrange(desc(cnt)) %>% 
  head(10)


### 문9. 1번 문제의 결과인 data.frame변수를 이용하여 종교 유무에 따른 이혼률을 분석하시오.
# 9-1) 종교 데이터인 religion 필드의 이상치 및 결측치를 확인한다.
table(welfare$religion, useNA = 'ifany')
table(welfare$religion, exclude = NULL)

# 9-2) religion 필드가 1이면 “종교-유”, 2이면 “종교-무”로 데이터를 변경한다. 
welfare$religion <- ifelse(welfare$religion == 1, '종교-유', '종교-무')

# 9-3) 종교 유무의 빈도를 시각화한다.
welfare %>% 
  group_by(religion) %>% 
  summarise(cnt = n()) %>% 
  ggplot(aes(x = religion, y = cnt, fill = religion)) +
  geom_bar(stat = 'identity', width = 0.5) +
  theme(legend.position = 'none')

# 9-4) 혼인 상태 데이터인 marriage 필드가 1이면 “기혼”, 3이면 “이혼”으로, 그 외는 NA로 값을 같은
#      marriage_group 파생변수를 추가한다.
table(welfare$marriage)
welfare$marriage_group <- ifelse(welfare$marriage == 1, '기혼', ifelse(welfare$marriage == 3, '이혼', NA))

# 9-5) 종교 유무에 따른 이혼률을 분석한다.
temp <- welfare %>% 
  filter(!is.na(marriage_group))

var.test(data = temp, marriage ~ religion)
t.test(data = temp, marriage ~ religion, var.equal = F) # p-value가 0.05 미만이므로 종교 유무에 따른 결혼
                                                        # 상태가 다를 수 있다.

# 9-6) 분석한 결과를 도표와 그래프로 시각화한다.
religion_marriage <- welfare %>% 
  filter(!is.na(marriage_group)) %>% 
  group_by(religion, marriage_group) %>% 
  summarise(cnt = n(), groups = "drop") %>% 
  group_by(religion) %>% 
  mutate(tot_group = sum(cnt)) %>% 
  mutate(ratio = round(cnt / tot_group *100, 1))

religion_marriage

ggplot(religion_marriage, aes(x = religion, y = cnt, fill = marriage_group)) +
  geom_col(position = position_dodge())


### 문10. 1번 문제의 결과인 data.frame변수를 이용하여 지역별 연령대 비율을 분석하시오. 노년층이 많은 지역은 어
#         디인지 출력하시오.
# 10-1) 결측치를 확인한다.
table(is.na(welfare$region))
table(is.na(welfare$age))

# 10-2) region 파생변수를 지역명으로 추가한다. 
#       1:서울 2:수도권(인천/경기) 3:부산/경남/울산 4:대구/경북 5:대전/충남 6:강원/충북 7:광주/전남/전북/제주도
welfare$region <- welfare$code_region

welfare$region <- ifelse(welfare$code_region == 1, '서울', welfare$region)
welfare$region <- ifelse(welfare$code_region == 2, '수도권(인천/경기)', welfare$region)
welfare$region <- ifelse(welfare$code_region == 3, '부산/경남/울산', welfare$region)
welfare$region <- ifelse(welfare$code_region == 4, '대구/경북', welfare$region)
welfare$region <- ifelse(welfare$code_region == 5, '대전/충남', welfare$region)
welfare$region <- ifelse(welfare$code_region == 6, '강원/충북', welfare$region)
welfare$region <- ifelse(welfare$code_region == 7, '광주/전남/전북/제주도', welfare$region)

# 10-3) 지역별 연령대 비율을 분석한 도표 및 그래프를 시각화한다.
welfare %>% 
  group_by(region) %>%
  summarise(cnt = n()) %>% 
  mutate(tot_peo = sum(cnt)) %>% 
  mutate(ratio = round(cnt / tot_peo * 100, 1)) %>% 
  ggplot(aes(x = region, y = ratio, fill = region)) +
  geom_bar(stat = 'identity') +
  theme(legend.position = 'none')

# 10-4) 노년층이 많은 지역이 어디인지 시각화한다.
welfare %>%
  filter(agegrade == 'old') %>% 
  group_by(region) %>%
  summarise(cnt = n()) %>% 
  mutate(tot_peo = sum(cnt)) %>% 
  mutate(ratio = round(cnt / tot_peo * 100, 1)) %>% 
  ggplot(aes(x = region, y = ratio, fill = region)) +
  geom_bar(stat = 'identity') +
  theme(legend.position = 'none')