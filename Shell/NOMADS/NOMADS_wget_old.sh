#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

workdir=/home/auto/MAMS/Data/NOMADS/gfs_0p25
year=2019

for (( month=4; month<=4; month++ )) do
  for (( day=1; day<=30; day++ )) do
#  fulldate=`date --date="2 days ago" +%Y%m%d`
    month2=`printf "%02d" ${month}`
    day2=`printf "%02d" ${day}`
    
    tempdir=${workdir}/${year}${month2}${day2}
    mkdir -p ${tempdir}
    cd ${tempdir}
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t00z.pgrb2.0p25.f003.idx
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t06z.pgrb2.0p25.f000
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t06z.pgrb2.0p25.f000.idx
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t06z.pgrb2.0p25.f003
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t06z.pgrb2.0p25.f003.idx
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t12z.pgrb2.0p25.f000
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t12z.pgrb2.0p25.f000.idx
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t12z.pgrb2.0p25.f003
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t12z.pgrb2.0p25.f003.idx
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t18z.pgrb2.0p25.f000
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t18z.pgrb2.0p25.f000.idx
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t18z.pgrb2.0p25.f003
    wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t18z.pgrb2.0p25.f003.idx
  done
done
#---- end of get: now data -------------------------

