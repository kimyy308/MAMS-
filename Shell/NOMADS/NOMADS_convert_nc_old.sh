#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

#fulldate=`date --date="2 days ago" +%Y%m%d`
#year=`echo $fulldate | cut -c1-4`
#month=`echo $fulldate | cut -c5-6`
#day=`echo $fulldate | cut -c7-8`

year=2019
month=05
day=1
daymax=29
for (( day; day<=daymax; day++ )) do
day2=`printf "%02d" ${day}`

fulldate=${year}${month}${day2}
#--- remove: forecast folder ------------
cd /home/auto/MAMS/Data/NOMADS/gfs_0p25/

#mkdir -p $fulldate
cd $fulldate
mkdir -p nc_pieces

#TMP 2m above ground (#260 in gdas file, #280 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 260 gdas.t00z.pgrb2.0p25.f000 -netcdf nc_pieces/t2m_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 280 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/t2m_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 260 gdas.t06z.pgrb2.0p25.f000 -netcdf nc_pieces/t2m_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 280 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/t2m_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 260 gdas.t12z.pgrb2.0p25.f000 -netcdf nc_pieces/t2m_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 280 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/t2m_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 260 gdas.t18z.pgrb2.0p25.f000 -netcdf nc_pieces/t2m_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 280 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/t2m_${fulldate}_21h.nc

#UGRD 10m above ground (#265 in gdas file, #287 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 265 gdas.t00z.pgrb2.0p25.f000 -netcdf nc_pieces/u10m_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 287 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/u10m_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 265 gdas.t06z.pgrb2.0p25.f000 -netcdf nc_pieces/u10m_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 287 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/u10m_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 265 gdas.t12z.pgrb2.0p25.f000 -netcdf nc_pieces/u10m_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 287 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/u10m_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 265 gdas.t18z.pgrb2.0p25.f000 -netcdf nc_pieces/u10m_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 287 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/u10m_${fulldate}_21h.nc

#VGRD 10m above ground (#266 in gdas file, #288 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 266 gdas.t00z.pgrb2.0p25.f000 -netcdf nc_pieces/v10m_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 288 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/v10m_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 266 gdas.t06z.pgrb2.0p25.f000 -netcdf nc_pieces/v10m_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 288 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/v10m_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 266 gdas.t12z.pgrb2.0p25.f000 -netcdf nc_pieces/v10m_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 288 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/v10m_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 266 gdas.t18z.pgrb2.0p25.f000 -netcdf nc_pieces/v10m_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 288 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/v10m_${fulldate}_21h.nc

#PRMSL pressure reduced to MSL (#351 in gdas file, #414 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 351 gdas.t00z.pgrb2.0p25.f000 -netcdf nc_pieces/psl_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 414 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/psl_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 351 gdas.t06z.pgrb2.0p25.f000 -netcdf nc_pieces/psl_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 414 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/psl_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 351 gdas.t12z.pgrb2.0p25.f000 -netcdf nc_pieces/psl_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 414 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/psl_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 351 gdas.t18z.pgrb2.0p25.f000 -netcdf nc_pieces/psl_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 414 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/psl_${fulldate}_21h.nc

##SPFH 2m above ground (#261 in gdas file, #281 in forcast file)
##~/MAMS/App/kwgrib2/kwgrib -d 261 gdas.t00z.pgrb2.0p25.f000 -netcdf nc_pieces/sphum_${fulldate}_00h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 281 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/sphum_${fulldate}_03h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 261 gdas.t06z.pgrb2.0p25.f000 -netcdf nc_pieces/sphum_${fulldate}_06h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 281 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/sphum_${fulldate}_09h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 261 gdas.t12z.pgrb2.0p25.f000 -netcdf nc_pieces/sphum_${fulldate}_12h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 281 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/sphum_${fulldate}_15h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 261 gdas.t18z.pgrb2.0p25.f000 -netcdf nc_pieces/sphum_${fulldate}_18h.nc
##~/MAMS/App/kwgrib2/kwgrib -d 281 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/sphum_${fulldate}_21h.nc

#RH 2m above ground (#263 in gdas file, #283 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 263 gdas.t00z.pgrb2.0p25.f000 -netcdf nc_pieces/rhum_${fulldate}_00h.nc
~/MAMS/App/kwgrib2/kwgrib -d 283 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/rhum_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 263 gdas.t06z.pgrb2.0p25.f000 -netcdf nc_pieces/rhum_${fulldate}_06h.nc
~/MAMS/App/kwgrib2/kwgrib -d 283 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/rhum_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 263 gdas.t12z.pgrb2.0p25.f000 -netcdf nc_pieces/rhum_${fulldate}_12h.nc
~/MAMS/App/kwgrib2/kwgrib -d 283 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/rhum_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 263 gdas.t18z.pgrb2.0p25.f000 -netcdf nc_pieces/rhum_${fulldate}_18h.nc
~/MAMS/App/kwgrib2/kwgrib -d 283 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/rhum_${fulldate}_21h.nc

#DSWRF surface (#334 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 334 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/swrad_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 334 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/swrad_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 334 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/swrad_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 334 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/swrad_${fulldate}_21h.nc

#PRATE surface (#291 in forcast file)
~/MAMS/App/kwgrib2/kwgrib -d 291 gdas.t00z.pgrb2.0p25.f003 -netcdf nc_pieces/prate_${fulldate}_03h.nc
~/MAMS/App/kwgrib2/kwgrib -d 291 gdas.t06z.pgrb2.0p25.f003 -netcdf nc_pieces/prate_${fulldate}_09h.nc
~/MAMS/App/kwgrib2/kwgrib -d 291 gdas.t12z.pgrb2.0p25.f003 -netcdf nc_pieces/prate_${fulldate}_15h.nc
~/MAMS/App/kwgrib2/kwgrib -d 291 gdas.t18z.pgrb2.0p25.f003 -netcdf nc_pieces/prate_${fulldate}_21h.nc

done
