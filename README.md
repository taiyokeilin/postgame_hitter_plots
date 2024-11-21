# postgame_hitter_plots
Create Postgame Hitter Plots using TrackMan Data

This R script takes a TrackMan CSV and creates a PDF with zone plots to evaluate a hitter's game performance. The plots simply show pitch type and location, and the result of the pitch. On a single game level, it is best used to evaluate swing decisions (making sure hitters swung at pitches in the damage zone, colored red, and didn't swing at pitches in the chase and waste zones, colored light gray and blue, respectively). It also displays the exit velocity and launch angle of batted balls. 

In a future iteration, I would wish to include a table for each hitter that includes more information about each pitch he saw in a game: count, pitch type, velocity, zone, and result, as well as the result of the plate appearance. I would also likely use either `openxlsx` or `ggpubr` to create a better looking page layout.

This particular script creates a report for UCLA Baseball's game against the University of Washington on March 26, 2023.
