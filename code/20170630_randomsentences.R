setwd("O:/R codes and data files/shiny/tutorial codes")
library(shiny)

textdata <- read.table("textdata.csv", sep=";", header=TRUE)

ui <- fluidPage(
  actionButton(inputId = "go", 
               label = "Click me"),
  htmlOutput("text")
)

server <- function(input, output) {
  obs <- eventReactive(input$go, {
    round(runif(1, min=1, max=5),digits = 0)
  })
  output$text <- renderUI({
    HTML(paste(textdata[textdata$num == obs(),"text"]))
  })
}

shinyApp(ui = ui, server = server)
