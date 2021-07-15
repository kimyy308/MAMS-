#!/bin/sh

#fulldate=`date --date="2 days ago" +%Y%m%d`
fulldate=$1
MAMS=$2
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`
workdir=$MAMS/Data/UM_global_10km
#--- remove: forecast directory ---

cd $workdir

rm_sday=1
rm_mday=3
#for (( rm_sday; rm_sday<rm_mday; rm_sday++ )) do
#        rm_day=`date -d "$fulldate ${rm_sday} day" +%Y%m%d`
#        echo '${rm_day}='${rm_day}
#        rm -rf ${rm_day}_forecast
#done

datadir=$workdir/${year}${month}${day}
mkdir -p ${datadir}
cd ${datadir}
 
host='147.47.242.138'
DIR='UM/GRIP2/'
ID=um
PW=getdata1234

ftp -ni $host <<EOF
user $ID $PW
cd UM/GRIP2/$year/$month/$day
pwd
!pwd
bin 
mget g120_v070_erea_unis_h000.${year}${month}${day}00.gb2
mget g120_v070_erea_unis_h003.${year}${month}${day}00.gb2
mget g120_v070_erea_unis_h006.${year}${month}${day}00.gb2
mget g120_v070_erea_unis_h009.${year}${month}${day}00.gb2
mget g120_v070_erea_unis_h012.${year}${month}${day}00.gb2
mget g120_v070_erea_unis_h015.${year}${month}${day}00.gb2
mget g120_v070_erea_unis_h018.${year}${month}${day}00.gb2
mget g120_v070_erea_unis_h021.${year}${month}${day}00.gb2
quit
EOF

