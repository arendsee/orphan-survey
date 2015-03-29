library(shiny)
library(ggvis)
source('global.R')

maketip <- function(x, dat){
    s <- orphan.data[orphan.data$key == x$key]
    paste0("<b>", s$sciname, "</b><br>",
           "Family: <b>", s$family, "</b><br>",
           "Orphans: <b>", s$orphans, "</b> (", 100 * signif(s$proportion, 3), "%)", "<br>",
           "Total proteins: <b>", s$total, "</b><br>",
           "Average orphan length: <b>", signif(s$ave.length, 3), "</b> (sd=", signif(s$sd.length, 3), ")", "<br>",
           "Length ratio (non-orphan / orphan): <b>", signif(s$length.rat, 3), "</b><br>",
           "Distance to nearest neighbor: <b>", signif(s$mean.distance, 3), "</b> (sd=", signif(s$sd.distance, 3), ")<br>"
           )
}

# Define server logic required to draw a histogram
shinyServer(
    function(input, output) {


        vis <- reactive({
            fs <- input$fontsize
            dat <- orphan.data[threshold == input$threshold & id == input$id]
            i <- which(dat$family %in% input$families)
            dat <- dat[i, c('key', 'family', 'qtaxid', 'reference',  input$xvar, input$yvar), with=FALSE] 
            setnames(dat, c(input$xvar, input$yvar),  c('xvar', 'yvar'))
            xlab <- names(axis.vars)[which(axis.vars == input$xvar)]
            ylab <- names(axis.vars)[which(axis.vars == input$yvar)]

            if(input$xlog){
                dat$xvar <- ifelse(dat$xvar == 0, 1, dat$xvar)
                xtrans <- 'log'
            } else {
                xtrans <- NULL 
            }
            if(input$ylog){
                dat$yvar <- ifelse(dat$yvar == 0, 1, dat$yvar)
                ytrans <- 'log'
            } else {
                ytrans <- NULL
            }

            g <- dat %>%
                ggvis(~xvar, ~yvar) %>% 
                layer_points(size := 100,
                             fill = ~factor(family),
                             stroke = ~factor(family),
                             shape = ~factor(reference),
                             strokeWidth := 2,
                             key := ~key,
                             size.hover := 200,
                             fillOpacity.hover := .75,
                             fillOpacity := .50) %>%
                add_legend(c('shape'),
                           title='Reference',
                           properties = legend_props(
                                            labels=list(fontSize = fs),
                                            title=list(fontSize = fs + 2))) %>%
                add_legend(c('fill', 'stroke'),
                           title='Family',
                           properties = legend_props(
                                            legend = list(y = 100),
                                            labels=list(fontSize = fs),
                                            title=list(fontSize = fs + 2))) %>%
                add_tooltip(maketip, 'hover') %>%
                add_axis('x',
                         title = xlab,
                         properties = axis_props(title=list(fontSize=fs + 2),
                                                 labels=list(fontSize=fs))) %>%
                add_axis('y',
                         title = ylab,
                         title_offset = 60,
                         properties = axis_props(title=list(fontSize=fs + 2),
                                                 labels=list(fontSize=fs))) %>%
                scale_numeric('x', trans=xtrans, expand=0) %>%
                scale_numeric('y', trans=ytrans, expand=0) %>%
                set_options(duration = 0)
        })

        vis %>% bind_shiny('mainplot')
    }
)
