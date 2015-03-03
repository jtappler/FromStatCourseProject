# Do parsing stuff
source("check_packages.R")
check_packages(c("httr", "stringr","XML","RCurl"))


AllStates = c(state.abb) #All 50 states
# Create an empty data frame
dennys = data.frame(matrix(vector(), 0, 13, dimnames=list(c(), c("name","address1","address2","city","clientkey","country","latitude","longitude","other","phone","postalcode","state","uid"))), stringsAsFactors=F)

# We pulled 1000 locations from each state, did it for all 50 states. For result, we have a total number ~50k locations. 
# However after we remove the duplicate rows. It's only 1698 locations left. We think the method pull all states is very inefficient. 
# If we have time to redo it for this specific case, it would be better just pull a few states, but the risk is missing some locations.

for (n in 1:50){
  state = AllStates[n]
  fileName = paste("dennys/",state,".html",sep = "")
  doc <- xmlParse(fileName)
  dennys.state = xmlToDataFrame(nodes=getNodeSet(doc,"//poi"))[c("name","address1","address2","city","clientkey","country","latitude","longitude","other","phone","postalcode","state","uid")]
  dennys <- rbind(dennys, dennys.state)
}
# Sort by uid by deleting
dennys <- dennys[order(dennys$uid),] 
# deleting duplicate rows
dennys <- unique(dennys)
# Resort by State
dennys <- dennys[order(dennys$state),] 

save(dennys, file="dennys/dennys_data.Rdata")
