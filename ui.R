library(shiny)
library(ggvis)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    titlePanel('Orphan Survey'),
    sidebarLayout(
        sidebarPanel(
            fluidRow(column(6, 
                selectInput("xvar", "X-axis variable", axis.vars, selected = "distance"),
                selectInput("id", "Reference Set", id.vars, selected = 'qseqid')),
                     column(6, 
                selectInput("yvar", "Y-axis variable", axis.vars, selected = "orphans"),
                selectInput("threshold", "Blast E-value Threshold", threshold.vars, selected = '0.001'))),
            fluidRow(column(6, 
                checkboxInput('ylog', 'Log Y-axis', value=FALSE),
                checkboxInput('xlog', 'Log X-axis', value=FALSE),
                sliderInput('fontsize', 'Font Size', value=10, step=1, min=8, max=20)),
                     column(6, 
            checkboxGroupInput('families', 'Families to display:',
                               levels(orphan.data$family),
                               selected = levels(orphan.data$family))))
        ),
        mainPanel(ggvisOutput("mainplot"))
        )
    )

)
