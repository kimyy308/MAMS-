#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

testname=auto01
#fulldate=`date --date="3 days ago" +%Y%m%d`
#fulldate=`date -d "$1 0 day" +%Y%m%d`
MAMS=$2
workdir=$MAMS/Model/LTRANS
inputdir=$workdir/Input
dayinfofile=$inputdir/dayinfo
fulldate=`head -1 $dayinfofile`
numday=`tail -1 $dayinfofile`
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`
yearday=`date -d "$fulldate" +%j`
yearday_4=`printf "%04d" ${yearday}`

$MAMS/App/runmatlab_auto_disp $fulldate $MAMS/Source/MATLAB/postprocessing/Figure/plot_all_particles_kyy.m

figdir=$MAMS/Figure/LTRANS/$year/$month/$fulldate

cd $figdir

convert -delay 70 ltrans_fig_${fulldate}_????.png ani_ltrans_${fulldate}.gif
