#!/bin/sh

source /usr/local/pgi/linux86-64/19.4/pgi.sh
export PATH=/usr/local/netcdf/pg_netcdf_4_1_3/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/netcdf/pg_netcdf_4_1_3/lib:$LD_LIBRARY_PATH
export PATH=/usr/local/pgi/linux86-64/19.4/mpi/openmpi-3.1.3/bin/:$PATH
export LD_LIBRARY_PATH=/usr/local/pgi/linux86-64/19.4/mpi/openmpi-3.1.3/lib/:$LD_LIBRARY_PATH

testname=auto01

fulldate=$1
fulldate=`date -d "$fulldate 1 days ago" +%Y%m%d`
MAMS=$2
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`
yearday=`date -d "$fulldate" +%j`
ensdir=$MAMS/Data/DA/01_NWP_1_10/Ensemble
#obsdir=$MAMS/Data/DA/01_NWP_1_10/OISST
obsdir=$MAMS/Data/DA/01_NWP_1_10/OSTIA
srcdir=$MAMS/Source/Fortran/EnOI_MPI_auto
inputdir=$MAMS/Model/ROMS/01_NWP_1_10/Input
rstdir=$MAMS/Model/ROMS/01_NWP_1_10/Output/Daily/$year/$month/$year$month$day



rawrstname=$rstdir/${testname}_rst_${fulldate}.nc
ininame=`ls $inputdir/${testname}_ini.nc`
datenc=`echo $rawrstname | rev | cut -c -11 | rev`
daname=${testname}_rst_DA_${datenc}

exefile=$srcdir/auto01_enoi
ctrlfile=$srcdir/auto01_enoi.in

mkdir -p $ensdir/piece
cat > $ctrlfile << EOF
GRDNAME = $inputdir/${testname}_grid.nc
ENSPATH = $ensdir
OBSNAME = $obsdir/${testname}_obs.nc
INNAME = $rstdir/$daname
INNAME_PIECE_PATH = $ensdir/piece
OUTNAME = $rstdir/${testname}_rst_${fulldate}.nc
LOGNAME = $srcdir/enoi.log
NENS = 37
DXDOMAIN = 100
DYDOMAIN = 100
CINF = 35000.0d0
HINF = 100.0d0
EPS = 0.001d0
ALPHA = 1.0d0
EOF
date
mpirun -np 4 $exefile $ctrlfile
date
ln -sf $rstdir/$daname $ininame
