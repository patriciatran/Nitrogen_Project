mags <- read.delim("~/Documents/GitHub/Nitrogen_Project/Metagenome/Mapping_for_Patricia_by_Sarah/mapping_normalized.csv", sep=",", stringsAsFactors = FALSE)
rownames(mags) <- mags$MAG
mags <- mags[,-1]
mags <- t(mags)
mags <- as.data.frame(mags)
mags$date <- rownames(mags)
library(reshape)
mags$date_good<- gsub("X", "", mags$date)
library(lubridate)
mags$date_good_2 <- ymd(mags$date_good)

# which ones failed to parse?
nrow(mags[is.na(mags$date_good_2),])
which(is.na(mags), arr.ind=TRUE)

mags$date_good_2[71] <- as.Date("2010-06-15")
mags$date_good_2[77] <- as.Date("2010-10-29")
mags$date_good_2[87] <- as.Date("2010-04-20")

mags <- mags[,c(-181,-182)]
mdata <- melt(mags, id="date_good_2")

head(mdata)
str(mdata$value)

hist(mdata$value, n=100, xlab="Coverage mapped, normalized by metagenome size")

library(data.table)
# Change this for your fave bacteria:
mdata_subset <- mdata[mdata$variable %like% "Limnohab", ]

#library(ggplot2)
my_plot <- ggplot(mdata_subset, aes(date_good_2, variable, size=value))

my_plot<- my_plot + geom_point() +
  xlab("Date") + 
  ylab("Metagenome name")+
  #facet_grid(~Season, drop=TRUE) +
  ggtitle("Normalized Reads mapped to each Limnohabitabs Metagenome accross time")+
  scale_x_date(date_breaks = "3 month", date_labels =  "%b %Y") +
  theme(legend.position="bottom", panel.background = element_rect(fill='white'),
        #panel.grid.major=element_line(linetype="dashed", colour="grey"),
        panel.border = element_rect(linetype = "solid", fill = NA, colour="grey"),
        axis.text.x = element_text(angle = 90, hjust = 1),
        axis.text.y=element_blank())

my_plot
