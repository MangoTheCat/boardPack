#' Retrieve a list of options from the DB
#'
#' @param name
getOptions <- function(name) {
  dt <- get(name)[active == 1,]
  vec <- dt[[1]]
  return(vec)
}

#' Return last day of previous month
getEndLastMonth <- function() {
  Sys.Date() - lubridate::day(Sys.Date())
}

#' Return first day of previous month
getBegLastMonth <- function() {
  getEndLastMonth() - lubridate::day(getEndLastMonth()) + 1
}

#' Provides a bigger textbox for commentary
#'
#' @param inputId The input slot that will be used to access the value

textboxInput <- function(inputId, commentDefault) {
  shiny::HTML(
    sprintf(
      "<textarea id=\"%1$s\" rows=\"3\" cols=\"50\">%2$s</textarea><br>"
      ,inputId
      , commentDefault
    )
  )
}

#' Construct a URL for working with cranlogs
#'
#' @param type API area
#' @param period API time period
#' @param count API return (for type=top only)
makeCRANLOG <-
  function(type = c("downloads", "ours", "top"), period, count = 30) {
    type <- match.arg(type)
    
    periodFMT <-
      grepl("(\\d{4})-(\\d{2})-(\\d{2}):(\\d{4})-(\\d{2})-(\\d{2})"
            , period)
    if (!periodFMT)
      stop("period was not provided in format `YYYY-MM-DD:YYYY-MM-DD`")
    
    baselink <- "http://cranlogs.r-pkg.org/"
    downloads <- paste("downloads","daily", period, "R", sep = "/")
    ours <- paste("downloads","daily", period
                  , "simplegraph,networkD3,franc,mangoTraining"
                  , sep = "/")
    top <- paste("top", "last-month", count, sep = "/")
    
    link <- paste0(baselink, get(type))
    return(link)
  }

#' Return a data.table of log results
#'
#' @inheritParams makeCRANLOG
getCRANLOG.base <-
  function(type = c("downloads", "ours", "top"), period, count = 30) {
    simp <- jsonlite::fromJSON(makeCRANLOG(type,period,count)
                               , simplifyVector = TRUE)
    if (type == "top") {
      tbl <- data.table::data.table(simp$downloads)
      ord <- tbl[order(-as.numeric(downloads)),package]
      tbl[,`:=`(package = ordered(package, levels = ord)
                ,downloads = as.numeric(downloads))]
    }
    if (type == "downloads") {
      tbl <- data.table::data.table(simp$downloads[[1]])
      tbl <- tbl[os!="NA",]
    }
    if (type == "ours") {
      tbl <- data.table::rbindlist(simp[["downloads"]])
      tbl[,package:= rep(simp[["package"]]
                          , times = sapply(simp[["downloads"]],nrow))]
    }
    
    return(tbl)
  }

getCRANLOG<-memoise::memoise(getCRANLOG.base)

#' Generate various charts
#'
makeChart <- function(data, type = c("downloads", "ours", "top")) {
  if (type == "top") {
    p <- ggplot(data,aes(x = package,y = downloads)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      coord_flip()
  }
  if (type == "downloads") {
    p <- ggplot(data,aes(x = day,y = downloads)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      coord_flip() +
      facet_wrap( ~ os)
  }
  if (type == "ours") {
    p <- ggplot(data,aes(x = day,y = downloads)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      coord_flip() +
      facet_wrap( ~ package)
  }
  
  return(p)
}

#' Custom HTML fragment renderer
#'
#' @param type  API area
#' @param param List of parameters to pass to fragment
#' @param lookup Name of lookup object
#'
#' @return markdown
customMDRender.base<-function(type, param, output_format, lookup=sections){
  title <- lookup$section[lookup$alias == type]
  out<-tempfile(fileext = ".md")
    rmarkdown::render(
      input = "boardfragment.Rmd"
      ,output_file=out
      ,output_format = output_format
      ,params = param
    )
  return(out)
}

customMDRender<-memoise::memoise(customMDRender.base)