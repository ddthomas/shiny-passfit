# Packages ----
library(shiny)  # Required to run any Shiny app
#library(ggplot2)
library(dplyr) 
library(readr)
library(shinythemes)
library(shinyWidgets)
library(googlesheets4)
library(RMySQL)
library(data.table)
library(shinyvalidate)
library(tidyverse)
library(DT)


# Question & Choices Variables ----
# Question IDs
# Demographics
demo.names <- list(
  demo.q1 = "study",
  demo.q2 = "study_id",
  demo.q3 = "affiliation",
  demo.q4 = "ethnicity",
  demo.q5 = "race",
  demo.q6 = "marital_status")
list2env(demo.names, envir = globalenv())
demo.data <- unlist(demo.names, use.names=FALSE)

# Testing options for working with list vs array
# eval(parse(text = a[[1]]))
# b<-c(as.name(a[[1]]),as.name(a[[2]]))
# d<- unlist(demo.names)
# e <- unlist(b)
# mget(a)


# Preferences, Tolerances, Social
pref.names <- list(
  pref.q1 = "pretie.1",
  pref.q2 = "pretie.2",
  pref.q3 = "pretie.3",
  pref.q4 = "pretie.4",
  pref.q8 = "pretie.8",
  pref.q9 = "pretie.9",
  pref.q12 = "pretie.12",
  pref.q13 = "pretie.13",
  pref.q14 = "pretie.14",
  pref.q15 = "pretie.15",
  social.q1 = "social.1")
list2env(pref.names, envir = globalenv())
pref.data <- unlist(pref.names, use.names=FALSE)

pref.choices <- c(paste0("1", br(), "I totally disagree"),
                  paste0("2", br(),"I disagree"),
                  paste0("3", br(),"I neither agree nor disagree"), 
                  paste0("4", br(),"I agree"),
                  paste0("5", br(),"I totally agree")) 

# Cognitive
cog.names <- list(
  cog.q1 = "fof.1",
  cog.q2 = "gds.1",
  cog.q3 = "gds.2",
  cog.q4 = "gds.3",
  cog.q5 = "gds.4",
  cog.q6 = "gds.5",
  cog.q7 = "ucla.1",
  cog.q8 = "ucla.2",
  cog.q9 = "ucla.3",
  cog.q10 = "ucla.4",
  cog.q11 = "ucla.5",
  cog.q12 = "ucla.6",
  cog.q13 = "ucla.7",
  cog.q14 = "ucla.8")
list2env(cog.names, envir = globalenv())
cog.data <- unlist(cog.names, use.names=FALSE)

# Physical
phys.names <- list(
  phys.q1 = "gender",
  phys.q2 = "age",
  phys.q3 = "weight",
  phys.q4 = "height",
  phys.q5 = "rHR",
  phys.q6 = "SRPA",
  phys.q7 = "single leg")
list2env(phys.names, envir = globalenv())
phys.data <- unlist(phys.names, use.names=FALSE)

# Psychological
barse.qs <- 1:4
essq.qs <- 5:9 # currently excluding q's 10-12

psyc.names <- list(
  psyc.q1 = "barse.1",
  psyc.q2 = "barse.3",
  psyc.q3 = "barse.12",
  psyc.q4 = "barse.13",
  psyc.q5 = "essq.1",
  psyc.q6 = "essq.2",
  psyc.q7 = "essq.3",
  psyc.q8 = "essq.4",
  psyc.q9 = "essq.5",
  psyc.q10 = "essq.6",
  psyc.q11 = "essq.7",
  psyc.q12 = "essq.8",
  psyc.q13 = "essq.9",
  psyc.q14 = "essq.10",
  psyc.q15 = "essq.11",
  psyc.q16 = "essq.12")
list2env(psyc.names, envir = globalenv())
psyc.data <- unlist(psyc.names, use.names=FALSE)

# psyc.values <- 1:11 Not able to use "choiceValues=" in sliderTextInput 

psyc.choices.con <- c("0% - Not confident at all",
                    "10%", "20%", "30%", "40%",
                    "50% - Moderately confident",
                    "60%", "70%", "80%", "90%",
                    "100% - Highly confident")
psyc.choices.des <- c("1 - Does not describe me",
                    "2", "3", "4", "5", "6",
                    "7","8", "9", "10",
                    "11 - Describes me")
psyc.choices.cer <- c("1 - Not at all certain",
                    "2", "3", "4", "5", "6",
                    "7","8", "9", "10",
                    "11 - Very certain")
psyc.choices.imp <- c("1 - Not at all important",
                    "2", "3", "4", "5", "6",
                    "7","8", "9", "10",
                    "11 - Very important")







# Load data 
#d <- as.Date(Sys.time())

#data <- tibble::tibble(Sample = "F", Variable1 = 1, Variable2 = 2, Variable3 = 3, Variable4 = 4, Variable5 = 5)


# MySQL
# pass <- "aezKRmcWE7a5C8!"
# user <- "passfitapp_admin"
# db <- "passfitapp_db"
# ip <- "18.220.149.166"



# options(mysql = list(
#   "host" = "127.0.0.1",
#   "port" = 3306,
#   "user" = "etcpassfit_admin",
#   "password" = "aezKRmcWE7a5C8!" C6VtkXpZ7KsRv48
# ))

# options(mysql = list(
#   "host" = "18.220.149.166",
#   "port" = 3306,
#   "user" = "passfitapp_shiny",
#   "password" = "C6VtkXpZ7KsRv48" 
# ))
# databaseName <- "passfitapp_db"
# table <- "responses"

# saveData <- function(data) {
#   # Connect to the database
#   db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host, 
#                   port = options()$mysql$port, user = options()$mysql$user, 
#                   password = options()$mysql$password)
#   # Construct the update query by looping over the data fields
#   query <- sprintf(
#     "INSERT INTO %s (%s) VALUES ('%s')",
#     table, 
#     paste(names(data), collapse = ", "),
#     paste(data, collapse = "', '")
#   )
#   # Submit the update query and disconnect
#   dbGetQuery(db, query)
#   dbDisconnect(db)
# }

# Google sheets ----
library(googlesheets4)
#options(gargle_oauth_cache = ".secrets")
#gs4_deauth()
gs4_auth(cache=".secrets", email="dennison.david.thomas@gmail.com")

sheet_id <- "1k5SauO_DLgIRxhgynyyz4XlUfutLC8XtnMPMWJlnleU"

saveData <- function(data, sheetName) {
  #data <- data.frame(rbind(c(as.character(Sys.time()),1,2,3)))
  sheet_append(sheet_id, data, sheet = sheetName)
}

# Styling options ----
## button status ----
btn_status = "default"

## CSS ----

css <- tags$style(
  type = "text/css",
  ".irs-bar {",
  "  border-color: transparent;",
  "  background-color: transparent;",
  "}",
  ".irs-bar-edge {",
  "  border-color: transparent;",
  "  background-color: transparent;",
  "}"
)


# ui.R ----

ui <- 
    navbarPage("PASSFIT Demo", id = "main", selected = "Questions", collapsible = TRUE, inverse = TRUE, 
               theme = shinytheme("flatly"), #theme = shinytheme("spacelab") # theme = "bootstrap.min.css"
     tags$style(css),
     tabPanel("Questions",
              fluidPage(
                  tabsetPanel( id = "tab_questions",
## DEMOGRAPHICS ===================================================================                    
                    tabPanel("Demographics", br(),
                    fluidPage( 
                      fluidRow(column(12, align="center",
                        p(style="text-align: left;", strong("Thanks for participating in our research. Please complete the following demographic questions.")),
                        br(),
                        br(),
                        textInput(demo.q1, "Please enter the name of your research study:",
                                  width = NULL, placeholder = "Study name"), br(),
                        textInput(demo.q2, "Study ID:",
                                  width = NULL, placeholder = "Study ID #"), br(),
                        br(),
                        textInput(demo.q3, "Please enter the name of the affiliated institution or business:",
                                  width = NULL, placeholder = "Affiliation name"), br(),
                        radioGroupButtons(
                          inputId = demo.q4, 
                          label = "Race", 
                          choices = c("Hispanic or Latino", "NOT Hispanic or Latino", "Unknown / Not Reported"),
                          justified = FALSE, status = btn_status,
                          checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                          selected = character(0)), br(),
                        radioGroupButtons(
                          inputId = demo.q5, 
                          label = "Ethnicity", 
                          choices = c("American Indian/Alaska Native",
                                      "Asian",
                                      "Native Hawaiian or Other Pacific Islander",
                                      "Black or African American",
                                      "White",
                                      "More Than One Race",
                                      "Unknown / Not Reported"),
                          justified = FALSE, status = btn_status,
                          checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                          selected = character(0),
                          direction = "vertical"), br(),
                        radioGroupButtons(
                          inputId = demo.q6, 
                          label = "Marital Status", 
                          choices = c("Single",
                                      "Married",
                                      "Divorced/Separated",
                                      "Partnered",
                                      "Widowed",
                                      "Independent"),
                          justified = FALSE, status = btn_status,
                          checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                          selected = character(0),
                          direction = "vertical"),
                        br(), br(),
                        tags$script(" $(document).ready(function () {
                                       $('#demo_next').on('click', function (e) {
                                        window.scrollTo(0, 0)
                                             });
                              
                                             });"),
                        actionBttn(
                          inputId = "demo_next",
                          label = "Next", 
                          style = "material-flat",
                          color = "danger"),
                        #textOutput('success_msg'),
                        br(), br(), br(), br()
                          
                        )))),
## ACTIVITY PREFERENCES ===================================================================                      
                    tabPanel("Activity Preferences", value = "activity_preferences",
                              br(),
                             fluidPage( 
                               fluidRow(column(12, align="center",
                                 p(style="text-align: left;", strong("Please read each of the following statements and then use the response scale below to indicate whether you agree or disagree with it. There are no right or wrong answers. Work quickly and mark the answer that best describes what you believe and how you feel. Make sure that you respond to all the questions.")),
                                 br(),
                                 br(),
                                 radioGroupButtons(
                                   inputId = pref.q1, 
                                   label = "Feeling tired during exercise is my signal to slow down or stop.", 
                                   choiceNames = pref.choices,
                                   choiceValues = c(1, 2, 3, 4, 5),
                                   justified = FALSE, status = btn_status,
                                   checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                   selected = character(0)),
                                 br(),
                                 radioGroupButtons(
                                   inputId = pref.q2, 
                                   label = "I would rather work out at low intensity levels for a long duration than at high-intensity levels for a short duration.", 
                                   choiceNames = pref.choices,
                                   choiceValues = c(1, 2, 3, 4, 5),
                                   justified = FALSE, status = btn_status,
                                   checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                   selected = character(0)),
                                 br(),
                                 radioGroupButtons(
                                   inputId = pref.q3, 
                                   label = "During exercise, if my muscles begin to burn excessively or if I find myself breathing very hard, it is time for me to ease off.", 
                                   choiceNames = pref.choices,
                                   choiceValues = c(1, 2, 3, 4, 5),
                                   justified = FALSE, status = btn_status,
                                   checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                   selected = character(0)),
                                 br(),
                                 radioGroupButtons(
                                   inputId = pref.q4, 
                                   label = "I’d rather go slow during my workout, even if that means taking more time.", 
                                   choiceNames = pref.choices,
                                   choiceValues = c(1, 2, 3, 4, 5),
                                   justified = FALSE, status = btn_status,
                                   checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                   selected = character(0)),
                                 br(),
                                 radioGroupButtons(
                                   inputId = pref.q8, 
                                   label = "When I exercise, I usually prefer a slow, steady pace.", 
                                   choiceNames = pref.choices,
                                   choiceValues = c(1, 2, 3, 4, 5),
                                   justified = FALSE, status = btn_status,
                                   checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                   selected = character(0)),
                                 br(),
                                 radioGroupButtons(
                                   inputId = pref.q9, 
                                   label = "I’d rather slow down or stop when a workout starts to get too tough.", 
                                   choiceNames = pref.choices,
                                   choiceValues = c(1, 2, 3, 4, 5),
                                   justified = FALSE, status = btn_status,
                                   checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                   selected = character(0)),
                                 br(),
                                 radioGroupButtons(
                                   inputId = pref.q12, 
                                   label = "While exercising, I prefer activities that are slow-paced and do not require much exertion.", 
                                   choiceNames = pref.choices,
                                   choiceValues = c(1, 2, 3, 4, 5),
                                   justified = FALSE, status = btn_status,
                                   checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                   selected = character(0)),
                                 br(),
                                 radioGroupButtons(
                                   inputId = pref.q13, 
                                   label = "When my muscles start burning during exercise, I usually ease off some.", 
                                   choiceNames = pref.choices,
                                   choiceValues = c(1, 2, 3, 4, 5),
                                   justified = FALSE, status = btn_status,
                                   checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                   selected = character(0)),
                                 br(),
                                 radioGroupButtons(
                                   inputId = pref.q14, 
                                   label = "The faster and harder the workout, the more pleasant I feel.", 
                                   choiceNames = pref.choices,
                                   choiceValues = c(1, 2, 3, 4, 5),
                                   justified = FALSE, status = btn_status,
                                   checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                   selected = character(0)),
                                 br(),
                                 radioGroupButtons(
                                   inputId = pref.q15, 
                                   label = "I always push through muscle soreness and fatigue when working out.", 
                                   choiceNames = pref.choices,
                                   choiceValues = c(1, 2, 3, 4, 5),
                                   justified = FALSE, status = btn_status,
                                   checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                   selected = character(0)),
                                 br(),
                                 radioGroupButtons(
                                   inputId = social.q1,
                                   label = "Which is more appealing to you? Exercising…", 
                                   choiceNames = c("A. In a group with an exercise leader (expert).",
                                                   "B. With people who are somewhat familiar (e.g., neighbors, friends, relatives, or coworkers).",
                                                   "C. On your own, with some instruction.",
                                                   "D. On your own, without instruction."),
                                   choiceValues = c(1, 2, 3, 4),
                                   justified = FALSE, status = btn_status,
                                   checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                   selected = character(0),
                                   direction = "vertical"),
                                 br(), br(),
                                 tags$script(" $(document).ready(function () {
                                                 $('#pref_next').on('click', function (e) {
                                                  window.scrollTo(0, 0)
                                                       });
                                        
                                                       });"),
                                 actionBttn(
                                   inputId = "pref_next",
                                   label = "Next", 
                                   style = "material-flat",
                                   color = "danger"),
                                 #textOutput('success_msg'),
                                 br(), br(), br(), br()
                                 )))),
## COGNITIVE ===================================================================
                    tabPanel("Section 1", value = "cognitive", br(),
                       fluidPage(
                         fluidRow(column(12, align="center",
                              br(),
                              conditionalPanel(condition = "(input.cog_next >= 1)",
                                               # & (input.ucla.7 == 'NULL'
                                               # || input.ucla.8  == 'NULL')
                                               
                                               textOutput('error_msg'), br()),
                              
                              # On a scale from 1 to 7, how would you rate your memory in terms of the kinds of problems you have?
                              radioGroupButtons(
                                inputId = cog.q1, 
                                label = "On a scale from 1 to 7, how would you rate your memory in terms of the kinds of problems you have?:", 
                                choiceNames = c("1, No Problems",
                                                "2", "3", "4, Some Problems",
                                                "5", "6", "7, Major Problems"),
                                choiceValues = c(1, 2, 3, 4, 5, 6, 7),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0),
                                direction = "vertical"),
                              br(),
                              #HTML("<b>For the next 5 questions, please indicate if each situation or feeling described CURRENTLY pertains to you. Select the response that most closely matches your own, remembering that there are no right or wrong answers.<b>"),
                              tags$b("For the next 5 questions, please indicate if each situation or feeling described CURRENTLY pertains to you. Select the response that most closely matches your own, remembering that there are no right or wrong answers."), 
                                 #style="text-align:center"),
                              br(), br(),
                              #Are you basically satisfied?
                              radioGroupButtons(
                                inputId = cog.q2, 
                                label = "Are you basically satisfied?:", 
                                choiceNames = c("Yes", "No"),
                                choiceValues = c(1, 0),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              #Do you get bored often?
                              radioGroupButtons(
                                inputId = cog.q3, 
                                label = "Do you get bored often?:", 
                                choiceNames = c("Yes", "No"),
                                choiceValues = c(1, 0),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              #Do you often feel helpless?
                              radioGroupButtons(
                                inputId = cog.q4, 
                                label = "Do you often feel helpless?", 
                                choiceNames = c("Yes", "No"),
                                choiceValues = c(1, 0),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              #Do you prefer to stay at home, rather than going out and doing new things?
                              radioGroupButtons(
                                inputId = cog.q5, 
                                label = "Do you prefer to stay at home, rather than going out and doing new things?", 
                                choiceNames = c("Yes", "No"),
                                choiceValues = c(1, 0),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              #Do you feel worthless the way you are now?
                              radioGroupButtons(
                                inputId = cog.q6, 
                                label = "Do you feel worthless the way you are now?", 
                                choiceNames = c("Yes", "No"),
                                choiceValues = c(1, 0),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              
                              tags$b("For the next 8 questions, please indicate how often you feel the way each of the statements below is descriptive of you. There are no right or wrong answers."),
                              br(), br(),
                              # 1 = Never, 2 = Rarely, 3 = Sometimes, 4 = Always
                              # I lack companionship.
                              radioGroupButtons(
                                inputId = cog.q7, 
                                label = "I lack companionship:", 
                                choiceNames = c("Never", "Rarely", "Sometimes", "Always"),
                                choiceValues = c(1, 2, 3, 4),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              #There is no one to turn to.
                              radioGroupButtons(
                                inputId = cog.q8, 
                                label = "There is no one to turn to:", 
                                choiceNames = c("Never", "Rarely", "Sometimes", "Always"),
                                choiceValues = c(1, 2, 3, 4),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              #I am an outgoing person.
                              radioGroupButtons(
                                inputId = cog.q9, 
                                label = "I am an outgoing person:", 
                                choiceNames = c("Never", "Rarely", "Sometimes", "Always"),
                                choiceValues = c(1, 2, 3, 4),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              #I feel left out.
                              radioGroupButtons(
                                inputId = cog.q10, 
                                label = "I feel left out:", 
                                choiceNames = c("Never", "Rarely", "Sometimes", "Always"),
                                choiceValues = c(1, 2, 3, 4),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              #I feel isolation from others.
                              radioGroupButtons(
                                inputId = cog.q11, 
                                label = "I feel isolation from others:", 
                                choiceNames = c("Never", "Rarely", "Sometimes", "Always"),
                                choiceValues = c(1, 2, 3, 4),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              # I can find companionship when I want it.
                              radioGroupButtons(
                                inputId = cog.q12, 
                                label = "I can find companionship when I want it:", 
                                choiceNames = c("Never", "Rarely", "Sometimes", "Always"),
                                choiceValues = c(1, 2, 3, 4),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              #I am unhappy being so withdrawn.
                              radioGroupButtons(
                                inputId = cog.q13, 
                                label = "I am unhappy being so withdrawn:", 
                                choiceNames = c("Never", "Rarely", "Sometimes", "Always"),
                                choiceValues = c(1, 2, 3, 4),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              #People are around me but not with me.
                              radioGroupButtons(
                                inputId = cog.q14, 
                                label = "People are around me but not with me:", 
                                choiceNames = c("Never", "Rarely", "Sometimes", "Always"),
                                choiceValues = c(1, 2, 3, 4),
                                justified = FALSE, status = btn_status,
                                checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                selected = character(0)),
                              br(), br(),
                              

                              # need to add conditional logic here
                              # to prevent scrolling up when
                              # missing inputs
                              
                              conditionalPanel(
                                condition = "input.cog.q14 > 0",
                                h3(textOutput('cog.q14.value'))),
                              
                              

                                tags$script(" $(document).ready(function () {
                                                 $('#cog_next').on('click', function (e) {
                                                  window.scrollTo(0, 0)});
                                                       });"),

                              
                              actionBttn(
                                inputId = "cog_next",
                                label = "Next", 
                                style = "material-flat",
                                color = "danger"),
                              #textOutput('success_msg'),

                              br(), br(), br(), br()
                              
                              
                              )))),
 ## PHYSICAL ===================================================================                   
                    tabPanel("Section 2", value = "physical", br(),
                        fluidPage(
                          fluidRow(column(12, align="center",
                               br(),
                               radioGroupButtons(
                                 inputId = phys.q1, 
                                 label = "Biological Sex at Birth :", 
                                 choiceNames = c("Male", "Female"),
                                 choiceValues = c(1, 0),
                                 justified = FALSE, status = btn_status,
                                 checkIcon = list(yes = icon("ok", lib = "glyphicon")),
                                 selected = character(0)),
                               br(),
                               
                               numericInput(
                                 inputId = phys.q2, 
                                 label = "Your Age :",
                                 value = 35,
                                 min = 18,
                                 max = 100,
                                 step = 1),
                              br(),
                              
                              numericInput(
                                inputId = phys.q3, 
                                label = "Your Weight (lbs) :",
                                value = 155,
                                min = 80,
                                max = 400,
                                step = 1),
                              br(),
                              
                              numericInput(
                                inputId = phys.q4, 
                                label = "Your Height (inches) :",
                                value = 56,
                                min = 45,
                                max = 85,
                                step = 1),
                              br(),
                              
                              numericInput(
                                inputId = phys.q5, 
                                label = "Your Resting Heart Rate (beats per min) :",
                                value = 60,
                                min = 35,
                                max = 100,
                                step = 1),
                              br(),
                              # tags$video(id="rhrTimer", type = "video/mp4", src = "www/rhrTimer.mp4", controls = "controls"),
                              HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/0yZcDeVsj_Y" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'),
                              br(),br(),
                              
                              HTML("<b>Choose one activity category that best describes your usual pattern of daily physical activities, including activities related to house and family care, transportation, occupation, exercise and wellness, and leisure or recreational purposes:</b>"),
                              br(),br(),
                              "Level 1: Inactive or little activity other than usual daily activities.",
                              br(),br(),
                              "Level 2: Regularly (>= 5 days/week) participate in physical activities requiring low levels of exertion that result in slight increases in breathing and heart rate for at least 10 minutes at a time.",
                              br(),br(),
                              "Level 3: Participate in aerobic exercises such as brisk walking, jogging or running, cycling, swimming, or vigorous sports at a comfortable pace or other activities requiring similar levels of exertion for 20 to 60 minutes per week.",
                              br(),br(),
                              "Level 4: Participate in aerobic exercises such as brisk walking, jogging or running at a comfortable pace, or other activities requiring similar levels of exertion for 1 to 3 hours per week.",
                              br(),br(),
                              "Level 5: Participate in aerobic exercises such as brisk walking, jogging or running at a comfortable pace, or other activities requiring similar levels of exertion for over 3 hours per week.",
                              radioGroupButtons(
                                inputId = phys.q6, label = "", 
                                choiceNames = c("Level 1",
                                            "Level 2",
                                            "Level 3",
                                            "Level 4",
                                            "Level 5"),
                                choiceValues = c(1, 2, 3, 4, 5),
                                justified = FALSE, status = btn_status,
                                selected = character(0),
                                checkIcon = list(yes = icon("ok", lib = "glyphicon"))),
                              br(),
                              "Without trying the test, please rate how confident are you that could complete the Single Leg Stance Test (by raising your right leg) for 60 seconds.",
                              br(), br(),
                              "The Single Leg Stance Test is a measure of balance. The test begins by standing with legs shoulder-width apart. While maintaining balance, the right foot is raised off the ground by bending the knee to a 90-degree angle. The goal of the Single Leg Stance Test is to see how long you can balance on one leg (as shown in the image below) without letting your raised leg touch the ground and without hopping or skipping.",
                              br(), br(),
                              # slst.jpg
                              tags$img(src = "slst.jpg", width = "300px", height = "300px"),
                              br(),
                              sliderInput(inputId = phys.q7, 
                                          label = "Enter your answer as a representation of your confidence from 100 (very confident) to 0 (not confident at all).",
                                          value = 0, min = 0, max = 100),
                              br(), br(), br(),
                              tags$script(" $(document).ready(function () {
                                                 $('#phys_next').on('click', function (e) {
                                                  window.scrollTo(0, 0)
                                                       });
                                        
                                                       });"),
                              actionBttn(
                                inputId = "phys_next",
                                label = "Next", 
                                style = "material-flat",
                                color = "danger"),
                              br(), br(), br(), br()
                              
                              
                             )))),

## PSYCHOLOGICAL ===============================================================                    
                    tabPanel("Section 3", value = "psychological", br(),
                             fluidPage(
                               fluidRow(column(12, align="center",
                                   br(),            
                                   tags$b("Please indicate the degree to which you are confident that you could exercise in the event that any of the following circumstances were to occur by entering the appropriate % from 0 to 100. Select the response that most closely matches your own, remembering that there are no right or wrong answers."),            
                                   br(), br(),
                                   # The weather was very bad (hot, humid, rainy, cold).
                                   sliderTextInput(
                                     inputId = psyc.q1, 
                                     label = "The weather was very bad (hot, humid, rainy, cold):", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.con,
                                     width = 600),
                                   br(),
                                   # I was on vacation.
                                   sliderTextInput(
                                     inputId = psyc.q2, 
                                     label = "I was on vacation:", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.con,
                                     width = 600),
                                   br(),
                                   # An instructor does not offer me any encouragement.
                                   sliderTextInput(
                                     inputId = psyc.q3, 
                                     label = "An instructor does not offer me any encouragement:", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.con,
                                     width = 600),
                                   br(),
                                   # I was under personal stress of some kind.
                                   sliderTextInput(
                                     inputId = psyc.q4, 
                                     label = "I was under personal stress of some kind:", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.con,
                                     width = 600),
                                   br(), br(),
                                   
                                   tags$b("For each of the following questions you are asked to make a rating on a scale of numbers. Answer each question by SELECTING THE APPROPRIATE NUMBER."),
                                   br(), br(),
                                   # Someone who exercises regularly
                                   sliderTextInput(
                                     inputId = psyc.q5, 
                                     label = "Someone who exercises regularly:", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.des,
                                     width = 600),
                                   br(),
                                   # How certain are you of this self-description?
                                   sliderTextInput(
                                     inputId = psyc.q6, 
                                     label = "How certain are you of this self-description?", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.cer,
                                     width = 600),
                                   br(),
                                   # How important is being someone who exercises regularly to the image you have of yourself, regardless of whether or not the trait describes you?
                                   sliderTextInput(
                                     inputId = psyc.q7, 
                                     label = "How important is being someone who exercises regularly to the image you have of yourself, regardless of whether or not the trait describes you?", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.imp,
                                     width = 600),
                                   br(),
                                   # Someone who keeps in shape
                                   sliderTextInput(
                                     inputId = psyc.q8, 
                                     label = "Someone who keeps in shape:", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.des,
                                     width = 600),
                                   br(),
                                   # How certain are you of this self-description?
                                   sliderTextInput(
                                     inputId = psyc.q9, 
                                     label = "How certain are you of this self-description?", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.cer,
                                     width = 600),
                                   br(),
                                   # How important is being someone who keeps in shape regularly to the image you have of yourself, regardless of whether or not the trait describes you?
                                   sliderTextInput(
                                     inputId = psyc.q10, 
                                     label = "How important is being someone who keeps in shape regularly to the image you have of yourself, regardless of whether or not the trait describes you?:", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.imp,
                                     width = 600),
                                   br(),
                                   # Physically active
                                   sliderTextInput(
                                     inputId = psyc.q11, 
                                     label = "Physically active:", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.des,
                                     width = 600),
                                   br(),
                                   # How certain are you of this self-description?
                                   sliderTextInput(
                                     inputId = psyc.q12, 
                                     label = "How certain are you of this self-description?", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.cer,
                                     width = 600),
                                   br(),
                                   # How important is being physically active to the image you have of yourself, regardless of whether or not the trait describes you?
                                   sliderTextInput(
                                     inputId = psyc.q13, 
                                     label = "How important is being physically active to the image you have of yourself, regardless of whether or not the trait describes you?", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.imp,
                                     width = 600),
                                   br(),
                                   # I am someone who will always be an exerciser
                                   sliderTextInput(
                                     inputId = psyc.q14, 
                                     label = "I am someone who will always be an exerciser:", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.des,
                                     width = 600),
                                   br(),
                                   # How certain are you of this self-description?
                                   sliderTextInput(
                                     inputId = psyc.q15, 
                                     label = "How certain are you of this self-description?", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.cer,
                                     width = 600),
                                   br(),
                                   # How important is always being an exerciser to the image you have of yourself, regardless of whether or not the trait describes you?
                                   sliderTextInput(
                                     inputId = psyc.q16, 
                                     label = "How important is always being an exerciser to the image you have of yourself, regardless of whether or not the trait describes you?", 
                                     grid = TRUE, 
                                     force_edges = TRUE,
                                     selected = NULL,
                                     choices = psyc.choices.imp,
                                     width = 600),
                                   br(), br(),

                                   tags$head(tags$script(src = "message-handler.js")),
                                   actionBttn(
                                     inputId = "submit",
                                     label = "See Results", 
                                     style = "material-flat",
                                     color = "danger"),
                                   br(), br(), br(), br()
                               )))),

      
      ## RESULTS ----
                    tabPanel("Results", value = "results",
                             br(),
                             fluidPage( 
                               fluidRow(column(12, align="left",
                             verbatimTextOutput('status'), # Status/Output Text Box
                             tags$label(h3('Results:')), 
                             br(),
                             tags$label((h5('Total Score:'))),
                             #"Total Score:",
                             textOutput('score'),
                             tags$label((h5('Flags:'))),
                             #"Flags:",
                             textOutput('cogFlags'),
                             textOutput('physFlags'),
                             textOutput('psycFlags'),
                             br(),
                             br(),
                             #textOutput('onehundred'),
                             #textOutput('bmi'),
                             textOutput('actPref'),
                             br(),
                             tableOutput('activities'),
                             tableOutput('tabledata')) #this was yielding 9 rows per submission
                             )))
                            

                ))),
     # Instructions ----
     tabPanel("Instructions",
              fluidPage(
                br(),
                tags$b("Please start on the Questions page, with Demographics and move to the next tabs one by one.")
                  )), 
    # About ----
     tabPanel("About",
              fluidPage(
                br(),
                tags$b("This is a project by the ETC Lab at the University of Illinois Urbana-Champaign.")
              ))
    )


# server.R
server <- function(input, output, session) {
  
  # Error message (All sections)
  output$error_msg <- renderText({"Please complete all questions"})
  # for testing purposes #output$cog.q14.value <- renderText({ input$ucla.8 })

  # Navigation----
  # click from demo to act pref
  observeEvent(input$demo_next, {
    
    # Input Validation
    iv <- InputValidator$new()
    for (i in demo.data) {
      iv$add_rule(i, sv_required())
    }
    iv$enable()

    for (i in demo.data) {
      shiny::req(input[[i]])
    }
    
    updateTabsetPanel(session, inputId = "tab_questions",
                      selected = "activity_preferences")
    output$success_msg <- renderText({"Success"})
  })
  # click from act pref to section 1 (cognitive)
  observeEvent(input$pref_next, {
    
    # Input Validation
    iv <- InputValidator$new()
    for (i in pref.data) {
      iv$add_rule(i, sv_required())
    }
    iv$enable()

    for (i in pref.data) {
      shiny::req(input[[i]])
    }
    updateTabsetPanel(session, inputId = "tab_questions",
                      selected = "cognitive")
    output$success_msg <- renderText({"Success"})
  })
  # click from section 1 (cognitive) to section 2 (physical)
  observeEvent(input$cog_next, {

    ## Input Validation
    iv <- InputValidator$new()
    for (i in cog.data) {
      iv$add_rule(i, sv_required())
    }
    iv$enable()
    
    for (i in cog.data) {
      shiny::req(input[[i]])
    }
    
    updateTabsetPanel(session, inputId = "tab_questions",
                      selected = "physical")
    output$success_msg <- renderText({"Success"})
    
  })
  # click from section 2 (physical) to section 3 (psych)
  observeEvent(input$phys_next, {
    ## Input Validation
    iv <- InputValidator$new()
    for (i in phys.data) {
      iv$add_rule(i, sv_required())
    }
    iv$enable()
    
    for (i in phys.data) {
      shiny::req(input[[i]])
    }
    updateTabsetPanel(session, inputId = "tab_questions",
                      selected = "psychological")
    output$success_msg <- renderText({"Success"})
  })
  
  # Submit data and move to results page----
  observeEvent(input$submit, {
    ## Psyc Input Validation
    iv <- InputValidator$new()
    for (i in psyc.data) {
      iv$add_rule(i, sv_required())
    }
    iv$enable()
    
    for (i in psyc.data) {
      shiny::req(input[[i]])
    }
    
    # pop-up message
    #session$sendCustomMessage(type = 'testmessage',
    #                         message = 'Thank you for participating.')
    # Define inputs to save
    ## Array of all question names -----
    all.data <- c(demo.data, pref.data, cog.data, phys.data, psyc.data)
    inputs_to_save <- all.data # defined in question names array
    # Declare inputs
    inputs <- NULL
    # Append all inputs before saving to folder; https://stackoverflow.com/questions/40029804/r-shiny-app-that-saves-inputs-for-later-use
    for(input.i in inputs_to_save){
      inputs <- append(inputs, input[[input.i]])
    }
    # Inputs data.frame
    data <- data.frame(rbind(c(as.character(Sys.time()), inputs))) 
    data <- cbind(data, calcs())
    # Save Inputs w/ SAVE DATA FUNCTION ----
    sheetName = "Log"
    saveData(data,sheetName)
    #sheet_append(sheet_id, data)
    
    
    
    
    updateTabsetPanel(session, inputId = "tab_questions",
                      selected = "results")
    output$success_msg <- renderText({"Success"})
  })
  
  # Read activity data ----
  activities_sheet <- "Activities"
  activities <- read_sheet(sheet_id, sheet = activities_sheet)
  activities <- select(activities, -Code) # drop first column
  activities <- activities[sample(1:nrow(activities)), ] # shuffle data
  
  # Calculations/Process inputs----
  
  calcs <- eventReactive(input$submit,{
   
    # Activity Preferences
    pretie.tolerance <- (6-as.numeric(input$pretie.1)
                        + (6-as.numeric(input$pretie.3))
                        + (6-as.numeric(input$pretie.9))
                        + (6-as.numeric(input$pretie.13))
                        + (as.numeric(input$pretie.15)))
    
    #pretie.tolerance.num <- case_when(pretie.tolerance >= 17.5 & pretie.tolerance <= 11 ~ 1, pretie.tolerance < 8 ~ 0)
    
    pretie.preference <- (6-as.numeric(input$pretie.2)
                        + (6-as.numeric(input$pretie.4))
                        + (6-as.numeric(input$pretie.8))
                        + (6-as.numeric(input$pretie.12))
                        + (as.numeric(input$pretie.14)))
    
    pretie.total <- pretie.tolerance + pretie.preference
    
    # Physical
    bmi<-(input$weight/2.205)/((input$height*2.54/100)^2)#ht in inches, wt in lbs
    crf<- 3.5*((as.numeric(input$gender)*2.77) - (input$age*0.10) - (bmi*0.17) - (input$rHR*0.03) + (as.numeric(input$SRPA) + 18.07))
    crf.flag <- case_when(crf < 28.5 ~ 1, TRUE ~ 0)
    sls <- input$`single leg`
    sls.flag <- case_when(sls <= 60 ~ 1, TRUE ~ 0)
    phys.flags <- crf.flag + sls.flag
    SRPA <- as.numeric(input$SRPA) -1 # 1to5 scale becomes 0to4
    PAG.flag <- case_when(SRPA == 0 ~ 1, TRUE ~ 0)
    
    # Cognitive
    fof <- input$fof.1
    fof.flag <- case_when(fof >= 6 ~ 1, TRUE ~ 0)
    gds <- (1-as.numeric(input$gds.1)) + as.numeric(input$gds.2) + as.numeric(input$gds.3) + as.numeric(input$gds.4) + as.numeric(input$gds.5)
    gds.flag <- case_when(gds >= 1 ~ 1, TRUE ~ 0)
    ucla <- (5-as.numeric(input$ucla.1)) + (5-as.numeric(input$ucla.2)) + as.numeric(input$ucla.3) + (5-as.numeric(input$ucla.4)) + (5-as.numeric(input$ucla.5)) + as.numeric(input$ucla.6) + (5-as.numeric(input$ucla.7)) + (5-as.numeric(input$ucla.8))
    ucla.flag <- case_when(ucla < 19.5 ~ 1, TRUE ~ 0)
    cog.flags <- fof.flag + gds.flag + ucla.flag
    
    # Psychological ---
    # Declare inputs
    psyc.new <- NULL
    # Append all psyc inputs
    # for(input.i in psyc.data){
    #   psyc.new <- append(psyc.new, parse_number(input[[input.i]])) # keep integers, strip characters
    # }
    # average of barse answers
    #barse <- mean(psyc.new[barse.qs])
    barse.1 <- parse_number(input$barse.1)
    barse.3 <- parse_number(input$barse.3)
    barse.12 <- parse_number(input$barse.12)
    barse.13 <- parse_number(input$barse.13)
    
    barse <- (barse.1 + barse.3 + barse.12 + barse.13) /4
    barse.flag <- case_when(barse <= 60 ~ 1, TRUE ~ 0)
    #essq
    #essq <- psyc.new[5:13] # CAUSING REPLICATION PROBLEMS
    #essq.mean <- mean(psyc.new[essq.qs])
    #essq.mean <- mean(essq)
    essq.1 <- parse_number(input$essq.1)
    essq.2 <- parse_number(input$essq.2)
    essq.3 <- parse_number(input$essq.3)
    essq.4 <- parse_number(input$essq.4)
    essq.5 <- parse_number(input$essq.5)
    essq.6 <- parse_number(input$essq.6)
    essq.7 <- parse_number(input$essq.7)
    essq.8 <- parse_number(input$essq.8)
    essq.9 <- parse_number(input$essq.9)
    essq.10 <- parse_number(input$essq.10)
    essq.11 <- parse_number(input$essq.11)
    essq.12 <- parse_number(input$essq.12)
    
    essq.mean <- (essq.1
                  + essq.2
                  + essq.3
                  + essq.4
                  + essq.5
                  + essq.6
                  + essq.7
                  + essq.8
                  + essq.9) / 9
    
    essq.flag <- case_when(essq.mean <= 7.4 ~ 1, TRUE ~ 0)

    ## self-description subscale
    ESSQ_sdc <- (essq.1 + essq.4 + essq.7)/3 # removed q10 from calc
    ## importance subscale
    ESSQ_ic <- (essq.3 + essq.6 + essq.9)/3 # removed q12 from calc
    ## certainty subscale
    ESSQ_cc <- (essq.2 + essq.5 + essq.8)/3 # removed q11 from calc

    # Create variables for schematic or nonschematic eaters
    # Self-desc
    ESSQ1.bin <- case_when(essq.1 >= 8 & essq.1 <= 11 ~ 1,
                           essq.1 < 8 ~ 0)
    ESSQ4.bin <- case_when(essq.4 >= 8 & essq.4 <= 11 ~ 1,
                                 essq.4 < 8 ~ 0)
    ESSQ7.bin <- case_when(essq.7 >= 8 & essq.7 <= 11 ~ 1,
                                 essq.7 < 8 ~ 0)
    ESSQ.desc.sum <- ESSQ1.bin + ESSQ4.bin + ESSQ7.bin
    # Importance
    ESSQ3.bin <- case_when(essq.3 >= 8 & essq.3 <= 11 ~ 1,
                                 essq.3 < 8 ~ 0)
    ESSQ6.bin <- case_when(essq.6 >= 8 & essq.6 <= 11 ~ 1,
                                 essq.6 < 8 ~ 0)
    ESSQ9.bin <- case_when(essq.9 >= 8 & essq.9 <= 11 ~ 1,
                                 essq.9 < 8 ~ 0)
    ESSQ.imp.sum <- ESSQ3.bin + ESSQ6.bin + ESSQ9.bin

    # Schematic = 1, Nonschematic = 0
    ESSQ.schematic <- ifelse(ESSQ.desc.sum >= 2 & ESSQ.imp.sum >= 2, 1, 0)
    
    psyc.flags <- barse.flag + essq.flag

    score <- (7 - (crf.flag + sls.flag + fof.flag + gds.flag 
                    + ucla.flag + barse.flag + essq.flag)) * 100
    # All
    # data.frame(PRETIE.Toler = pretie.tolerance,
    #            PRETIE.Pref = pretie.preference,
    #            PRETIE.Total = pretie.total,
    #            bmi = bmi,
    #            CRF = crf,
    #            CRF.Flag = crf.flag,
    #            SLS = sls,
    #            SLS.Flag = sls.flag,
    #            PhysTotal = phys.flags,
    #            FOF = fof,
    #            FOF.Flag = fof.flag,
    #            GDS = gds,
    #            GDS.Flag = gds.flag,
    #            UCLA = ucla,
    #            UCLA.Flag = ucla.flag,
    #            CogTotal = cog.flags,
    #            BARSE = barse,
    #            BARSE.Flag = barse.flag,
    #            ESSQ = essq.mean,
    #            ESSQ.Flag = essq.flag,
    #            score = score)
    
    data.frame(PRETIE.Toler = pretie.tolerance,
               PRETIE.Pref = pretie.preference,
               PRETIE.Total = pretie.total,
               UCLA = ucla,
               UCLA.Flag = ucla.flag,
               PhysTotal = phys.flags,
               PsycTotal = psyc.flags,
               CogTotal = cog.flags,
               score = score,
               #---
               StudyID = input$study_id,
               age = input$age,
               gender = input$gender,
               BMIm0 = bmi,
               FOFfail = fof.flag,
               GDSfail = gds.flag,
               SELFfail = essq.flag,
               BARSfail = barse.flag,
               SLSfail = sls.flag,
               CRFfail = crf.flag,
               PAG75fail = PAG.flag,
               PASStotal = score / 100,
               fof1m0 = fof,
               GDStot = gds,
               CRFm0 = crf,
               SRPA = SRPA, 
               RtSEm0 = sls,
               sbe1m0 = barse.1,
               sbe3m0 = barse.3,
               sbe12m0 = barse.12,
               sbe13m0 = barse.13,
               bars4m0 = barse,
               ESSQ1 = essq.1,
               ESSQ2 = essq.2,
               ESSQ3 = essq.3,
               ESSQ4 = essq.4,
               ESSQ5 = essq.5,
               ESSQ6 = essq.6,
               ESSQ7 = essq.7,
               ESSQ8 = essq.8,
               ESSQ9 = essq.9,
               ESSQ10 = essq.10,
               ESSQ11 = essq.11,
               ESSQ12 = essq.12,
               ESSQ_sdc = ESSQ_sdc,
               ESSQ_ic = ESSQ_ic,
               ESSQ_cc = ESSQ_cc,
               ESSQ1.bin = ESSQ1.bin,
               ESSQ4.bin = ESSQ4.bin,
               ESSQ7.bin = ESSQ7.bin,
               ESSQ.desc.sum = ESSQ.desc.sum,
               ESSQ3.bin = ESSQ3.bin,
               ESSQ6.bin = ESSQ6.bin,
               ESSQ9.bin = ESSQ9.bin,
               ESSQ.imp.sum = ESSQ.imp.sum,
               ESSQ.schematic = ESSQ.schematic)

    
    # data.frame(PRETIE.Toler = pretie.tolerance,
    #            PRETIE.Pref = pretie.preference,
    #            Score = score)
    

  })
  
  
  
  
  # Process Flags----
  # flagsPrint <- reactive({  
  #   return(paste0("BMI: ", calcs()$bmi, " CRF:", calcs()$crf ))
  # })
  

  onehundred <- reactive({
    print(100)
  })

  # bmi <- reactive({
  #   bmi<-(input$weight/2.205)/((input$height*2.54/100)^2)
  #   print(bmi)
  # })
  

  
  # OUTPUTS----
  # Status/Output Text Box
  output$status <- renderPrint({
    if (input$submit>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })

  output$onehundred <- renderText({
    if (input$submit>0) { 
    isolate(onehundred())
    }
  })
  
  output$bmi <- renderText({
    if (input$submit>0) { 
      isolate(as.numeric(calcs()$BMIm0)*100)
    }
  })
  
  # passfit score
  output$score <- renderText({
    isolate(calcs()$score)
  })
  
  # section flags
  output$cogFlags <- renderText({
    isolate(paste0("Cognitive Section Flags: ", calcs()$CogTotal))
  })
  output$physFlags <- renderText({
    isolate(paste0("Physical Section Flags: ", calcs()$PhysTotal))
  })
  output$psycFlags <- renderText({
    isolate(paste0("Psychological Section Flags: ", calcs()$PsycTotal))
  })
  
  # Calcs() table
  output$tabledata <- renderTable({
    if (input$submit>0) {
      isolate(calcs())
    }
  })
  
  output$actPref <- renderText({
    if (input$submit>0) {
      if (calcs()$PRETIE.Total/2 >= 17.5){
        return("Your recommended exercise intensity is >6.0 METS.")
      } else if (calcs()$PRETIE.Total/2 < 13.5){
        return("Your recommended exercise intensity is <3.0 METS.")
      } else {
        return("Your recommended exercise intensity is between 3.0-6.0 METS.")
      }
    }
  })

  # Calculate/Print Activities
  output$activities <- renderTable({
    if (input$submit>0) {
      if (calcs()$PRETIE.Total/2 >= 17.5){
        a <- dplyr::filter(activities, METS > 6.0)
        head(a)
      } else if (calcs()$PRETIE.Total/2 < 13.5){
        a <- dplyr::filter(activities, METS < 3.0)
        head(a)
      } else {
        a <- dplyr::filter(activities, METS <= 6.0 & METS >= 3.0)
        head(a)
      }
    }
  })
  

  # Prediction ----
  
  prediction <- reactive({
  
  ## Load Data
  passfit.data <- read_sheet("https://docs.google.com/spreadsheets/d/1k5SauO_DLgIRxhgynyyz4XlUfutLC8XtnMPMWJlnleU/edit#gid=940908051",
                          sheet = "Data", na = c("NA"), col_types = "c")

  # drop study_id and gender columns
  passfit.data <- select(passfit.data, c(-StudyID, -gender))
  # column types
  coltypes <- cols(
    #StudyID = "i",
    age = "i",
    #gender = "f",
    BMIm0 = "n",
    FOFfail = "f",
    GDSfail = "f",
    SELFfail = "f",
    BARSfail = "f",
    SLSfail = "f",
    CRFfail = "f",
    PAG75fail = "f",
    PASStotal = "i",
    fof1m0 = "i",
    GDStot = "i",
    CRFm0 = "n",
    SRPA = "f", #answer minus 1, to match old passfit data
    RtSEm0 = "n",
    sbe1m0 = "n",
    sbe3m0 = "n",
    sbe12m0 = "n",
    sbe13m0 = "n",
    bars4m0 = "n",
    ESSQ1 = "n",
    ESSQ2 = "n",
    ESSQ3 = "n",
    ESSQ4 = "n",
    ESSQ5 = "n",
    ESSQ6 = "n",
    ESSQ7 = "n",
    ESSQ8 = "n",
    ESSQ9 = "n",
    ESSQ10 = "n",
    ESSQ11 = "n",
    ESSQ12 = "n",
    ESSQ_sdc = "n",
    ESSQ_ic = "n",
    ESSQ_cc = "n",
    ESSQ1.bin = "f",
    ESSQ4.bin = "f",
    ESSQ7.bin = "f",
    ESSQ.desc.sum = "f",
    ESSQ3.bin = "f",
    ESSQ6.bin = "f",
    ESSQ9.bin = "f",
    ESSQ.imp.sum = "f",
    ESSQ.schematic = "f"
  )
  # convert column types
  passfit.data <- type_convert(passfit.data, col_types = coltypes)

  # labels as factor
  passfit.data$dropout <- as.factor(passfit.data$dropout)


  ## Train model

  library(randomForest)
  set.seed(233)
  train <- sample(1:nrow(passfit.data), nrow(passfit.data) * 0.75)
  passfit.train <- passfit.data[train, ]
  passfit.test <- passfit.data[-train, ]
  # remove rows w/ missing data
  passfit.train <- passfit.train %>% na.omit
  passfit.test <- passfit.test %>% na.omit
  # random forest ==
  # mtry = p/2
  rf.passfit <- randomForest(dropout ~ ., data = passfit.train, ntree = 500, mtry = 16 )
  ## Test model
  yhat.passfit <- predict(rf.passfit, newdata = passfit.test)
  # test error
  table(yhat.passfit, passfit.test$dropout) # confusion matrix
  # var importance
  varImpPlot(rf.passfit)

  
  # Predict w/ new data
  new_dat <- calcs() %>% select(-PRETIE.Toler,
                                -PRETIE.Pref,
                                -PRETIE.Total,
                                -UCLA,
                                -UCLA.Flag,
                                -PhysTotal,
                                -PhysTotal,
                                -CogTotal,
                                -score)
  
  prediction <- predict(rf.passfit, newdata = new_dat)
  print(prediction)
    
  })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
