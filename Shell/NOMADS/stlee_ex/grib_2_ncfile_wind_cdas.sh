#!/bin/sh

workdir=/data1/stlee/ext_hdd/NOMADS/
tempdir=/data1/stlee/NOMADS_temp/
##cd $workdir 
##year=1993
for (( year=2016; year<=2016; year++ )) do
    cd ${workdir}${year}
    mkdir temp
    mkdir nc_file
  ##yeartwo=`expr ${year} - 1`
  for (( month=1; month<=1; month++ )) do
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
    lastindex=`echo "(($dayofmonth*56))"|bc`
##    mkdir -p ${workdir}${year}
##    cd ${workdir}${year}
	for (( ind=1; ind<=${lastindex}; ind+=14 )) do
    indthree=`printf "%04d" $ind`
  	/data1/auto/App/kwgrb2/kwgrib -d ${indthree} wnd10m.cdas1.${year}${monthtwo}.grb2 -netcdf ${tempdir}Uwnd10m.cdas1.${year}${monthtwo}_${indthree}.nc
    done
 	for (( ind=7; ind<=${lastindex}; ind+=14 )) do
    indthree=`printf "%04d" $ind`
  	/data1/auto/App/kwgrb2/kwgrib -d ${indthree} wnd10m.cdas1.${year}${monthtwo}.grb2 -netcdf ${tempdir}Uwnd10m.cdas1.${year}${monthtwo}_${indthree}.nc
    done 

	for (( ind=2; ind<=${lastindex}; ind+=14 )) do
    indthree=`printf "%04d" $ind`
  	/data1/auto/App/kwgrb2/kwgrib -d ${indthree} wnd10m.cdas1.${year}${monthtwo}.grb2 -netcdf ${tempdir}Vwnd10m.cdas1.${year}${monthtwo}_${indthree}.nc
    done 
	for (( ind=8; ind<=${lastindex}; ind+=14 )) do
    indthree=`printf "%04d" $ind`
  	/data1/auto/App/kwgrb2/kwgrib -d ${indthree} wnd10m.cdas1.${year}${monthtwo}.grb2 -netcdf ${tempdir}Vwnd10m.cdas1.${year}${monthtwo}_${indthree}.nc
    done 

##    for (( ind=2; ind<=${lastindex}; ind+=8 ))do
##    indthree=`printf "%03d" $ind`
##  		rm -f ./temp/pressfc.cdas1.${year}${monthtwo}_${indthree}.nc
##    done
##    for (( ind=13; ind<=${lastindex}; ind+=14 ))do
##    indthree=`printf "%04d" $ind`
##  		rm -f ./temp/Uwnd10m.cdas1.${year}${monthtwo}_${indthree}.nc
##    done
##    for (( ind=14; ind<=${lastindex}; ind+=14 ))do
##    indthree=`printf "%04d" $ind`
##  		rm -f ./temp/Vwnd10m.cdas1.${year}${monthtwo}_${indthree}.nc
##
##    done

##        ncecat ./pressfc/pressfc.cdas1.${year}${monthtwo}* -O ./pressfc.cdas1.${year}${monthtwo}.nc
        ncrcat -h ${tempdir}Uwnd10m.cdas1.${year}${monthtwo}* -O /data1/stlee/ext_hdd/NOMADS/${year}/nc_file/Uwnd10m.cdas1.${year}${monthtwo}.nc
        ncrcat -h ${tempdir}Vwnd10m.cdas1.${year}${monthtwo}* -O /data1/stlee/ext_hdd/NOMADS/${year}/nc_file/Vwnd10m.cdas1.${year}${monthtwo}.nc

    rm -f ${tempdir}Uwnd10m.cdas1.${year}${monthtwo}*
    rm -f ${tempdir}Vwnd10m.cdas1.${year}${monthtwo}*

#/data1/stlee/ext_hdd/NOMADS/1993/nc_file
  done
done
