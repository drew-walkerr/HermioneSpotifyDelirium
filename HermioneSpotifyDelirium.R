#Spotify Code for Hermione Granger


#R Spotify Code

##Install packages, do this once on new computer
install.packages("devtools")
devtools::install_github('charlie86/spotifyr')
install.packages("knitr")
install.packages("tidyverse")
install.packages("data.table")

#Begin selection here and extend to bottom of page to run daily. This section below assures the commands are sourced in loaded packages
library(data.table)
library(devtools)
library(spotifyr)
library(knitr)
library(tidyverse)

#This sets up system env variables that grant our app authorization to pull GET requests from Spotify API
Sys.setenv(SPOTIFY_CLIENT_ID = '2c46a5d6764f425ab746a56a1c8791b9')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '9b809cd5be004e8fbbc72ad74b0e19a7')

access_token <- get_spotify_access_token(client_id = Sys.getenv("SPOTIFY_CLIENT_ID"),
                                         client_secret = Sys.getenv("SPOTIFY_CLIENT_SECRET"))
#This begins the authorization process, linked to the account most recently signed in
get_my_recently_played(limit = 50) %>% 
  select(track_name, artist_name, album_name, played_at_utc) %>% 
  kable()

##This will prompt the authorization process, showing 
##1: Yes
##2: No"
## Then, Respond with 1
1
##Then, it will ask you if you'd like to save the token locally
1
#This fetches the 50 most recently played 
myrecent50 <- get_my_recently_played(limit=50)

####NEXT We will do an audio analysis on all the songs and make that its own data frame from track.id variables in the myrecent50

#This pulls the audiofeatures of the recent 50 by track.id
audiofeaturesrecent50 <-get_track_audio_features(myrecent50$track.id)
#Now I change the column names for audiofeaturesrecent50 from "id" to track.id so it links up
colnames(audiofeaturesrecent50)[which(names(audiofeaturesrecent50) == "id")] <- "track.id"


#Next we merge the recent 50 and their audiofeatures into one big table 
total <- merge(myrecent50,audiofeaturesrecent50,sort=FALSE)
#And remove the duplicate values
total <- distinct(total,played_at, .keep_all = TRUE)
#Now i need to sort it by played_at, decreasing in value to sync up with .csv
#I make an R object that is essentially the index order I want the file to be in
ndx <- order(total$played_at,decreasing = TRUE)
total <- total[ndx,]
#Then we make a title element that updates with the timestamp of the data pull
csvFileName <- paste("HermioneGranger",format(Sys.time(),"%d-%b-%Y %H.%M"),".csv")
#Next we'll make sure this table is a data frame 
total <- data.frame(total)
#Some columns are lists that can't be translated to csv so we flatten those columns
total <- apply(total,2,as.character)
#and we make the csv that will be saved in the working directory 
write.csv(total, file = csvFileName)
#End selection to run daily 
