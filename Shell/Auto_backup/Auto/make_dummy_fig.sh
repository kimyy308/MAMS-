#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

#fulldate=$1

fulldate=`date --date="2 days ago" +%Y%m%d`
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
#day=`echo $fulldate | cut -c7-8`
#yearday=`date -d "$fulldate" +%j`
#yearday_4=`printf "%04d" ${yearday}`
MAMS=/home/auto/MAMS
dummydir=$MAMS/Figure/01_NWP_1_10
figdir=$MAMS/Figure/01_NWP_1_10/$year/$month/$fulldate/ES
mkdir -p $figdir
cd $figdir


arr_i_da=(2 1 0 -1)
for ((idx_day; idx_day<=3; idx_day++ )) do

fulldate=`date --date="${arr_i_da[$idx_day]} days ago" +%Y%m%d`

arr_i_h=(03 06 09 12 15 18 21 24)
arridx=0;
arridx_max=7;

for (( arridx; arridx<=arridx_max; arridx++ )) do
  cp $dummydir/ES_dummy.png $figdir/SSS_${fulldate}${arr_i_h[$arridx]}.png
  cp $dummydir/ES_dummy.png $figdir/SST_${fulldate}${arr_i_h[$arridx]}.png
  cp $dummydir/ES_dummy.png $figdir/UV_${fulldate}${arr_i_h[$arridx]}.png
  cp $dummydir/ES_dummy.png $figdir/WIND_${fulldate}${arr_i_h[$arridx]}.png
done

  cp $dummydir/ES_dummy.png $figdir/AVG_SST_${fulldate}.png
  cp $dummydir/ES_dummy.png $figdir/AVG_SSS_${fulldate}.png
  cp $dummydir/ES_dummy.png $figdir/AVG_UV_${fulldate}.png
  cp $dummydir/ES_dummy.png $figdir/AVG_WIND_${fulldate}.png
  cp $dummydir/ES_dummy.png $figdir/ani_AVG_SST_${fulldate}.png
  cp $dummydir/ES_dummy.png $figdir/ani_AVG_SSS_${fulldate}.png
  cp $dummydir/ES_dummy.png $figdir/ani_AVG_UV_${fulldate}.png
  cp $dummydir/ES_dummy.png $figdir/ani_AVG_WIND_${fulldate}.png
  cp $dummydir/ES_dummy.png $figdir/ani_SST_${fulldate}.png
  cp $dummydir/ES_dummy.png $figdir/ani_SSS_${fulldate}.png
  cp $dummydir/ES_dummy.png $figdir/ani_UV_${fulldate}.png
  cp $dummydir/ES_dummy.png $figdir/ani_WIND_${fulldate}.png

done
