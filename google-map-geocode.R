library(dplyr)

url <- function(address, key, return.call = "json", sensor = "false") {
  root <- "https://maps.google.com/maps/api/geocode/"
  u <- paste0(root, return.call, "?address=", address, "&sensor=", sensor, "&key=", key)
  return(URLencode(u))
}

geoCode <- function(address) {
  if (file.exists("data/google-key"))
    key <- scan("data/google-key", "character")
  u <- url(address, key)
  doc <- RCurl::getURL(u)
  x <- RJSONIO::fromJSON(doc, simplify = FALSE)
  if (x$status == "OK") {
    latitude <- x$results[[1]]$geometry$location$lat
    longitude <- x$results[[1]]$geometry$location$lng
    location_type  <- x$results[[1]]$geometry$location_type
    formatted_address  <- x$results[[1]]$formatted_address
    return(data.frame(address, latitude, longitude, location_type,formatted_address))
  } else {
    print(x$status)
  }
}

cities = c("Charles de Gaulle Airport (CDG), 95700 Roissy-en-France, France",
           "Hamad International Airport, everestDoha، Doha, Qatar",
           "KL International Airport, Kuala Lumpur International Airport, 64000 Sepang, Selangor, Malaysia",
           "Gold Coast Airport (OOL), Eastern Ave, Bilinga QLD 4225, Australia",
           "Auckland Airport (AKL) Ray Emery Dr, Auckland Airport, Auckland 2022, New Zealand",
           "Christchurch International Airport (CHC) 30 Durey Rd, Christchurch Airport, Christchurch 8053, New Zealand")
dfCities <- lapply(cities, geoCode)
dfCities <- do.call(rbind, dfCities)
