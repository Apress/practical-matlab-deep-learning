The files in this elevation folder are DEM (digital elevation model) files obtained from the US Geological Service.

As of 02/26/2010, we are using versions of these files that are divided into 10 degree latitude strips, and also compressed using gzip compression. These modified files have a filename extension of .compdem.

We are using DEM files from the GTOPO30 data set obtained
via download from the US Geological Service Earth Resources Observation & Sciencer (EROS)
Center. The files were current as of 02/16/2010. At that date, the web location was:
http://eros.usgs.gov/#/Find_Data/Products_and_Data_Available/gtopo30_info

The DEM files represent a grid of 3 rows of 9 tiles covering 40 degress of longitude
and 50 degrees of latitude each for everything above -60 deg latitude, and 1 row of 6 tiles
covering 60 degrees of longitude and 30 degrees of latitude for everything south of -60 deg
latitude. Each of the 27 tiles has 6000 rows and 4800 columns of 16 bit integers in big-ending
byte-order. They are in row-major order, so the first 12000 bytes represent the first row.
Each of the 6 tiles covering the southern portion of the globe has 3600 rows and 7200 columns.
Longitudes increase as you move across each row of data, and latitudes decrease as you move
down each column of data. Each "pixel" of data represents approximately 0.0083333333333
degrees of latitude/longitude.
