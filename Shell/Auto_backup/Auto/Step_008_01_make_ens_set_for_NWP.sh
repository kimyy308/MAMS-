#!/bin/sh

testname=auto01

fulldate=$1
fulldate=`date -d "$fulldate 1 days ago" +%Y%m%d`
date -d "$fulldate 1 days ago" +%Y%m%d
MAMS=$2
#fulldate=20190618
#MAMS=/home/auto/MAMS

year=`echo $fulldate | cut -c1-4`
echo $fulldate | cut -c1-4
month=`echo $fulldate | cut -c5-6`
echo $fulldate | cut -c5-6
day=`echo $fulldate | cut -c7-8`
echo $fulldate | cut -c7-8
yearday=`date -d "$fulldate" +%j`
yearday=`echo $yearday | sed 's/^0*//'`
date -d "$fulldate" +%j
ensdir=$MAMS/Data/DA/01_NWP_1_10/Ensemble
#datadir=/home/auto/ext_hdi/nwp_1_10/reanalysis
datadir=/data2/auto/MAMS/Data/DA/01_NWP_1_10/Ensemble_hdd/nwp_1_10/reanalysis

yearday_4=`printf "%04d" ${yearday}`
printf "%04d" ${yearday}
# 1983 ~ 2018
for (( ensi=1; ensi<=36; ensi++ )) do
  ensyear=`echo $ensi + 1982 |bc`
  ensi_4=`printf "%04d" $ensi`
  ln -sf $datadir/$ensyear/ocean_avg_${yearday_4}.nc $ensdir/ocean_ens_${ensi_4}.nc
done
