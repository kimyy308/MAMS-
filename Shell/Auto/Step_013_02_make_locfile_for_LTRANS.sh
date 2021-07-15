#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

testname=auto01
#fulldate=`date --date="3 days ago" +%Y%m%d`
#daybefore=-15
#fulldate=`date -d "$1 $daybefore day" +%Y%m%d`
MAMS=$2
workdir=$MAMS/Model/LTRANS
inputdir=$workdir/Input
dayinfofile=$inputdir/dayinfo
fulldate=`head -1 $dayinfofile`
numday=`tail -1 $dayinfofile`
numday_ltrans=`echo $numday + 2|bc`
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`
yearday=`date -d "$fulldate" +%j`
yearday_4=`printf "%04d" ${yearday}`


outputdir=$workdir/Output/$year/$month/$fulldate
#datadir=/home/auto/ext_hdi/nwp_1_10/reanalysis
datadir=$MAMS/Data/01_NWP_1_10/Output/Daily
locfile=$outputdir/ltrans_loc_${fulldate}.txt

#numfile=`find $inputdir/ | wc -l`
#numday=`echo $numfile -3|bc`

mkdir -p $outputdir
cd $outputdir

mfile=$workdir/source/make_LTRANS_loc_auto.m
cat > $mfile << EOF
close all; clear all;
addpath(genpath(['netcdf_old']));

workdir='$workdir'
testname='$testname'
datadir='$datadir'
startyear=$year
lastyear=$year
startmonth=$month
lastmonth=$month
startday=$day
laststartday=$day
numday=$numday_ltrans

%%%%%%%%%%%%%%%%%%%%%%%%% user variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the day of LTRANS

% Initial condition of particle (egg)
particle_depth = -0.25;
%particle_time = 86400 * 2 + 86400 / 2; % after 2days and half 
particle_time = 86400 * 2; % after 2days
particle_marker = 101001;

% find egg location
egg_stddepth = 500; 
min_temp = 2; max_temp = 10; 

minlat = 36; maxlat = 44;
minlon = 127; maxlon = 133;

for year=startyear:lastyear
    yy = num2str(year,'%04i');

for month=startmonth:lastmonth
    mm = num2str(month, '%02i');

for day=startday:laststartday
    numdd = num2str(numday, '%04i');
    dd2 = num2str(day, '%02i');
    dd4_num = sum(eomday(year,1:month-1)) + day;
    dd4 = num2str(dd4_num, '%04i');
    disp(['file day : ', dd4])

    name_prefix=[numdd,'d_',yy,mm,dd2];
    outputdir=[workdir,'/Output/','$year','/', '$month', '/', '$fulldate', ];
    mkdir([outputdir,'/'])
       
 % Reanalysis file Info
        filepath = [datadir,'/','$year','/','$month','/','$fulldate','/'];
        filename = ['$testname','_avg_',dd4,'.nc'];
        fname = [filepath, filename];
        disp(['use ',fname])

 % output txt file Info
        locfile=[outputdir,'/ltrans_loc_','$fulldate','.txt']
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nc = netcdf(fname);
lat_rho = nc{'lat_rho'}(:);
lon_rho = nc{'lon_rho'}(:);
close(nc);

find_minlat = min(min(abs(lat_rho(:,1) - minlat)));
find_maxlat = min(min(abs(lat_rho(:,1) - maxlat)));
find_minlon = min(min(abs(lon_rho(1,:) - minlon)));
find_maxlon = min(min(abs(lon_rho(1,:) - maxlon)));

idx_minlat = find(abs(lat_rho(:,1) - minlat) == find_minlat);
idx_maxlat = find(abs(lat_rho(:,1) - maxlat) == find_maxlat);
idx_minlon = find(abs(lon_rho(1,:) - minlon) == find_minlon);
idx_maxlon = find(abs(lon_rho(1,:) - maxlon) == find_maxlon);

nc = netcdf(fname);
depth = nc{'h'}(:); 
temp = nc{'temp'}(:); 
close(nc)

vname = temp; type = 'temp';
level = -50; 
temp50 = get_hslice_ltrans(fname,fname,vname,level,type);

cut_lon = lon_rho(idx_minlat:idx_maxlat,idx_minlon:idx_maxlon);
cut_lat = lat_rho(idx_minlat:idx_maxlat,idx_minlon:idx_maxlon);
cut_depth = depth(idx_minlat:idx_maxlat,idx_minlon:idx_maxlon);
cut_temp50 = temp50(idx_minlat:idx_maxlat,idx_minlon:idx_maxlon);
idx_egg = find(cut_depth <= egg_stddepth & cut_temp50 >= min_temp & cut_temp50 <= max_temp);

egg_lon = cut_lon(idx_egg);
egg_lat = cut_lat(idx_egg);
egg_depth = repmat(particle_depth,length(egg_lon),1);
egg_time = repmat(particle_time,length(egg_lon),1);
egg_marker = repmat(particle_marker,length(egg_lon),1);

fdata = [egg_lon'; egg_lat'; egg_depth'; egg_time'; egg_marker';];
fid=fopen([locfile],'w');
fprintf(fid,'%6.2f,%5.2f,%5.2f,%5d,%6d \r\n',fdata);
fclose(fid);

    end
  end
end

EOF

$workdir/source/runmatlab $mfile

ln -sf $locfile $inputdir/loc.txt
