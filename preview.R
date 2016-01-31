previewUI <- function(id) {
  ns <- NS(id)
  title <- sections$section[sections$alias == id]
  tabPanel(title
           ,h2(title)
           ,htmlOutput(ns("knitDoc")))
}

preview <- function(input,output,session
                      ,type = c("downloads", "ours", "top")
                      ,period) {
  contents <- callModule(keyData, id = type, type, period)
  
  boardpreview <-  reactive(readr::read_file(
    rmarkdown::render(
      input = "boardfragment.Rmd"
      ,output_format = rmarkdown::html_fragment()
      ,output_file = "boardfragment.html"
      ,params = list(
        comment = input$commentary
        ,period = period
        ,type = type
      )
    )
  ))
  
  output$knitDoc <- renderUI({
    HTML(boardpreview())
  })
}