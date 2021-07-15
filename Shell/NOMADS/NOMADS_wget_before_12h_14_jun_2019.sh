#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

fulldate=`date --date="2 days ago" +%Y%m%d`
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`

#--- remove: forecast folder ------------
cd /home/auto/MAMS/Data/NOMADS/gfs_0p25/
#rm -rf ${fulldate}_forecast

rm_sday=-2
rm_mday=6
for (( rm_sday; rm_sday<rm_mday; rm_sday++ )) do
	rm_day=`date -d "$today ${rm_sday} day" +%Y%m%d`
	echo '${rm_day}='${rm_day}
	rm -rf ${rm_day}_forecast
done

# should insert remove all forecast folder !! -ss 2019.03.19

#--- get: now data ---------------------------------
mkdir -p $fulldate
cd $fulldate
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t00z.pgrb2.0p25.f000
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t00z.pgrb2.0p25.f000.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f024
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f024.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t00z.pgrb2.0p25.f003
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t00z.pgrb2.0p25.f003.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t06z.pgrb2.0p25.f000
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t06z.pgrb2.0p25.f000.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t06z.pgrb2.0p25.f003
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t06z.pgrb2.0p25.f003.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t12z.pgrb2.0p25.f000
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t12z.pgrb2.0p25.f000.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t12z.pgrb2.0p25.f003
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t12z.pgrb2.0p25.f003.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t18z.pgrb2.0p25.f000
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t18z.pgrb2.0p25.f000.idx
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t18z.pgrb2.0p25.f003
wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas."${fulldate}/gdas.t18z.pgrb2.0p25.f003.idx

#---- end of get: now data -------------------------


##---- get: forecast data during 8 days ----------------
#lag_day=-1
#lag_max=6
#---- get: forecast data during 3 days ----------------
lag_day=-1
lag_max=1

for (( lag_day; lag_day<=lag_max; lag_day++ )) do
	#--- move to data of NOMAD folder ------------------
	cd /home/auto/MAMS/Data/NOMADS/gfs_0p25/

	#--- set the time of download data -----------------
        fore_date=`date -d "$today ${lag_day} day" +%Y%m%d`
	data_dir=${fore_date}_forecast
	echo '$lag_day ='$lag_day
	echo '$fore_date ='$fore_date
	
	#--- set the data number of target forecast day -------------
	case $lag_day in
	-2)
	        mkdir ${data_dir}
	        cd ${data_dir}
		arr_i=(000 003 006 009 012 015 018 021)
		;;
	-1)	
	        mkdir ${data_dir}
	        cd ${data_dir}
		arr_i=(024 027 030 033 036 039 042 045)
		;;
	0)
	        mkdir ${data_dir}
	        cd ${data_dir}
		arr_i=(048 051 054 057 060 063 066 069)
                ;;
	1)
	        mkdir ${data_dir}
	        cd ${data_dir}
		arr_i=(072 075 078 081 084 087 090 093)
	        ;;
	2)
	        mkdir ${data_dir}
	        cd ${data_dir}
		arr_i=(096 099 102 105 108 111 114 117)
	        ;;
	3)
	        mkdir ${data_dir}
	        cd ${data_dir}
		arr_i=(120 123 126 129 132 135 138 141)
	        ;;
	4)
	        mkdir ${data_dir}
	        cd ${data_dir}
		arr_i=(144 147 150 153 156 159 162 165)
	        ;;
	5)       
		mkdir ${data_dir}
	        cd ${data_dir}
		arr_i=(168 171 174 177 180 183 186 189)
	        ;;
	esac
	#--- end of: set the data number ---------------------------------

	#--- start: get data at each forcast day ---------------------------
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[0]}
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[0]}.idx
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[1]}
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[1]}.idx
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[2]}
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[2]}.idx
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[3]}
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[3]}.idx
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[4]}
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[4]}.idx
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[5]}
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[5]}.idx
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[6]}
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[6]}.idx
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[7]}
	wget "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs."${fulldate}00/gfs.t00z.pgrb2.0p25.f${arr_i[7]}.idx
	#--- end of: get data at each forcast day ---------------------------
	
done









