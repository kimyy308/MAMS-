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

#--- remove: forecast folder ------------
cd $MAMS/Data/UM_global_10km/

cd $fulldate
mkdir -p nc_pieces

#TMP 1.5m above ground (#39)
~/MAMS/App/kwgrib2/kwgrib -d 39 g120_v070_erea_unis_h000.${year}${month}${day}00.gb2 -netcdf nc_pieces/tmp_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 39 g120_v070_erea_unis_h003.${year}${month}${day}00.gb2 -netcdf nc_pieces/tmp_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 39 g120_v070_erea_unis_h006.${year}${month}${day}00.gb2 -netcdf nc_pieces/tmp_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 39 g120_v070_erea_unis_h009.${year}${month}${day}00.gb2 -netcdf nc_pieces/tmp_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 39 g120_v070_erea_unis_h012.${year}${month}${day}00.gb2 -netcdf nc_pieces/tmp_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 39 g120_v070_erea_unis_h015.${year}${month}${day}00.gb2 -netcdf nc_pieces/tmp_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 39 g120_v070_erea_unis_h018.${year}${month}${day}00.gb2 -netcdf nc_pieces/tmp_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 39 g120_v070_erea_unis_h021.${year}${month}${day}00.gb2 -netcdf nc_pieces/tmp_${fulldate}_21h.nc

#UGRD 10m above ground (#26)
~/MAMS/App/kwgrib2/kwgrib -d 26 g120_v070_erea_unis_h000.${year}${month}${day}00.gb2 -netcdf nc_pieces/u10m_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 26 g120_v070_erea_unis_h003.${year}${month}${day}00.gb2 -netcdf nc_pieces/u10m_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 26 g120_v070_erea_unis_h006.${year}${month}${day}00.gb2 -netcdf nc_pieces/u10m_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 26 g120_v070_erea_unis_h009.${year}${month}${day}00.gb2 -netcdf nc_pieces/u10m_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 26 g120_v070_erea_unis_h012.${year}${month}${day}00.gb2 -netcdf nc_pieces/u10m_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 26 g120_v070_erea_unis_h015.${year}${month}${day}00.gb2 -netcdf nc_pieces/u10m_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 26 g120_v070_erea_unis_h018.${year}${month}${day}00.gb2 -netcdf nc_pieces/u10m_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 26 g120_v070_erea_unis_h021.${year}${month}${day}00.gb2 -netcdf nc_pieces/u10m_${fulldate}_21h.nc

#VGRD 10m above ground (#27)
~/MAMS/App/kwgrib2/kwgrib -d 27 g120_v070_erea_unis_h000.${year}${month}${day}00.gb2 -netcdf nc_pieces/v10m_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 27 g120_v070_erea_unis_h003.${year}${month}${day}00.gb2 -netcdf nc_pieces/v10m_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 27 g120_v070_erea_unis_h006.${year}${month}${day}00.gb2 -netcdf nc_pieces/v10m_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 27 g120_v070_erea_unis_h009.${year}${month}${day}00.gb2 -netcdf nc_pieces/v10m_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 27 g120_v070_erea_unis_h012.${year}${month}${day}00.gb2 -netcdf nc_pieces/v10m_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 27 g120_v070_erea_unis_h015.${year}${month}${day}00.gb2 -netcdf nc_pieces/v10m_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 27 g120_v070_erea_unis_h018.${year}${month}${day}00.gb2 -netcdf nc_pieces/v10m_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 27 g120_v070_erea_unis_h021.${year}${month}${day}00.gb2 -netcdf nc_pieces/v10m_${fulldate}_21h.nc

#PRMSL pressure reduced to MSL (#107)
~/MAMS/App/kwgrib2/kwgrib -d 107 g120_v070_erea_unis_h000.${year}${month}${day}00.gb2 -netcdf nc_pieces/psl_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 107 g120_v070_erea_unis_h003.${year}${month}${day}00.gb2 -netcdf nc_pieces/psl_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 107 g120_v070_erea_unis_h006.${year}${month}${day}00.gb2 -netcdf nc_pieces/psl_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 107 g120_v070_erea_unis_h009.${year}${month}${day}00.gb2 -netcdf nc_pieces/psl_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 107 g120_v070_erea_unis_h012.${year}${month}${day}00.gb2 -netcdf nc_pieces/psl_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 107 g120_v070_erea_unis_h015.${year}${month}${day}00.gb2 -netcdf nc_pieces/psl_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 107 g120_v070_erea_unis_h018.${year}${month}${day}00.gb2 -netcdf nc_pieces/psl_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 107 g120_v070_erea_unis_h021.${year}${month}${day}00.gb2 -netcdf nc_pieces/psl_${fulldate}_21h.nc

#RH 1.5 m above ground (#44, Relative Humidity)
~/MAMS/App/kwgrib2/kwgrib -d 44 g120_v070_erea_unis_h000.${year}${month}${day}00.gb2 -netcdf nc_pieces/rhum_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 44 g120_v070_erea_unis_h003.${year}${month}${day}00.gb2 -netcdf nc_pieces/rhum_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 44 g120_v070_erea_unis_h006.${year}${month}${day}00.gb2 -netcdf nc_pieces/rhum_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 44 g120_v070_erea_unis_h009.${year}${month}${day}00.gb2 -netcdf nc_pieces/rhum_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 44 g120_v070_erea_unis_h012.${year}${month}${day}00.gb2 -netcdf nc_pieces/rhum_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 44 g120_v070_erea_unis_h015.${year}${month}${day}00.gb2 -netcdf nc_pieces/rhum_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 44 g120_v070_erea_unis_h018.${year}${month}${day}00.gb2 -netcdf nc_pieces/rhum_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 44 g120_v070_erea_unis_h021.${year}${month}${day}00.gb2 -netcdf nc_pieces/rhum_${fulldate}_21h.nc

#TPR surface (#72, Total Precipitation Rate)
~/MAMS/App/kwgrib2/kwgrib -d 72 g120_v070_erea_unis_h000.${year}${month}${day}00.gb2 -netcdf nc_pieces/tprep_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 72 g120_v070_erea_unis_h003.${year}${month}${day}00.gb2 -netcdf nc_pieces/tprep_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 72 g120_v070_erea_unis_h006.${year}${month}${day}00.gb2 -netcdf nc_pieces/tprep_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 72 g120_v070_erea_unis_h009.${year}${month}${day}00.gb2 -netcdf nc_pieces/tprep_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 72 g120_v070_erea_unis_h012.${year}${month}${day}00.gb2 -netcdf nc_pieces/tprep_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 72 g120_v070_erea_unis_h015.${year}${month}${day}00.gb2 -netcdf nc_pieces/tprep_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 72 g120_v070_erea_unis_h018.${year}${month}${day}00.gb2 -netcdf nc_pieces/tprep_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 72 g120_v070_erea_unis_h021.${year}${month}${day}00.gb2 -netcdf nc_pieces/tprep_${fulldate}_21h.nc

#??? surface (#1, Net Down Surface SW Flux)
~/MAMS/App/kwgrib2/kwgrib -d 1 g120_v070_erea_unis_h000.${year}${month}${day}00.gb2 -netcdf nc_pieces/swrad_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 1 g120_v070_erea_unis_h003.${year}${month}${day}00.gb2 -netcdf nc_pieces/swrad_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 1 g120_v070_erea_unis_h006.${year}${month}${day}00.gb2 -netcdf nc_pieces/swrad_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 1 g120_v070_erea_unis_h009.${year}${month}${day}00.gb2 -netcdf nc_pieces/swrad_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 1 g120_v070_erea_unis_h012.${year}${month}${day}00.gb2 -netcdf nc_pieces/swrad_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 1 g120_v070_erea_unis_h015.${year}${month}${day}00.gb2 -netcdf nc_pieces/swrad_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 1 g120_v070_erea_unis_h018.${year}${month}${day}00.gb2 -netcdf nc_pieces/swrad_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 1 g120_v070_erea_unis_h021.${year}${month}${day}00.gb2 -netcdf nc_pieces/swrad_${fulldate}_21h.nc

#---- get: forecast data during 8 days ----------------
lag_day=1
lag_max=3

for (( lag_day; lag_day<=lag_max; lag_day++ )) do
  #--- move to data of NOMAD folder ------------------
  cd $MAMS/Data/UM_global_10km/
  
  #--- set the time of download data -----------------
  fore_date=`date -d "$fulldate ${lag_day} day" +%Y%m%d`
  data_dir=${fore_date}_forecast
  echo '$lag_day = '$lag_day
  echo '$fore_date = '$fore_date
  if [[ "$fore_date" -le -1 ]]; then
    echo 'abc'
    year=`echo $fore_date | cut -c1-4`
    month=`echo $fore_date | cut -c5-6`
    day=`echo $fore_date | cut -c7-8`
  fi
  year2=`echo $fore_date | cut -c1-4`
  month2=`echo $fore_date | cut -c5-6`
  day2=`echo $fore_date | cut -c7-8`

  
  
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
     4)
        mkdir ${data_dir}
        cd ${data_dir}
        arr_i=(072 075 078 081 084 087 090 093)
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
    #TMP 1.5m above ground (#39)
    ~/MAMS/App/kwgrib2/kwgrib -d 39 ./../${year}${month}${day}/g120_v070_erea_unis_h0${houridx}.${year}${month}${day}00.gb2 -netcdf nc_pieces/tmp_${year2}${month2}${day2}_${houridx}h.nc
    #UGRD 10m above ground (#26)
    ~/MAMS/App/kwgrib2/kwgrib -d 26 ./../${year}${month}${day}/g120_v070_erea_unis_h0${houridx}.${year}${month}${day}00.gb2 -netcdf nc_pieces/u10m_${year2}${month2}${day2}_${houridx}h.nc
    #VGRD 10m above ground (#27)
    ~/MAMS/App/kwgrib2/kwgrib -d 27 ./../${year}${month}${day}/g120_v070_erea_unis_h0${houridx}.${year}${month}${day}00.gb2 -netcdf nc_pieces/v10m_${year2}${month2}${day2}_${houridx}h.nc
    #PRMSL pressure reduced to MSL (#107)
    ~/MAMS/App/kwgrib2/kwgrib -d 107 ./../${year}${month}${day}/g120_v070_erea_unis_h0${houridx}.${year}${month}${day}00.gb2 -netcdf nc_pieces/psl_${year2}${month2}${day2}_${houridx}h.nc
    #RH 1.5 m above ground (#44, Relative Humidity)
    ~/MAMS/App/kwgrib2/kwgrib -d 44 ./../${year}${month}${day}/g120_v070_erea_unis_h0${houridx}.${year}${month}${day}00.gb2 -netcdf nc_pieces/rhum_${year2}${month2}${day2}_${houridx}h.nc
    #??? surface (#1, Net Down Surface SW Flux)
    ~/MAMS/App/kwgrib2/kwgrib -d 1 ./../${year}${month}${day}/g120_v070_erea_unis_h0${houridx}.${year}${month}${day}00.gb2 -netcdf nc_pieces/swrad_${year2}${month2}${day2}_${houridx}h.nc
    #TPR surface (#72, Total Precipitation Rate)
    ~/MAMS/App/kwgrib2/kwgrib -d 72 ./../${year}${month}${day}/g120_v070_erea_unis_h0${houridx}.${year}${month}${day}00.gb2 -netcdf nc_pieces/tprep_${year2}${month2}${day2}_${houridx}h.nc
  done

done










