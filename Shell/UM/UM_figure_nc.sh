#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

#fulldate=`date --date="2 days ago" +%Y%m%d`
#fulldate=20190601
fulldate=$1
MAMS=$2
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`

datadir=$MAMS/Data/UM_global_10km/$fulldate/nc_pieces/
cd $MAMS/Figure/UM_global_10km/

mkdir -p $fulldate
cd $fulldate
ferscrfile=UM_global_ferscrfile_${fulldate}.jnl
arr_i=(00 03 06 09 12 15 18 21)
cat > $ferscrfile << EOF
use "${datadir}swrad_${fulldate}_${arr_i[1]}h.nc"
shade/lev=(0,1200,50)/palette=rainbow_rgb var0_4_192_surface,longitude,latitude
go land
frame/file=swrad_${fulldate}_${arr_i[1]}h.gif
cancel data 1
use "${datadir}swrad_${fulldate}_${arr_i[3]}h.nc"
shade/lev=(0,1200,50)/palette=rainbow_rgb var0_4_192_surface,longitude,latitude
go land
frame/file=swrad_${fulldate}_${arr_i[3]}h.gif
cancel data 1
use "${datadir}swrad_${fulldate}_${arr_i[5]}h.nc"
shade/lev=(0,1200,50)/palette=rainbow_rgb var0_4_192_surface,longitude,latitude
go land
frame/file=swrad_${fulldate}_${arr_i[5]}h.gif
cancel data 1
use "${datadir}swrad_${fulldate}_${arr_i[7]}h.nc"
shade/lev=(0,1200,50)/palette=rainbow_rgb var0_4_192_surface,longitude,latitude
go land
frame/file=swrad_${fulldate}_${arr_i[7]}h.gif
cancel data 1

use "${datadir}tmp_${fulldate}_${arr_i[0]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=tmp_${fulldate}_${arr_i[0]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[1]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=tmp_${fulldate}_${arr_i[1]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[2]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=tmp_${fulldate}_${arr_i[2]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[3]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=tmp_${fulldate}_${arr_i[3]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[4]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=tmp_${fulldate}_${arr_i[4]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[5]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=tmp_${fulldate}_${arr_i[5]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[6]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=tmp_${fulldate}_${arr_i[6]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[7]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=tmp_${fulldate}_${arr_i[7]}h.gif
cancel data 1

use "${datadir}psl_${fulldate}_${arr_i[0]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb prmsl_meansealevel,longitude,latitude
go land
frame/file=psl_${fulldate}_${arr_i[0]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[1]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb prmsl_meansealevel,longitude,latitude
go land
frame/file=psl_${fulldate}_${arr_i[1]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[2]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb prmsl_meansealevel,longitude,latitude
go land
frame/file=psl_${fulldate}_${arr_i[2]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[3]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb prmsl_meansealevel,longitude,latitude
go land
frame/file=psl_${fulldate}_${arr_i[3]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[4]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb prmsl_meansealevel,longitude,latitude
go land
frame/file=psl_${fulldate}_${arr_i[4]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[5]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb prmsl_meansealevel,longitude,latitude
go land
frame/file=psl_${fulldate}_${arr_i[5]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[6]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb prmsl_meansealevel,longitude,latitude
go land
frame/file=psl_${fulldate}_${arr_i[6]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[7]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb prmsl_meansealevel,longitude,latitude
go land
frame/file=psl_${fulldate}_${arr_i[7]}h.gif
cancel data 1

use "${datadir}rhum_${fulldate}_${arr_i[0]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb RH_1_5maboveground,longitude,latitude
go land
frame/file=rhum_${fulldate}_${arr_i[0]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[1]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb RH_1_5maboveground,longitude,latitude
go land
frame/file=rhum_${fulldate}_${arr_i[1]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[2]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb RH_1_5maboveground,longitude,latitude
go land
frame/file=rhum_${fulldate}_${arr_i[2]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[3]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb RH_1_5maboveground,longitude,latitude
go land
frame/file=rhum_${fulldate}_${arr_i[3]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[4]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb RH_1_5maboveground,longitude,latitude
go land
frame/file=rhum_${fulldate}_${arr_i[4]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[5]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb RH_1_5maboveground,longitude,latitude
go land
frame/file=rhum_${fulldate}_${arr_i[5]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[6]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb RH_1_5maboveground,longitude,latitude
go land
frame/file=rhum_${fulldate}_${arr_i[6]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[7]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb RH_1_5maboveground,longitude,latitude
go land
frame/file=rhum_${fulldate}_${arr_i[7]}h.gif
cancel data 1

use "${datadir}u10m_${fulldate}_${arr_i[0]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[0]}h.nc"
vec/len=15/xskip=13/yskip=13 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=wind_${fulldate}_${arr_i[0]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[1]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[1]}h.nc"
vec/len=15/xskip=13/yskip=13 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=wind_${fulldate}_${arr_i[1]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[2]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[2]}h.nc"
vec/len=15/xskip=13/yskip=13 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=wind_${fulldate}_${arr_i[2]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[3]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[3]}h.nc"
vec/len=15/xskip=13/yskip=13 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=wind_${fulldate}_${arr_i[3]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[4]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[4]}h.nc"
vec/len=15/xskip=13/yskip=13 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=wind_${fulldate}_${arr_i[4]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[5]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[5]}h.nc"
vec/len=15/xskip=13/yskip=13 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=wind_${fulldate}_${arr_i[5]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[6]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[6]}h.nc"
vec/len=15/xskip=13/yskip=13 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=wind_${fulldate}_${arr_i[6]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[7]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[7]}h.nc"
vec/len=15/xskip=13/yskip=13 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=wind_${fulldate}_${arr_i[7]}h.gif
cancel data 1
cancel data 2
use "${datadir}swrad_${fulldate}_${arr_i[1]}h.nc"
shade/lev=(0,1200,50)/palette=rainbow_rgb/i=150:350/j=150:340 var0_4_192_surface,longitude,latitude
go land
frame/file=Korea_swrad_${fulldate}_${arr_i[1]}h.gif
cancel data 1
use "${datadir}swrad_${fulldate}_${arr_i[3]}h.nc"
shade/lev=(0,1200,50)/palette=rainbow_rgb/i=150:350/j=150:340 var0_4_192_surface,longitude,latitude
go land
frame/file=Korea_swrad_${fulldate}_${arr_i[3]}h.gif
cancel data 1
use "${datadir}swrad_${fulldate}_${arr_i[5]}h.nc"
shade/lev=(0,1200,50)/palette=rainbow_rgb/i=150:350/j=150:340 var0_4_192_surface,longitude,latitude
go land
frame/file=Korea_swrad_${fulldate}_${arr_i[5]}h.gif
cancel data 1
use "${datadir}swrad_${fulldate}_${arr_i[7]}h.nc"
shade/lev=(0,1200,50)/palette=rainbow_rgb/i=150:350/j=150:340 var0_4_192_surface,longitude,latitude
go land
frame/file=Korea_swrad_${fulldate}_${arr_i[7]}h.gif
cancel data 1

use "${datadir}tmp_${fulldate}_${arr_i[0]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb/i=150:350/j=150:340 tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=Korea_tmp_${fulldate}_${arr_i[0]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[1]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb/i=150:350/j=150:340 tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=Korea_tmp_${fulldate}_${arr_i[1]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[2]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb/i=150:350/j=150:340 tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=Korea_tmp_${fulldate}_${arr_i[2]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[3]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb/i=150:350/j=150:340 tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=Korea_tmp_${fulldate}_${arr_i[3]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[4]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb/i=150:350/j=150:340 tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=Korea_tmp_${fulldate}_${arr_i[4]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[5]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb/i=150:350/j=150:340 tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=Korea_tmp_${fulldate}_${arr_i[5]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[6]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb/i=150:350/j=150:340 tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=Korea_tmp_${fulldate}_${arr_i[6]}h.gif
cancel data 1
use "${datadir}tmp_${fulldate}_${arr_i[7]}h.nc"
shade/lev=(-10,35,1)/palette=rainbow_rgb/i=150:350/j=150:340 tmp_1_5maboveground-273.15,longitude,latitude
go land
frame/file=Korea_tmp_${fulldate}_${arr_i[7]}h.gif
cancel data 1

use "${datadir}psl_${fulldate}_${arr_i[0]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb/i=150:350/j=150:340 prmsl_meansealevel,longitude,latitude
go land
frame/file=Korea_psl_${fulldate}_${arr_i[0]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[1]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb/i=150:350/j=150:340 prmsl_meansealevel,longitude,latitude
go land
frame/file=Korea_psl_${fulldate}_${arr_i[1]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[2]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb/i=150:350/j=150:340 prmsl_meansealevel,longitude,latitude
go land
frame/file=Korea_psl_${fulldate}_${arr_i[2]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[3]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb/i=150:350/j=150:340 prmsl_meansealevel,longitude,latitude
go land
frame/file=Korea_psl_${fulldate}_${arr_i[3]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[4]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb/i=150:350/j=150:340 prmsl_meansealevel,longitude,latitude
go land
frame/file=Korea_psl_${fulldate}_${arr_i[4]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[5]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb/i=150:350/j=150:340 prmsl_meansealevel,longitude,latitude
go land
frame/file=Korea_psl_${fulldate}_${arr_i[5]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[6]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb/i=150:350/j=150:340 prmsl_meansealevel,longitude,latitude
go land
frame/file=Korea_psl_${fulldate}_${arr_i[6]}h.gif
cancel data 1
use "${datadir}psl_${fulldate}_${arr_i[7]}h.nc"
shade/lev=(97000,103000,100)/palette=rainbow_rgb/i=150:350/j=150:340 prmsl_meansealevel,longitude,latitude
go land
frame/file=Korea_psl_${fulldate}_${arr_i[7]}h.gif
cancel data 1

use "${datadir}rhum_${fulldate}_${arr_i[0]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb/i=150:350/j=150:340 RH_1_5maboveground,longitude,latitude
go land
frame/file=Korea_rhum_${fulldate}_${arr_i[0]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[1]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb/i=150:350/j=150:340 RH_1_5maboveground,longitude,latitude
go land
frame/file=Korea_rhum_${fulldate}_${arr_i[1]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[2]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb/i=150:350/j=150:340 RH_1_5maboveground,longitude,latitude
go land
frame/file=Korea_rhum_${fulldate}_${arr_i[2]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[3]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb/i=150:350/j=150:340 RH_1_5maboveground,longitude,latitude
go land
frame/file=Korea_rhum_${fulldate}_${arr_i[3]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[4]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb/i=150:350/j=150:340 RH_1_5maboveground,longitude,latitude
go land
frame/file=Korea_rhum_${fulldate}_${arr_i[4]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[5]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb/i=150:350/j=150:340 RH_1_5maboveground,longitude,latitude
go land
frame/file=Korea_rhum_${fulldate}_${arr_i[5]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[6]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb/i=150:350/j=150:340 RH_1_5maboveground,longitude,latitude
go land
frame/file=Korea_rhum_${fulldate}_${arr_i[6]}h.gif
cancel data 1
use "${datadir}rhum_${fulldate}_${arr_i[7]}h.nc"
shade/lev=(0,100,5)/palette=rainbow_rgb/i=150:350/j=150:340 RH_1_5maboveground,longitude,latitude
go land
frame/file=Korea_rhum_${fulldate}_${arr_i[7]}h.gif
cancel data 1

use "${datadir}u10m_${fulldate}_${arr_i[0]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[0]}h.nc"
vec/len=15/xskip=4/yskip=4/i=150:350/j=150:340 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=Korea_wind_${fulldate}_${arr_i[0]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[1]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[1]}h.nc"
vec/len=15/xskip=4/yskip=4/i=150:350/j=150:340 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=Korea_wind_${fulldate}_${arr_i[1]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[2]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[2]}h.nc"
vec/len=15/xskip=4/yskip=4/i=150:350/j=150:340 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=Korea_wind_${fulldate}_${arr_i[2]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[3]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[3]}h.nc"
vec/len=15/xskip=4/yskip=4/i=150:350/j=150:340 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=Korea_wind_${fulldate}_${arr_i[3]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[4]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[4]}h.nc"
vec/len=15/xskip=4/yskip=4/i=150:350/j=150:340 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=Korea_wind_${fulldate}_${arr_i[4]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[5]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[5]}h.nc"
vec/len=15/xskip=4/yskip=4/i=150:350/j=150:340 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=Korea_wind_${fulldate}_${arr_i[5]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[6]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[6]}h.nc"
vec/len=15/xskip=4/yskip=4/i=150:350/j=150:340 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=Korea_wind_${fulldate}_${arr_i[6]}h.gif
cancel data 1
cancel data 2
use "${datadir}u10m_${fulldate}_${arr_i[7]}h.nc"
use "${datadir}v10m_${fulldate}_${arr_i[7]}h.nc"
vec/len=15/xskip=4/yskip=4/i=150:350/j=150:340 ugrd_10maboveground[d=1],vgrd_10maboveground[d=2],longitude[d=1],latitude[d=1]
go land
frame/file=Korea_wind_${fulldate}_${arr_i[7]}h.gif
cancel data 1
cancel data 2

EOF
$MAMS/App/FERRET/bin/ferret -script $ferscrfile








