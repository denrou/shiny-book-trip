url <- function(origin, destination, key, mode = "driving", language = "fr",
                units = "metric", region = "nz", return.call = "json") {
  root <- "https://maps.googleapis.com/maps/api/directions/"
  u <- paste0(root, return.call,
              "?origin=", origin,
              "&destination=", destination,
              "&key=", key,
              "&mode=", mode,
              "&language=", language,
              "&units=", units,
              "&region=", region)
  return(URLencode(u))
}

binToDec <- function(x)
  sum(2 ** (which(rev(unlist(strsplit(as.character(x), "")) == 1)) - 1))

decodePolyline <- function(code) {
  n <- sapply(strsplit(code, "")[[1]], function(c) strtoi(charToRaw(c), base = 16)) - 63
  l <- sapply(rev(n), function(i) paste(rev(as.numeric(intToBits(i))[1:5]), collapse = ""))
  b <- as.numeric(strsplit(paste(l, collapse = ""), split = "")[[1]])
  negative <- b[length(b)]
  if (negative)
    b <- sapply(b, function(i) ifelse(i == 1, 0, 1))
  b <- c(1, b[1:(length(b) - 1)])
  if (negative)
    b <- as.numeric(strsplit(gsub("^0+", "", paste(rev(as.numeric(intToBits(strtoi(paste(b, collapse = ""), base = 2) - 1))), collapse = "")), split = "")[[1]])
    b <- sapply(b, function(i) ifelse(i == 0, 1, 0))
  strtoi(paste(b, collapse = ""), base = 2) / 1e5
}

encodePolyline <- function(val) {

  # Take the decimal value and multiply it by 1e5, rounding the result
  val <- round(val*1e5)

  # Convert the decimal value to binary.
  # Note that a negative value must be calculated using its two's complement by inverting the binary value and adding one to the result
  b <- rev(as.numeric(intToBits(val)))

  # Left-shift the binary value one bit:
  b <- c(b[2:length(b)], 0)

  # If the original decimal value is negative, invert this encoding
  if (val < 0)
    b <- sapply(b, function(i) ifelse(i == 1, 0, 1))

  # Break the binary value out into 5-bit chunks (starting from the right hand side)
  # Place the 5-bit chunks into reverse order
  l <- unlist(lapply(0:5, function(i) {
    paste(b[(length(b) - 5 * (i + 1) + 1):(length(b) - 5 * i)], collapse = "")
  }))

  # OR each value with 0x20 if another bit chunk follows
  l <- sapply(1:length(l), function(i) if (i == length(l)) paste0("0", l[i]) else paste0("1", l[i]))

  # Convert each value to decimal
  # Add 63 to each value
  n <- sapply(l, strtoi, base = 2) + 63
  paste(sapply(n, function(i) rawToChar(as.raw(i))), collapse = "")
}

direction <- function(origin, destination) {
  if (file.exists("data/google-key"))
    key <- scan("data/google-key", "character")
  u <- url(origin, destination, key)
  doc <- RCurl::getURL(u)
  x <- RJSONIO::fromJSON(doc, simplify = FALSE)
  if (x$status == "OK") {
    overview_polyline <- x$routes[[1]]$overview_polyline$points
    return(overview_polyline)
  } else {
    print(x$status)
  }
}
