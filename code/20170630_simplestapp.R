setwd("O:/R codes and data files/shiny/tutorial codes")
library(shiny)

textdata <- read.table("textdata.csv", sep=";", header=TRUE)

ui <- fluidPage(
  sliderInput(inputId = "nummer", 
    label = "Choose a number", 
    value = 1, min = 1, max = 5),
  htmlOutput("text")
)

server <- function(input, output) {
  
  output$text <- renderUI({
    HTML(paste(textdata[textdata$num == input$nummer,"text"]))
  })
}

shinyApp(ui = ui, server = server)
