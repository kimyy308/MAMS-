#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

fulldate=$1
MAMS=$2
$MAMS/App/runmatlab_auto $fulldate $MAMS/Source/MATLAB/SBC/roms_forcing_kimyy_auto.m

#fulldate=`date --date="2 days ago" +%Y%m%d`
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`

testname=auto01
workdir=$MAMS/Data/01_NWP_1_10/Input

ln -sf  ${workdir}/SBC/${year}${month}/auto01_${year}${month}${day}_Tair.nc ${workdir}/auto01_Tair.nc
ln -sf  ${workdir}/SBC/${year}${month}/auto01_${year}${month}${day}_Pair.nc ${workdir}/auto01_Pair.nc
ln -sf  ${workdir}/SBC/${year}${month}/auto01_${year}${month}${day}_Qair.nc ${workdir}/auto01_Qair.nc
ln -sf  ${workdir}/SBC/${year}${month}/auto01_${year}${month}${day}_swrad.nc ${workdir}/auto01_swrad.nc
ln -sf  ${workdir}/SBC/${year}${month}/auto01_${year}${month}${day}_Uwind.nc ${workdir}/auto01_Uwind.nc
ln -sf  ${workdir}/SBC/${year}${month}/auto01_${year}${month}${day}_Vwind.nc ${workdir}/auto01_Vwind.nc

