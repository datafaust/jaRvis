library(shiny)
library(RCurl)
library(XML)

getGoogleURL <- function(search.term, domain = '.co.uk', quotes=TRUE) 
{
  search.term <- gsub(' ', '%20', search.term)
  if(quotes) search.term <- paste('%22', search.term, '%22', sep='') 
  getGoogleURL <- paste('http://www.google', domain, '/search?q=',
                        search.term, sep='')
}

getGoogleLinks <- function(google.url) {
  doc <- getURL(google.url, httpheader = c("User-Agent" = "R
                                           (2.10.0)"))
  html <- htmlTreeParse(doc, useInternalNodes = TRUE, error=function
                        (...){})
  nodes <- getNodeSet(html, "//div[@class='_o0d']")
  return(nodes)
}

shinyApp(
  options(browser = "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"),
  ui = fluidPage(
    singleton(tags$head(
      tags$script(src="//cdnjs.cloudflare.com/ajax/libs/annyang/1.4.0/annyang.min.js"),
      includeScript('init.js')
    )),
    fluidRow(
      column(4),
      column(6,
             h1("Awesome R Robot")
      )
    ),
    fluidRow(
      column(3),
      column(2,
             h3("My Question"),
             wellPanel(
               textOutput("question")
             )
      ),
      column(4,
             h3("Answer"),
             textOutput("answer")
      ),
      column(3)
    )
  ),
  
  
  server = function(input, output) {
    output$answer<-renderText({""})
    output$question<-renderText({""})
    observe({
      print("START ASK QUESTION")
      question<-input$albert
      print(question)
      answer<-""
      if(length(question)>0)
      {
        if(question=="when is my next appointment")
        {
          answer<-"Tomorrow at 3pm, in London Bridge."
        } else if(question=="show me something cool")
        {
          shell.exec("http://www.r-bloggers.com")
          answer<-""
        } else 
        {
          # It's not in our list, let's see if Google knows the answer
          search.term<-question
          quotes <- "FALSE"
          google.url <- getGoogleURL(search.term=search.term, quotes=quotes)
          #
          links <- getGoogleLinks(google.url)
          #
          if(length(links)>0)
          {
            for(i in 1:length(links))
            {
              if(i==1)
              {
                answer<-xmlValue(links[[1]])
              } 
              else
              {
                answer<-c(answer,xmlValue(links[[i]]))
              }
            }
          }
          
        }
      }
      output$question<-renderText({
        paste0(question,"?")
      })
      output$answer<-renderText({answer})
    })
  }
)