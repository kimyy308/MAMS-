#!/bin/sh

workdir=/data1/stlee/ext_hdd/NOMADS/
cd $workdir 
##year=1993
for (( year=2016; year<=2016; year++ )) do
  ##yeartwo=`expr ${year} - 1`
  for (( month=1; month<=1; month++ )) do
    monthtwo=`printf "%02d" $month`
    mkdir -p ${workdir}${year}
    cd ${workdir}${year}

##    until [ -e "wnd10m.gdas.${year}${monthtwo}.grib2" ]
##    do
##    	wget ftp://nomads.ncdc.noaa.gov/modeldata/cfsv2_analysis_timeseries/${year}/${year}${monthtwo}/wnd10m.gdas.${year}${monthtwo}.grib2
##    done

    until [ -e "dswsfc.gdas.${year}${monthtwo}.grib2" ]
    do
    	wget ftp://nomads.ncdc.noaa.gov/modeldata/cfsv2_analysis_timeseries/${year}/${year}${monthtwo}/dswsfc.gdas.${year}${monthtwo}.grib2
    done

    until [ -e "uswsfc.gdas.${year}${monthtwo}.grib2" ]
    do
    	wget ftp://nomads.ncdc.noaa.gov/modeldata/cfsv2_analysis_timeseries/${year}/${year}${monthtwo}/uswsfc.gdas.${year}${monthtwo}.grib2
    done

    until [ -e "q2m.gdas.${year}${monthtwo}.grib2" ]
    do
    	wget ftp://nomads.ncdc.noaa.gov/modeldata/cfsv2_analysis_timeseries/${year}/${year}${monthtwo}/q2m.gdas.${year}${monthtwo}.grib2
    done

    until [ -e "tmp2m.gdas.${year}${monthtwo}.grib2" ]
    do
    	wget ftp://nomads.ncdc.noaa.gov/modeldata/cfsv2_analysis_timeseries/${year}/${year}${monthtwo}/tmp2m.gdas.${year}${monthtwo}.grib2
    done

    until [ -e "pressfc.gdas.${year}${monthtwo}.grib2" ]
    do
    	wget ftp://nomads.ncdc.noaa.gov/modeldata/cfsv2_analysis_timeseries/${year}/${year}${monthtwo}/pressfc.gdas.${year}${monthtwo}.grib2
    done
  done
done
