#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

fulldate=$1
MAMS=$2
testname=auto01
#fulldate=`date --date="2 days ago" +%Y%m%d`
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`
workdir=$MAMS/Model/ROMS/01_NWP_1_10
inputdir=$MAMS/Data/01_NWP_1_10/Input
datadir=$MAMS/Data/01_NWP_1_10/Input/river/$year$month
mkdir -p $datadir
cd $datadir
riverfile=auto01_river_${fulldate}.nc
#arr_i=(00 03 06 09 12 15 18 21)

$MAMS/App/runmatlab_auto $fulldate $MAMS/Source/MATLAB/River/create_riverfile_auto.m

ln -sf ${datadir}/${riverfile} ${inputdir}/auto01_river.nc








