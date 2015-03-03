# Load Required packages
source("check_packages.R")
check_packages(c("httr", "stringr"))

# Define URL
url = "http://www.lq.com/en/findandbook/hotel-listings.html"

page = GET(url)

s = content(page, as="text")

dir.create("lq/", showWarnings = FALSE)

# Write List File
write(s, file="lq/list.html")


# get hotel name and link
Name = str_match_all(s, "html\">([A-Za-z0-9'\\() /&\\.-]*)</a><br>\r\n")
link = str_match_all(s, "<a href=\"([a-z0-9 \\/\\.-]*)\">La Quinta")

#change the data structure to character matrix
Name = unlist(Name)
Name = Name[(length(Name)/2+1):length(Name)]
link = unlist(link)
link = link[(length(link)/2+1):length(link)]
link = paste0("http://www.lq.com",link)

#The numbers of link and name are different, because 17 hotels own the same link: "/en/findandbook/hotel-details.null.address.html" 
#so we don't want to match hotel names with links, the only information we need now are the links, but not the names
link = unique(link)
Name = unique(Name)

# Save results as Rdata file
save(link, file="lq/list.Rdata")

	