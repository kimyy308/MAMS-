#!/bin/sh

#fulldate2=`date +%Y%m%d`
##fulldate=`echo ${fulldate2}-2|bc`

set runtime = `head -1 ${LOG}/runtime.tim | cut -c1-10`
set YYMMDD =  `head -1 ${LOG}/runtime.tim | cut -c1-8`

set RAWDIR = /home/auto/MAMS/Data/NOMADS/gfs_0p25
set EXT_DIR = rNOMADS_EXT
set OUT_DIR = rNOMADS_nc_out

foreach tail_n ( 000 003 )
foreach mid_n ( 00 06 12 18 )
foreach fname1 ( ${RAWDIR}/${YYMMDD}/gdas.t${mid_n}z.pgrb2.0p25.f000)
foreach fname2 ( ${RAWDIR}/${YYMMDD}/gdas.t&{mid_n}z.pgrd2.0p25.f003)



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



