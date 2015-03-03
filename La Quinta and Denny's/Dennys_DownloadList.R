# Load Required packages
source("check_packages.R")
check_packages(c("httr", "stringr","XML","RCurl"))

dir.create("dennys/", showWarnings = FALSE)
AllStates = c(state.abb) #All 50 states

#We download data by States, instead of by cities
urlHead = "http://hosted.where2getit.com/dennys/ajax?&xml_request=%3Crequest%3E%3Cappkey%3E8D6F0428-F3A9-11DD-8BF2-659237ABAA09%3C%2Fappkey%3E%3Cformdata+id%3D%22locatorsearch%22%3E%3Cdataview%3Estore_default%3C%2Fdataview%3E%3Climit%3E3000%3C%2Flimit%3E%3Cgeolocs%3E%3Cgeoloc%3E%3Caddressline%3E"
urlTail = "%3C%2Faddressline%3E%3Clongitude%3E%3C%2Flongitude%3E%3Clatitude%3E%3C%2Flatitude%3E%3C%2Fgeoloc%3E%3C%2Fgeolocs%3E%3Csearchradius%3E3000|10000%3C%2Fsearchradius%3E%3C%2Fformdata%3E%3C%2Frequest%3E"

for (n in 1:50){
  state = AllStates[n]
  url = paste(urlHead, state, urlTail, sep = "")
  st = GET(url)
  fileName = paste("dennys/",state,".html",sep = "")
  write(content(st, as="text"), file = fileName)
}