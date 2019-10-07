#This function works to identify the spotify track solely from artist and track title! 
#To do this, you need to get the last.fm data first. to do that we can merge the data from another R script
#We need to update this so that it works for the entire list of 1700 songs and artists. Also need to be able to resolve all the instances of garbled data-- maybe my code already does this?
#Find track spotify id, audio features, from song artist and title
install.packages("tidyverse")
install.packages("devtools")
devtools::install_github('charlie86/spotifyr')
install.packages("purrr")
install.packages("dplyr")
install.packages("Rcpp")
devtools::install_github("condwanaland/scrobbler")

#Added Library installation of package "Rcpp" due to error code in work computer-- may not need if we install Rtools first
library(devtools)
library(purrr)
library(spotifyr)
library(dplyr)
library(tidyverse)
library("scrobbler")
library(Rcpp)

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
#Now we will "scrobble" the last.fm history, which will give us a all of the songs recorded through last.fm
my_data <- scrobbler::download_scrobbles(username = "thedrewwalker", api_key = "50d7685d484772f2ff42c45891b31c7b")

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
#This index does not work-- because the date format does not decrease in any chronological order-- can fix by converting to table
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
