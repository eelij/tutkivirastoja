
# Ladataan paketit
library(maptools)
library(pxR)
library(rio)
library(tmap)
library(RColorBrewer)
library(rgdal)
library(leafletR)

# Työhakemisto
setwd("O://R codes and data files/shiny/kuntarajat")

# Karttapohja
# http://geo.stat.fi/geoserver/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=tilastointialueet:maakunta1000k&outputFormat=SHAPE-ZIP

# Luetaan shapefile
sh<-readShapeSpatial("maakunta1000k.shp", proj4string=CRS("+init=epsg:3067"),verbose=TRUE)

# Konvertoidaan koordinaatisto WGS84:ksi
sh.wgs84 <- spTransform(sh, CRS("+init=epsg:4326"))

# Kunta-aineisto
# Suora lataus ei toimi, taulukko on virheilmoituksen mukaan rikki
#dat<-as.data.frame(read.px("https://pxnet2.stat.fi/PXWeb/Resources/PX/Databases/Kuntien_avainluvut/2017/kuntien_avainluvut_2017_aikasarja.px"))
#dat<-as.data.frame(read.px("kuntien_avainluvut_2017_aikasarja.px"))

# Ladataan käsin kaikkien kuntien avainluvut vuodelta 2015
#dat<-import("C:\\Users\\lenovo\\Desktop\\Kuntien avainluvut.xlsx")

# Yhdistetään data ja kartta
shm<-merge(sh.wgs84, dat, by.x="nimi", by.y="maakunta")

# seuraava vaihe: 
# 1. luo data, jossa tiedot, jotka haluat visualisoida
# 1.1 varmista, että datassa on maakunta ja nimi -nimiset sarakkeet
# 2. yhdistä kartalle kuten alla

# Interaktiivinen kartta
shm@data$nimi2<-gsub("å", "a", gsub("Å", "a", gsub("ö", "o", gsub("ä", "a", gsub("Ö", "ö", gsub("Ä", "A", shm@data$nimi))))))
shm@data$nimi<-shm@data$nimi2
shm@data$namn<-shm@data$nimi2
shm@data$name<-shm@data$nimi2
writeOGR(shm, "shm_geojson", layer='shm', driver="GeoJSON")
popup <- c("nimi", "euroa")
shm@data$euroa<-shm@data$"Sosiaali- ja terveystoiminta yhteensä, nettokäyttökustannukset, euroa/asukas"

cuts <- c(1000, 2000, 3000, 4000, 5000, 6000)
sty <- styleGrad(prop="euroa",
                 breaks = cuts,
                 right=FALSE,
                 style.par="col",
                 style.val=brewer.pal(5, "Reds"),
                 leg="Euroa per asukas", lwd=1, fill.alpha=0.8)

map <- leaflet(data = 'shm_geojson',
               dest = ".",
               style=sty,
               title = "interactive_choropleth",
               base.map = "darkmatter",
               incl.data = TRUE, 
               popup = popup)
