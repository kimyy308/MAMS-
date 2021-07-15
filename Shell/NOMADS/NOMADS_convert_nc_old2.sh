#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

#fulldate=`date --date="2 days ago" +%Y%m%d`
fulldate=$1
MAMS=$2
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`

cd $MAMS/Data/NOMADS/gfs_0p25/

#mkdir -p $fulldate
cd $fulldate
mkdir -p nc_pieces

#TMP 2m above ground (#415 in gdas file, #435 in forcast file)
# /home/auto/MAMS/App/kwgrib2/kwgrib gdas.t00z.pgrb2.0p25.f003 -s |grep ':UGRD:' | grep '10 m' | /home/auto/MAMS/App/kwgrib2/kwgrib -i gdas.t00z.pgrb2.0p25.f003 -netcdf test.nc
~/MAMS/App/kwgrib2/kwgrib -d 415 gdas.t00z.pgrb2.0p25.f000 -netcdf nc_pieces/t2m_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 435 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/t2m_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 415 gdas.t06z.pgrb2.0p25.f000 -netcdf nc_pieces/t2m_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 435 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/t2m_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 415 gdas.t12z.pgrb2.0p25.f000 -netcdf nc_pieces/t2m_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 435 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/t2m_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 415 gdas.t18z.pgrb2.0p25.f000 -netcdf nc_pieces/t2m_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 435 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/t2m_${fulldate}_21h.nc

#UGRD 10m above ground (#420 in gdas file, #442 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 420 gdas.t00z.pgrb2.0p25.f000 -netcdf nc_pieces/u10m_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 442 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/u10m_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 420 gdas.t06z.pgrb2.0p25.f000 -netcdf nc_pieces/u10m_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 442 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/u10m_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 420 gdas.t12z.pgrb2.0p25.f000 -netcdf nc_pieces/u10m_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 442 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/u10m_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 420 gdas.t18z.pgrb2.0p25.f000 -netcdf nc_pieces/u10m_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 442 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/u10m_${fulldate}_21h.nc

#VGRD 10m above ground (#421 in gdas file, #443 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 421 gdas.t00z.pgrb2.0p25.f000 -netcdf nc_pieces/v10m_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 443 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/v10m_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 421 gdas.t06z.pgrb2.0p25.f000 -netcdf nc_pieces/v10m_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 443 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/v10m_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 421 gdas.t12z.pgrb2.0p25.f000 -netcdf nc_pieces/v10m_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 443 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/v10m_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 421 gdas.t18z.pgrb2.0p25.f000 -netcdf nc_pieces/v10m_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 443 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/v10m_${fulldate}_21h.nc

#PRMSL pressure reduced to MSL (#519 in gdas file, #585 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 519 gdas.t00z.pgrb2.0p25.f000 -netcdf nc_pieces/psl_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 585 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/psl_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 519 gdas.t06z.pgrb2.0p25.f000 -netcdf nc_pieces/psl_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 585 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/psl_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 519 gdas.t12z.pgrb2.0p25.f000 -netcdf nc_pieces/psl_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 585 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/psl_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 519 gdas.t18z.pgrb2.0p25.f000 -netcdf nc_pieces/psl_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 585 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/psl_${fulldate}_21h.nc

##SPFH 2m above ground (#261 in gdas file, #281 in forcast file)
##~/MAMS/App/kwgrib2/kwgrib -d 261 gdas.t00z.pgrb2.0p25.f000 -netcdf nc_pieces/sphum_${fulldate}_00h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 281 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/sphum_${fulldate}_03h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 261 gdas.t06z.pgrb2.0p25.f000 -netcdf nc_pieces/sphum_${fulldate}_06h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 281 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/sphum_${fulldate}_09h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 261 gdas.t12z.pgrb2.0p25.f000 -netcdf nc_pieces/sphum_${fulldate}_12h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 281 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/sphum_${fulldate}_15h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 261 gdas.t18z.pgrb2.0p25.f000 -netcdf nc_pieces/sphum_${fulldate}_18h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 281 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/sphum_${fulldate}_21h.nc

#RH 2m above ground (#418 in gdas file, #438 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 418 gdas.t00z.pgrb2.0p25.f000 -netcdf nc_pieces/rhum_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 438 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/rhum_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 418 gdas.t06z.pgrb2.0p25.f000 -netcdf nc_pieces/rhum_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 438 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/rhum_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 418 gdas.t12z.pgrb2.0p25.f000 -netcdf nc_pieces/rhum_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 438 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/rhum_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 418 gdas.t18z.pgrb2.0p25.f000 -netcdf nc_pieces/rhum_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 438 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/rhum_${fulldate}_21h.nc

#DSWRF surface (#497 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 497 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/swrad_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 497 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/swrad_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 497 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/swrad_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 497 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/swrad_${fulldate}_21h.nc

#PRATE surface (#448 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 448 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/prate_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 448 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/prate_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 448 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/prate_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 448 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/prate_${fulldate}_21h.nc


##---- get: forecast data during 8 days ----------------
#lag_day=-1
#lag_max=6
#---- get: forecast data during 3 days ----------------
lag_day=1
lag_max=3

for (( lag_day; lag_day<=lag_max; lag_day++ )) do
  #--- move to data of NOMAD folder ------------------
  cd $MAMS/Data/NOMADS/gfs_0p25/
  
  #--- set the time of download data -----------------
  fore_date=`date -d "$fulldate ${lag_day} day" +%Y%m%d`
  data_dir=${fore_date}_forecast
  echo '$lag_day ='$lag_day
  echo '$fore_date ='$fore_date
  #--- set the data number of target forecast day -------------
  case $lag_day in
     0)
        mkdir ${data_dir}
        cd ${data_dir}
        arr_i=(000 003 006 009 012 015 018 021)
        ;;
     1)	
        mkdir ${data_dir}
        cd ${data_dir}
        arr_i=(024 027 030 033 036 039 042 045)
        ;;
     2)
        mkdir ${data_dir}
        cd ${data_dir}
        arr_i=(048 051 054 057 060 063 066 069)
        ;;
     3)
        mkdir ${data_dir}
        cd ${data_dir}
        arr_i=(072 075 078 081 084 087 090 093)
        ;;
     4)
        mkdir ${data_dir}
        cd ${data_dir}
        arr_i=(096 099 102 105 108 111 114 117)
        ;;
     5)
        mkdir ${data_dir}
        cd ${data_dir}
        arr_i=(120 123 126 129 132 135 138 141)
        ;;
     6)
        mkdir ${data_dir}
        cd ${data_dir}
        arr_i=(144 147 150 153 156 159 162 165)
        ;;
     7)       
        mkdir ${data_dir}
        cd ${data_dir}
        arr_i=(168 171 174 177 180 183 186 189)
        ;;
  esac
  #--- end of: set the data number ---------------------------------
     
  mkdir -p nc_pieces
  arridx=0;
  arridx_max=7;
  for (( arridx; arridx<=arridx_max; arridx++ )) do
    houridx1=${arridx}
    houridx2=`echo ${arridx}*3|bc`
    houridx=`printf "%02d" ${houridx2}`
    #TMP 2m above ground (#435 in forcast file)
    ~/MAMS/App/kwgrib2/kwgrib -d 435 gfs.t00z.pgrb2.0p25.f${arr_i[${arridx}]} -netcdf nc_pieces/t2m_${fore_date}_${houridx}h.nc
    #UGRD 10m above ground (#442 in forcast file)
    ~/MAMS/App/kwgrib2/kwgrib -d 442 gfs.t00z.pgrb2.0p25.f${arr_i[${arridx}]} -netcdf nc_pieces/u10m_${fore_date}_${houridx}h.nc
    #VGRD 10m above ground (#443 in forcast file)
    ~/MAMS/App/kwgrib2/kwgrib -d 443 gfs.t00z.pgrb2.0p25.f${arr_i[${arridx}]} -netcdf nc_pieces/v10m_${fore_date}_${houridx}h.nc
    #PRMSL pressure reduced to MSL (#585 in forcast file)
    ~/MAMS/App/kwgrib2/kwgrib -d 585 gfs.t00z.pgrb2.0p25.f${arr_i[${arridx}]} -netcdf nc_pieces/psl_${fore_date}_${houridx}h.nc
##    #SPFH 2m above ground (#282 in forcast file)
##    ~/MAMS/App/kwgrib2/kwgrib -d 282 gfs.t00z.pgrb2.0p25.f${arr_i[${arridx}]} -netcdf nc_pieces/sphum_${fore_date}_${houridx}h.nc
    #RH 2m above ground (#438 in forcast file)
    ~/MAMS/App/kwgrib2/kwgrib -d 438 gfs.t00z.pgrb2.0p25.f${arr_i[${arridx}]} -netcdf nc_pieces/rhum_${fore_date}_${houridx}h.nc
    #DSWRF surface (#335 in forcast file. [0h, 6h, 12h, 18h --> 6h forecast ave, 3h, 9h, 15h, 21h --> 3h forecast ave]) 
    ~/MAMS/App/kwgrib2/kwgrib -d 497 gfs.t00z.pgrb2.0p25.f${arr_i[${arridx}]} -netcdf nc_pieces/swrad_${fore_date}_${houridx}h.nc
    #PRATE surface (#448 in forcast file. [0h, 6h, 12h, 18h --> 6h forecast ave, 3h, 9h, 15h, 21h --> 3h forecast ave])
    ~/MAMS/App/kwgrib2/kwgrib -d 448 gfs.t00z.pgrb2.0p25.f${arr_i[${arridx}]} -netcdf nc_pieces/prate_${fore_date}_${houridx}h.nc
  done
done








