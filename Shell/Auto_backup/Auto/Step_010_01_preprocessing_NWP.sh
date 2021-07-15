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

ln -sf ${datadir}/${rstfile} ${inputdir}/${inifile}


fulldate=`date -d "$1 -0 day" +%Y%m%d`
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`
riverfile=auto01_river_${fulldate}.nc
riverdir=$MAMS/Data/01_NWP_1_10/Input/river/$year$month
ln -sf  ${inputdir}/SBC/${year}${month}/auto01_${year}${month}${day}_Tair.nc ${inputdir}/auto01_Tair.nc
ln -sf  ${inputdir}/SBC/${year}${month}/auto01_${year}${month}${day}_Pair.nc ${inputdir}/auto01_Pair.nc
ln -sf  ${inputdir}/SBC/${year}${month}/auto01_${year}${month}${day}_Qair.nc ${inputdir}/auto01_Qair.nc
ln -sf  ${inputdir}/SBC/${year}${month}/auto01_${year}${month}${day}_swrad.nc ${inputdir}/auto01_swrad.nc
ln -sf  ${inputdir}/SBC/${year}${month}/auto01_${year}${month}${day}_Uwind.nc ${inputdir}/auto01_Uwind.nc
ln -sf  ${inputdir}/SBC/${year}${month}/auto01_${year}${month}${day}_Vwind.nc ${inputdir}/auto01_Vwind.nc
ln -sf  ${inputdir}/OBC/${year}${month}/auto01_bndy_${year}${month}${day}.nc ${inputdir}/auto01_bndy.nc
ln -sf ${riverdir}/${riverfile} ${inputdir}/auto01_river.nc
