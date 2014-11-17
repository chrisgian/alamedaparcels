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

## proto
#parcel<-"11-836-1-1"
#url<-paste('http://www.acgov.org/MS/prop/index.aspx?PRINT_PARCEL=',parcel,sep="")
#parse<-htmlParse(url)

## proto end
pop(paste('Make sure that we have an attributes table in the 
          ',path_output," folder!
          Click to proceed! If you don't, then run other script.",sep=""))

parcellist<-data.frame(read.csv(paste(path_output,'parcel_id.csv',sep=""))[,2])
names(parcel)<-'parcel_id'

parcel_dataset<-data.frame()

for (i in parcellist){
  
  url<-paste('http://www.acgov.org/MS/prop/index.aspx?PRINT_PARCEL=',parcel,sep="")
  err <- try(htmlParse(url),silent=T)

if (
    class(err) == "try-error")
    {next
    }else{
      parse<-htmlParse(url)
      
      }
  )
extract<-data.frame(xpathSApply(parse,"//span[@class='desc2']",xmlValue))
set<-data.frame("variable"=c(
  'Use Code','Description','land','improvements','Fixtures',
  'Household Personal Property','Business Personal Property',
  'Total Taxable Value','Homeowner','Other',
  'Total Net Taxable Value'),'values'=extract[-1,1],"parcel"=i)

parcel_dataset<-rbind(parcel_dataset,set)
  
}


#trycatch
err <- try( #parse )

  # add a little time jiggler
if (class(err) == "try-error"){
  next}else{
    # parse it
    # add a little progress bar
      )
)    
  } 
