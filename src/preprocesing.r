library(jsonlite)
library(NISTunits)

system.time(x <- fromJSON("hist.json"))

#Promien ziemi
R = 6378137 

loc = x$locations

loc$activity = NULL
loc$altitude = NULL
loc$verticalAccuracy = NULL
loc$velocity = NULL
loc$heading = NULL

loc$time = as.POSIXct(as.numeric(x$locations$timestampMs)/1000, origin = "1970-01-01")
loc$lat = loc$latitudeE7 / 1e7
loc$lon = loc$longitudeE7 / 1e7

day = loc[(loc$time > '2018-05-12 9:35:00' & loc$time <= '2018-05-12 9:50:00'),]

#day$lat = day$lat - lat_ref
#day$lon = day$lon - lon_ref

day$lat = NISTdegTOradian(day$lat)
day$lon = NISTdegTOradian(day$lon)

day$y = R * cos(day$lat) * cos(day$lon)
day$x = R * cos(day$lat) * sin(day$lon)

day$y = day$y - min(day$y)
day$y = max(day$y) - day$y 
day$x = day$x - min(day$x)
day$time_sek = 0
day$time_sek[2:length(day$time)] = as.numeric(day$time[1:length(day$time)-1]) - as.numeric(day$time[2:length(day$time)])

summary(day)

plot(day$x/1000, day$y/1000, xlim = c(0, 100), ylim = c(0, 100))
plot(day$time, day$time_sek/60)
plot(day$time, day$x/1000)
plot(day$time, day$y/1000)
plot(day$time, (day$y^2 + day$x^2)^(1/2))

day<- day[seq(dim(day)[1],1),]

write.csv(cbind(day$x, day$y, day$time_sek, as.numeric(day$timestampMs)), file = "data.csv")

