#!/bin/sh

testname=auto01

fulldate=$1
MAMS=$2
#fulldate=20190618
#MAMS=/home/auto/MAMS
cp -r $MAMS/Source/Shell/Auto $MAMS/Source/Shell/Auto_backup

backupdir=/home/auto/ext_hdi/nwp_1_10/reanalysis

year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`
yearday=`date -d "$fulldate" +%j`
yearday_4=`printf "%04d" ${yearday}`


## remove dummy and old forecast files until 30 days ago
for (( ii=1; ii<=30; ii++ )); do
tempdate=`date -d "$fulldate $ii days ago" +%Y%m%d`
tempyear=`echo $tempdate | cut -c1-4`
tempmonth=`echo $tempdate | cut -c5-6`
tempday=`echo $tempdate | cut -c7-8`
tempyearday=`date -d "$tempdate" +%j`
tempyearday_4=`printf "%04d" ${tempyearday}`
tempoutputdir=$MAMS/Data/01_NWP_1_10/Output/Daily/$tempyear/$tempmonth/$tempdate
if [ -e $tempoutputdir ]; then
cd $tempoutputdir
find . ! -name ".*" -and ! -name "${testname}_???_${tempyearday_4}.nc" -and ! -name "*.in" -and ! -name "*flt*" -and ! -name "*sta*" -and ! -name "*rst*" | xargs rm -f #find and remove files except for -name files
#if [ $ii -le 1 ]; then
mkdir -p $backupdir/$tempyear/$tempmonth/$tempdate
rsync -a $tempoutputdir/ $backupdir/$tempyear/$tempmonth/$tempdate/  #backup
#fi
fi

done


