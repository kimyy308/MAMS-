#!/bin/sh

workdir=/data1/stlee/ext_hdd/NOMADS/
cd $workdir 
year=1993
##for (( year=2012; year<=2019; year++ )) do
  ##yeartwo=`expr ${year} - 1`
  for (( month=1; month<=12; month++ )) do
    monthtwo=`printf "%02d" $month`
##    mkdir -p ${workdir}${year}
    cd ${workdir}${year}

    	/data1/auto/App/kwgrib2/kwgrib wnd10m.gdas.${year}${monthtwo}.grb2 -netcdf wnd10m.gdas.${year}${monthtwo}.nc

    	/data1/auto/App/kwgrib2/kwgrib dswsfc.gdas.${year}${monthtwo}.grb2 -netcdf dswsfc.gdas.${year}${monthtwo}.nc

    	/data1/auto/App/kwgrib2/kwgrib uswsfc.gdas.${year}${monthtwo}.grb2 -netcdf uswsfc.gdas.${year}${monthtwo}.nc

    	/data1/auto/App/kwgrib2/kwgrib q2m.gdas.${year}${monthtwo}.grb2 -netcdf q2m.gdas.${year}${monthtwo}.nc

    	/data1/auto/App/kwgrib2/kwgrib tmp2m.gdas.${year}${monthtwo}.grb2 -netcdf tmp2m.gdas.${year}${monthtwo}.nc

    	/data1/auto/App/kwgrib2/kwgrib pressfc.gdas.${year}${monthtwo}.grb2 -netcdf pressfc.gdas.${year}${monthtwo}.nc

  done
##done
