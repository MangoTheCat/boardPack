reportGenUI <- function(id) {
  ns <- NS(id)
  tagList(downloadButton(ns("generate")
                         , "Download file"))
}

reportGen <- function(input,output,session, period) {
  fragRender <- function(type, period) {
    contents <- callModule(keyData,id = type,type,period)

    title <- sections$section[sections$alias == type]

    readr::read_file(customMDRender(
      type
      , list(
        comment = input$commentary
        , period = period
        , type = type
        , title = title
      )
      , rmarkdown::md_document()
    ))
  }
  
  output$generate <- downloadHandler(
    filename = myOutputFileName
    , content = function(file) {
      file.copy("boardpack.Rmd", "dummy.Rmd", overwrite = TRUE)
      toAdd <-
        paste("\n",lapply(sections[,alias], fragRender, period = period))
      write(toAdd,"dummy.Rmd", append = TRUE)
      rmarkdown::render("dummy.Rmd")
      file.rename("dummy.pdf", file)
    }
    , contentType = "application/pdf"
  )
  
}