library(tidyverse)
library(stringr)

Hitter_Plot <- function(Trackman, Hitters, Game_Date) {
  for (i in seq_along(Hitters)) {
    hitter <- Hitters[i]
    name_listed <- str_split(hitter, ", ")
    Name <- stringr::str_glue(name_listed[[1]][2], name_listed[[1]][1], .sep = " ")
  
    Game <- Trackman %>%
      dplyr::filter(Batter == hitter,
                    PitchCall != 'Undefined',
                    !is.na(PlateLocHeight),
                    !is.na(PlateLocSide)) %>% 
      dplyr::arrange(Date, Inning, PAofInning, PitchofPA)
  
    Game$result <- rep(NA, nrow(Game))
    for (i in 1:nrow(Game)) {
      if (Game$PitchCall[i] %in% c('BallCalled', 'BallinDirt', 'StrikeCalled')) {
        Game$result[i] <- 'Take'
      } else if (Game$PitchCall[i] == 'StrikeSwinging') {
        Game$result[i] <- 'Whiff'
      } else if (Game$PitchCall[i] == 'InPlay' & !is.na(Game$ExitSpeed[i]) & Game$ExitSpeed[i] >= 90) {
        Game$result[i] <- 'Hard Contact'
      } else {
        Game$result[i] <- 'Contact'
      }
    }
  
    Game$PitchType <- rep(NA, nrow(Game))
    for (i in 1:nrow(Game)) {
      if (Game$TaggedPitchType[i] %in% c('Fastball', 'Sinker')) {
        Game$PitchType[i] <- 'Hard'
      } else if (Game$TaggedPitchType[i] %in% c('Slider', 'Curveball', 'Cutter')) {
        Game$PitchType[i] <- 'Breaking'
      } else if (Game$TaggedPitchType[i] %in% c('Changeup', 'ChangeUp', 'Splitter')) {
        Game$PitchType[i] <- 'OffSpeed'
      } else {
        Game$PitchType[i] <- 'Other'
      }
    }
    
    Game$PA_num <- rep(NA, nrow(Game))
    Game$PA_num[1] <- 1
    for (i in 2:nrow(Game)) {
      if (Game$PitchofPA[i] > Game$PitchofPA[i-1]) {
        Game$PA_num[i] <- Game$PA_num[i-1]
      }
      else {
        Game$PA_num[i] <- Game$PA_num[i-1] + 1
      }
    }
  
    cols <- c("Take" = "black", "Whiff" = "#384CDF", "Hard Contact" = "#FF0000", "Contact" = "#135F0F")
    
    cat("\n\n\\pagebreak\n")
    cat("**", Name, " -- ", Game_Date, "**\n\n", sep = "")
    hitter_plot <- ggplot(Game, aes(x = -1 * PlateLocSide, y = PlateLocHeight, shape = factor(PitchType), color = factor(result))) +
      # chase zone
      geom_rect(aes(xmin = -2.5, ymin = -.5, xmax = 2.5, ymax = 5), fill = '#9BBFE3', color = '#9BBFE3') +
      # edge zone
      geom_rect(aes(xmin = -1, ymin = 1.25, xmax = 1, ymax = 3.6), fill = '#D2D3D4', color = '#D2D3D4') + 
      # shadow zone
      geom_rect(aes(xmin = -.7, ymin = 1.7, xmax = .7, ymax = 3.15), fill = '#A1A1A1', color = '#A1A1A1') +
      # damage zone
      geom_rect(aes(xmin = -.45, ymin = 2.1, xmax = .45, ymax = 2.8), fill = '#E88F8F', color = '#E88F8F') +
      geom_point(size = 4) +
      # strike zone
      geom_segment(aes(x = -.82, y = 1.5, xend = .82, yend = 1.5), color = 'black') +
      geom_segment(aes(x = -.82, y = 3.35, xend = .82, yend = 3.35), color = 'black') +
      geom_segment(aes(x = -.82, y = 1.5, xend = -.82, yend = 3.35), color = 'black') +
      geom_segment(aes(x = .82, y = 3.35, xend = .82, yend = 1.5), color = 'black') +
      # plate
      geom_segment(x = -.82, y = .5, xend = -.8, yend = .2, color = 'black') +
      geom_segment(x = .82, y = .5, xend = .80, yend = .2, color = 'black') +
      geom_segment(x = -.8, y = .2, xend = 0, yend = .01, color = 'black') +
      geom_segment(x = .8, y = .2, xend = 0, yend = .01, color = 'black') +
      geom_segment(x = -.82, y = .5, xend = .82, yend = .5, color = 'black') +
      xlim(-2.5, 2.5) +
      ylim(-0.5, 5) +
      theme_bw() +
      scale_colour_manual(values = cols) +
      ggtitle(Name, subtitle = 'Umpire View') +
      theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) +
      labs(shape = 'Pitch Type',
           color = 'Pitch Result',
           x = '',
           y = '') +
      theme(aspect.ratio = 1.35)
    
    print(hitter_plot)
    cat("\n\n\\pagebreak\n")
  } 
}












