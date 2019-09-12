#Spotify Code for Hermione Granger

##Install packages, do this once on new computer
install.packages("devtools")
devtools::install_github('charlie86/spotifyr')
install.packages("knitr")
install.packages("tidyverse")
install.packages("data.table")

#Begin selection here to run daily 
library(data.table)
library(devtools)
library(spotifyr)
library(knitr)
library(tidyverse)
#Need ^^ (spotifyr), knitr, tidyverse
Sys.setenv(SPOTIFY_CLIENT_ID = '2c46a5d6764f425ab746a56a1c8791b9')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '9b809cd5be004e8fbbc72ad74b0e19a7')

access_token <- get_spotify_access_token(client_id = Sys.getenv("SPOTIFY_CLIENT_ID"),
                                         client_secret = Sys.getenv("SPOTIFY_CLIENT_SECRET"))
##This below should give the app authorization

get_my_recently_played(limit = 50) %>% 
  select(track_name, artist_name, album_name, played_at_utc) %>% 
  kable()

##This will prompt the authorization process, showing 
##1: Yes
##2: No"
## Then, Respond with 1
1
#This works 
myrecent50 <- get_my_recently_played(limit=50)
#This works

###NEXT We will do an audio analysis on all the songs and make that its own data frame from track.id variables in the myrecent50

#SThis works-- pulls the audiofeatures of the recent 50 by track id
audiofeaturesrecent50 <-get_track_audio_features(myrecent50$track.id)

#This works-- this is the myrecent50 song list as well as a full audio analysis for every track
Hermionetotal <- merge(myrecent50,audiofeaturesrecent50)
#trying to make name generated for total, with date.)
csvFileName <- paste("Hermionetotal",format(Sys.time(),"%d-%b-%Y %H.%M"),".csv")
#So it seems like this name worked, but in the line below there is an error in getting a full rundown of the table
Hermionetotal <- data.frame(Hermionetotal)
#All checked so far

Hermionetotal <- apply(Hermionetotal,2,as.character)
write.csv(Hermionetotal, file = csvFileName)
#End selection to run daily 
