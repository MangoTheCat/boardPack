library(shiny)
library(shinythemes)
library(ggplot2)
library(data.table)

source("config.R")

shinyUI(navbarPage(
  theme = myTheme
  ,title = myTitle
  ,setupInput
  ,tabPanel("Add commentary", uiOutput("inputs"))
  ,tabPanel("Live preview", uiOutput("previews"))
  ,tabPanel("Make PDF", reportGenUI("generate"))
))
