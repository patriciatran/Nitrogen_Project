#ammonia plots
nh4 <- read.csv("~/Documents/GitHub/Nitrogen_Project/Incubations/Results/ammonia_data.csv")
library(dplyr)

library(reshape)
melt_nh4 <- melt(nh4, id="Time")

library(plotly)

p <- plot_ly(melt_nh4, x = ~Time, y = ~value, type = 'scatter', mode = 'lines', color = ~variable)
p

# Add metadata
melt_nh4$Depth <- NA
melt_nh4$Treatment <- NA

library(data.table)

for i in (i:nrow(melt_nh4)){
  if melt_nh4[melt_nh4$variable %like% "B", ][i,]{
    melt_nh4$Treatment[i] <- "NO3"
  }
  else{
    melt_nh4$Treatment[i] <- "NO2"
  }
}
