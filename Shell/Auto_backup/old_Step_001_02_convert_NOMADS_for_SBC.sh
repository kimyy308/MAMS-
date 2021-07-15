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

