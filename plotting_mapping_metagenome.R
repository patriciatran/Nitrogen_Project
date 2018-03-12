# Patricia Tran
# Plotting the MAGS that Sarah mapped

mags<- read.delim("~/Documents/GitHub/Nitrogen_Project/Metagenome/Mapping_for_Patricia_by_Sarah/allAvgDepths.abv95.renamed.txt", stringsAsFactors = FALSE)
match_library_ID <- read.delim("~/Documents/GitHub/Nitrogen_Project/Metagenome/Mapping_for_Patricia_by_Sarah/match_library_ID.txt", stringsAsFactors = FALSE)
nb_raw_reads <- read.delim("~/Documents/GitHub/Nitrogen_Project/Metagenome/Mapping_for_Patricia_by_Sarah/metaReads.txt", sep=" ", stringsAsFactors = FALSE, header=FALSE)
#Rename headers of nb_raw_reads

names(nb_raw_reads)[1] <- "Library_ID_old"
names(nb_raw_reads)[2] <- "nb.raw.reads"
library(reshape)
nb_raw_reads$Library_ID <- gsub("./", "", nb_raw_reads$Library_ID_old)
nb_raw_reads$Library_ID <- gsub(".mum.fastq", "", nb_raw_reads$Library_ID)

# Merge the match_library_ID and the nb_raw_reads
library(dplyr)
merged_library_ID <- full_join(match_library_ID, nb_raw_reads)

# Rename the headers in the mags table
names(mags) <- merged_library_ID$Sample_Name[match(names(mags), merged_library_ID$Library_ID)]
names(mags)[1]<-"Bin_name"

rownames(mags) <- mags$Bin_name


#mags <- mags[,-1]

#transpose:
mags <- t(mags)
# colnames(mags) <- mags[1,]
mags <- mags[-1,]
mags <- as.data.frame(mags)

mags$Sample_Name <- rownames(mags)

mags.normalized <- left_join(mags, merged_library_ID)
mags.normalized.no.na <- mags.normalized[complete.cases(mags.normalized), ]

# Are there duplicates?
which(duplicated(mags.normalized.no.na$Sample_Name))
which(duplicated(mags.normalized.no.na$Library_ID))
# The fourth row is dupplicated

mags.normalized.no.na <- unique(mags.normalized.no.na)
which(duplicated(mags.normalized.no.na$Library_ID))

# Make a matrix
rownames(mags.normalized.no.na) <- mags.normalized.no.na$Library_ID
# Now removethe unessacery columns
mags.normalized.no.na <- mags.normalized.no.na[,c(-181:-183)]

mags.normalized.no.na.matrix <- as.matrix(mags.normalized.no.na)

#Divide each row by the value of a specific column
for (i in 1:nrow(mags.normalized)){
  mags.normalized.no.na[1,]<- mags.normalized.no.na[1, ]/mags.normalized.no.na[i,181]
}

mags$dates <- rownames(mags)
# rownames(mags) <- c()

# Rename the dates

mags$date <- gsub("MEDH", "", mags$dates)

library(lubridate)
mags$date <- dmy(mags$date)

# Are there any dates that didn't match?
nrow(mags[is.na(mags$date),])
which(is.na(mags), arr.ind=TRUE)

mags$date[16] <- as.Date("2010-09-13")
mags$date[71] <- as.Date("2010-06-15")
mags$date[77] <- as.Date("2010-10-29")
mags$date[87] <- as.Date("2010-04-20")

str(mags$date)

# Remove the column with MEDH_dates
mags.copy <- mags[,-181]

mdata <- melt(mags.copy, id="date")
head(mdata)

summary(mdata)
str(mdata$value)

#Explore the data:
# How many MAGS are there?
levels(mdata$variable)


# AOB_NOB MAG:

#mdata$value <- as.numeric(mdata$value)
# Assign guild:

#mdata$Guild <- ifelse(grepl("Nitroso", mdata$variable), "AOB", "NOB")


library(ggplot2)
#my_plot <- ggplot(mdata, aes(date, variable, size=value, color=Guild))

hist(mdata$value, n=100, xlab="Coverage mapped")

library(data.table)
mdata_subset <- mdata[mdata$variable %like% "acI-B1", ]

my_plot <- ggplot(mdata_subset, aes(date, variable, size=value))

my_plot<- my_plot + geom_point() +
  xlab("Date") + 
  ylab("Metagenome name")+
  #facet_grid(~Season, drop=TRUE) +
  ggtitle("Reads mapped to each Metagenome accross time")+
  scale_x_date(date_breaks = "3 month", date_labels =  "%b %Y") +
  theme(legend.position="bottom", panel.background = element_rect(fill='white'),
        #panel.grid.major=element_line(linetype="dashed", colour="grey"),
        panel.border = element_rect(linetype = "solid", fill = NA, colour="grey"),
        axis.text.x = element_text(angle = 90, hjust = 1),
        axis.text.y=element_blank())

my_plot

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
