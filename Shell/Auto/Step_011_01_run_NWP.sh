#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

testname=auto01
#fulldate=`date --date="2 days ago" +%Y%m%d`
fulldate=$1
MAMS=$2
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`

workdir=$MAMS/Model/ROMS/01_NWP_1_10
datadir=$MAMS/Data/01_NWP_1_10/Output/Daily/$year/$month/$fulldate/
cd $datadir
exefile=${workdir}/roms_nwp4_auto
ctrlfile=auto01_${fulldate}.in
#logfile=auto01_${fulldate}.log

#mpirun -np 12 ${exefile} ${ctrlfile} > ${logfile}
#which mpirun


#openmpi (gcc, gfortran. not intel)
export PATH=/home/auto/MAMS/App/openmpi/intel_3_1_4/bin/:$PATH
export LD_LIBRARY_PATH=/home/auto/MAMS/App/openmpi/intel_3_1_4/lib/:$LD_LIBRARY_PATH

#HDF5 1.8.6
export PATH=$PATH:/home/auto/MAMS/App/hdf5/g_hdf5_1_8_6/bin/
export LD_LIBRARY_PATH=/home/auto/MAMS/App/hdf5/g_hdf5_1_8_6/lib/:$LD_LIBRARY_PATH

#netcdf 4.1.3
export PATH=/home/auto/MAMS/App/netcdf/g_netcdf_4_1_3/bin/:$PATH
export LD_LIBRARY_PATH=/home/auto/MAMS/App/netcdf/g_netcdf_4_1_3/lib/:$LD_LIBRARY_PATH


$MAMS/App/openmpi/intel_3_1_4/bin/mpirun -np 12 ${exefile} ${ctrlfile}


