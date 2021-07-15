#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

testname=auto01
#fulldate=`date --date="3 days ago" +%Y%m%d`
fulldate=`date -d "$1 -1 day" +%Y%m%d`
MAMS=$2
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`


workdir=$MAMS/Model/ROMS/01_NWP_1_10
inputdir=$MAMS/Model/ROMS/01_NWP_1_10/Input
datadir=$MAMS/Data/01_NWP_1_10/Output/Daily/$year/$month/$fulldate
cd $datadir
rstfile=${testname}_rst_DA_${fulldate}.nc
inifile=${testname}_ini.nc
ctrlfile=${testname}_${fulldate}.in
logfile=${testname}_${fulldate}.log

ln -sf ${datadir}/${rstfile} ${inputdir}/${inifile}
