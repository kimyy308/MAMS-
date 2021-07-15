#!/bin/sh

workdir=/data1/stlee/ext_hdd/NOMADS/
tempdir=/data1/stlee/NOMADS_temp/
##cd $workdir 
##year=1993
for (( year=2018; year<=2018; year++ )) do
  ##yeartwo=`expr ${year} - 1`
      cd ${workdir}${year}
      mkdir temp
      mkdir nc_file
  for (( month=1; month<=7; month++ )) do
    monthtwo=`printf "%02d" $month`
      if [ ${month} -lt 12 ];then
        monthindex=`echo "(($monthtwo+1))"|bc`
      fi
       if [ ${month} -eq 12 ];then
        monthindex=`echo "(($monthtwo-10))"|bc`
      fi
    monthindextwo=`printf "%02d" $monthindex`
##  dayofmonth=`date +%d -d "${year}${monthtwo}01 -1 day"`
    dayofmonth=`date +%d -d "${year}${monthindextwo}01 -1 day"`
    lastindex=`echo "(($dayofmonth*28))"|bc`
##    mkdir -p ${workdir}${year}
	for (( ind=1; ind<=${lastindex}; ind+=7 )) do
    indthree=`printf "%03d" $ind`
    	/data1/auto/App/kwgrib2/kwgrib -d ${indthree} dswsfc.gdas.${year}${monthtwo}.grib2 -netcdf ${tempdir}dswsfc.gdas.${year}${monthtwo}_${indthree}.nc
    	/data1/auto/App/kwgrib2/kwgrib -d ${indthree} q2m.gdas.${year}${monthtwo}.grib2 -netcdf ${tempdir}q2m.gdas.${year}${monthtwo}_${indthree}.nc
    	/data1/auto/App/kwgrib2/kwgrib -d ${indthree} tmp2m.gdas.${year}${monthtwo}.grib2 -netcdf ${tempdir}tmp2m.gdas.${year}${monthtwo}_${indthree}.nc
    done 
	for (( ind=4; ind<=${lastindex}; ind+=7 )) do
    indthree=`printf "%03d" $ind`
    	/data1/auto/App/kwgrib2/kwgrib -d ${indthree} dswsfc.gdas.${year}${monthtwo}.grib2 -netcdf ${tempdir}dswsfc.gdas.${year}${monthtwo}_${indthree}.nc
    	/data1/auto/App/kwgrib2/kwgrib -d ${indthree} q2m.gdas.${year}${monthtwo}.grib2 -netcdf ${tempdir}q2m.gdas.${year}${monthtwo}_${indthree}.nc
    	/data1/auto/App/kwgrib2/kwgrib -d ${indthree} tmp2m.gdas.${year}${monthtwo}.grib2 -netcdf ${tempdir}tmp2m.gdas.${year}${monthtwo}_${indthree}.nc
    done 

##    for (( ind=7; ind<=${lastindex}; ind+=7 ))do
##    indthree=`printf "%03d" $ind`
##  		rm -f ./temp/dswsfc.gdas.${year}${monthtwo}_${indthree}.nc
##  		rm -f ./temp/q2m.gdas.${year}${monthtwo}_${indthree}.nc
##  		rm -f ./temp/tmp2m.gdas.${year}${monthtwo}_${indthree}.nc
##  		rm -f ./temp/uswsfc.gdas.${year}${monthtwo}_${indthree}.nc
##    done

##        ncecat ./pressfc/pressfc.gdas.${year}${monthtwo}* -O ./pressfc.gdas.${year}${monthtwo}.nc
        ncrcat -h ${tempdir}dswsfc.gdas.${year}${monthtwo}* -O /data1/stlee/ext_hdd/NOMADS/${year}/nc_file/dswsfc.gdas.${year}${monthtwo}.nc
        ncrcat -h ${tempdir}q2m.gdas.${year}${monthtwo}* -O /data1/stlee/ext_hdd/NOMADS/${year}/nc_file/q2m.gdas.${year}${monthtwo}.nc
        ncrcat -h ${tempdir}tmp2m.gdas.${year}${monthtwo}* -O /data1/stlee/ext_hdd/NOMADS/${year}/nc_file/tmp2m.gdas.${year}${monthtwo}.nc

    rm -f ${tempdir}dswsfc.gdas.${year}${monthtwo}*
    rm -f ${tempdir}q2m.gdas.${year}${monthtwo}*
    rm -f ${tempdir}tmp2m.gdas.${year}${monthtwo}*

  done
done
