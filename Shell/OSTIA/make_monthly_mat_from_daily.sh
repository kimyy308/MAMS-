#!/bin/bash

workdir=/home/auto/MAMS/Data/OSTIA

startyear=2007
endyear=2007

for (( yy=${startyear}; yy<=${endyear}; yy++ )) do
tempyear=${yy}
presentyear=`printf "%04d" $tempyear`
#presentnum=`echo "(($presentyear-$refyear)*365)+1"|bc`
presentnum=1

cd $workdir/$tempyear

if [[ `expr $tempyear % 4`   -eq 0 ]] && \
   [[ `expr $tempyear % 100` -ne 0 ]] || \
   [[ `expr $tempyear % 400` -eq 0 ]]; then  ## judge if it's leap year
  ly=1
else
  ly=0
fi


## month loop
for (( jj=1; jj<=2; jj++ )) do
  case $jj in ## select proper monthdays
    1 | 3 | 5 | 7 | 8 | 10 | 12 )
      mday=31 ;;
    4 | 6 | 9 | 11 )
      mday=30 ;;
    2 )   
      if [[ $ly -eq 1 ]]; then  mday=29;
      else                      mday=28; fi;;
  esac
  presentmonth=`printf "%02d" $jj`
  monthlydir=${workdir}/monthly_from_daily/${presentyear}
  mkdir -p $monthlydir
  outputname=${monthlydir}/OSTIA_${presentyear}${presentmonth}.nc
  dailydir=${workdir}/daily/${presentyear}/${presentmonth}
#  inputnum=`printf "%04d" $presentnum`
  if [ -f $testname"_monthly_"$presentyear"_"$presentmonth".nc" ]; then
    echo "file already exists"  
  else
#    ncra "-n "$mday",4,1" "ocean_avg_"$inputnum".nc" $testname"_monthly_"$presentyear"_"$presentmonth".nc"
    for (( pp=0; pp<mday; pp++ )) do
      fnum=`expr $pp + 1`
      fnumstr=`printf "%02d" $fnum`
#      params=( "${params[@]}" "ocean_avg_"${fnumstr}".nc" )
      params[$pp]=`printf ${dailydir}/"OSTIA_"${presentyear}${presentmonth}${fnumstr}".nc"`
    done

#    printf $fnumstr
#    printf ${params[0]}
#    sleep 2m 

    sh $workdir/avg_nc2.sh ${params[@]} ${outputname}
    unset params
  fi
#  presentnum=`expr $presentnum + $mday`
#  inputnum=`printf "%04d" $presentnum`
done

done


