setupInput <- tabPanel(
  "Setup"
  , textInput("title", "Title"
             , value = myTitle)
  , dateInput("date", "Date")
  , selectInput("author", "Company"
               , getOptions("companies"))
  , dateRangeInput(
    "dateRange", "Period to cover"
    , start = getBegLastMonth()
    , end = getEndLastMonth()
  )
  , checkboxGroupInput(
      "includes"
    , "Include sections"
    , choices = getOptions("sections")
    , selected = getOptions("sections")
  )
)