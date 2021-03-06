# N-cyclers bubble plot:
n_mags <- read.csv("~/Dropbox/McMahonLab_Project/Nitrogen_Project/Metagenome/n_mags.csv")
library(reshape)
mdata <- melt(n_mags, id=c("Season","Date"))

# Assign guild:

mdata$Guild <- ifelse(grepl("Nitroso", mdata$variable), "AOB", "NOB")


library(ggplot2)
my_plot <- ggplot(mdata, aes(date, variable, size=value, color=Guild))

n_plot<- my_plot + geom_point() +
  xlab("Date") + 
  ylab("Metagenome name")+
  #facet_grid(~Season, drop=TRUE) +
  ggtitle("Reads mapped to each Metagenome accross time")+
  scale_x_date(date_breaks = "3 month", date_labels =  "%b %Y") +
  theme(legend.position="bottom", panel.background = element_rect(fill='white'),
        panel.grid.major=element_line(linetype="dashed", colour="grey"),
        panel.border = element_rect(linetype = "solid", fill = NA, colour="grey"),
        axis.text.x = element_text(angle = 90, hjust = 1))

n_plot

n_mags.matrix <- as.matrix(n_mags[,2:10])
row.names(n_mags.matrix) <- n_mags[,2]
n_mags.matrix <- n_mags.matrix[,-1]
mode(n_mags.matrix) <- "numeric" 

heatmap_dendogram <- heatmap(n_mags.matrix, cexCol=0.80)

install.packages('ape')
library(ape)
# plot basic tree

hc <- hclust(dist(n_mags.matrix))
plot(hc)
plot(as.phylo(n_mags.matrix), cex = 0.9, label.offset = 1)


nba_heatmap <- heatmap(n_mags.matrix, Rowv=T, Colv=T,
                       col = heat.colors(256), scale="row", 
                       margins=c(5,10))
