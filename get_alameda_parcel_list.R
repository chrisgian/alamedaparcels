### Get a list of all parcels!
### http://www.acgov.org/assessor/resources/parcel_viewer.htm
###
### Author: Chris Gian
### 

### Section Info: Setting up

# Check and Install Packages #
checkdown<-function(x){
  if(x %in% rownames(installed.packages()) == FALSE) {
    install.packages(x)}}

checkdown('tcltk2') # for popup boxes
checkdown('shapefiles') # for scraping
checkdown('rgdal')
# Load Packages #
require('shapefiles')
require('tcltk2')

# friendly pop up messages #

pop <- function(x) {
  tt <- tktoplevel()
  tkpack( tkbutton(tt, text=x, command=function()tkdestroy(tt)),
          side='bottom')
  tkbind(tt,'<Key>', function()tkdestroy(tt) )
  tkfocus(tt)
  tkwait.window(tt)
}

pop('Description: \<newline> 
    This script does some really tedious things for you. \<newline>
    First: it downloads a geospatial file for alameda county\<newline>
    Second: it strips all the parcel id numbers for you\<newline>
    finally: it formats that data for you to use in the scraper script!'
    )

pop('This script will download a 100+ Mb file 
    in order to extract some values! Be warned. 
    Click to continue.')

# create directory
dir.create('files')
dir.create('output')

path_file<-paste(getwd(),"/files",sep="")
path_output<-paste(getwd(),"/output",sep="")

alameda_zip_url<-'https://www.acgov.org/maps/geospatial/geospatial.zip'
file<-paste(path_file,"/geo.zip",sep="")
download.file(alameda_zip_url,file,mode='wb')

# unzip
shape<-unzip(zipfile=file,exdir = path_file)

x<-read.dbf(shape[4])
attributes<-x[[1]][,1]
write.csv(attributes,paste(path_output,".csv",sep=""))

