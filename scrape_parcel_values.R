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
checkdown('gtools') # for mixed ordering
checkdown('tcltk2') # for popup boxes
 
# Load Packages #
require('Rcurl')
require('gtools')
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
