#scrape that alameda parcel data!  
alamedaparcels
==============

###Author: Chris Gian  
###Date: 11/17/2014  
Hey everyone!  

These two scripts will together allow you to scrape alameda county's parcel data.

here:
http://www.acgov.org/assessor/resources/parcel_viewer.htm

Run get_alameda_parcel_list.r in order to download a dbf 
which gets you the entire universe of Parcel ids (limitation 
is whether or not it is updated)

Then run scrape_parcel_values.r in order to begin the scraping process!
I've included a few cool features:
- Try catch for bad urls
- progress bar
- pop up messages
- a range setter (if for some reason the script breaks down 
and you want to start of where you stopped, or if you need a certain range)

Enjoy!

Chris Gian
