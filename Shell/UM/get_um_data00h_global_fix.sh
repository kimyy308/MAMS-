#!/bin/sh

##fulldate=`date --date="2 days ago" +%Y%m%d`
##year=`echo $fulldate | cut -c1-4`
##month=`echo $fulldate | cut -c5-6`
##day=`echo $fulldate | cut -c7-8`

## Someday If there is no data, this script fill it from forecast file of yesterday or past

year=2019
month=05  #01, 02 ~, fixed
day2=21  
endday=21
#for (( day2; day2<=endday; day2++ )) do
day=`printf "%02d" ${day2}`

lag_day=-1 # -1 = yesterady, -2 = 2 days ago(minimum)

pastdate=`date -d "${year}${month}${day2} ${lag_day} day" +%Y%m%d`
pastyear=`echo $pastdate | cut -c1-4`
pastmonth=`echo $pastdate | cut -c5-6`
pastday=`echo $pastdate | cut -c7-8`

workdir=/home/auto/MAMS/Data/UM_global_10km

cd $workdir

datadir=$workdir/${year}${month}${day}
mkdir -p ${datadir}
cd ${datadir}
 
host='147.47.242.138'
DIR='UM/GRIP2/'
ID=um
PW=getdata1234

if [ "$lag_day" -eq -1 ]; then
ftp -ni $host <<EOF
user $ID $PW
cd UM/GRIP2/$pastyear/$pastmonth/$pastday
pwd
bin 
mget g120_v070_erea_unis_h024.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h027.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h030.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h033.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h036.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h039.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h042.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h045.${pastyear}${pastmonth}${pastday}00.gb2
quit
EOF

ln -sf g120_v070_erea_unis_h024.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h000.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h027.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h003.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h030.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h006.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h033.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h009.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h036.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h012.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h039.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h015.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h042.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h018.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h045.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h021.${year}${month}${day}00.gb2

elif [ "$lag_day" -eq -2 ]; then
ftp -ni $host <<EOF
user $ID $PW
cd UM/GRIP2/$pastyear/$pastmonth/$pastday
pwd
bin 
mget g120_v070_erea_unis_h048.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h051.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h054.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h057.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h060.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h063.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h066.${pastyear}${pastmonth}${pastday}00.gb2
mget g120_v070_erea_unis_h069.${pastyear}${pastmonth}${pastday}00.gb2
quit
EOF

ln -sf g120_v070_erea_unis_h048.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h000.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h051.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h003.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h054.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h006.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h057.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h009.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h060.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h012.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h063.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h015.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h066.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h018.${year}${month}${day}00.gb2
ln -sf g120_v070_erea_unis_h069.${pastyear}${pastmonth}${pastday}00.gb2 g120_v070_erea_unis_h021.${year}${month}${day}00.gb2

fi

#done
