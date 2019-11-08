#This function works to identify the spotify track solely from artist and track title! 
#To do this, you need to get the last.fm data first. to do that we can merge the data from another R script
#We need to update this so that it works for the entire list of 1700 songs and artists. Also need to be able to resolve all the instances of garbled data-- maybe my code already does this?
#Find track spotify id, audio features, from song artist and title
install.packages("checkpoint")
install.packages("tidyverse")
install.packages("devtools")
devtools::install_github('charlie86/spotifyr')
devtools::install_github("condwanaland/scrobbler")
install.packages("purrr")
install.packages("dplyr")
install.packages("Rcpp")
install.packages("knitr")
devtools::install_github("ewenme/geniusr")
#Added Library installation of package "Rcpp" due to error code in work computer-- may not need if we install Rtools first
library(checkpoint)
checkpoint("2019-11-08")

#if installing for first time, this "checkpoint" package helps us load and install the other necessary packages 

library(tidyverse)
library(devtools)
library(spotifyr)
library(scrobbler)
library(purrr)
library(dplyr)
library(Rcpp)
library(knitr)
library(lubridate)

#This is how we create function for searching spotify to get song features
track_audio_features <- function(artist, title, type = "track") {
  search_results <- search_spotify(paste(artist, title), type = type)
  track_audio_feats <- get_track_audio_features(search_results$id[[1]]) %>%
    dplyr::select(-uri, -track_href, -analysis_url)
  return(track_audio_feats)
}
# create a version of this function which can handle errors
possible_af <- possibly(track_audio_features, otherwise = tibble())
#
#Now we will "scrobble" the last.fm history, which will give us a all of the songs recorded through last.fm
my_data <- scrobbler::download_scrobbles(username = "LunaLove_UF", api_key = "50d7685d484772f2ff42c45891b31c7b")

#This sets up system env variables that grant our app authorization to pull GET requests from Spotify API
Sys.setenv(SPOTIFY_CLIENT_ID = '2c46a5d6764f425ab746a56a1c8791b9')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '9b809cd5be004e8fbbc72ad74b0e19a7')
access_token <- get_spotify_access_token(client_id = Sys.getenv("SPOTIFY_CLIENT_ID"), 
                                         client_secret = Sys.getenv("SPOTIFY_CLIENT_SECRET"))

#Get system env variable that grant authorization to pull GET requests from Genius API
Sys.setenv(GENIUS_API_TOKEN = 'YR553aNK0PbMhAZ1In25a44KYUv7g2Ycc9o3LZXC4ICWKtIHwwctYHqHZpm5cz2t')

#This begins the authorization process, linked to the account most recently signed in

colnames(my_data)
colnames(my_data)[colnames(my_data)=="song_title"] <- "title"
##Now, we'll make a function that applys the search track audio features through the rows of artists and track titles. 
possible_feats <- possibly(track_audio_features, otherwise = tibble("NA"))
totalaudio_features <- my_data %>%
  mutate(audio_features = map2(artist, title, possible_feats)) %>%
  unnest() %>% 
  as_tibble()

##This works! Although we are missing 9 observations-- 9 songs in this data set, I'm guessing ones that were unable to find-- can we change the tibble that the function produces for incomplete songs in the possibly? 
#The following code will create one huge .csv file
#Now we will change the dates given by last.fm to UTC timestamps. It's worth noting we are only accurate to the minute
totalaudio_features$date <- dmy_hm(totalaudio_features$date)
#Now we'll convert to change to US Timezone for easier data analysis
totalaudio_features$date <- with_tz(totalaudio_features$date, tzone = "US/Eastern")
total <- totalaudio_features
#Then we make a title element that updates with the timestamp of the data pull
csvFileName <- paste("LunaLoveGood",format(Sys.time(),"%d-%b-%Y %H.%M"),".csv")
#and we make the csv that will be saved in the working directory 
write.csv(total, file = csvFileName)

write.csv(totalaudio_features, file = csvFileName)

####Install Geniusr to begin collecting song lyric data for sentiment analysis 

devtools::install_github("ewenme/geniusr")
library(geniusr)

#This works, but separates the lyrics line by line into a 65 row, 5 variable table
ConAltura <- get_lyrics_search("Rosalia", "Con Altura")
get_lyrics


ConAltura <- search_song("Con Altura", n_results = 1, access_token = genius_token())

#this doesn't work yet  but we're close! 
track_lyrics <- function(artist, title, type = "track") {
  lyricssearch_results <- get_lyrics_search(paste(artist, title)
  track_audio_feats <- get_track_lyrics(search_results$id[[1]])
  return(track_lyrics)
}



#Now I'm gonna try something crazy, and get the music lyrics for every song
possible_lyrics <- possibly(track_lyrics, otherwise = tibble("NA"))
lyricsandmusic <- totalaudio_features %>%
  mutate(lyrics = map2(artist, title, track_lyrics)) %>%
  unnest() %>% 
  as_tibble()

