rm(list = ls())
library(rvest)
url <- 'http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature'

# fieds to scrap
# Rank: The rank of the film from 1 to 100 on the list of 100 most popular feature films released in 2016.
# Title: The title of the feature film.
# Description: The description of the feature film.
# Runtime: The duration of the feature film.list 
# Genre: The genre of the feature film,
# Rating: The IMDb rating of the feature film.
# Metascore: The metascore on IMDb website for the feature film.
# Votes: Votes cast in favor of the feature film.
# Gross_Earning_in_Mil: The gross earnings of the feature film in millions.
# Director: The main director of the feature film. Note, in case of multiple directors, I’ll take only the first.
# Actor: The main actor of the feature film. Note, in case of multiple actors, I’ll take only the first.

#getting rank data 
rank_data <- url %>% read_html %>% html_nodes(css = '.text-primary') %>% html_text
head(rank_data)

# processing rank data
ranks <- as.numeric(rank_data)
head(ranks)

#reading movie titles
title_data <- url %>% read_html %>% html_nodes(css = '.lister-item-header a') %>% html_text
head(title_data)

#description of movies
description_data <- url %>% read_html %>% html_nodes(css = '.ratings-bar+ .text-muted') %>% html_text
description_data <- trimws(description_data)
head(description_data)

#runtime of movies
runtime_data <- url %>% read_html %>% html_nodes(css = 'span.runtime') %>% html_text
head(runtime_data)

#processing run time data
runtime_data <- as.numeric(gsub(' min','',runtime_data))
head(runtime_data)

#genre data
genre_data <- url %>% read_html %>% html_nodes(css = 'span.genre') %>% html_text
#head(genre_data)
genre_data <- trimws(genre_data)
head(genre_data)
genre_data_temp <- str_split(genre_data,',')
for(i in 1:length(genre_data_temp)){
  genre_data_temp[[i]] = trimws(genre_data_temp[[i]])
}
head(genre_data_temp)

#rating data
rating_data <- url %>% read_html %>% html_nodes(css = '.ratings-imdb-rating strong') %>% html_text
rating_data <- as.numeric(rating_data)
head(rating_data)

#director data
director_data <- url %>% read_html %>% html_nodes(css = '.text-muted+ p') %>% html_text
director_data <- gsub('\n','',director_data)
director_data <- trimws(director_data)
head(director_data)
library(stringr)
director_data <- str_split(director_data,'[|]')
directors <- rep()
stars <- rep()
for(i in 1:length(director_data)){
  directors[i] <- director_data[[i]][1]
  directors[i] <- trimws(directors[i])
  directors[i] <- str_split(directors[i],':')[[1]][2]
  stars[i] <- director_data[[i]][2]
  stars[i] <- trimws(stars[i])
  stars[i] <- str_split(stars[i],':')[[1]][2]
}
head(directors)
head(stars) 

#scrapping the votes
votes_data <- url %>% read_html %>% 
  html_nodes(css = '.sort-num_votes-visible span:nth_child(2)') %>% html_text
votes_data <- as.numeric(gsub(',','',votes_data))
head(votes_data)

#scarapping metascore
metascore <- url %>% read_html %>% html_nodes(css = 'span.metascore') %>% html_text
metascore <- as.numeric(trimws(metascore))
metascore <- append(metascore,NA,53)
metascore <- append(metascore,NA,60)
head(metascore)

#scrapping Gross earnings

gross_earn <- url %>% read_html %>% html_nodes(css = '.sort-num_votes-visible span:nth_child(5)') %>% html_text
gross_earn <- gsub('M','',gross_earn)
gross_earn <- as.numeric(str_sub(gross_earn,2))
missing_val <- c(11,16,54,70,81,92,97)
for(i in missing_val){
  gross_earn <- append(gross_earn,NA,after = i)
}
length(gross_earn)
head(gross_earn)

#final datast
dataset <- data.frame(ranks,title_data,description_data,runtime_data,genre_data,rating_data
                      ,directors,stars,votes_data,metascore,gross_earn)
