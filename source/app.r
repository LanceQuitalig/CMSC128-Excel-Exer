install.packages("shiny")

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
        mainPanel(
            wellPanel(
                tableOutput("data"),
                hr(),
                helpText("The database updates in real time as more users are introduced.")
            ),
            tags$style("hr {
			    border: 1px solid #333333;
			}"),
        )
    )
)

# Server function

server <- function(input, output, session) {
    rv_data <- reactiveValues(data = NULL)
    
    if (!file.exists("..\\imports\\data.csv")) rv_data$data = c(" ", " ")
    else {
        df = read.csv("..\\imports\\data.csv")
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
        output$data <- renderTable(rv_data$data, striped = TRUE, bordered = TRUE, align = 'c', width = "100%")
    }
    
    observeEvent(input$login, {
        if (input$user == "Username") output$status <- renderText("ERROR 403: Enter a username.")
        else if (input$pass == "" || input$pass == " " || input$pass == "Password") output$status <- renderText("ERROR 404: Enter a password.")
        else {
            rowIndex = FindUser(input$user, rv_data$data)
            if (rowIndex[1]) {
                if (CheckPass(input$pass, rv_data$data, rowIndex)) {
                    output$status <- renderText({paste("WELCOME ", input$user, sep = "")})
                } else output$status <- renderText("ERROR 404: Invalid Password")
            } else output$status <- renderText("ERROR 405: Invalid Username")
        }
    })
    
    observeEvent(input$signup, {
        if (input$user == "Username") output$status <- renderText("ERROR 403: Enter a username.")
        else if (input$pass == "" || input$pass == " " || input$pass == "Password") output$status <- renderText("ERROR 404: Enter a password.")
        else {
            rowIndex = FindUser(input$user, rv_data$data)
            if (!rowIndex[1]) {
                output$status <- renderText("Sign-up Successful")
                rv_data$data = Signup(input$user, input$pass, rv_data$data)
            } else output$status <- renderText("ERROR 406: Username already exists")
        }
    })
    
    session$onSessionEnded(function() {
        temp = isolate(rv_data$data)
        write.csv(temp, file = "..\\imports\\data.csv", row.names = FALSE)
        stopApp()
    })
}

shinyApp(ui = ui, server = server)