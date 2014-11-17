### Scrape Parcel Data from Alameda County's Parcel Viewer
### http://www.acgov.org/assessor/resources/parcel_viewer.htm
###
### Author: Chris Gian
### 

### Section Info: Setting up

# Check and Install Packages #
checkdown<-function(x){
  if(x %in% rownames(installed.packages()) == FALSE) {
    install.packages(x)}}

checkdown('RCurl') # for scraping
checkdown('XML') # for mixed ordering
checkdown('tcltk2') # for popup boxes
 
# Load Packages #
require('Rcurl')
require('XML')
require('tcltk2')

# pop up message windo #
pop <- function(x) {
  tt <- tktoplevel()
  tkpack( tkbutton(tt, text=x, command=function()tkdestroy(tt)),
          side='bottom')
  tkbind(tt,'<Key>', function()tkdestroy(tt) )
  tkfocus(tt)
  tkwait.window(tt)
}

pop("Hey there! Thanks for using this script.")

# directories
dir.create('files')
dir.create('output')
path_file<-paste(getwd(),"/files",sep="")
path_output<-paste(getwd(),"/output",sep="")

# Popup message
pop(paste('Make sure that we have an attributes table in the 
          ',path_output," folder!
          Click to proceed! If you don't, then run other script.",sep=""))

# insheet parcel list
parcellist<-as.vector(read.csv(paste(path_output,'parcel_id.csv',sep=""))[,2])

# Build a data input, forked from: 
# http://stackoverflow.com/questions/16847621/get-data-out-of-a-tcltk-function

inputs <- function(){
  
  start <- tclVar("")
  end <- tclVar("")
  
  tt <- tktoplevel()
  tkwm.title(tt,"Input Numbers")
  x.entry <- tkentry(tt, textvariable=start)
  y.entry <- tkentry(tt, textvariable=end)
  
  reset <- function()
  {
    tclvalue(start)<-""
    tclvalue(end)<-""
  }
  
  reset.but <- tkbutton(tt, text="Reset", command=reset)
  
  submit <- function() {
    x <- as.numeric(tclvalue(start))
    y <- as.numeric(tclvalue(end))
    e <- parent.env(environment())
    e$x <- x
    e$y <- y
    tkdestroy(tt)
  }
  submit.but <- tkbutton(tt, text="submit", command=submit)
  
  tkgrid(tklabel(tt,text=paste("Input Numbers Min: 1, max: ",length(parcellist),sep="")),columnspan=2)
  tkgrid(tklabel(tt,text="Input1"), x.entry, pady = 10, padx =10)
  tkgrid(tklabel(tt,text="Input2"), y.entry, pady = 10, padx =10)
  tkgrid(submit.but, reset.but)
  
  tkwait.window(tt)
  return(c(x,y))
}


# write a data set to fill
parcel_dataset<-data.frame()


myval<-inputs()

# engage loop
for (i in myval[1]:myval[2]){

url<-paste('http://www.acgov.org/MS/prop/index.aspx?PRINT_PARCEL=',parcellist[i],sep="")
err <- try(htmlParse(url),silent=T)
  
  if (class(err) == "try-error"){next}else{
  parse<-htmlParse(url)

}
# build a progress bar
pb <- txtProgressBar(min = 0, max = myval[2], style = 3)
# progress updated
setTxtProgressBar(pb, i)
#
extract<-data.frame(xpathSApply(parse,"//span[@class='desc2']",xmlValue))
#
set<-data.frame("variable"=c(
  'Use Code','Description','land','improvements','Fixtures',
  'Household Personal Property','Business Personal Property',
  'Total Taxable Value','Homeowner','Other',
  'Total Net Taxable Value'),'values'=extract[-1,1],"parcel"=parcellist[i])
#
parcel_dataset<-rbind(parcel_dataset,set)
# 1 second sleep
Sys.sleep(1)

}
# close the progress bar
close(pb)

# pop up for save
pop(paste("okay! done. Now your csv will be saved at:
      ",path_output,sep=""))
# write csv
write.csv(parcel_dataset,paste(path_output,"/parcel_extract_",myval[1],"_to_",myval[2],"_",substr(Sys.time(),1,10),".csv",sep=""))


