#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

#fulldate=`date --date="2 days ago" +%Y%m%d`
fulldate=$1
MAMS=$2
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`

#--- remove: forecast folder ------------
cd $MAMS/Data/NOMADS/gfs_0p25/
#rm -rf ${fulldate}_forecast

rm_sday=0
rm_mday=3
#for (( rm_sday; rm_sday<rm_mday; rm_sday++ )) do
#	rm_day=`date -d "$fulldate ${rm_sday} day" +%Y%m%d`
#	echo '${rm_day}='${rm_day}
#	rm -rf ${rm_day}_forecast
#done

# should insert remove all forecast folder !! -ss 2019.03.19

#--- get: now data ---------------------------------
mkdir -p $fulldate
cd $fulldate
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/00/gdas.t00z.pgrb2.0p25.f000
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/00/gdas.t00z.pgrb2.0p25.f000.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f024
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f024.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/00/gdas.t00z.pgrb2.0p25.f003
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/00/gdas.t00z.pgrb2.0p25.f003.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/06/gdas.t06z.pgrb2.0p25.f000
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/06/gdas.t06z.pgrb2.0p25.f000.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/06/gdas.t06z.pgrb2.0p25.f003
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/06/gdas.t06z.pgrb2.0p25.f003.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/12/gdas.t12z.pgrb2.0p25.f000
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/12/gdas.t12z.pgrb2.0p25.f000.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/12/gdas.t12z.pgrb2.0p25.f003
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/12/gdas.t12z.pgrb2.0p25.f003.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/18/gdas.t18z.pgrb2.0p25.f000
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/18/gdas.t18z.pgrb2.0p25.f000.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/18/gdas.t18z.pgrb2.0p25.f003
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/18/gdas.t18z.pgrb2.0p25.f003.idx

#---- end of get: now data -------------------------
