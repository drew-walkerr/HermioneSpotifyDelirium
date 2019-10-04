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
library(memoise)

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
###BELOW HERE DOESN'T WORK YET, it's to grab the genre if we can!





#This sets up system env variables that grant our app authorization to pull GET requests from Spotify API
Sys.setenv(SPOTIFY_CLIENT_ID = '2c46a5d6764f425ab746a56a1c8791b9')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '9b809cd5be004e8fbbc72ad74b0e19a7')

access_token <- get_spotify_access_token(client_id = Sys.getenv("SPOTIFY_CLIENT_ID"),
                                         client_secret = Sys.getenv("SPOTIFY_CLIENT_SECRET"))
playlists <- get_my_playlists(limit = 20)
#That will ask you to enter 1
1
#That should open up the browser. 
#Now, we need to make sure we are selecting the playlist that is the last.fm pull
playlist_id <- "5D2y9WkW79chB4XpaRG54Y"


get_playlist_tracks <- function(playlist_id, fields = NULL, limit = 100, offset = 0, market = NULL, authorization = get_spotify_access_token(), include_meta_info = FALSE) {
  base_url <- 'https://api.spotify.com/v1/playlists'
  url <- str_glue('{base_url}/{playlist_id}/tracks')
  params <- list(
    fields = paste0('items(', paste0(fields, collapse = ','), ')'),
    limit = limit,
    offset = offset,
    market = market,
    access_token = authorization
  )
  res <- RETRY('GET', url, query = params, encode = 'json')
  stop_for_status(res)
  res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)
  
  if (!include_meta_info) {
    res <- res$items
  }
  return(res)
}


function










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


build_track_info_query <- function(artist, track, base = "http://ws.audioscrobbler.com/2.0/") {
  base <- param_set(base, "method", "track.getInfo")
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