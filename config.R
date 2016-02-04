myTheme <- shinythemes::shinytheme("United")
myTitle <- "Board Pack"
myOutputFileName<-paste0("MyBoardPack",format(Sys.Date(),"%Y%m%d"),".pdf")
sections <- data.table(
  section = c("R downloads"
              ,"Popular packages"
              ,"Our packages")
  ,alias = c("downloads","top","ours")
  ,active = rep(1,3)
)

companies <- data.table(
  company = c("Mango"
              ,"Mango Pharma Products"
              ,"Mango Consultancy")
  ,active = rep(1,3)
)

source("prereqs.R")
source("keyData.R")
source("preview.R")
source("reportGen.R")
source("setup.R")