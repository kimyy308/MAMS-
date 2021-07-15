#!/bin/bash
#fulldate=`date -d "$today" +%Y%m%d`
#fulldate=$1
MAMS=/home/auto/MAMS
lag_max=3
x_min=110
x_max=165
y_min=10
y_max=55
#var_str="zos so thetao uo vo"
#var_str=`echo ${var_str}|sed 's/ / -v /g'|sed 's/^/-v /'`
work_dir=$MAMS
cd ${work_dir}/Source/Python/Analysis/MyOcean/motu-client-python/
source /home/auto/.bashrc

  tempmonth=`printf "%02d" $datamonth`
  idx=0
  first_time=20070115
  this_time=$first_time
  last_time=20201015
  while [ ${this_time} -le ${last_time} ]; do
     
    dstr_time=`date -d "${first_time} ${idx} month" +%Y-%m-%d`
    this_time=`date -d "${first_time} ${idx} month" +%Y%m%d`
    this_year=`echo $this_time | cut -c1-4`
    this_month=`echo $this_time | cut -c5-6`
    this_day=`echo $this_time | cut -c7-8`
    data_dir=${work_dir}/Data/OSTIA/monthly/${this_year}
    filename=${data_dir}/OSTIA_${this_year}${this_month}.nc
    mkdir -p ${data_dir}
    
    if test -e $filename
    then
    ls
    else
       conda activate
#       python -m motuclient --user ykim7 --pwd Mepl036$ --motu http://my.cmems-du.eu/motu-web/Motu -s GLOBAL_REANALYSIS_PHY_001_030-TDS -d global-reanalysis-phy-001-030-monthly -x ${x_left} -X ${x_right} -y ${y_lower} -Y ${y_upper} -t "${dstr_time}" -T "${dstr_time2}" -z ${z_min} -Z ${z_max} ${var_str} --out-dir ./ --out-name ${data_dir}/myocean_${bdry_name}_${this_time}.nc
       python -m motuclient --motu http://nrt.cmems-du.eu/motu-web/Motu --service-id SST_GLO_SST_L4_NRT_OBSERVATIONS_010_001-TDS --product-id METOFFICE-GLO-SST-L4-NRT-OBS-SST-MON-V2 --longitude-min ${x_min} --longitude-max ${x_max} --latitude-min ${y_min} --latitude-max ${y_max} --date-min "${dstr_time} 12:00:00" --date-max "${dstr_time} 12:00:00" --variable analysed_sst --variable standard_deviation_sst --out-dir ./ --out-name ${filename} --user ykim7 --pwd Mepl036$
       conda deactivate
       ls $filename
    fi
    let idx=idx+1
    this_time=`date -d "${first_time} ${idx} month" +%Y%m%d`

  done #bdy idx
#conda deactivate
