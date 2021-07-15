#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

#fulldate=`date --date="2 days ago" +%Y%m%d`
fulldate=$@
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`

datadir=/home/auto/MAMS/Data/OISST/$fulldate/
cd /home/auto/MAMS/Figure/OISST/

ym=${year}${month}
mkdir -p $ym
cd $ym
ferscrfile=OISST_ferscrfile_${fulldate}.jnl
cat > $ferscrfile << EOF

use "${datadir}OISST_${fulldate}.nc"
shade/x=79:173/y=13:61/lev=(-10,35,1)/palette=rainbow_rgb analysed_sst-273.15
go land
frame/file=SST_${fulldate}.gif
shade/x=79:173/y=13:61/palette=rainbow_rgb analysis_error
go land
frame/file=Error_${fulldate}.gif
shade/x=108:150/y=30:52/lev=(-10,35,1)/palette=rainbow_rgb analysed_sst-273.15
go land
frame/file=Korea_SST_${fulldate}.gif
shade/x=108:150/y=30:52/palette=rainbow_rgb analysis_error
go land
frame/file=Korea_Error_${fulldate}.gif
cancel data 1
EOF
/home/auto/MAMS/App/FERRET/bin/ferret -script $ferscrfile
