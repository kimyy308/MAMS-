#!/bin/sh

workdir=/data1/stlee/ext_hdd/NOMADS/
##cd $workdir 
year=1993
##for (( year=2012; year<=2019; year++ )) do
  ##yeartwo=`expr ${year} - 1`
##  for (( month=1; month<=12; month++ )) do
month=1;
    monthtwo=`printf "%02d" $month`
##    mkdir -p ${workdir}${year}
##    cd ${workdir}${year}
	for (( ind=2; ind<=986; ind+=8 )) do
    indthree=`printf "%03d" $ind`
    	rm -f ./pressfc/pressfc.gdas.${year}${monthtwo}_${indthree}.nc
	done
##  done
##done
