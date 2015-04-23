library(kernlab)
library(lattice)
library(ggplot2)
library(caret)
library(randomForest)
library(stringr)
data(spam, package="kernlab")

shinyServer(function(input, output) {
        #cleartext <- eventReactive(input$clearButton, {""})
        #output$isSpam <- renderText({cleartext()})        
        #output$isSpam <- renderText({paste("Text is Spam")})
        set.seed(4321)
        
        inTrain <- createDataPartition(y=spam$type, p=0.7, list=FALSE)
        training <- spam[inTrain,]
        testing <- spam[-inTrain,]
        
        nzv <- nearZeroVar(training)
        trainingNZV <- training[,-nzv]
        testingNZV <- testing[,-nzv]
        
        RFmodFit <- randomForest(type ~. , data=trainingNZV, na.action = na.omit)
        RFpred <- predict(RFmodFit, testingNZV, type = "class")
        RFCM <- confusionMatrix(RFpred, testing$type)
        output$accuracy <- renderText({paste("NOTE: Model Accuracy is ", 
                                             trunc(RFCM$overall[1]*100), "%")})
        
        test_set_predictions <- reactive({
                your_count <- str_count(tolower(input$emailText), "your")
                you_count <- str_count(tolower(input$emailText), "you") - your_count
                hp_count <- str_count(tolower(input$emailText), "hp")
                charRoundbracket_count <- str_count(input$emailText, "\\(")
                charExclamation_count <- str_count(input$emailText, "!")
                charDollar_count <- str_count(input$emailText, "\\$")
                
                # Convert String to a vector
                inputStringAsVector <- unlist(strsplit(input$emailText, split=" "))
                # Remove words that don't contain capital letters
                inputStringAsVector <- inputStringAsVector[grepl("['A-Z]", inputStringAsVector)]
                
                uppercaseSearch <- "A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z"
                inputStringAsVector <- sapply(inputStringAsVector, function(y) str_count(y, uppercaseSearch))
                
                charAve_count <- 0
                charLong_count <- 0
                charTotal_count <- 0
                if(length(inputStringAsVector) > 0) {
                        charAve_count <- mean(inputStringAsVector) # Average length of word with all capital letters
                        charLong_count <- max(inputStringAsVector, na.rm = TRUE) # Longest word in all capital letters
                        charTotal_count <- sum(inputStringAsVector) # Total number of capital letters
                }
                userInputToPredict <- as.data.frame(rbind(c(you_count, your_count, hp_count, charRoundbracket_count,
                                                            charExclamation_count, charDollar_count, charAve_count,
                                                            charLong_count, charTotal_count)))
                names(userInputToPredict) <- head(names(trainingNZV), -1)
                test_set_predictions <- predict(RFmodFit, userInputToPredict, type = "class")
        })
        
        output$spamImage <- renderImage({
                if(test_set_predictions() == "spam") {
                        filename <- normalizePath(file.path('./images',
                                                            paste('spam', '.png', sep='')))
                        # Return a list containing the filename
                        list(src = filename,
                             width = 200,
                             height = 210)
                } else {
                        filename <- normalizePath(file.path('./images',
                                                            paste('ham', '.png', sep='')))
                        # Return a list containing the filename
                        list(src = filename,
                             width = 200,
                             height = 210)
                }
        }, deleteFile = FALSE)
        output$isSpam <- renderText({
                if(test_set_predictions() == "spam") {
                        paste("Text is Spam")
                } else {
                        paste("Text is NOT Spam")
                }
        })
})
