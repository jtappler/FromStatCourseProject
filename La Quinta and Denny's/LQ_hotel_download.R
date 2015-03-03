source("check_packages.R")
check_packages(c("httr", "stringr","XML"))

# Load list
load(file="lq/list.Rdata")

dir.create("lq/hotels/", showWarnings = FALSE)

# Loop over hotels and download their pages (html's already in directory)
for(i in 1:length(link))  
{
    url = link[i]
    page = GET(url)
    s = content(page, as="text")
    write(s, file=paste0("lq/hotels/",i,".html"))
    Sys.sleep(.3) # wait before grabbing the next page
}
