#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

fulldate=$1
MAMS=$2
$MAMS/App/runmatlab_auto $fulldate $MAMS/Source/MATLAB/OBC/create_boundary_auto.m

#fulldate=`date --date="2 days ago" +%Y%m%d`
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`

testname=auto01
workdir=$MAMS/Data/01_NWP_1_10/Input

ln -sf  ${workdir}/OBC/${year}${month}/auto01_bndy_${year}${month}${day}.nc ${workdir}/auto01_bndy.nc

