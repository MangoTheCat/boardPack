previewUI <- function(id) {
  ns <- NS(id)
  title <- sections$section[sections$alias == id]
  tabPanel(title
           ,htmlOutput(ns("knitDoc")))
}

preview <- function(input,output,session
                      ,type = c("downloads", "ours", "top")
                      ,period) {
  contents <- callModule(keyData, id = type, type, period)
  
  boardpreview <-  reactive({
    title <- sections$section[sections$alias == type]
    readr::read_file(
      customMDRender(type
                     ,list(comment = input$commentary
                               ,period = period
                               ,type = type
                               ,title = title
                             )
                     ,rmarkdown::html_fragment()
                     )
  )})
  
  output$knitDoc <- renderUI({
    HTML(boardpreview())
  })
}