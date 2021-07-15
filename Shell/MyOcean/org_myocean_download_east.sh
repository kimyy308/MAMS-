#!/bin/bash
today=20190101
lag_max=1
bdry_name=east
x_min=162
x_max=162
y_min=15
y_max=52
z_min=0.494
z_max=5727.9171
var_str="zos so thetao uo vo"
var_str=`echo ${var_str}|sed 's/ / -v /g'|sed 's/^/-v /'`
work_dir=$(pwd)
data_dir=${work_dir}/${bdry_name}
#python='/home/auto/bin/Python-2.7.10/bin/python'
#source /home/auto/.bashrc
#conda activate py27

for (( lag_day=0; lag_day<lag_max; lag_day++ )) do
##export dstr_time=$(date -d "$today ${lag_day} day" +%Y-%m-%d)
##export this_time=$(date -d "$today ${lag_day} day" +%Y%m%d)
  dstr_time=`date -d "$today ${lag_day} day" +%Y-%m-%d`
  this_time=`date -d "$today ${lag_day} day" +%Y%m%d`
  
  if test -e $data_dir/myocean_${bdry_name}_${this_time}.nc
  then
     ls $data_dir/myocean_${bdry_name}_${this_time}.nc
  else
     python ${work_dir}/motu-client.py -u ykim7 -p Mepl036$ -m http://nrtcmems.mercator-ocean.fr/mis-gateway-servlet/Motu -s http://purl.org/myocean/ontology/service/database#GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS -d global-analysis-forecast-phy-001-024 -x ${x_min} -X ${x_max} -y ${y_min} -Y ${y_max} -t "${dstr_time} 12:00:00" -T "${dstr_time} 12:00:00" -z ${z_min} -Z ${z_max} ${var_str} -o ./ -f myocean_${bdry_name}_${this_time}.nc
     echo ""
     echo "${bdry_name} $dstr_time = $lag_day"
     echo ""
     ncrename -v thetao,temperature -v so,salinity -v uo,u -v vo,v -v zos,ssh -v time,time_counter -d time,time_counter -O ./myocean_${bdry_name}_${this_time}.nc
  
     ls myocean_${bdry_name}_${this_time}.nc $data_dir/
     mv -f myocean_${bdry_name}_${this_time}.nc $data_dir/
  fi
done #str day
#conda deactivate
