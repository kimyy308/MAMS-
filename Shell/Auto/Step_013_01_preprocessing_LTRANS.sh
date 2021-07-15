#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

testname=auto01
#fulldate=`date --date="3 days ago" +%Y%m%d`
fulldate=`date -d "$1 0 day" +%Y%m%d`
MAMS=$2
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`
yearday=`date -d "$fulldate" +%j`
yearday=`echo $yearday | sed 's/^0*//'`
yearday_4=`printf "%04d" ${yearday}`


workdir=$MAMS/Model/LTRANS
inputdir=$workdir/Input
#datadir=/home/auto/ext_hdi/nwp_1_10/reanalysis
datadir=$MAMS/Data/01_NWP_1_10/Output/Daily
cd $datadir

startday=-15   # -12 ~ 2 (15 days)
endday=-1
numday=`echo  $endday - $startday +1  |bc `
startdate=`date -d "$fulldate $startday days" +%Y%m%d`
enddate=`date -d "$fulldate $endday days" +%Y%m%d`
dayinfofile=$inputdir/dayinfo
echo $startdate > $dayinfofile
echo $numday >> $dayinfofile

#ln -sf ${datadir}/${rstfile} ${inputdir}/${inifile}

rm -f $inputdir/input*nc
for (( dayind=$startday; dayind<=$endday; dayind++ )) do
tempdate=`date -d "$fulldate $dayind days" +%Y%m%d`
tempyear=`echo $tempdate | cut -c1-4`
tempmonth=`echo $tempdate | cut -c5-6`
tempday=`echo $tempdate | cut -c7-8`
tempyearday=`date -d "$tempdate" +%j`
tempyearday=`echo $tempyearday | sed 's/^0*//'`
tempyearday_4=`printf "%04d" ${tempyearday}`

inputind=`echo $dayind - $startday +4|bc`
inputind_4=`printf "%04d" ${inputind}`

if [ $dayind -eq $startday ]; then

#      fullnum_file_rmzero=$(echo $fullnum_file | sed 's/^0*//')  
      ln -sf $datadir/$tempyear/$tempmonth/$tempdate/${testname}_avg_${tempyearday_4}".nc" $inputdir/input_0001.nc
      ln -sf $datadir/$tempyear/$tempmonth/$tempdate/${testname}_avg_${tempyearday_4}".nc" $inputdir/input_0002.nc
      ln -sf $datadir/$tempyear/$tempmonth/$tempdate/${testname}_avg_${tempyearday_4}".nc" $inputdir/input_0003.nc
      ln -sf $datadir/$tempyear/$tempmonth/$tempdate/${testname}_avg_${tempyearday_4}".nc" $inputdir/input_0004.nc
      #numday2=`echo $numday - 1|bc`

elif [ $dayind -ge 0 ]; then
##~~ -> need to get all 3 days avg file from last tempday
      ln -sf $datadir/$year/$month/$fulldate/${testname}_avg_${yearday_4}".nc" $inputdir/input_${inputind_4}.nc
     

else 
      ln -sf $datadir/$tempyear/$tempmonth/$tempdate/${testname}_avg_${tempyearday_4}".nc" $inputdir/input_${inputind_4}.nc

fi
done
      
