#!/bin/bash
#fulldate=`date -d "$today" +%Y%m%d`
#fulldate=$1
MAMS=/home/auto/MAMS
lag_max=3
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
source /home/auto/.bashrc
#conda activate py27

for (( datayear=1993; datayear<=2018; datayear++ )) do
  for (( datamonth=1; datamonth<=12; datamonth++ )) do
  tempmonth=`printf "%02d" $datamonth`
  bdy_idx=0
  while [ ${bdy_idx} -le 3 ]; do

  case ${bdy_idx} in
    0) bdry_name=east
    #abc = `echo 3 + 3 * 1|bc`      # get 7
       x_left=`echo ${x_max}-1 |bc`
       x_right=`echo ${x_max}-1 |bc`
       y_lower=${y_min}
       y_upper=${y_max}
       ;;
    1) bdry_name=west
       x_left=`echo ${x_min}+1 |bc`
       x_right=`echo ${x_min}+1 |bc`
       y_lower=${y_min}
       y_upper=${y_max}
       ;;
    2) bdry_name=south
       x_left=${x_min}
       x_right=${x_max}
       y_lower=`echo ${y_min}+1 |bc`
       y_upper=`echo ${y_min}+1 |bc`
       ;;
    3) bdry_name=north
       x_left=${x_min}
       x_right=${x_max}
       y_lower=`echo ${y_max}-1 |bc`
       y_upper=`echo ${y_max}-1 |bc` 
       ;;
  esac
    dstr_time=`date -d "${datayear}${tempmonth}15 0 day" +%Y-%m-%d`
    dstr_time2=`date -d "${datayear}${tempmonth}17 0 day" +%Y-%m-%d`
    #this_time=`date -d "$fulldate ${lag_day} day" +%Y%m%d`
    this_time=`date -d "${datayear}${tempmonth}17 0 day" +%Y%m`
    data_dir=${work_dir}/Data/MyOcean/GAFP_001_024/monthly/${datayear}
    
    mkdir -p ${data_dir}
    
    if test -e $data_dir/myocean_${bdry_name}_${this_time}.nc
    then
       ls $data_dir/myocean_${bdry_name}_${this_time}.nc
       let bdy_idx=bdy_idx+1
    else
       conda activate
       python -m motuclient --user ykim7 --pwd Mepl036$ --motu http://my.cmems-du.eu/motu-web/Motu -s GLOBAL_REANALYSIS_PHY_001_030-TDS -d global-reanalysis-phy-001-030-monthly -x ${x_left} -X ${x_right} -y ${y_lower} -Y ${y_upper} -t "${dstr_time}" -T "${dstr_time2}" -z ${z_min} -Z ${z_max} ${var_str} --out-dir ./ --out-name ${data_dir}/myocean_${bdry_name}_${this_time}.nc
       conda deactivate
#       echo ""
#       echo "${bdry_name} $dstr_time = $lag_day"
#       echo ""
##       ncrename -v thetao,temp -v so,salt -v uo,u -v vo,v -v zos,zeta -O ${data_dir}/myocean_${bdry_name}_${this_time}.nc
    
       ls ${data_dir}/myocean_${bdry_name}_${this_time}.nc
#       mv -f myocean_${bdry_name}_${this_time}.nc $data_dir/
    fi
  done #bdy idx
done #month
done #year
#conda deactivate
