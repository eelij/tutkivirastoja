# asetetaan perusjutut
setwd("O:/R codes and data files/data")
library(shiny)
library(leaflet)


# virastodatassa jokaisella virasto&kunta yhdistelmällä oma rivi
virastodata <- read.table("taso2kuntamaakunta.csv", header=T, sep=";")
content1 <- paste(sep="<br/>", virastodata$Maakunta, virastodata$Kunta, virastodata$Taso2.virasto, virastodata$Palvelussuhteiden.lukumäärä.12.2016)
str(virastodata)

# Vakiomuotoisella klusteroinnilla virastoittain
leaflet(virastodata) %>% addTiles() %>% addMarkers(popup=content1,
  clusterOptions = markerClusterOptions()
)

# kuntadatassa kunnalla yksi rivi, ei tietoa mitä virastoja missäkin kunnassa
kuntadata <- read.table("virastot_kunnittain.csv", header=T, sep=";")

# popup content ilman virastojen nimiä
content2 <- paste(sep="<br/>", kuntadata$kunta, paste(sep=" ", kuntadata$virastoja,"virastoa"), paste(sep=" ",kuntadata$virkamiehiä, "virkamiestä"))

# popup content virastoittain
content3 <- paste(sep=" ", "<div style='height:200px;overflow:auto;'>" ,"<b>",kuntadata$ï..kunta,"<br/>","Virastoja:",kuntadata$virastoja,"<br/>","Palvelussuhteita:",kuntadata$virkamiehia,"</b>","<br/>", kuntadata$teksti, "</div>")

# Vakiomuotoisella klusteroinnilla kunnittain
leaflet(kuntadata) %>% addTiles() %>% addMarkers(popup=content3,
  clusterOptions = markerClusterOptions() 
)
