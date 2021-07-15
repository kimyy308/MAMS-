#!/bin/sh

olddate=20210321
newdate=20210322

workdir=/home/auto/MAMS/Data/NOMADS/gfs_0p25

cd $workdir

mkdir -p $newdate
cd $newdate

ln -sf $workdir/$olddate/*f00* ./
mkdir -p nc_pieces

cd nc_pieces

ln -sf
arr_i_var=(prate psl rhum swrad t2m u10m v10m)
arr_i_var2=(psl rhum t2m u10m v10m)
arr_i_h=(03 09 15 21)
arr_i_h2=(00 06 12 18)
for (( arridx_var=0; arridx_var<=6; arridx_var++ )) do
  for (( arridx_h=0; arridx_h<=3; arridx_h++ )) do
    ln -sf $workdir/$olddate/nc_pieces/${arr_i_var[$arridx_var]}_${olddate}_${arr_i_h[$arridx_h]}h.nc ./${arr_i_var[$arridx_var]}_${newdate}_${arr_i_h[$arridx_h]}h.nc
  done
done

for (( arridx_var=0; arridx_var<=4; arridx_var++ )) do
  for (( arridx_h=0; arridx_h<=3; arridx_h++ )) do
    ln -sf $workdir/$olddate/nc_pieces/${arr_i_var2[$arridx_var]}_${olddate}_${arr_i_h2[$arridx_h]}h.nc ./${arr_i_var2[$arridx_var]}_${newdate}_${arr_i_h2[$arridx_h]}h.nc
  done
done

