#!/bin/sh
# Updated, 19-Jan-2021 by Yong-Yub Kim (empty forecast file -> not convert)

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

#fulldate=`date --date="2 days ago" +%Y%m%d`
fulldate=$1
MAMS=$2
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`

cd $MAMS/Data/NOMADS/gfs_0p25/

#mkdir -p $fulldate
cd $fulldate
mkdir nc_pieces

#TMP 2m above ground (#415 in gdas file, #435 in forcast file)
# /home/auto/MAMS/App/kwgrib2/kwgrib gdas.t00z.pgrb2.0p25.f003 -s |grep ':TMP:' | grep '10 m above' | /home/auto/MAMS/App/kwgrib2/kwgrib -i gdas.t00z.pgrb2.0p25.f003 -netcdf test.nc

wgrib2=$MAMS/App/kwgrib2/kwgrib
arr_i_da=(00 00 06 06 12 12 18 18)
arr_i_fc=(000 003 000 003 000 003 000 003)
arr_i_h=(00 03 06 09 12 15 18 21)

arridx=0;
arridx_max=7;
for (( arridx; arridx<=arridx_max; arridx++ )) do
fname=gdas.t${arr_i_da[$arridx]}z.pgrb2.0p25.f${arr_i_fc[$arridx]}
ncname=nc_pieces/t2m_${fulldate}_${arr_i_h[$arridx]}h.nc
$wgrib2 $fname -s | grep ':TMP:' | grep '2 m above' | $wgrib2 -i $fname -netcdf $ncname

ncname=nc_pieces/u10m_${fulldate}_${arr_i_h[$arridx]}h.nc
$wgrib2 $fname -s | grep ':UGRD:' | grep '10 m above' | $wgrib2 -i $fname -netcdf $ncname

ncname=nc_pieces/v10m_${fulldate}_${arr_i_h[$arridx]}h.nc
$wgrib2 $fname -s | grep ':VGRD:' | grep '10 m above' | $wgrib2 -i $fname -netcdf $ncname

ncname=nc_pieces/psl_${fulldate}_${arr_i_h[$arridx]}h.nc
$wgrib2 $fname -s | grep ':PRMSL:' | $wgrib2 -i $fname -netcdf $ncname

ncname=nc_pieces/rhum_${fulldate}_${arr_i_h[$arridx]}h.nc
$wgrib2 $fname -s | grep ':RH:' | grep '2 m above' | $wgrib2 -i $fname -netcdf $ncname

ncname=nc_pieces/swrad_${fulldate}_${arr_i_h[$arridx]}h.nc
$wgrib2 $fname -s | grep ':DSWRF:' | $wgrib2 -i $fname -netcdf $ncname

ncname=nc_pieces/prate_${fulldate}_${arr_i_h[$arridx]}h.nc
$wgrib2 $fname -s | grep ':PRATE:' | grep '0-3 hour ave' | $wgrib2 -i $fname -netcdf $ncname

done

##---- get: forecast data during 8 days ----------------
#lag_day=-1
#lag_max=6
#---- get: forecast data during 3 days ----------------
lag_day=1
lag_max=3

for (( lag_day; lag_day<=lag_max; lag_day++ )) do
  #--- move to data of NOMAD folder ------------------
  cd $MAMS/Data/NOMADS/gfs_0p25/
  
  #--- set the time of download data -----------------
  fore_date=`date -d "$fulldate ${lag_day} day" +%Y%m%d`
  data_dir=${fore_date}_forecast
  echo '$lag_day ='$lag_day
  echo '$fore_date ='$fore_date
  
  if [[ -d "$fore_date" ]]; then
    printf "        Skip\n"
    continue
  else
    #--- set the data number of target forecast day -------------
    case $lag_day in
       0)
          mkdir ${data_dir}
          cd ${data_dir}
          arr_i=(000 003 006 009 012 015 018 021)
          ;;
       1)	
          mkdir ${data_dir}
          cd ${data_dir}
          arr_i=(024 027 030 033 036 039 042 045)
          ;;
       2)
          mkdir ${data_dir}
          cd ${data_dir}
          arr_i=(048 051 054 057 060 063 066 069)
          ;;
       3)
          mkdir ${data_dir}
          cd ${data_dir}
          arr_i=(072 075 078 081 084 087 090 093)
          ;;
       4)
          mkdir ${data_dir}
          cd ${data_dir}
          arr_i=(096 099 102 105 108 111 114 117)
          ;;
       5)
          mkdir ${data_dir}
          cd ${data_dir}
          arr_i=(120 123 126 129 132 135 138 141)
          ;;
       6)
          mkdir ${data_dir}
          cd ${data_dir}
          arr_i=(144 147 150 153 156 159 162 165)
          ;;
       7)       
          mkdir ${data_dir}
          cd ${data_dir}
          arr_i=(168 171 174 177 180 183 186 189)
          ;;
    esac
    #--- end of: set the data number ---------------------------------
       
    mkdir nc_pieces
    arridx=0;
    arridx_max=7;
    for (( arridx; arridx<=arridx_max; arridx++ )) do
      houridx1=${arridx}
      houridx2=`echo ${arridx}*3|bc`
      houridx=`printf "%02d" ${houridx2}`
      
      
      fname=gfs.t00z.pgrb2.0p25.f${arr_i[$arridx]}
      ncname=nc_pieces/t2m_${fore_date}_${houridx}h.nc
      $wgrib2 $fname -s | grep ':TMP:' | grep '2 m above' | $wgrib2 -i $fname -netcdf $ncname
      
      ncname=nc_pieces/u10m_${fore_date}_${houridx}h.nc
      $wgrib2 $fname -s | grep ':UGRD:' | grep '10 m above' | $wgrib2 -i $fname -netcdf $ncname
      
      ncname=nc_pieces/v10m_${fore_date}_${houridx}h.nc
      $wgrib2 $fname -s | grep ':VGRD:' | grep '10 m above' | $wgrib2 -i $fname -netcdf $ncname
      
      ncname=nc_pieces/psl_${fore_date}_${houridx}h.nc
      $wgrib2 $fname -s | grep ':PRMSL:' | $wgrib2 -i $fname -netcdf $ncname
      
      ncname=nc_pieces/rhum_${fore_date}_${houridx}h.nc
      $wgrib2 $fname -s | grep ':RH:' | grep '2 m above' | $wgrib2 -i $fname -netcdf $ncname
      
      ncname=nc_pieces/swrad_${fore_date}_${houridx}h.nc
      $wgrib2 $fname -s | grep ':DSWRF:' | $wgrib2 -i $fname -netcdf $ncname
      
      ncname=nc_pieces/prate_${fore_date}_${houridx}h.nc
      $wgrib2 $fname -s | grep ':PRATE:' | grep '0-3 hour ave' | $wgrib2 -i $fname -netcdf $ncname
    done
  fi
done








