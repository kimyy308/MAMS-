#!/bin/bash
#fulldate=`date -d "$today" +%Y%m%d`
#fulldate=`date --date="2 days ago" +%Y%m%d`
fulldate=$1
MAMS=$2
yyyymm=`date -d ${fulldate} +%Y%m` 
work_dir=$MAMS/Data/OISST/
data_dir=${work_dir}${fulldate}
#remotedir=/data/sea-surface-temperature-optimum-interpolation/access/${fulldate}120000-NCEI/0-fv02/
remotedir=/data/sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr/${yyyymm}/
#filename=${fulldate}120000-NCEI-L4_GHRSST-SSTblend-AVHRR_OI-GLOB-v02.0-fv02.0.nc 
filename=oisst-avhrr-v02r01.${fulldate}.nc 
filename2=oisst-avhrr-v02r01.${fulldate}_preliminary.nc 
mkdir -p ${data_dir}
cd ${data_dir}

countind=0
exind=0
while [ ${exind} -ne 1 ] ; do 
  if test -e ${data_dir}/${filename2} 
  then
    echo "file exists"
    ln -s ${filename2} OISST_${fulldate}.nc
    exind=1
  else
    wget https://www.ncei.noaa.gov${remotedir}${filename2}
    ((countind++))
    if [ $countind -gt 5 ] ; then
      exind=1
    fi
  fi
done

countind=0
exind=0
while [ ${exind} -ne 1 ] ; do 
  if test -e ${data_dir}/${filename} 
  then
    echo "file exists"
    ln -s ${filename} OISST_${fulldate}.nc
    exind=1
  else
    wget https://www.ncei.noaa.gov${remotedir}${filename}
    ((countind++))
    if [ $countind -gt 5 ] ; then
      exind=1
    fi
  fi
done
