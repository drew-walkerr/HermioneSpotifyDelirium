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
#Summarizing session variable summaries, session lengths, session midpoints 
by_session_number <- group_by(Drewdata, session_number)
session_summary <- summarise(by_session_number,
                   count = n(),
                   session_valence_mean = mean(valence, na.rm = TRUE),
                   session_energy_mean = mean(energy, na.rm = TRUE),
                   session_key_mean = mean(key, na.rm = TRUE),
                   session_loudness_mean = mean(loudness, na.rm = TRUE),
                   sessionmonth = mean(month, na.rm = TRUE),
                   lastsongdatetime = max(end, na.rm = TRUE),
                   firstsongdatetime = min(recentstart, na.rm = TRUE))
#Making session length duration objects
sessionlength <- session_summary$firstsongdatetime %--% session_summary$lastsongdatetime
midpointinterval <- sessionlength/2
#Adding session duration, midpointdatetime variables
session_summary <- session_summary %>% 
  mutate(midpointdatetime = firstsongdatetime + as.duration(midpointinterval),
         duration = as.duration(sessionlength))



# VISUALIZATIONS ----------------------------------------------------------

ggplot(data = session_summary) +
  geom_point(mapping = aes(x = firstsongdatetime, y = session_valence_mean, color = sessionmonth))

typeof(hour)

Drewdata %>% 
  hist(hour)

summary(Drewdata$hour)


plot(Drewdata$year)


# Shelton Data ------------------------------------------------------------
SheltonData <- read.csv("SheltonMusic 14-Mar-2020 18.47 .csv")
  
as_datetime(SheltonData$date)
# Separating Dates into Components, adding Year, month, day variables ----------------------------------------

SheltonData2 <- SheltonData %>% 
  mutate(year = year(date), month = month(date), day = day(date), hour = hour(date))


# Summarizing and Exploring Data ------------------------------------------



(Sheltonsummary <- summary.data.frame(SheltonData))

