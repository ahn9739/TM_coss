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
