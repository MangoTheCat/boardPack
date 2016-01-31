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
    rmarkdown::render(
      input = "boardfragment.Rmd"
      ,output_format = rmarkdown::html_fragment()
      ,output_file = "boardfragment.html"
      ,params = list(
        comment = input$commentary
        ,period = period
        ,type = type
        ,title = title
      )
    )
  )})
  
  output$knitDoc <- renderUI({
    HTML(boardpreview())
  })
}