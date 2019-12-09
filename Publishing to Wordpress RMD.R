
library(knitr); library(RWordPress)

options(WordPressLogin = c(aandrewwalkerr = 'L9k_tar4275849'),
        WordPressURL = 'https://andrewlouiswalker.com/xmlrpc.php')


postID <- knit2wp(
  input = 'Spotify_Code_Markdown.RmD', 
  title = 'Music Listening History Analysis in R', 
  publish = FALSE,
  action = "newPost"
)

knit2wp('Spotify_Code_Markdown.RmD',
        title = 'Music Listening History Analysis in R',
        publish = FALSE,
        action = "newPost")