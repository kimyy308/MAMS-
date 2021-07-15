#!/bin/sh

workdir=/data1/stlee/ext_hdd/NOMADS/
tempdir=/data1/stlee/NOMADS_temp/
##cd $workdir 
##year=1993
for (( year=2017; year<=2017; year++ )) do
  ##yeartwo=`expr ${year} - 1`
    cd ${workdir}${year}
    mkdir temp
    mkdir nc_file
  for (( month=1; month<=12; month++ )) do
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
    lastindex=`echo "(($dayofmonth*32))"|bc`
##    mkdir -p ${workdir}${year}
##    cd ${workdir}${year}
	for (( ind=1; ind<=${lastindex}; ind+=4 )) do
    indthree=`printf "%03d" $ind`
    	/data1/auto/App/kwgrib2/kwgrib -d ${indthree} pressfc.gdas.${year}${monthtwo}.grib2 -netcdf ${tempdir}pressfc.gdas.${year}${monthtwo}_${indthree}.nc
    done 

##    for (( ind=2; ind<=${lastindex}; ind+=8 ))do
##    indthree=`printf "%03d" $ind`
##  		rm -f ./temp/pressfc.gdas.${year}${monthtwo}_${indthree}.nc
##    done
##    for (( ind=8; ind<=${lastindex}; ind+=8 ))do
##    indthree=`printf "%03d" $ind`
##  		rm -f ./temp/pressfc.gdas.${year}${monthtwo}_${indthree}.nc
##    done

##        ncecat ./pressfc/pressfc.gdas.${year}${monthtwo}* -O ./pressfc.gdas.${year}${monthtwo}.nc
        ncrcat -h ${tempdir}pressfc.gdas.${year}${monthtwo}* -O /data1/stlee/ext_hdd/NOMADS/${year}/nc_file/pressfc.gdas.${year}${monthtwo}.nc

    rm -f ${tempdir}pressfc.gdas.${year}${monthtwo}*

#/data1/stlee/ext_hdd/NOMADS/1993/nc_file
  done
done
