#!/bin/bash
#fulldate=`date -d "$today" +%Y%m%d`
fulldate=$1
MAMS=$2
lag_max=0
x_min=114
x_max=163
y_min=14
y_max=53
z_min=0.494
z_max=5727.9171
var_str="zos so thetao uo vo"
var_str=`echo ${var_str}|sed 's/ / -v /g'|sed 's/^/-v /'`
work_dir=$MAMS
cd ${work_dir}/Source/Python/Analysis/MyOcean/motu-client-python/
#python='/home/auto/bin/Python-2.7.10/bin/python'
#source /home/auto/.bashrc
#conda activate py27

#for (( bdy_idx=0; bdy_idx<=3; bdy_idx++)) do
#rm -rf ${work_dir}/Data/MyOcean/GAFP_001_024/????????_forecast
for (( lag_day=0; lag_day<=lag_max; lag_day++ )) do
  bdy_idx=0
  while [ ${bdy_idx} -le 3 ]; do
  case ${bdy_idx} in
    0) bdry_name=east
       x_left=${x_max}
       x_right=${x_max}
       y_lower=${y_min}
       y_upper=${y_max}
       ;;
    1) bdry_name=west
       x_left=${x_min}
       x_right=${x_min}
       y_lower=${y_min}
       y_upper=${y_max}
       ;;
    2) bdry_name=south
       x_left=${x_min}
       x_right=${x_max}
       y_lower=${y_min}
       y_upper=${y_min}
       ;;
    3) bdry_name=north
       x_left=${x_min}
       x_right=${x_max}
       y_lower=${y_max}
       y_upper=${y_max}
       ;;
  esac
    dstr_time=`date -d "$fulldate ${lag_day} day" +%Y-%m-%d`
    this_time=`date -d "$fulldate ${lag_day} day" +%Y%m%d`
    if [ ${lag_day} -gt 0 ]
    then
      echo ${lag_day}"abcabc"
      data_dir=${work_dir}/Data/MyOcean/GAFP_001_024/${this_time}_forecast
    else
      data_dir=${work_dir}/Data/MyOcean/GAFP_001_024/${this_time}
    fi
    
    mkdir -p ${data_dir}
    
    if test -e $data_dir/myocean_${bdry_name}_${this_time}.nc
    then
       ls $data_dir/myocean_${bdry_name}_${this_time}.nc
       let bdy_idx=bdy_idx+1
    else
       python ${work_dir}/Source/Python/Analysis/MyOcean/motu-client-python/motu-client.py -u ykim7 -p Mepl036$ -m http://nrtcmems.mercator-ocean.fr/mis-gateway-servlet/Motu -s http://purl.org/myocean/ontology/service/database#GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS -d global-analysis-forecast-phy-001-024 -x ${x_left} -X ${x_right} -y ${y_lower} -Y ${y_upper} -t "${dstr_time} 12:00:00" -T "${dstr_time} 12:00:00" -z ${z_min} -Z ${z_max} ${var_str} -o ./ -f ${data_dir}/myocean_${bdry_name}_${this_time}.nc
       echo ""
       echo "${bdry_name} $dstr_time = $lag_day"
       echo ""
       ncrename -v thetao,temp -v so,salt -v uo,u -v vo,v -v zos,zeta -O ${data_dir}/myocean_${bdry_name}_${this_time}.nc
    
       ls ${data_dir}/myocean_${bdry_name}_${this_time}.nc
#       mv -f myocean_${bdry_name}_${this_time}.nc $data_dir/
    fi
  done #str day
done #bdy idx
#conda deactivate
