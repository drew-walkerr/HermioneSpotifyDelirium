#This function works to identify the spotify track solely from artist and track title! 
#To do this, you need to get the last.fm data first. to do that we can merge the data from another R script
#We need to update this so that it works for the entire list of 1700 songs and artists. Also need to be able to resolve all the instances of garbled data-- maybe my code already does this?
#Find track spotify id, audio features, from song artist and title

library(purrr)
library(spotifyr)
library(dplyr)
library(tidyverse)

#This is how we create function for getting song features
track_audio_features <- function(artist, title, type = "track") {
  search_results <- search_spotify(paste(artist, title), type = type)
  track_audio_feats <- get_track_audio_features(search_results$id[[1]]) %>%
    dplyr::select(-id, -uri, -track_href, -analysis_url)
  return(track_audio_feats)
}

# create a version of this function which can handle errors
possible_af <- possibly(track_audio_features, otherwise = tibble())
#
#okay, so I think we used the wrong code from before

#This sets up system env variables that grant our app authorization to pull GET requests from Spotify API
Sys.setenv(SPOTIFY_CLIENT_ID = '2c46a5d6764f425ab746a56a1c8791b9')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '9b809cd5be004e8fbbc72ad74b0e19a7')

access_token <- get_spotify_access_token(client_id = Sys.getenv("SPOTIFY_CLIENT_ID"),
                                         client_secret = Sys.getenv("SPOTIFY_CLIENT_SECRET"))
#This begins the authorization process, linked to the account most recently signed in

colnames(my_data)
colnames(my_data)[colnames(my_data)=="song_title"] <- "title"
##I am acurrently having issues pulling using this, getting error codes consisting of Unknown or uninitialised column: 'id'
possible_feats <- possibly(track_audio_features, otherwise = tibble())
totalaudio_features <- my_data %>%
  mutate(audio_features = map2(artist, title, possible_feats)) %>%
  unnest() %>% 
  as_tibble()

#This works! Although we are missing 9 observations-- 9 songs in this data set, I'm guessing ones that were unable to find
#The following code will create one huge .csv file

ndx <- order(total$played_at,decreasing = TRUE)
total <- totalaudio_features[ndx,]
#Then we make a title element that updates with the timestamp of the data pull
csvFileName <- paste("HermioneGranger",format(Sys.time(),"%d-%b-%Y %H.%M"),".csv")
#Next we'll make sure this table is a data frame 
total <- data.frame(total)
#Some columns are lists that can't be translated to csv so we flatten those columns
total <- apply(total,2,as.character)
#and we make the csv that will be saved in the working directory 
write.csv(total, file = csvFileName)
