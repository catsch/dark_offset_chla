#!/bin/bash

usage() { 
	echo "Usage: $0 -W <WMO_number> [-m <median_size>] [-n <plot_name>] [-r <runmed_size>] [-y <y_zoom>] [-dhkMw]
Do '$0 -h' for help" 1>&2
	exit 1 
}
helprint() {
	echo "
#########################################################################################

DARK makes analytics plots to compare methods for the computation of the dark offset
of chla in BGC-ARGO

Usage: $0 -W <WMO_number> [-m <median_size>] [-n <plot_name>] [-r <runmed_size>] [-y <y_zoom>] [-dhkMw]

### Options

-W <WMO_number> : 7 digits WMO number of the float to consider.
[-m <median_size>] : Specify a size for median running filters in the computation of
                     minima, default is 5.
[-n <plot_name>] : Specify a file name for the output (with pathway), if not specified
                   the default is 'DARK_WMO.png' where WMO is replaced by the 7 digit WMO
                   number. Please use a '.png' extension in your file name.
[-r <runmed_size>] : Specify a size for the optional running median filter along the life
                     of the float.
[-y <y_zoom>] : Specify bounds for the y-axis with the format 'MIN.min;MAX.max' with the
                single quotation marks.
[-d] : Use dates as horizontal axis instead of profile index.
[-h] : help
[-k] : Compute Kalman filtered minima (experimental, not recommended)
[-M] : Include offsets computed by DMMC, warning : long.
[-w] : For each method considered except DMMC, write a file with the profile names in
       a format consistent with DMMC and with the offsets computed by the method.


#########################################################################################
" 1>&2
	exit 0
}

WMO=NA
plot_name=NA
median_size=NA
y_zoom=NA
use_DMMC=FALSE
use_kal=FALSE
runmed_size=NA
date_axis=FALSE
do_write=FALSE

while getopts W:n:m:y:Mkr:dwh option
do
case "${option}"
in
W) WMO=${OPTARG};;
n) plot_name=${OPTARG};;
m) median_size=${OPTARG};;
y) y_zoom=${OPTARG};;
M) use_DMMC=TRUE;;
k) use_kal=TRUE;;
r) runmed_size=${OPTARG};;
d) date_axis=TRUE;;
w) do_write=TRUE;;
h) helprint;;
*) usage;;
esac
done


Rscript ~/TRAITEMENT_FLOTTEUR/FLOAT_DM/DM_CHLA/STEP1_DARKESTIMATION/dark_offset_chla/main.R $WMO $plot_name $median_size $y_zoom $use_DMMC $use_kal $runmed_size $date_axis $do_write
