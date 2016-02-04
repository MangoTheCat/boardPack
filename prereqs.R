packages<-c("shiny", "knitr", "shinythemes"
            , "data.table", "lubridate", "stringi"
            ,"jsonlite", "memoise", "rmarkdown"
            ,"readr")

installLoad<-function(x){
  if(!require(x,character.only=TRUE)) install.packages(x)
  require(x,character.only=TRUE,quietly = TRUE)
}

lapply(packages, installLoad)