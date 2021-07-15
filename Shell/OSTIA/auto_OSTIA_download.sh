#!/bin/bash
# Updated, 12-Jan-2021 by Yong-Yub Kim (OSTIA SST download)


#fulldate=`date -d "$today" +%Y%m%d`
#fulldate=`date --date="2 days ago" +%Y%m%d`
fulldate=$1
MAMS=$2

dstr_time=`date -d "${fulldate} 0 day" +%Y-%m-%d`
this_year=`echo $fulldate | cut -c1-4`
this_month=`echo $fulldate | cut -c5-6`

x_min=110
x_max=165
y_min=10
y_max=55

cd ${work_dir}/Source/Python/Analysis/MyOcean/motu-client-python/
source /home/auto/.bashrc

data_dir=${MAMS}/Data/OSTIA/daily/${this_year}/${this_month}
filename=${data_dir}/OSTIA_${fulldate}.nc

mkdir -p ${data_dir}
cd ${data_dir}

countind=0
exind=0
while [ ${exind} -ne 1 ] ; do 
  if test -e ${filename} 
  then
    echo "file exists"
    exind=1
  else
    conda activate
    python -m motuclient --motu http://nrt.cmems-du.eu/motu-web/Motu --service-id SST_GLO_SST_L4_NRT_OBSERVATIONS_010_001-TDS --product-id METOFFICE-GLO-SST-L4-NRT-OBS-SST-V2 --longitude-min ${x_min} --longitude-max ${x_max} --latitude-min ${y_min} --latitude-max ${y_max} --date-min "${dstr_time} 12:00:00" --date-max "${dstr_time} 12:00:00" --variable analysed_sst --variable analysis_error --variable mask --variable sea_ice_fraction --out-dir ./ --out-name ${filename} --user ykim7 --pwd Mepl036$ 
    conda deactivate
    ls $filename
    ((countind++))
    if [ $countind -gt 5 ] ; then
      exind=1
    fi
  fi
done
