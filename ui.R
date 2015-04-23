shinyUI(
        pageWithSidebar(
        div(headerPanel("Email Campaign Spam Detector"), style="text-align:center; margin:10px"),
        sidebarPanel(
                br(),
                div(imageOutput("spamImage"), style="text-align:center; height:210px"),
                div(h3(textOutput("isSpam")), style="text-align:center"),
                div(textOutput("accuracy"), style="text-align:center; font-size:10px; font-weight:bold"),
                br(),
                p(paste("Out model looks for a combination of things on the ", 
                        "email including the amount of run-in capital letters ", 
                        "and the amount of the following letters and words:")),
                tags$ul(
                        tags$li("'your'"), 
                        tags$li("'you'"), 
                        tags$li("'hp'"),
                        tags$li("'$'"),
                        tags$li("'('"),
                        tags$li("'!'")
                ),
                p(paste("Other aspects are not considered since the dataset ",
                        "little to no influence from other words or characters ",
                        "(Near Zero Variance)."))
        ),
        mainPanel(
                br(),
                p(paste("One of marketers biggest challenges is knowing ",
                               "the effectiveness of an email campaign. One of ",
                               "the many issues they encounter is knowing if the ",
                               "emails sent on the campaign will end up on the ",
                               "recipient's spam folder to never be read.")),
                p(paste("The purpose of the text box below should help a ",
                               "marketer know if the email they are composing ",
                               "will automatically go to the spam folder or not. ",
                        "Type a message below and if the application beleives it ",
                        "is spam, it will change the icon on the left to SPAM, ",
                        "if the application does not think the message is spam, ",
                        "it will give you a green icon saying the message is not ",
                        "considered spam.")),
                tags$textarea(id="emailText", rows=10, cols=80, 
                              paste("DO YOU WANT TO EARN MORE MONEY$$$$$\n\r",
                                "You can earn over $10,000 a day from working from home!!!!\n\r",
                              "WHAT ARE YOU WAITING FOR? CALL US NOW!")),
                br(),
                #actionButton("clearButton", "Clear")
                p("To made this application work, we created a predictive ",
                        "model using the ",strong("kernlab spam")," (", 
                  a("http://www.inside-r.org/packages/cran/kernlab/docs/spam"), 
                  ") dataset. This dataset classifies 4,601 emails into either spam or non-spam.",
                  "In addition to this class label there are 57 variables ",
                  "indicating the frequency of certain words and characters in the e-mail."),
                p("In order to predict whether the text you type above can be ",
                  "considered spam or not, we identified the variables that have ",
                  "the most impact on spam emails and created a Random Forest ",
                  "model around it. We have tested the model and have found that ",
                  "has around 90% accuracy."),
                p("We then take the text you type above and pass it through the ",
                  "model to find out if the text can be considered spam or not.")
                )
        )
)
