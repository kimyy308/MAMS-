#!/bin/bash
##today=`date -d "$today" +%Y%m%d`
refday=20190101
lag_max=37
work_dir=/home/auto/MAMS/Data/OISST/

for (( lag_day=0; lag_day<lag_max; lag_day++ )) do
  this_time=`date -d "$refday ${lag_day} day" +%Y%m%d`
  data_dir=${work_dir}${this_time}
  mkdir -p ${data_dir}
  cd ${data_dir}
  remotedir=/data/sea-surface-temperature-optimum-interpolation/access/${this_time}120000-NCEI/0-fv02/
  filename=${this_time}120000-NCEI-L4_GHRSST-SSTblend-AVHRR_OI-GLOB-v02.0-fv02.0.nc 
  if test -e ${data_dir}/${filename} 
  then
    echo "file exists"
  else
  wget https://www.ncei.noaa.gov${remotedir}${filename}
  fi
done #str day
