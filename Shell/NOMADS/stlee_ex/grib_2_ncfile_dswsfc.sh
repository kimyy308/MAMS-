#!/bin/sh

workdir=/data1/stlee/ext_hdd/NOMADS/
##cd $workdir 
year=1993
##for (( year=2012; year<=2019; year++ )) do
  ##yeartwo=`expr ${year} - 1`
  for (( month=12; month<=12; month++ )) do
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
##    cd ${workdir}${year}
	for (( ind=1; ind<=${lastindex}; ind++ )) do
    indthree=`printf "%03d" $ind`
    	/data1/auto/App/kwgrib2/kwgrib -d ${indthree} dswsfc.gdas.${year}${monthtwo}.grb2 -netcdf ./temp/dswsfc.gdas.${year}${monthtwo}_${indthree}.nc
##  	/data1/auto/App/kwgrib2/kwgrib -d ${indthree} wnd10m.gdas.${year}${monthtwo}.grb2 -netcdf ./temp/wnd10m.gdas.${year}${monthtwo}_${indthree}.nc
    done 

##    for (( ind=2; ind<=${lastindex}; ind+=8 ))do
##    indthree=`printf "%03d" $ind`
##  		rm -f ./temp/pressfc.gdas.${year}${monthtwo}_${indthree}.nc
##    done
    for (( ind=7; ind<=${lastindex}; ind+=7 ))do
    indthree=`printf "%03d" $ind`
  		rm -f ./temp/dswsfc.gdas.${year}${monthtwo}_${indthree}.nc



##		rm -f ./temp/wnd10m.gdas.${year}${monthtwo}_${indthree}.nc
    done

##        ncecat ./pressfc/pressfc.gdas.${year}${monthtwo}* -O ./pressfc.gdas.${year}${monthtwo}.nc
        ncrcat -h ./temp/dswsfc.gdas.${year}${monthtwo}* -O /data1/stlee/ext_hdd/NOMADS/${year}/nc_file/dswsfc.gdas.${year}${monthtwo}.nc



##      ncrcat -h ./temp/wnd10m.gdas.${year}${monthtwo}* -O /data1/stlee/ext_hdd/NOMADS/${year}/nc_file/wnd10m.gdas.${year}${monthtwo}.nc

    rm -f ./temp/dswsfc.gdas.${year}${monthtwo}*



##  rm -f ./temp/wnd10m.gdas.${year}${monthtwo}*

#/data1/stlee/ext_hdd/NOMADS/1993/nc_file
  done
##done
