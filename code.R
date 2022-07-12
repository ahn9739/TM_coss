####################################################
# 예제2-1 : 데이터 입력하여 데이터 셋 생성 
####################################################

# input variables
id = c(1, 2, 3, 4, 5, 6, 7) # id = 1:7
region = c('서울', '부산', '대구', '인천', '광주', '대전', '울산')
pop = c(9.7, 3.4, 2.4, 2.9, 1.5, 1.5, 1.1)
pop

# create data set
pop_2020 = data.frame(id, region, pop)


####################################################
# 예제2-2 : csv 파일 읽어 데이터 셋 생성
####################################################

# Working directory 지정 : setwd("d:/TM") 또는 Session 메뉴 이용
# setwd("d:/TM")

# read file and create data set
SiDo_Pop = read.csv("SiDo_Pop.csv", header=T)

head(SiDo_Pop)


####################################################
# 예제2-3 : 텍스트 데이터 읽기
####################################################

# 방법1
#install.packages("readr")  
library(readr)  # to use read_file(), [4장 이후] read_csv()

raw_moon = read_file("speech_moon.txt")
head(raw_moon)

# 방법 2
raw_moon = readLines("speech_moon.txt", encoding="UTF-8")
head(raw_moon)


#########################################################################
# 예제2-4 : Data set 다루기 (특정한 행/열 이용, 새로운 data set 생성 등)
#########################################################################

# read file and create data set
SiDo_Pop = read.csv("SiDo_Pop.csv", header=T)

head(SiDo_Pop)

# 데이터 셋의 행/열의 수
nr = nrow(SiDo_Pop)
nc = ncol(SiDo_Pop)

# 데이터(변수) 요약 정보
summary(SiDo_Pop)


### data set_name[행, 열]
# 특정한 변수 이용
SiDo_Pop[, 5] #total은 열의 5번째에 위치한 변수
SiDo_Pop$total # $ 기호 활용하면 편리

summary(SiDo_Pop$total)	 #summary(SiDo_Pop[, 5])

# chain/pipe operator : 어떤 작업에서 여러 단계의 절차를 필요로 할 때, 
# 중간 결과를 생성한 후 그 결과를 후속 절차에서 받아서 사용하는 경우에 유용
library(dplyr)   # to use %>%, select(), as_tibble(), mutate(), [3장 이후] count(), filter(), arrange(), ...   
                 # package for Data Manipulation

m = SiDo_Pop %>% summary()
m

# 특정한 관측치 이용
SiDo_Pop[SiDo_Pop$year==2000, ]	# == 는 같음을 나타내는 비교연산자
SiDo_Pop[SiDo_Pop$year!=2000, ]


#########################################
# data frame/set에서 일부 데이터로 구성된 새로운 data set 생성 방법

# year, region, total 변수로 구성된 새로운 data set
new_data = SiDo_Pop[, c(1, 2, 5)]
new_data = subset(SiDo_Pop, select=c(year, region, total))
new_data = SiDo_Pop %>% select(year, region, total)


# year, region, total 변수를 제거한 data set
new_data = SiDo_Pop[, -c(1, 2, 5)]
new_data = subset(SiDo_Pop, select=-c(year, region, total))


# 2010년 이후의 데이터로 구성된 새로운 data set
new_data = SiDo_Pop[SiDo_Pop$year>=2010, ]
new_data = subset(SiDo_Pop, year>=2010)

# 2010 이후 데이터, (year, region, total) 변수로 구성된 새로운 data set
new_data = subset(SiDo_Pop, year>=2010, select=c(year, region, total))
new_data = SiDo_Pop %>% filter(year>=2010) %>% select(year, region, total)

SiDo_Pop$male = as.numeric(SiDo_Pop$male)
SiDo_Pop %>% filter(year>=2010) %>% select(male) %>% colMeans


# 2000, 2010년의 area_tag=='M'인 데이터에서 year, region, area_tag, male, female 변수로 구성된 data set
new_data = subset(SiDo_Pop, year<=2010 & area_tag=='M', select=c(year, region, area_tag, male, female))
new_data = SiDo_Pop %>% filter(year<=2010 & area_tag=='M') %>% select(year, region, area_tag, male, female)


###########################################################
# 예제2-5 : Sampling (sample 추출하여 새로운 data set 생성)
###########################################################

# data set에서 sample 추출하여 새로운 data set 생성 방법
new_data = SiDo_Pop[sample(nrow(SiDo_Pop), 10), ]	 # 10 samples without replacement

s_n = ceiling(nrow(SiDo_Pop) * 0.3)	  # 30% samples #ceiling(), round(), floor()
new_data = SiDo_Pop[sample(nrow(SiDo_Pop), s_n), ]	


#######################################################
# 예제2-6 : 데이터 분할 (training/test data set 생성)
#######################################################
# Splitting into training and test data sets
SiDo_Pop$gp = runif(dim(SiDo_Pop)[1])

# training set 90%, test set 10%로 분할
trainingSet = SiDo_Pop %>% filter(gp <= 0.9)
testSet = SiDo_Pop %>% filter(gp > 0.9)

# training set 90%, test set 30% (20% 데이터가 겹치도록) 분할
trainingSet = SiDo_Pop %>% filter(gp <= 0.9)
testSet = SiDo_Pop %>% filter(gp > 0.7)



####################################################
# 예제2-7 : Loop and Condition statement 
####################################################

# 2020년 female 인구 합 계산
new_data = SiDo_Pop %>% filter(year==2020) 
n = nrow(new_data)

# 방법 1 : 반복문 이용
female_pop_2020 = 0

for(i in 1:n) {
  female_pop_2020 = female_pop_2020 + new_data[i, 'female']  #new_data[i, 7]
}

# 방법 2 : 함수 이용
female_pop_2020 = sum(new_data$female)


# SiDo_Pop 데이터 셋을 이용한 2020년 female 인구 합 계산
n = nrow(SiDo_Pop)

# 방법 1: 반복문과 조건문 같이 이용
female_pop_2020 = 0

for(i in 1:n) {
  
  if (SiDo_Pop[i, 'year']==2020) {
    female_pop_2020 = female_pop_2020 + SiDo_Pop[i, 'female']  
  } else {
    
  }
  
}

# 방법 2 : pipe operator와 함수 이용
female_pop_2020 = SiDo_Pop %>% filter(year==2020) %>% select(female) %>% sum


####################################################
# 예제2-8 : 기본 plot
####################################################
# 데이터 scale 조정
SiDo_Pop$total = round(SiDo_Pop$total/1000000, 1)
SiDo_Pop$male = round(SiDo_Pop$male/1000000, 1)
SiDo_Pop$female = round(SiDo_Pop$female/1000000, 1)

# 2020년 데이터
Pop_2020 = SiDo_Pop %>% filter(year==2020) 

# 가장 기본적인 함수: plot(x, y)
plot(Pop_2020$male, Pop_2020$female) 

### 자주 쓰는 함수
hist(Pop_2020$total)

barplot(table(Pop_2020$area_tag))
pie(table(cut(Pop_2020$total, breaks=4)))


# 전체 데이터 이용
SiDo_Pop$year = as.factor(SiDo_Pop$year)
pairs(SiDo_Pop[5:7], main = "Population", pch = 21, bg = c("red", "green3", "blue")[SiDo_Pop$year])
pairs(SiDo_Pop[5:7], main = "Population", pch = 21, col = c("red", "green3", "blue")[SiDo_Pop$year])

# 년도별로 점(point)의 색을 다르게
SiDo_Pop$Colour="red"
SiDo_Pop$Colour[SiDo_Pop$year==2010]="green3"
SiDo_Pop$Colour[SiDo_Pop$year==2020]="blue"

plot(SiDo_Pop$male, SiDo_Pop$female, main="Scatter plot", xlab="Male", ylab="Female",
     xlim=c(0, 10), ylim=c(0, 10), type="p", pch=20, cex=1, col=SiDo_Pop$Colour)


####################################################
# 예제2-9 : 기본 plot에 내용 추가
####################################################

# plot에 내용 추가 함수 활용
# 그래프에 text 및 화살표 추가
plot(SiDo_Pop$male, SiDo_Pop$female, main="Scatter plot", xlab="Male", ylab="Female",
     xlim=c(0, 10), ylim=c(0, 10), type="p", pch=20, cex=1, col=SiDo_Pop$Colour, font=3)
text(7, 8, "r = 0.95", font=3)

arrows(6.8, 2, 6.8, 6.5, length=0.2, angle=20)
text(6.8, 1.5, "경기도", col="red")

# 범례(legend) 작성
legend(8, 9, legend=c("2000", "2010", "2020"), col=c("red", "green3", "blue"), pch=20)



####################################################
# 예제2-10 : ggplot 함수 활용
####################################################

### Graph 1: Basic graph function
hist(SiDo_Pop$total, breaks=7, col="red")

### Graph 2: ggplot2 package
library(ggplot2)  # to use ggplot(), geom_histogram(), annotate(), ...

# histogram
ggplot(SiDo_Pop) +
  geom_histogram(aes(x=total), bins=7, fill="red") +
  annotate("text", x=13, y=3, col = "blue", label = "경기도?")

# scatter plot
SiDo_Pop$year = as.factor(SiDo_Pop$year)

ggplot(SiDo_Pop, aes(x=male, y=female, fill=year)) +
  geom_point(na.rm=TRUE, aes(colour=year)) +
  annotate("text", x=7.5, y=7.2, label="r = 0.95") 





####################################################
# 예제3-0 : A Simple Example
####################################################

# 필요한 패키지 load
library(KoNLP)      # to use useSejongDic(), extractNoun(), [예제3-5] useNIADic()  
library(wordcloud)  # to use wordcloud()

# KoNLP에 있는 세종사전을 사용하기 위한 함수
useSejongDic()

# ①② 데이터 준비 및 코퍼스 구성 (데이터 준비 및 read)
text<- "텍스트마이닝은 자연어 (Natural Language)로 구성된 비정형데이터 (unstructured data)에서 패턴 또는 관계를 추출하여 의미있는 정보를 찾아내는 기법으로, 컴퓨터가 사람들이 말하는 언어를 이해할 수 있는 자연어 처리 (Natural Language Processing)에 기반으로 둔 기술이다. 트위터, 페이스북과 같은 소셜 미디어에서 생산되는 데이터는 비정형데이터이기 때문에 텍스트마이닝을 이용하여 분석할 수 있다.
 텍스트마이닝은 말 그대로 텍스트 형태의 비정형데이터에 마이닝 기법을 적용한 것이다. 즉, 텍스트에 나타나는 단어를 분해, 정제하고, 특정 단어의 출현빈도 등을 파악하여 단어들 간의 관계를 조사하는 기법이다. 
데이터마이닝 (data mining)은 대규모 DB에 저장된 정형화된 데이터로부터 정보를 찾아내는 기법이라면 텍스트마이닝은 비정형화된 텍스트 문서에서 정보를 찾아내는 기법이라 할 수 있다.
그림 2.1은  데이터마이닝 과 텍스트마이닝의 관계를 나타내는 그림이다."

# ③ 데이터 사전처리 및 형태소 분석
nouns = extractNoun(text) #명사만 추출

nouns <- nouns[nchar(nouns)>=2]   #명사 중에서 2글자 이상만 남기기

nouns <- gsub("텍스트마이닝.*","텍스트마이닝", nouns)
nouns <- gsub("데이터마이닝.*","데이터마이닝", nouns)

# ④ 데이터 분석
wordFreq <-table(nouns)    #빈도 계산
sort.wordFreq = sort(wordFreq, decreasing=TRUE)
sort.wordFreq = sort.wordFreq[1:10]

# 막대그래프
barplot(sort.wordFreq, horiz = TRUE, names.arg=, cex.names=0.6, las=1)

# 워드 클라우드
pal <- brewer.pal(6, "Dark2")
windowsFonts(malgun=windowsFont("맑은 고딕"))

wordcloud(words=names(wordFreq), freq=wordFreq, colors=pal, min.freq=1, random.order=F, family="malgun")



####################################################
# 예제3-1 : 사전처리 및 data set 구성
####################################################

raw_moon = readLines("speech_moon.txt", encoding="UTF-8")
head(raw_moon)

# stringr 패키지에 있는 함수를 이용하여 사전처리
library(stringr)    # to use str_replace_all(), str_squish()

# 불필요한 문자(특수문자, 한자, 공백 등) 제거 : str_replace_all()
# 파라미터명 입력 : str_replace_all(string = txt, pattern = "[^가-힣]", replacement = " ")
# 파라미터명 생략 : str_replace_all(txt, "[^가-힣]", " ")
moon <- raw_moon %>% str_replace_all("[^가-힣]", " ")
head(moon)

# 연속된 공백 하나만 남기고 제거 : str_squish()
moon <- moon %>% str_squish()
head(moon)

# 문자열 벡터 형태의 데이터를 tibble 구조로 바꾸기
# tibble은 simple data frame이라고 생각하면 됨. 데이터를 간략하게 표현할 수 있고,
# 이 구조를 이용하면 대용량 데이터 세트를 다루는데 용이함
moon <- as_tibble(moon)
moon


# 위의 과정을 한꺼번에 처리하기
moon <- raw_moon %>%
  str_replace_all("[^가-힣]", " ") %>%  # 한글만 남기기
  str_squish() %>%                      # 연속된 공백 제거
  as_tibble()                           # tibble로 변환


####################################################
# 예제3-2 : 토큰화 하기
####################################################
# 토큰화 : 전처리 작업 후 텍스트를 분석목적에 따라 토큰(단락, 문장, 단어 등)으로 나누는 작업 

library(tidytext)   # to use unnest_tokens(), [예제4-2] cast_dtm()   
     # 텍스트 포맷의 데이터를 여러 토큰(token) 단위로 쪼개서 분석하는데 필요한 패키지

word_space <- moon %>%
  unnest_tokens(input = value,
                output = word,
                token = "words")
word_space


#############################################################################
# 참고 : 여기부터 ~~
raw_moon = read_file("speech_moon.txt")
head(raw_moon)

# stringr 패키지에 있는 함수를 이용하여 사전처리
#library(stringr)

# 불필요한 문자(특수문자, 한자, 공백 등) 제거 : str_replace_all()
# 파라미터명 입력 : str_replace_all(string = txt, pattern = "[^가-힣]", replacement = " ")
# 파라미터명 생략 : str_replace_all(txt, "[^가-힣]", " ")
moon <- raw_moon %>% str_replace_all("[^가-힣]", " ")
head(moon)

# 연속된 공백 하나만 남기고 제거 : str_squish()
moon <- moon %>% str_squish()
head(moon)

# 문자열 벡터 형태의 데이터를 tibble 구조로 바꾸기
# tibble은 simple data frame이라고 생각하면 됨. 데이터를 간략하게 표현할 수 있고,
# 이 구조를 이용하면 대용량 데이터 세트를 다루는데 용이함
moon <- as_tibble(moon)
moon


# 위의 과정을 한꺼번에 처리하기
moon <- raw_moon %>%
  str_replace_all("[^가-힣]", " ") %>%  # 한글만 남기기
  str_squish() %>%                      # 연속된 공백 제거
  as_tibble()     

### 토큰화하기
# 토큰화 : 전처리 작업 후 텍스트를 분석목적에 따라 토큰(단락, 문장, 단어 등)으로 나누는 작업 
#library(tidytext)

word_space <- moon %>%
  unnest_tokens(input = value,
                output = word,
                token = "words")
word_space

# 참고 : 여기까지
#############################################################################


####################################################
# 예제3-3 : 단어 빈도 분석
####################################################

# 자주 사용된 단어를 살펴보면 무엇을 강조했는지 알 수 있음
word_space <- word_space %>%
  count(word, sort = T)
word_space

# 두 글자 이상만 남기기
word_space <- word_space %>%
  filter(str_count(word) > 1)
word_space

# 위의 과정 한 번에 처리
word_space <- word_space %>%
  count(word, sort = T) %>%
  filter(str_count(word) > 1)


# 빈도가 높은 상위 20개 단어
top20 <- word_space %>%
  head(20)
top20


####################################################
# 예제3-4 : 단어 빈도 그래프로 표현하기
####################################################

# 막대그래프
#library(ggplot2)

ggplot(top20, aes(x = reorder(word, n), y = n)) +
  geom_col() +
  coord_flip() +
  geom_text(aes(label = n), hjust = -0.3) +            # 막대 밖 빈도 표시
  labs(title = "문재인 대통령 출마 연설문 단어 빈도",  # 그래프 제목
       x = NULL, y = NULL) +                           # 축 이름 삭제
  theme(title = element_text(size = 12))               # 제목 크기

# 워드 클라우드
library(ggwordcloud)   # to use geom_text_wordcloud()  # ggplot()에서 워드 클라우드 만들도록 도와주는 패키지  

ggplot(word_space, 
       aes(label = word, 
           size = n, 
           col = n)) +                      # 빈도에 따라 색깔 표현
  geom_text_wordcloud(seed = 1234) +  
  scale_radius(limits = c(3, NA),           # 최소, 최대 단어 빈도
               range = c(3, 30)) +          # 최소, 최대 글자 크기
  scale_color_gradient(low = "#66aaf2",     # 최소 빈도 색깔
                       high = "#004EA1") +  # 최고 빈도 색깔
  theme_minimal()                           # 배경 없는 테마 적용



###################################################################
# 예제3-5 : 형태소 분석 : 데이터 읽기, 사전처리, 토큰화(명사)
###################################################################

### 자바와 rJava 패키지, KoNLP 의존성 패키지 등 설치
#install.packages("multilinguer")
#library(multilinguer)
#install_jdk()

#install.packages(c("stringr", "hash", "tau", "Sejong", "RSQLite", "devtools"),
#                 type = "binary")

#install.packages("remotes")
#remotes::install_github("haven-jeon/KoNLP",
#                        upgrade = "never",
#                        INSTALL_opts = c("--no-multiarch"))

#library(KoNLP)      # to use useNIADic(), useSejongDic(), extractNoun() 

useNIADic()


# 명사 추출 : KoNLP 패키지에 있는 extractNoun() 이용
raw_moon <- readLines("speech_moon.txt", encoding = "UTF-8")

# 기본적인 전처리
moon <- raw_moon %>%
  str_replace_all("[^가-힣]", " ") %>%  # 한글만 남기기
  str_squish() %>%                      # 중복 공백 제거
  as_tibble()                           # tibble로 변환

# 명사 기준 토큰화
word_noun <- moon %>%
  unnest_tokens(input = value,
                output = word,
                token = extractNoun)


####################################################
# 예제3-6 : 명사 빈도 분석
####################################################

# 명사 빈도 & 두 글자 이상만 남기기
word_noun <- word_noun %>% 
  count(word, sort = T) %>%    # 단어 빈도 구해 내림차순 정렬
  filter(str_count(word) > 1)  # 두 글자 이상만 남기기
word_noun

# 상위 20개 명사 추출
top20 <- word_noun %>%
  head(20)

# 워드 클라우드 
#library(ggwordcloud)
ggplot(word_noun, aes(label = word, size = n, col = n)) +
  geom_text_wordcloud(seed = 1234) +
  scale_radius(limits = c(3, NA),
               range = c(3, 15)) +
  scale_color_gradient(low = "#66aaf2", high = "#004EA1") +
  theme_minimal()



####################################################
# 예제4-1 : 단어 빈도 분석
####################################################

#library(tm)   # package for Text Mining (Corpus(), VectorSource(), ...) 
               # 여기에서는 사용하지 않음

raw_speeches <- read_csv("speeches_presidents.csv")
#raw_speeches <- read_csv("speeches_presidents2.csv", locale=locale('ko',encoding='euc-kr'))
raw_speeches

# 기본적인 전처리
speeches <- raw_speeches %>%
  mutate(value = str_replace_all(value, "[^가-힣]", " "),
         value = str_squish(value))

# 토큰화
speeches <- speeches %>%
  unnest_tokens(input = value,
                output = word,
                token = extractNoun)

# 단어 빈도 구하기
frequency <- speeches %>%
  count(president, word, sort = T) %>%
  filter(str_count(word) > 1)
frequency

# 단어 빈도 누적합 및 누적비율 구하기
frequency = frequency %>% group_by(president) %>%
  mutate(cn = cumsum(n),
         prop = cn/sum(n))


nrow(raw_speeches)
ncol(raw_speeches)

# 상위 발현 단어들이 차지하는 비율 그래프로 표현  
for (i in 1:nrow(raw_speeches)) {
  freq = frequency %>% filter(president==raw_speeches$president[i])

  plot((1:nrow(freq))/nrow(freq)*100, freq$prop, type='l', xlab='단어의 발현빈도', ylab='누적비율',
       main=raw_speeches$president[i], ylim=c(0, 1))
}

freq = frequency %>% filter(president==raw_speeches$president[4])
#데이터는 테이블에서 확인



##############################################################
###### 참고 : # 상위 발현 단어들이 차지하는 비율 그래프로 표현 (labels 추가)  

for (i in 1:nrow(raw_speeches)) {
  freq = frequency %>% filter(president==raw_speeches$president[i])
  
  #상위 발현 단어들이 차지하는 비율  
  plot(1:nrow(freq), freq$prop, type='l', xlab='단어의 발현빈도', ylab='누적비율',
       main=raw_speeches$president[i], axes=FALSE)
  axis(1, at=round(nrow(freq)/10*(0:10)), labels=paste(10*(0:10), "%", sep=""))
  axis(2, at=0.20*(0:5), labels=paste(20*(0:5), "%", sep=""))
  
  for (j in 1:9) {
    text(nrow(freq)/100*10*j, 0.05+freq$prop[nrow(freq)/100*10*j], 
         labels=paste(round(100*freq$prop[nrow(freq)/100*10*j]), "%", sep=""))
    points(nrow(freq)/100*10*j, freq$prop[nrow(freq)/100*10*j], pch=19)
  }
}
##############################################################


# 상위 발현 단어 워드 클라우드  
pal <- brewer.pal(4, "Dark2")

for (i in 1:nrow(raw_speeches)) {
  freq = frequency %>% filter(president==raw_speeches$president[i])
  
  wordcloud(freq$word, freq=freq$n, scale=c(4, 0.05), rot.per=0.0, min.freq=2, 
            random.order=FALSE, col=pal)
  
}


#######################################################################
### 예제4-2 : 문서들간의 상관계수
#######################################################################

raw_speeches <- read_csv("speeches_presidents.csv")
raw_speeches

# 기본적인 전처리
speeches <- raw_speeches %>%
  mutate(value = str_replace_all(value, "[^가-힣]", " "),
         value = str_squish(value))

# 토큰화
speeches <- speeches %>%
  unnest_tokens(input = value,
                output = word,
                token = extractNoun)

# 단어 빈도 구하기
frequency <- speeches %>%
  count(president, word, sort = T) 
#  %>% filter(str_count(word) > 1)
frequency

# DTM 만들기
dtm <- frequency %>%
  cast_dtm(document = president, term = word, value = n)
dtm

# 벡터화
as.matrix(dtm[1:4, 1:16])
dtm = as.matrix(dtm)

#문서와 문서의 상관계수 행렬 계산 
doc.corr <- matrix(NA, nrow=nrow(dtm), ncol=nrow(dtm))

for (i in 1:nrow(dtm)) {
  for (j in 1:nrow(dtm)) {
    doc.corr[i,j] <- cor(dtm[, i], dtm[, j])
  }
}

rownames(doc.corr) <- colnames(doc.corr) <- rownames(dtm)

#상관계수 행렬
round(doc.corr, 3)



#######################################################################
### 예제5-1 : 감정 사전 불러오기 및 사전 내용 살펴보기 
#######################################################################

# 감정 사전 불러오기
dic <- read_csv("knu_sentiment_lexicon.csv")

# 긍정 단어
dic %>% 
  filter(polarity == 2) %>% 
  arrange(word)

# 부정 단어
dic %>% 
  filter(polarity == -2) %>% 
  arrange(word)


# 감정사전에 있는 긍정/부정/중성 단어 갯수
dic %>% 
  mutate(sentiment = ifelse(polarity >=  1, "pos",
                            ifelse(polarity <= -1, "neg", "neu"))) %>% 
  count(sentiment)



#######################################################################
### 예제5-2 : 문서별 감정 파악
#######################################################################

# 데이터 read
raw_speeches <- read_csv("speeches_presidents.csv")
raw_speeches

# 기본적인 전처리
speeches <- raw_speeches %>%
  mutate(value = str_replace_all(value, "[^가-힣]", " "),
         value = str_squish(value))

# 토큰화
speeches <- speeches %>%
  unnest_tokens(input = value,
                output = word,
                token = "words",
                drop = F)

# 단어에 감정점수 부여하기
sentiment_score <- speeches %>% select(-value) %>%
  left_join(dic, by = "word") %>% 
  mutate(polarity = ifelse(is.na(polarity), 0, polarity))
sentiment_score


# 문서별 감정 점수
doc_score <- sentiment_score %>% 
  group_by(president) %>% 
  summarise(score  = sum(polarity))
doc_score



# 문서별 감정 단어의 빈도를 그래프로 표현 : 막대그래프
for (i in 1:nrow(raw_speeches)) {
  score = sentiment_score %>% filter(president==raw_speeches$president[i])
  
  #
  score_senti <- score %>%
    mutate(sentiment = ifelse(polarity >=  1, "pos",
                              ifelse(polarity <= -1, "neg", "neu")))
  
  freq_senti = score_senti %>% 
    count(sentiment) %>% 
    mutate(ratio = n/sum(n)*100)
  
  # 막대 그래프 만들기
  bp = barplot(freq_senti$ratio, main=raw_speeches$president[i], names.arg=freq_senti$sentiment, 
          col = c("red", "gray", "green"), ylim=c(0, 110))
  text(x=bp, y=freq_senti$ratio, labels = paste(round(freq_senti$ratio,1), "%"), pos=3)
}


#######################################################################
### 예제5-3 : 전체 문서의 감정 파악
#######################################################################

# 전체문서 감정 단어 빈도
score_senti <- sentiment_score %>% 
  mutate(sentiment = ifelse(polarity >=  1, "pos", 
                            ifelse(polarity <= -1, "neg", "neu")))
  
freq_senti = score_senti %>% 
  count(sentiment) %>% 
  mutate(ratio = n/sum(n)*100)
  
# 막대 그래프 만들기
bp = barplot(freq_senti$ratio, main="감정 단어 사용 분포", names.arg=freq_senti$sentiment, 
               col = c("red", "gray", "green"), ylim=c(0, 100))
text(x=bp, y=freq_senti$ratio, labels = paste(round(freq_senti$ratio,1), "%"), pos=3)




#######################################################################
### 예제6-1 : N2H4 패키지를 이용한 네이버 뉴스에 대한 댓글 크롤링
#######################################################################

#install.packages("N2H4")

library(N2H4)   # to use getAllComment()
library(data.table)   # to use setnames()

url = "https://n.news.naver.com/mnews/article/001/0013299250?sid=100"
comm <- getAllComment(url)     # 댓글 읽어오기 

# data frame 만들고, 필요한 작업 수행
d = data.frame(comm$contents)

d = d %>% mutate(d, id = row_number())
d <- d[, c("id", "comm.contents")]
setnames(d, "comm.contents", "comment")

# csv 화일로 저장
write.csv(d, "naver_com.csv", row.names=FALSE)



#######################################################################
### 예제6-2 : 전북대 커뮤니티 - 교내공지 제목 크롤링
#######################################################################

library(rvest)   # to use read_html(), html_nodes, html_text()     #package for Web Pages scraping

code_url <- "https://www.jbnu.ac.kr/kor/?menuID=139"

# 페이지 주소
url <- paste0(code_url, "&pno=", 1)   # 1 page만 읽기
html <- read_html(url)                # 필요에 따라 encoding="euc-kr" 또는 "UTF-8" 등 이용

post <- html %>%
  html_nodes("td") %>%
  html_nodes("a") %>%
  html_text() 
post  

post <- gsub("[\r\n\t]","", post)     # \r\n\t 태그 제거

# 빈줄 제거
post2 = c()
for(i in 1:length(post)){
  if(nchar(post[i]) > 1) {
    post2 = append(post2, post[i])    
  }
}
post2

# data frame 만들고, 필요한 작업 수행
d = data.frame(post2)

d = d %>% mutate(d, id = row_number())
d <- d[, c("id", "post2")]
setnames(d, "post2", "post_title")

# csv 화일로 저장
write.csv(d, "jbnu_post.csv", row.names=FALSE)




