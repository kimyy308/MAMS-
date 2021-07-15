#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

fulldate=$1
MAMS=$2
$MAMS/App/runmatlab_auto_disp $fulldate $MAMS/Source/MATLAB/postprocessing/Figure/plot_surface_data_auto.m

#fulldate=`date --date="2 days ago" +%Y%m%d`


year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`
yearday=`date -d "$fulldate" +%j`
yearday_4=`printf "%04d" ${yearday}`

figdir=$MAMS/Figure/01_NWP_1_10/$year/$month/$fulldate/NWP/

cd $figdir
convert -delay 100 SST_*.png ani_SST.gif
convert -delay 100 SSS_*.png ani_SSS.gif
convert -delay 100 UV_*.png ani_UV.gif



#expect <<EOF                              
#spawn scp -oStrictHostKeyChecking=no ani_SST.gif auto@mepl.snu.ac.kr:/var/www/html/tmpData/NWP/gifs/temperature.gif
#expect "password:"
#send "rlackdtls\r"
#expect eof
#EOF
cp -f ani_SST.gif /var/www/html/tmpData/NWP/gifs/temperature.gif

#expect <<EOF                              
#spawn scp -oStrictHostKeyChecking=no ani_SSS.gif auto@mepl.snu.ac.kr:/var/www/html/tmpData/NWP/gifs/salinity.gif
#expect "password:"
#send "rlackdtls\r"
#expect eof
#EOF
cp -f ani_SSS.gif /var/www/html/tmpData/NWP/gifs/salinity.gif


#expect <<EOF                              
#spawn scp -oStrictHostKeyChecking=no ani_UV.gif auto@mepl.snu.ac.kr:/var/www/html/tmpData/NWP/gifs/currents.gif
#expect "password:"
#send "rlackdtls\r"
#expect eof
#EOF

cp -f ani_UV.gif /var/www/html/tmpData/NWP/gifs/currents.gif



$MAMS/App/runmatlab_auto_disp $fulldate $MAMS/Source/MATLAB/postprocessing/Figure/plot_surface_data_mict_auto.m


figdir=$MAMS/Figure/01_NWP_1_10/$year/$month/$fulldate/ES/
cd $figdir
convert -delay 100 AVG_SST_*.png ani_AVG_SST.gif
convert -delay 100 AVG_SSS_*.png ani_AVG_SSS.gif
convert -delay 100 AVG_UV_*.png ani_AVG_UV.gif
convert -delay 100 AVG_WIND_*.png ani_AVG_WIND.gif
convert -delay 100 SST_*.png ani_SST.gif
convert -delay 100 SSS_*.png ani_SSS.gif
convert -delay 100 UV_*.png ani_UV.gif
convert -delay 100 WIND_*.png ani_WIND.gif
