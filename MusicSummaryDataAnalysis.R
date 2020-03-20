library(tidyverse)
library(lubridate)

Drewdata <- read.csv("DrewMusic 09-Mar-2020 22.26 .csv")


as_datetime(Drewdata$date)

# ADDING SESSION VARIABLES -------------------------------------
#Convert duration_ms to millisecond period value 
milli <- dmilliseconds(Drewdata$duration_ms)

#adding variables to start to create the intervals
Drewdata <- Drewdata %>% 
  mutate(year = year(date), 
         month = month(date), 
         day = day(date), 
         hour = hour(date),
         last_play = lead(date), 
         recentstart = as_datetime(date),
         end = (as_datetime(date) + milli),
         last_theo_end = lead(end))
#make time.interval object between when the previous song could have theoretically ended and the start of the track played most recently to indicate if there was time after it finished playing or was skipped
time.interval <- Drewdata$last_theo_end %--% Drewdata$recentstart
#Create variable that is the difference between start time and theoretical last time played in duration
Drewdata <- Drewdata %>% 
  mutate(diff = as.duration(time.interval))
#REORDER
Drewdata <- arrange(Drewdata, date) 
#ASSIGN SESSION LABELS 
Drewdata <- Drewdata %>% mutate(new_interval = diff > as.duration(3600),
                      new_interval = ifelse(is.na(new_interval), FALSE, new_interval),
                      session_number = cumsum(new_interval))

#Summarizing session numbers
by_session_number <- group_by(Drewdata, session_number, recentstart, end)





#Basically trying to recreate this  
#https://stackoverflow.com/questions/37168305/group-date-intervals-by-the-proximity-of-their-start-and-end-times 
#create interval to indicate new interval if greater than 1 hour

#Finding session midpoints!!? 
for session_number




# VISUALIZATIONS ----------------------------------------------------------



ggplot(data = Drewdata) +
  geom_point(mapping = aes(x = hour, y = valence, color = year))

typeof(hour)

Drewdata %>% 
  hist(hour)

summary(Drewdata$hour)

hist(Drewdata$year, )

plot(Drewdata$year)

# DREWDATA VISUALIZATIONS -----------------------------------------------------





Drewdata %>% 
  group_by(year) %>% 







view(Drewsummary)


summary <- Drewdata %>% 
  summarise()

view(as.table(Drewsummary))

out <- capture.output(summary.data.frame(Drewdata))
cat("Drewsummary", out, file="Drewsummaries.txt", sep="n", append=TRUE)

#Taking summary making it an r object, table chr [1:7, 1:27]
Drewsummary <- summary.data.frame(Drewdata)

Drewsummary %>% 
  select(Var2,Freq)


newdf <- select(Drewsummary, 


#Make summary file
write.csv(as.table(Drewsummary),"Drewsummary")

write.table(Drewsummary, file = "summary.txt")

#

sink(Drewsummary)
print(Drewsummary)
sink()  #



Drewdata

view(summary)

as.Date.character(Drewdata$date)

Drewdata %>% 
  mutate(date <-)
  group_by(date) %>% 
  
  summarise(…)

  =


# DrewData Time Listening sessions ----------------------------------------
dateplayed <- as.Datetime(Drewdata$date)
  
as_datetime(Drewdata$date)
  
i <- interval()

typeof(Drewdata$duration_ms)


Drewdata <- 
  Drewdata %>% 
  mutate(lagged_date = lag(date))

, start = date, end = (date + duration_ms))d

#new 
Df %>% 
        diff = start - lagged_end,
         new_interval = diff > 5,
         new_interval = ifelse(is.na(new_interval), FALSE, new_interval),
         interval_number = cumsum(new_interval))
  
  
Drewdata

# Shelton Data ------------------------------------------------------------
SheltonData <- read.csv("SheltonMusic 14-Mar-2020 18.47 .csv")
  
as_datetime(SheltonData$date)
# Separating Dates into Components, adding Year, month, day variables ----------------------------------------

SheltonData2 <- SheltonData %>% 
  mutate(year = year(date), month = month(date), day = day(date), hour = hour(date))


# Summarizing and Exploring Data ------------------------------------------



(Sheltonsummary <- summary.data.frame(SheltonData))

