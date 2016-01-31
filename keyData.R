keyDataUI <- function(id) {
  ns <- NS(id)
  title <- sections$section[sections$alias == id]
  tabPanel(title
           ,h2(title)
           ,textboxInput(ns("commentary"),title)
           ,plotOutput(ns("chart")))
}

keyData <- function(input,output,session
                    ,type = c("downloads", "ours", "top")
                    ,period) {
  getData <- reactive({
    getCRANLOG(type,period)
  })
  
  chart <- reactive(makeChart(getData(),type))
  output$chart <- renderPlot(chart())
  
}