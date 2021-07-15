#!/bin/sh

workdir=/data1/stlee/ext_hdd/NOMADS/
cd $workdir 
##year=1993
for (( year=1979; year<=2017; year++ )) do
  ##yeartwo=`expr ${year} - 1`
  for (( month=1; month<=12; month++ )) do
    monthtwo=`printf "%02d" $month`
    mkdir -p ${workdir}${year}
    cd ${workdir}${year}

    until [ -e "wnd10m.gdas.${year}${monthtwo}.grb2" ]
    do
    	wget ftp://nomads.ncdc.noaa.gov/CFSR/HP_time_series/${year}${monthtwo}/wnd10m.gdas.${year}${monthtwo}.grb2
    done

    until [ -e "dswsfc.gdas.${year}${monthtwo}.grb2" ]
    do
    	wget ftp://nomads.ncdc.noaa.gov/CFSR/HP_time_series/${year}${monthtwo}/dswsfc.gdas.${year}${monthtwo}.grb2
    done

    until [ -e "uswsfc.gdas.${year}${monthtwo}.grb2" ]
    do
    	wget ftp://nomads.ncdc.noaa.gov/CFSR/HP_time_series/${year}${monthtwo}/uswsfc.gdas.${year}${monthtwo}.grb2
    done

    until [ -e "q2m.gdas.${year}${monthtwo}.grb2" ]
    do
    	wget ftp://nomads.ncdc.noaa.gov/CFSR/HP_time_series/${year}${monthtwo}/q2m.gdas.${year}${monthtwo}.grb2
    done

    until [ -e "tmp2m.gdas.${year}${monthtwo}.grb2" ]
    do
    	wget ftp://nomads.ncdc.noaa.gov/CFSR/HP_time_series/${year}${monthtwo}/tmp2m.gdas.${year}${monthtwo}.grb2
    done

    until [ -e "pressfc.gdas.${year}${monthtwo}.grb2" ]
    do
    	wget ftp://nomads.ncdc.noaa.gov/CFSR/HP_time_series/${year}${monthtwo}/pressfc.gdas.${year}${monthtwo}.grb2
    done
  done
done
