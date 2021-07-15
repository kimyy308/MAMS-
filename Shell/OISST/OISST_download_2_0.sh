#!/bin/bash
#fulldate=`date -d "$today" +%Y%m%d`
#fulldate=`date --date="2 days ago" +%Y%m%d`
fulldate=$1
MAMS=$2
work_dir=$MAMS/Data/OISST/
data_dir=${work_dir}${fulldate}
remotedir=/data/sea-surface-temperature-optimum-interpolation/access/${fulldate}120000-NCEI/0-fv02/
filename=${fulldate}120000-NCEI-L4_GHRSST-SSTblend-AVHRR_OI-GLOB-v02.0-fv02.0.nc 
mkdir -p ${data_dir}
cd ${data_dir}
exind=0
while [ ${exind} -ne 1 ]; do 
  if test -e ${data_dir}/${filename} 
  then
    echo "file exists"
    exind=1
  else
    wget https://www.ncei.noaa.gov${remotedir}${filename}
  fi
done
