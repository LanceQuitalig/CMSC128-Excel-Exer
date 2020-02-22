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

}

shinyApp(ui = ui, server = server)