#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

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
fulldate=${year}${month}${day}

#--- remove: forecast folder ------------
cd /home/auto/MAMS/Data/UM_global_10km/

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

done









