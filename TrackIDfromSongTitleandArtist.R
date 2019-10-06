#This function works to identify the spotify track solely from artist and track title! 
#We need to update this so that it works for the entire list of 1700 songs and artists. Also need to be able to resolve all the instances of garbled data-- maybe my code already does this?
#Find track spotify id, audio features, from song artist and title
library(purrr)
library(spotifyr)
library(dplyr)

#This is how we create function for getting song features
track_audio_features <- function(artist, title, type = "track") {
  search_results <- search_spotify(paste(artist, title), type = type)
  track_audio_feats <- get_track_audio_features(search_results$id[[1]])
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

#This is a test call to test the function track_audio_features
audiofeatureeees <- track_audio_features("Sonic Youth","Incinerate", type = "track")
#Note that this is not a full audio analysis


songs <- my_data$song_title
#this is a character [1]
#How to convert to a list?
listsongs <- list(songs)

typeof(songs)

#trying to make these into a list but it doesn't work, just gives the first one
lastfmtitle <- list(my_data$song_title)
lastfmartist <- list(my_data$artist)


listfeatures <- map2(lastfmartist, lastfmtitle, track_audio_features)

 
#Is it possible to map these? So that the same function occurs for all?
audio_features <- map2(artist, title, track_audio_features)

map2_dfc(artist, title, track_audio_features, type = "track")

audiofeaturestrack <- track_audio_features("Sonic Youth", "Incinerate", type = "track")

functionBody(track_audio_features)
