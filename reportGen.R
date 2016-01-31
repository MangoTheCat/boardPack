reportGenUI <- function(id) {
  ns<-NS(id)
  tagList(actionButton(ns("make"),"Generate file")
          ,downloadButton(ns("download"),"Download file"))
}

reportGen <- function(input,output,session, period) {
  tmp<-tempfile(fileext = ".pdf")
  
  fragRender<-function(type, period){
    content<-callModule(keyData,type,type,period)
    
    title <- sections$section[sections$alias == type]
    
    readr::read_file(
      rmarkdown::render(
        input = "boardfragment.Rmd"
        ,output_format = rmarkdown::md_document()
        ,output_file=tempfile(fileext = ".md")
        ,output_dir = tempdir()
        ,params = list(
          comment = input$commentary
          ,period = period
          ,type = type
          ,title = title
        )))
  }
  
  observeEvent(input$make,{
    file.copy("boardpack.Rmd", "dummy.Rmd", overwrite = TRUE)
    toAdd<-paste("\n",lapply(sections[,alias], fragRender, period=period))
    write(toAdd,"dummy.Rmd", append=TRUE)
    rmarkdown::render("dummy.Rmd",output_file=tmp)
  } )
  
  
  output$generate <- downloadHandler(
    filename = myOutputFileName
    ,content = function(file) {
      rmarkdown::render("dummy.Rmd")
      file.rename("dummy.pdf",file)
    }
    ,contentType = "application/pdf"
  )
  
}