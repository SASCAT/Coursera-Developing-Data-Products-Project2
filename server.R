# Developing Data Products Shiny Example.
# January 2015
#
# SAScat
#
# Based on Shiny Gallery example.

library(shiny)
library(ggplot2)

# Load the data from the local CSV file.
ds <- read.csv("./ds.csv")

# Define categories and give them readable titles.
catage <- cut(ds$AGE, breaks=c(20, 60, 65, 70, 100))
levels(catage)[] <- c("Under 60", "60 to 65", "65 to 70 ", "Over 70")

catwt <- cut(ds$Weight, breaks=c(40, 65, 75, 85, 200))
levels(catwt)[] <- c("Under 65kg", "65 to 75", "75 to 85 ", "Over 85kg")

cattob <- cut(ds$TOBANPY, breaks=c(0,20,30,40,50,70,200))
levels(cattob)[] <- c("Under 20", "20 to 30", "30 to 40", "40 to 50", "50 to 70", "Over 70")

catbmi <- cut(ds$BMI, breaks=c(0,18.5, 25, 30, 60))
levels(catbmi)[] <- c('Under weight', 'Normal',  'Over weight', 'Obese')


# Define data frames for the different categories of data
baseline <- ds[,c(1,2,4,5,7:55)]
oneyear <- ds[,c(1,56:63)]
categs <- cbind(ds[,c(1,3,6)], catage, catwt, cattob, catbmi)

# Recombine into one dataset (for conveniance)
alld <- cbind(categs, baseline, oneyear)

shinyServer(function(input, output) {
  output$plot <- renderPlot({
   
    # Create a new DF with just the data columns needed.  
    # This is not specifically needed for this implementation, but will be 
    # used in the next version.
    tds <- data.frame(alld[,1])
    namtds <- c("ID")
    dt <- c(input$x, input$y, input$color, input$facet_row, input$facet_col)
    for (nm in dt){
      if (nm != "None" & nm != "."){
        tds <- cbind(tds, alld[,which(names(alld)==nm)])
        namtds <- c(namtds, nm)
      }
    }
    names(tds)[] <- namtds
    tds <- tds[complete.cases(tds),]        
    
    # Produce the basic scatter plot.
    p <- ggplot(tds, aes_string(x=input$x, y=input$y)) + geom_point(na.rm=T)
    
    # ... Colour/grouping
    if (input$color != 'None')
      p <- p + aes_string(color=input$color) 
    
    # ... Add a regression line? 
    if (input$regline)
      p <- p + geom_smooth(method=lm, se=FALSE, na.rm=T)
    
    # ... Facet the plot?
    facets <- paste(input$facet_row, '~', input$facet_col)
    if (facets != '. ~ .')
      p <- p + facet_grid(facets, drop=T)
    
    # ... Jitter to avoid overlapping point?
    if (input$jitter)
      p <- p + geom_jitter()

    # ... Log the X axis?
    if (input$logx)
      p <- p + scale_x_log10()

    # ... Log the Y axis?
    if (input$logy)
      p <- p + scale_y_log10()

    # DISPLAY the plot. 
    print(p)
    
  })
  
})
