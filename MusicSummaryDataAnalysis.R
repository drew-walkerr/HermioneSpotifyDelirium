library(tidyverse)
library(lubridate)




my_data -> Drewdata

Drewdata <- read.csv("DrewMusic 09-Mar-2020 22.26 .csv")
as.data.frame(Drewsummary)

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
dateplayed <- as.Date(Drewdata$date)
  

# Shelton Data ------------------------------------------------------------
SheltonData <- read.csv("SheltonMusic 14-Mar-2020 18.47 .csv")
  
(Sheltonsummary <- summary.data.frame(SheltonData))


