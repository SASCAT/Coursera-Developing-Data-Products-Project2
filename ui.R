# Developing Data Products Shiny Example.
# January 2015
#
# SAScat
#
# Based on Shiny Gallery example.

library(shiny)
library(ggplot2)

# Names for the columns in the data for selection.  This was originally 
# names() for the separate datframes, but direct specification is "lighter"
catnam <- c( "SEX", "Treatment", "catage", "catwt", "cattob", "catbmi")
y2nam <- c("Y2F1A", "Y2DLC", "Y2V1",  "Y2PXA", "Y2RX1", "Y2OC1", "Y2SGR", "Y26M" )
basnam <- c(
  "AGE", "Height", "Weight", "BDSURF", "BMI", "TOBANPY", "EXACE", "XDLC", "JVA", 
  "JF1A", "JF1FVC", "XF1MA", "JF1PPA", "JFVCA", "JHTT1", "QLV1", "XOC1", "QPX1", 
  "QRX1", "XV1", "QW1", "JMLD1", "JPX1", "JPXE1", "XRX1", "KF1ST", "KBDE", "X6M", 
  "KDYSPFS", "JFRCPP", "JIC", "XPXA", "KMMRC", "KRET", "JRVPP", "JTLCPP", "XSGR", 
  "JCRP", "JRBP" )

shinyUI(fluidPage(
  
  title = "Comparison of treatment results at one Year",
  h3("Baseline versus Enpoints for Treatment X"),
  plotOutput('plot'),
  
  hr(),
  
  fluidRow(
    column(5,
           h4("Usgae"),
           p("This app allows the graphical investigation the relationship between 
baseline characteristics (parameters) at the Start of the trial versus outcomes at 
the end of one year of treatment with either Treatment A or Treatment B. "),
           p("The plots can be grouped or faceted (e.g. by treatment or Sex)."),
           p("A regression line for the groups can be added.  The X and Y axes can both be set
             to log"),
           p("To update the plot, select different parameters from the drop down boxes"),
           br(),
           p("This code is based on a Shiny Gallery example program."),
           hr()
    ),
    column(3,
           selectInput('x', 'X (Baseline)', basnam, basnam[1]),
           selectInput('y', 'Y (Change at One Year)', y2nam, y2nam[1]),
           checkboxInput('jitter', 'Jitter'),
           checkboxInput('logx', 'Log X Axis'),
           checkboxInput('logy', 'Log Y Axis'),
           checkboxInput('regline', 'Regression Line (for group)')
    ),
    column(3,
           selectInput('color', 'Grouping', c('None', catnam)),
           selectInput('facet_row', 'Facet Row', c(None='.', catnam)),
           selectInput('facet_col', 'Facet Column', c(None='.', catnam))
    )
  )
))
