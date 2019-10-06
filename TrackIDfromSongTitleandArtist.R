#This function works to identify the spotify track solely from artist and track title! 
#We need to update this so that it works for the entire list of 1700 songs and artists. Also need to be able to resolve all the instances of garbled data-- maybe my code already does this?
#Find track spotify id, audio features, from song artist and title
library(purrr)
library(spotifyr)
library(dplyr)

#This is how we create function for getting song features
track_audio_features <- function(artist, title, type = "track") {
  search_results <- search_spotify(paste(artist, title), type = type)
  track_audio_feats <- get_track_audio_features(search_results$id[[1]]) %>%
    dplyr::select(-analysis_url)
  
  return(track_audio_feats)
}

# create a version of this function which can handle errors
possible_af <- possibly(track_audio_features, otherwise = tibble())
##
#okay, so I think we used the wrong code from before


audiofeatureeees <- track_audio_features("Sonic Youth","Incinerate", type = "track")
#Note that this is not a full audio analysis

artist <- my_data$artist
title <- my_data$song_title

#Is it possible to map these? So that the same function occurs for all?
audio_features <- map2(artist, title, track_audio_features)

map2_dfc(artist, title, track_audio_features, type = "track")

audiofeaturestrack <- track_audio_features("Sonic Youth", "Incinerate", type = "track")

functionBody(track_audio_features)
