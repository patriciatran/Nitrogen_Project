# Patricia Tran
# Code to analyse the mapping data
# Mapped by Sarah Stevens using BBMAP

# ---- Define Paths and Dependencies ----

folder.path <- "/Volumes/mcmahonlab/home/ptran/depthsfromSarah/"

# ---- Functions ----

import.multiple.csv.files<-function(mypath,mypattern,...)
{
  tmp.list.1<-list.files(mypath, pattern=mypattern)
  tmp.list.2<-list(length=length(tmp.list.1))
  for (i in 1:length(tmp.list.1)){tmp.list.2[[i]]<-read.csv(tmp.list.1[i],...)}
  names(tmp.list.2)<-tmp.list.1
  tmp.list.2
}


# ---- Import Data ----

metadata <- read.csv("/Volumes/mcmahonlab/home/ptran/depthsfromSarah/ME_metadata.all.txt", sep="\t")

csv.import<-import.multiple.csv.files(folder.path,"95PID.txt$",sep="\t")


