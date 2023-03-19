library(tidyverse)
library(skimr)
library(janitor)

#load all the data
data0122 = read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/data2201.csv', colClasses=c("ride_id"="character", "start_station_name"="character", "start_station_id"="character", "end_station_name"="character", "end_station_id"="character", "start_lat"="numeric", "start_lng"="numeric", "end_lat"="numeric", "end_lng"="numeric", "member_casual"="character", "ride_length"="integer", "day_of_week"="integer"), header=TRUE, sep=",")
data0222 = read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/data2202.csv', colClasses=c("ride_id"="character", "start_station_name"="character", "start_station_id"="character", "end_station_name"="character", "end_station_id"="character", "start_lat"="numeric", "start_lng"="numeric", "end_lat"="numeric", "end_lng"="numeric", "member_casual"="character", "ride_length"="integer", "day_of_week"="integer"), header=TRUE, sep=",")
data0322 = read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/data2203.csv', colClasses=c("ride_id"="character", "start_station_name"="character", "start_station_id"="character", "end_station_name"="character", "end_station_id"="character", "start_lat"="numeric", "start_lng"="numeric", "end_lat"="numeric", "end_lng"="numeric", "member_casual"="character", "ride_length"="integer", "day_of_week"="integer"), header=TRUE, sep=",")
data0422 = read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/data2204.csv', colClasses=c("ride_id"="character", "start_station_name"="character", "start_station_id"="character", "end_station_name"="character", "end_station_id"="character", "start_lat"="numeric", "start_lng"="numeric", "end_lat"="numeric", "end_lng"="numeric", "member_casual"="character", "ride_length"="integer", "day_of_week"="integer"), header=TRUE, sep=",")
data0522 = read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/data2205.csv', colClasses=c("ride_id"="character", "start_station_name"="character", "start_station_id"="character", "end_station_name"="character", "end_station_id"="character", "start_lat"="numeric", "start_lng"="numeric", "end_lat"="numeric", "end_lng"="numeric", "member_casual"="character", "ride_length"="integer", "day_of_week"="integer"), header=TRUE, sep=",")
data0622 = read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/data2206.csv', colClasses=c("ride_id"="character", "start_station_name"="character", "start_station_id"="character", "end_station_name"="character", "end_station_id"="character", "start_lat"="numeric", "start_lng"="numeric", "end_lat"="numeric", "end_lng"="numeric", "member_casual"="character", "ride_length"="integer", "day_of_week"="integer"), header=TRUE, sep=",")
data0722 = read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/data2207.csv', colClasses=c("ride_id"="character", "start_station_name"="character", "start_station_id"="character", "end_station_name"="character", "end_station_id"="character", "start_lat"="numeric", "start_lng"="numeric", "end_lat"="numeric", "end_lng"="numeric", "member_casual"="character", "ride_length"="integer", "day_of_week"="integer"), header=TRUE, sep=",")
data0822 = read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/data2208.csv', colClasses=c("ride_id"="character", "start_station_name"="character", "start_station_id"="character", "end_station_name"="character", "end_station_id"="character", "start_lat"="numeric", "start_lng"="numeric", "end_lat"="numeric", "end_lng"="numeric", "member_casual"="character", "ride_length"="integer", "day_of_week"="integer"), header=TRUE, sep=",")
data0922 = read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/data2209.csv', colClasses=c("ride_id"="character", "start_station_name"="character", "start_station_id"="character", "end_station_name"="character", "end_station_id"="character", "start_lat"="numeric", "start_lng"="numeric", "end_lat"="numeric", "end_lng"="numeric", "member_casual"="character", "ride_length"="integer", "day_of_week"="integer"), header=TRUE, sep=",")
data1022 = read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/data2210.csv', colClasses=c("ride_id"="character", "start_station_name"="character", "start_station_id"="character", "end_station_name"="character", "end_station_id"="character", "start_lat"="numeric", "start_lng"="numeric", "end_lat"="numeric", "end_lng"="numeric", "member_casual"="character", "ride_length"="integer", "day_of_week"="integer"), header=TRUE, sep=",")
data1122 = read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/data2211.csv', colClasses=c("ride_id"="character", "start_station_name"="character", "start_station_id"="character", "end_station_name"="character", "end_station_id"="character", "start_lat"="numeric", "start_lng"="numeric", "end_lat"="numeric", "end_lng"="numeric", "member_casual"="character", "ride_length"="integer", "day_of_week"="integer"), header=TRUE, sep=",")
data1222 = read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/data2212.csv', colClasses=c("ride_id"="character", "start_station_name"="character", "start_station_id"="character", "end_station_name"="character", "end_station_id"="character", "start_lat"="numeric", "start_lng"="numeric", "end_lat"="numeric", "end_lng"="numeric", "member_casual"="character", "ride_length"="integer", "day_of_week"="integer"), header=TRUE, sep=",")

#combine all monthly data into one yearly data
data22 = rbind(data0122, data0222, data0322, data0422, data0522, data0622, data0722, data0822, data0922, data1022, data1122, data1222)
write.csv(data22, file='C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/AllData22.csv', row.names=FALSE)

#read the saved csv (clean the previously loaded file in order to save memory)
data22 <- read.csv('C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/AllData22.csv', header=TRUE, sep=",")

#check the data type and a little overview of the data
str(data22)

#The started_at and ended_at are imported as character. We need to convert it to datetime
data22$started_at <- as.POSIXct(data22$started_at, format="%Y-%m-%d %H:%M:%OS")
data22$ended_at <- as.POSIXct(data22$ended_at, format="%Y-%m-%d %H:%M:%OS")
#recheck the data type
str(data22)
#re-save into the file to create checkpoint
write.csv(data22, file='C:/Personal/DA/Google Data Analytics/Capstone Project/SQL/Export/AllData22.csv', row.names=FALSE)

#explore more about the data
skim_without_charts(data22)


data22 %>%
  group_by(member_casual) %>% summarize(avg_trip_length=mean(ride_length), median_trip_length=median(ride_length), max_trip_length=max(ride_length), min_trip_length=min(ride_length))

data22 %>%
  group_by(member_casual) %>%
  summarize(total_ride=length(ride_id))

data22 %>% 
  filter(member_casual=="casual") %>%
  group_by(day_of_week) %>%
  summarize(total_ride=length(ride_id), avg_length=mean(ride_length))

data22 %>% 
  filter(member_casual=="member") %>%
  group_by(day_of_week) %>%
  summarize(total_ride=length(ride_id), avg_length=mean(ride_length))

#the promotion can be done on weeekend since it is more popular for casual_members.

casual_start_habit <- 
  data22 %>% 
  filter(member_casual=="casual") %>%
  group_by(start_station_name) %>%
  summarize(total_ride=length(ride_id))
attach(casual_start_habit)
casual_start_habit <- casual_start_habit[order(-total_ride), ]
detach(casual_start_habit)
casual_start_habit

casual_end_habit <- 
  data22 %>% 
  filter(member_casual=="casual") %>%
  group_by(end_station_name) %>%
  summarize(total_ride=length(ride_id))
attach(casual_end_habit)
casual_end_habit <- casual_end_habit[order(-total_ride), ]
detach(casual_end_habit)
casual_end_habit

#Top 5 start_station and end_station for casual riders remain the same.
#1 Streeter Dr & Grand Ave                 
#2 DuSable Lake Shore Dr & Monroe St       
#3 Millennium Park                         
#4 Michigan Ave & Oak St                   
#5 DuSable Lake Shore Dr & North Blvd  


member_start_habit <- 
  data22 %>% 
  filter(member_casual=="member") %>%
  group_by(start_station_name) %>%
  summarize(total_ride=length(ride_id))
attach(member_start_habit)
member_start_habit <- member_start_habit[order(-total_ride), ]
detach(member_start_habit)
member_start_habit

member_end_habit <- 
  data22 %>% 
  filter(member_casual=="casual") %>%
  group_by(end_station_name) %>%
  summarize(total_ride=length(ride_id))
attach(member_end_habit)
member_end_habit <- member_end_habit[order(-total_ride), ]
detach(member_end_habit)
member_end_habit
