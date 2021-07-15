#!/bin/sh

#fulldate2=`date +%Y%m%d`
##fulldate=`echo ${fulldate2}-2|bc`

fulldate=`date --date="2 days ago" +%Y%m%d`
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`

#cd /data1/auto/Atm/NOMADS/gfs_0p25/
cd /home/auto/MAMS/Data/NOMADS/gfs_0p25/
mkdir $fulldate
cd $fulldate
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t00z.pgrb2.0p25.f000
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t00z.pgrb2.0p25.f024
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t00z.pgrb2.0p25.f024.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t00z.pgrb2.0p25.f000.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t00z.pgrb2.0p25.f003
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



