require(xlsx)
library(shiny)

# UI function

ui <- fluidPage(
    id = "main page",
    title = "CMSC 128 Requirement",
    sidebarLayout(
        sidebarPanel(
            h3("Welcome!"),
            textOutput("status"),
            br(),
            textInput("user", "Username: ", "Username"),
            textInput("pass", "Password: ", "Password"),
            actionButton("signup", "Sign Up"),
            actionButton("login", "Log In")
        ),
        mainPanel()
    )
) 

# Server function

server <- function(input, output, session) {
    rv_data <- reactiveValues(data = NULL)

    if (!file.exists("..\\imports\\data.xlsx")) rv_data = c(" ", " ")
    else {
        df = read.xlsx2("..\\imports\\data.xlsx", sheetName = "Sheet1")
        if (length(df) != 2){
            output$status <- renderText("ERROR 401: \nPlease recheck the imported xlsx file. The file must only contain 2 columns!.")
            rv_data$data = c(" ", " ")
        } else if (is.na( df[[1]][length(df[[1]])] ) || is.na( df[[2]][[length(df[[2]])]]) ) {
            output$status <- renderText("ERROR 402: \nPlease recheck the imported xlsx file. The file has an unequal ration of username to password!")
            rv_data$data = c(" ", " ")
        } else {
            source("Extra_Functions.r")
            rv_data$data = FixData(df)
        }
    }
}

shinyApp(ui = ui, server = server)