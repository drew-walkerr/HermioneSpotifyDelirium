library(tidyverse)
library(lubridate)




my_data -> Drewdata

Drewdata <- read.csv("DrewMusic 09-Mar-2020 22.26 .csv")


as_datetime(Drewdata$date)
# Separating Dates into Components, adding Year, month, day variables ----------------------------------------

#Convert duration_ms to millisecond period value 
milli <- dmilliseconds(Drewdata$duration_ms)
#WOrkable sparsing hours and days and months 

# WORKING ANALYSIS TRACK SESSION CODE -------------------------------------


Drewdata <- Drewdata %>% 
  mutate(year = year(date), 
         month = month(date), 
         day = day(date), 
         hour = hour(date),
         last_play = lead(date), 
         recentstart = as_datetime(date),
         end = (as_datetime(date) + milli),
         last_theo_end = lead(end))
         
time.interval <- Drewdata$last_theo_end %--% Drewdata$recentstart


Drewdata <- Drewdata %>% 
  mutate(diff = as.duration(time.interval),
         
  
         diff = dmilliseconds(Drewdata$last_play - Drewdata$recentstart)
  )

str(time.interval)

as.duration(time.interval)

summary(Drewdata$diff)

#Workable interval code

Drewdata <- Drewdata %>% 
  mutate(last_play = lead(date), start = date, end = (as_datetime(date) + milli))

#Trying differences

typeof(Drewdata$start)

Drewdata <- Drewdata %>% 
  mutate(diff = dmilliseconds(Drewdata$start %--% Drewdata$lagged_date))

typeof(Drewdata$start)
typeof(lagged_date)
a
#funky
diff = start - lagged_date,
new_interval = diff > 5,
new_interval = ifelse(is.na(new_interval), FALSE, new_interval),
interval_number = cumsum(new_interval))


typeof(Drewdata$duration_ms)

asinte



Drewdata <- Drewdata %>% 
  mutate(end = (as_datetime(date) + milli))

, start = date, end = (date + duration_ms))d

as_datetime(Drewdata$date) + milli


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

