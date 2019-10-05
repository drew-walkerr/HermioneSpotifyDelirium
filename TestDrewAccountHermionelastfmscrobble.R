#Install and check the packages from the ScrobbleR package
install.packages("devtools")
install.packages("urltools")
install.packages("jsonlite")
install.packages("memoise")
library(devtools)
library("scrobbler")
library(readr)
library(tibble)
library(urltools)
library(jsonlite)


#Next we'll install and check the packages from the Spotifyr package that we made


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


my_data <- scrobbler::download_scrobbles(username = "thedrewwalker", api_key = "50d7685d484772f2ff42c45891b31c7b")
#so this works. Note that the time value is 4 hours ahead. Can we just adjust that here?
#Research converting time- research what sort of data the time is 

# create function for getting song features

artist <- my_data$artist
title <- my_data$song_title



# create a version of this function which can handle errors
possible_af <- possibly(track_audio_features, otherwise = tibble())

track_audio_features(artist,title, type = "track")


#This sets up system env variables that grant our app authorization to pull GET requests from Spotify API
Sys.setenv(SPOTIFY_CLIENT_ID = '2c46a5d6764f425ab746a56a1c8791b9')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '9b809cd5be004e8fbbc72ad74b0e19a7')

access_token <- get_spotify_access_token(client_id = Sys.getenv("SPOTIFY_CLIENT_ID"),
                                         client_secret = Sys.getenv("SPOTIFY_CLIENT_SECRET"))
playlists <- get_my_playlists(limit = 20)
#That will ask you to enter 1
1
#That should open up the browser. #This will also give us a dataframe of the playlists, where we'll find the one we're interestd in capturing and record the playlist id
#Now, we need to make sure we are selecting the playlist that is the last.fm pull
playlist_id <- "5D2y9WkW79chB4XpaRG54Y"
#Playlist URI:  spotify:playlist:5D2y9WkW79chB4XpaRG54Y



#this

audiofeatures <- get_playlist_audio_features(drewdacris,"5D2y9WkW79chB4XpaRG54Y")
audio_features <-get_playlist_audio_features(drewdacris, playlist_uris = "spotify:playlist:5D2y9WkW79chB4XpaRG54Y",
  authorization = get_spotify_access_token())




##This works to get a big database large list file-- super big tho 
lastfmplaylist <- get_playlist("5D2y9WkW79chB4XpaRG54Y")


#We want to try to work with this list into something we can extract the track uri ##
flatlastfmplaylist <- flatten(lastfmplaylist)

lastfmplaylisttibble <- tibble(lastfmplaylist$tracks$items$track.uri, lastfmplaylist$tracks$items$track.artists, lastfmplaylist$tracks$items$track.id, lastfmplaylist$tracks$items$track.album.name)


#this is wheer I realize the problem that we can only pull 100 songs at a time from the playlist. Our next step here is how to repeatedly call each set of 100 songs




lastfmplaylist2 <- get_playlist("5D2y9WkW79chB4XpaRG54Y", offset = 100)




get_playlist_audio_features(drewdacris, "5D2y9WkW79chB4XpaRG54Y")

#how to set up getting the track


lastfmplaylisttracks <- get_playlist_tracks("5D2y9WkW79chB4XpaRG54Y")



audiofeatures <- get_playlist_audio_features(drewdacris, "5D2y9WkW79chB4XpaRG54Y")

get_playlist_audio_features()



##Future resolve below
audioanalysis <- get_track_audio_analysis(lastfmplaylist$tracks$items$track.id, authorization = get_spotify_access_token())

####This next section I believe should try to get top tags for each artist 
##This is all code from last-fm-api.R We are just trying it all out. Make sure to update api_key values
build_artist_toptags_query <- function(artist, base = "http://ws.audioscrobbler.com/2.0/") {
  base <- param_set(base, "method", "artist.gettoptags")
  base <- param_set(base, "artist", URLencode(artist))
  base <- param_set(base, "api_key", "50d7685d484772f2ff42c45891b31c7b")
  base <- param_set(base, "format", "json")
  
  return(base)
}


build_track_toptags_query <- function(artist, track, base = "http://ws.audioscrobbler.com/2.0/") {
  base <- param_set(base, "method", "track.gettoptags")
  base <- param_set(base, "artist", URLencode(artist))
  base <- param_set(base, "track", URLencode(track))
  base <- param_set(base, "api_key", "50d7685d484772f2ff42c45891b31c7b")
  base <- param_set(base, "format", "json")
  
  return(base)
}


fetch_artist_toptags <- function(artist) {
  print(paste0("Fetching ", artist))
  json <- fromJSON(build_artist_toptags_query(artist))
  
  if (length(json$toptags$tag) == 0) return(NA)
  
  return(as.vector(json$toptags$tag[,"name"]))
}

fetch_track_toptags <- function(artist, track) {
  print(paste0("Fetching ", artist, " song: ", track))
  json <- fromJSON(build_track_toptags_query(artist, track))
  
  if (length(json$toptags$tag) == 0) return(NA)
  
  return(as.vector(json$toptags$tag[,"name"]))
}

fetch_track_album <- function(artist, track) {
  print(paste0("Fetching ", artist, " song: ", track))
  json <- fromJSON(build_track_info_query(artist, track))
  
  if (is.null(json$track$album)) return(NA)
  
  return(json$track$album$title)
}


memfetch_artist_toptags <- memoise(fetch_artist_toptags)
memfetch_track_toptags <- memoise(fetch_track_toptags)
memfetch_track_album <- memoise(fetch_track_album)

fetch_all_artists_toptag <- function(artists) {
  toptags <- sapply(artists, memfetch_artist_toptags)
  toptags <- unname(sapply(toptags, function(x) x[1]))
  
  return(tolower(toptags))
}

fetch_songs_genres <- function(artists, tracks) {
  if (length(artists) != length(tracks)) {
    stop("Cannot fetch genres for songs because inputs")
  }
  
  mapply(memfetch_track_toptags, artist = artists, track = tracks)
}

fetch_tracks_albums <- function(artists, tracks) {
  if (length(artists) != length(tracks)) {
    stop("Cannot fetch genres for songs because inputs")
  }
  
  mapply(memfetch_track_album, artist = artists, track = tracks)
}

spotifyr::