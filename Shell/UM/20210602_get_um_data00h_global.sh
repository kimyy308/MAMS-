#!/bin/sh
# Updated, 19-Jan-2021 by Yong-Yub Kim (forecast year edited)

#fulldate=`date --date="2 days ago" +%Y%m%d`
fulldate=$1
MAMS=$2
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`
workdir=$MAMS/Data/UM_global_10km
#--- remove: forecast directory ---

cd $workdir

rm_sday=0
rm_mday=3
for (( rm_sday; rm_sday<=rm_mday; rm_sday++ )) do
        rm_day=`date -d "$fulldate ${rm_sday} day" +%Y%m%d`
        echo '${rm_day}='${rm_day}
        rm -rf ${rm_day}_forecast
done

datadir=$workdir/${year}${month}${day}
mkdir -p ${datadir}
cd ${datadir}
 
host='147.47.242.138'
#DIR='UM/GRIP2/'i
DIR='UM/'i
#--- ID/PW,folder change ----------------------------------#
# since 2020.01.22 --- edit ebcho -------------------------#
# ID=UM
# PW=getdata1234
# 42line: cd UM/GRIP2/$year/$month/$day
# 98line: cd UM/GRIP2/$year_fix/$month_fix/$day_fix
# new ID: seaenv
# net PW: Dr^zL7#4
#---------------------------------------------------------#
ID=seaenv
PW=Dr^zL7#4

ftp -ni $host <<EOF
user $ID $PW
cd UM/
pwd
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


##for (( month=1; month<=)) do
lag_day=1
lag_max=3
for (( lag_day; lag_day<=lag_max; lag_day++ )) do

        cd $workdir
        #--- set the time of download data -----------------
        fore_date=`date -d "$fulldate ${lag_day} day" +%Y%m%d`
        data_dir=${fore_date}_forecast
        echo '$lag_day ='$lag_day
        echo '$fore_date ='$fore_date
        
        year=`echo $fore_date | cut -c1-4`
        month=`echo $fore_date | cut -c5-6`
        day=`echo $fore_date | cut -c7-8`
        if [ $lag_day -eq 1 ]; then
          year_fix=`echo $fore_date | cut -c1-4`
          month_fix=`echo $fore_date | cut -c5-6`
          day_fix=`echo $fore_date | cut -c7-8`
        fi
        #--- set the data number of target forecast day -------------
        case $lag_day in
        1) 
                mkdir ${data_dir}
                cd ${data_dir}
                arr_i=(000 003 006 009 012 015 018 021)
                ;;  
        2)    
                mkdir ${data_dir}
                cd ${data_dir}
                arr_i=(024 027 030 033 036 039 042 045)
                ;;  
        3)  
                mkdir ${data_dir}
                cd ${data_dir}
                arr_i=(048 051 054 057 060 063 066 069)
                ;;
        esac
ftp -ni $host <<EOF
        user $ID $PW
        cd UM
        pwd
        bin 
        mget g120_v070_erea_unis_h${arr_i[0]}.${year_fix}${month_fix}${day_fix}00.gb2
        mget g120_v070_erea_unis_h${arr_i[1]}.${year_fix}${month_fix}${day_fix}00.gb2
        mget g120_v070_erea_unis_h${arr_i[2]}.${year_fix}${month_fix}${day_fix}00.gb2
        mget g120_v070_erea_unis_h${arr_i[3]}.${year_fix}${month_fix}${day_fix}00.gb2
        mget g120_v070_erea_unis_h${arr_i[4]}.${year_fix}${month_fix}${day_fix}00.gb2
        mget g120_v070_erea_unis_h${arr_i[5]}.${year_fix}${month_fix}${day_fix}00.gb2
        mget g120_v070_erea_unis_h${arr_i[6]}.${year_fix}${month_fix}${day_fix}00.gb2
        mget g120_v070_erea_unis_h${arr_i[7]}.${year_fix}${month_fix}${day_fix}00.gb2
        quit
EOF
done

#sh -xv $MAMS/Source/Shell/UM/UM_convert_nc.sh
