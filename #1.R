library(RSelenium)
library(rvest)
library(stringr)
library(dplyr)


#Tworznie srodowwiska Reselenium
driver <- rsDriver(browser = "firefox", port = 4444L)
remote_driver <- driver[["client"]]
remote_driver$navigate("https://euw.op.gg/summoner/userName=DV1+lee+sang")
 
 #Wciskanie przysiku poka¿ wicej
find_button <- remote_driver$findElement("css", "div[class='GameMoreButton Box']")
find_button1 <-  find_button$findElement("class", "Button")
find_button1$clickElement()

opgg <- xml2::read_html(remote_driver$getPageSource()[[1]], encoding = "UTF-8")

# champion <- remote_driver$findElement("css", "div[class = 'GameSettingInfo' ")
# champion <- champion$findElement("css", "div[class = 'ChampionName' ")


Postaæ <- opgg %>% 
   html_nodes(".GameItemWrap") %>%  
   html_nodes(".GameSettingInfo") %>% 
   html_nodes(".ChampionName") %>% 
   html_nodes("a") %>% 
   html_text()
 
Czas <- opgg %>% 
   html_nodes(".TimeStamp") %>% 
   html_nodes("span") %>% 
   html_attr("title")

Tryb <- opgg %>% 
   html_nodes(".GameStats") %>% 
   html_nodes(".GameType") %>% 
   html_attr("title")
 
Rezultat <- opgg %>% 
   html_nodes(".GameResult") %>% 
   html_text()

Kills <- opgg %>% 
   html_nodes(".KDA") %>% 
   html_nodes(".KDA") %>% 
   html_nodes(".Kill") %>% 
   html_text()

Deaths <- opgg %>% 
   html_nodes(".Content") %>% 
   html_nodes(".KDA") %>% 
   html_nodes(".KDA") %>% 
   html_nodes(".Death") %>% 
   html_text()

Assists <- opgg %>% 
   html_nodes(".Content") %>% 
   html_nodes(".KDA") %>% 
   html_nodes(".KDA") %>% 
   html_nodes(".Assist") %>% 
   html_text()




 Kills <-  Kills[-1]
 Deaths <-  Deaths[-1]
 Assists <- Assists[-1]


Rezultat <-  ifelse(str_detect(Rezultat, "Z") == TRUE, "Zwyciestwo", "Porazka")

soloq <-  data.frame(Czas ,Postaæ, Rezultat,Kills, Deaths, Assists, Tryb)

dzien <-  str_extract(soloq$Czas, "\\d{1,999}.?")
miesiac <-  str_extract(soloq$Czas, "[a-z]+")
rok <-  str_extract(soloq$Czas, "(?<= )\\d{4}")

soloq <-  data.frame(dzien, miesiac, rok, Postaæ, Rezultat,Kills, Deaths, Assists, Tryb)
soloq <- soloq %>%  
   filter(Tryb == "Rankingowa, solo")

write.xlsx(soloq, "soloq.xlsx")

# get_last_page <- function(html){
#   
#   pages_data <- html %>% 
#     # The '.' indicates the class
#     html_nodes('.GameMoreButton Box') %>% 
#     # Extract the raw text as a list
#     html_text()                   
#   
#   # The second to last of the buttons is the one
#   pages_data[(length(pages_data)-1)] %>%            
#     # Take the raw string
#     unname() %>%                                     
#     # Convert to number
#     as.numeric()                                     
# }

 
 


