source("check_packages.R")
check_packages(c("httr", "rvest","stringr","XML","htmltools"))

# Create list of files
f <- list.files(path="lq/hotels", pattern="*.html", full.names=T, recursive=FALSE)

#Contact Info (Address, phone, fax)
contact <- sapply(f, function(x){
  html_text(html_nodes(html(x),"p"))[2]
})

add1 <- add2 <- phone <- fax <- NULL

for(i in 1:length(contact)){
  add1[i] <- gsub(",","",strsplit(contact[i],"[\r\n]")[[1]][1])
  add2[i] <- strsplit(contact[i],"[\r\n]")[[1]][3]
 	phone[i] <- gsub("Phone: ","",strsplit(contact[i],"[\r\n]")[[1]][9])
	fax[i] <- gsub("Fax: ","",strsplit(contact[i],"[\r\n]")[[1]][15])
}


# hotel name
name <- sapply(f, function(x){
  as.character(unlist(xmlToDataFrame(html_nodes(html(x),"h3")))[1])
})

# Lattitude and Longitude
lat_lon <- sapply(f, function(x){
	a <- readLines(x)
	b <- paste(a, collapse = "")
	str_match_all(b, "green.gif|([-]*[0-9]*[.][0-9]*),([-]*[0-9]*[.][0-9]*)")
})

lat_lon_mat <- matrix(NA,length(contact),2)
for (i in 1:length(contact))
{lat_lon_mat[i,] <- tail(lat_lon[i][[1]], n=1)[,-1]
}

#combine hotel data
hotel_data <- cbind(add1,add2,phone,fax,lat_lon_mat[,1],lat_lon_mat[,2],name)
colnames(hotel_data) <- c("address1","address2","phone","fax","latitude","longitude","hotel name")

# Save results as Rdata file
save(hotel_data, file="lq/hotel_data.Rdata")
