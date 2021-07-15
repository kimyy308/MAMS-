#!/bin/sh

##fulldate=`date --date="2 days ago" +%Y%m%d`
##year=`echo $fulldate | cut -c1-4`
##month=`echo $fulldate | cut -c5-6`
##day=`echo $fulldate | cut -c7-8`

year=2019
month=05  #01, 02 ~, fixed
day2=21  
endday=21
for (( day2; day2<=endday; day2++ )) do
day=`printf "%02d" ${day2}`

workdir=/home/auto/MAMS/Data/UM_global_10km
#--- remove: forecast directory ---

cd $workdir

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

done
