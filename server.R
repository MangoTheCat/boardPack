library(shiny)

shinyServer(function(input, output, session) {
  period <- reactive({
    paste0(as.character(input$dateRange[1]), ":" ,
           as.character(input$dateRange[2]))
  })

  modsToRun <- reactive({
    sections[section %in% input$includes,]
  })

  output$inputs <- renderUI({
    tagList(lapply(modsToRun()$alias, keyDataUI))
  })

  output$previews <- renderUI({
    tagList(lapply(modsToRun()$alias, previewUI))
  })

  modules <- list(
    callModule(keyData, "top", type = "top",period()),
    callModule(keyData, "ours", type = "ours",period()),
    callModule(keyData, "downloads", type = "downloads",period()),
    callModule(preview, "top", type = "top",period()),
    callModule(preview, "ours", type = "ours",period()),
    callModule(preview, "downloads", type = "downloads",period()),
    callModule(reportGen, "generate",period())
  )
})
