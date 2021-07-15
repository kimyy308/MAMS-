%=======================================================================
% Make river Changjiang & Yellow river
%  add 10 rivers (rivers in the bohai sea and the Korea coast)
%                            editted by C.S KIM (10 Jan. 2012)
%    Updated 11-May-2018 by Yong-Yub Kim (makes possible to running at R2017b ~)
%=======================================================================
%  River.flag can have any of the following values:
%             = 0,  All Tracer source/sink are off.
%             = 1,  Only temperature is on.
%             = 2,  Only salinity is on.
%             = 3,  Both temperature and salinity are on. 
% 
%  + tumen river transport
% 
% This script will create a river runoff FORCING NetCDF file.
%
% Paul Goodman's modification of useast_rivers.m (J. Wilkin)
% BJ Choi's modification AUG 2, 2004.
% 18-Jun-2019, Yong-Yub Kim

% % clear all
% % close all
% clc

testname='auto01';
warning off;
system_name=computer;
if (strcmp(system_name,'PCWIN64'))
    % % for windows
    dropboxpath='C:\Users\KYY\Dropbox'; %% SNU_desktop\
    addpath(genpath([dropboxpath '\source\matlab\Common\m_map']));
    addpath(genpath([dropboxpath '\source\matlab\Common\Figure']));
    addpath(genpath([dropboxpath '\source\matlab\Common\netcdf_old']));
    addpath(genpath([dropboxpath '\source\matlab\Model\ROMS\Grid_kyy']));
    addpath(genpath([dropboxpath '\source\matlab\Model\ROMS\Analysis\Figure\nwp_1_20\run']));
    addpath(genpath([dropboxpath '\source\matlab\Model\ROMS\Roms_tools\Preprocessing_tools']));
    OGCM_path = '???';
    bry_prefix='???';
elseif (strcmp(system_name,'GLNXA64'))
    % % for linux
    dropboxpath='/home/auto/MAMS/Source/MATLAB'; %% MEPL2 server
    addpath(genpath([dropboxpath '/util/m_map']));
    addpath(genpath([dropboxpath '/util/Figure']));
    addpath(genpath([dropboxpath '/util/netcdf_old']));
    addpath(genpath([dropboxpath '/util/roms_grid']));
    addpath(genpath([dropboxpath '/source/matlab/Model/ROMS/Analysis/Figure/nwp_1_20/run']));
    addpath(genpath([dropboxpath '/Roms_tools/Preprocessing_tools']));
end

% runtime=datevec(datenum(date)-2); % year, month, day(2 days ago)
tempday=num2str(fulldate);
runtime(1)=str2num(tempday(1:4));
runtime(2)=str2num(tempday(5:6));
runtime(3)=str2num(tempday(7:8));

year=runtime(1);
month=runtime(2);
day=runtime(3);
output_dir=['/home/auto/MAMS/Data/01_NWP_1_10/Input/river/', ...
    num2str(year,'%04i'),num2str(month,'%02i'),'/'];
if (exist(output_dir,'dir')~=7)
    mkdir(output_dir)
end

workdir='/home/auto/MAMS/Data/01_NWP_1_10/Input';

OISSTdir='/home/auto/MAMS/Data/OISST';
OISSTpath=[OISSTdir,'/',tempday];
%OISST_name=[OISSTpath,'/',tempday,'120000-NCEI-L4_GHRSST-SSTblend-AVHRR_OI-GLOB-v02.0-fv02.0.nc'];
OISST_name=[OISSTpath,'/','OISST_', tempday, '.nc'];

totalday  = 4; %% 2d ago, yesterday, today, tomorrow
firstdofy=datenum(['01-Jan-',num2str(year)]); % dd-mmm-yyyy
presenttime=datenum([num2str(month),'-',num2str(day),'-',num2str(year)]); % mm-dd-yyyy
fulltime = presenttime - firstdofy;
time = fulltime+0.5 : 1.0 : fulltime + 3.5; 


% totalday for 365.25

% riv = load('cal_discharge_all.txt');
% riv = load('cal_discharge_all9210.txt');
% riv = load('datong_1961_2018.txt');
% riv_raw = load(['/home/auto/MAMS/Data/CJD/2019/discharge_', ...
%     num2str(year),num2str(month,'%02i'),'.mat']);
% 
% for rivi=1:length(riv.CJ)
%     riv.discharge(rivi) = str2num(riv.CJ{rivi,1}.discharge{9,4}{1});
%     riv.day(rivi) = str2num(riv.CJ{rivi,1}.discharge{9,4}{1});
% end
riv_raw = textread(['/home/auto/MAMS/Data/CJD/2020/datong_archive_', ...
    num2str(year),num2str(month,'%02i'),'.dat']);
  
riv = riv_raw(and(riv_raw(:,2) == month, riv_raw(:,3) == day),7);
riv(riv==0)=NaN;
avgriv=nanmean(riv);
if(isnan(avgriv)==1)
    riv = riv_raw(riv_raw(:,2) == month,7);
    riv(riv==0)=NaN;
    avgriv=nanmean(riv);
end

seasonal_day=[-15, 15, 45, 75, 105, 135, 165, 195, 225, 255, 285, 315, 345, 375];




% % riv2= riv(12:end-1,:);
% riv2= riv ;
% riv3_yr= reshape(riv2(:,1),12,length(riv2)/12);
% riv3_riv= reshape(riv2(:,2),12,length(riv2)/12);
% 
% 
% if (year==0) % % make climate data;
%     riv3_riv =  mean(riv3_riv,2);
%     riv3_yr = repmat(0,12,1);
% end
% 


% season_discharge=[440 378  296  299  209  216  271  907  1481  1345  1084  619  440  378];
% daily_discharge=interp1(seasonal_day,season_discharge,1:365);
% dis=daily_discharge(fulltime+1);


% % % sinusoidal fitting --> not used
% seasonal_day=[-15, 15, 45, 75, 105, 135, 165, 195, 225, 255, 285, 315, 345, 375];
% season_discharge=[440 378  296  299  209  216  271  907  1481  1345  1084  619  440  378];
% yu = max(season_discharge);
% yl = min(season_discharge);
% yr = (yu-yl);                               % Range of ¡®y¡¯
% yz = season_discharge-yu+(yr/2);
% zx = seasonal_day(yz .* circshift(yz,[0 1]) <= 0);     % Find zero-crossings
% per = 2*mean(diff(zx));                     % Estimate period
% ym = mean(season_discharge);                               % Estimate offset
% fit = @(b,seasonal_day)  b(1).*(sin(2*pi*seasonal_day./b(2) + 2*pi/b(3))) + b(4);    % Function to fit
% fcn = @(b) sum((fit(b,seasonal_day) - season_discharge).^2);                              % Least-Squares cost function
% s = fminsearch(fcn, [yr;  per;  -1;  ym]);                       % Minimise Least-Squares
% xp = linspace(min(seasonal_day),max(seasonal_day));
% % figure(1)
% plot(seasonal_day,season_discharge,'b',  xp,fit(s,xp), 'r')
% grid




disp(' ')
disp(['Date is ',num2str(year,'%04i'),num2str(month,'%02i'),num2str(day,'%02i')])
disp(' ')


r = 1;
dis(1:totalday) = avgriv;
% avgflow=avgriv; %25031.7
% season_totalday_CRD = dis./avgflow;
sizedis = totalday;

Name = 'ChangJiang+Huai';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 120.0;
River.lat(r) = 31.9;  % raw
% River.lon(r) = 117.7;
% River.lat(r) = 30.9; %edyz3
River.lon(r) = 119.5;
River.lat(r) = 32; % nwps12
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=1794+244;
River.pfact(r)=1;
River.flow_mean(r)=mean(dis);
River.trans(r,1:totalday)=dis;

%--- edited by e.b.cho 2021.01.05 ------------------------------------
% set name of rivers
r_name = {'Changjiang+Huai','HuangHe','HaiheRiv.','LuanheRiv.','LiaoheRiv.','YaluRiv.','TaedongRiv.','HanRiv.',...
          'KeumRiv.','YeongsanRiv.','SumjinRiv.','NakdongRiv.','TumenRiv.'};

% set lon/lat 
r_lon = [119.5 118.5 117.75 119.2 121.9 124.4 125.8 127.4 127.2 126.6 127.56 128.95 130.6989];
r_lat = [32 37.5 39 39.5 41 40.2 38.8 37.4 36.0 34.9 35.18 35.15 42.2928 ];

% set discharge at river sourse points
season_discharge(2,:) = [440 378  296  299  209  216  271  907  1481  1345  1084  619  440  378];
season_discharge(3,:) = [27 23  19  22  13  8  18  283  651 273  66  53  27 23];
season_discharge(4,:) = [37 3 25 37 33 12 23 341 467 134 76 63 37 3];
season_discharge(5,:) = [90 36  40 100 133 134 193 559 1144 513 279 158 90 36];
season_discharge(6,:) = [685 656 657 709 693 695 828 1353 2117 1158 699 678 685 656];
season_discharge(7,:) = [34.57 25.43 23.21 36.86 89.57 84.86 181.36  513.79  800.29  259.71  42.36  48.79 34.57 25.43];
season_discharge(8,:) = [148.72 137.79  150.58  240.04  482.46  302.92  426.28 ... 
               2238.92 1768.71 920.92  273.36  214.92 148.72 137.79] ;
season_discharge(9,:) = [82.25 71 89 100.5 140.5 100.5 155 295 347.5 212.5 103 87.5 82.25 71];
season_discharge(10,:) = [21.75 20  36.75  26.75  53.75  32  93  52.25  76.5  54.5  25.25  22.75  21.75 20];
season_discharge(11,:) = [15.25 24.25 37.5 30 53 52.75 92.5 82.5 172.5 65  26.25 20.75 15.25 24.25];
season_discharge(12,:) = [83.3 61.45    83.75   130.25  218.25  149.2   119.65  608.9   404.9   531.65  188.7   121.35  83.3 61.45];
season_discharge(13,:) = [10, 30, 20, 50, 160, 200, 340, 380, 570, 410, 160, 80, 10, 30];


for r_loop = 2:13

% interpolation from  monthly to daily 
daily_discharge=interp1(seasonal_day,season_discharge(r_loop,:),1:365);
if fulltime == 365
dis = daily_discharge(fulltime);
else
dis = daily_discharge(fulltime+1);
end

avgflow = mean(dis);
Name = char(r_name(r_loop));
River.Name(r_loop,1:length(Name)) = Name;
River.lon(r_loop) = r_lon(r_loop);
River.lat(r_loop) = r_lat(r_loop);
River.flag(r_loop) = 3;
filen='RivDis';
River.file(r_loop,1:length(filen))=filen;
if r_loop == 2 
River.area(r_loop)=894;
else
River.area(r_loop)=30;
end
River.pfact(r_loop)=1;
River.flow_mean(r_loop)=  avgflow ;
River.trans(r_loop,1:totalday)= dis;

end

%--- editing - not completed -----------------------------------------

%{

r = 2;
% [Dec Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Jan] for interpolation
season_discharge=[440 378  296  299  209  216  271  907  1481  1345  1084  619  440  378]; 
daily_discharge=interp1(seasonal_day,season_discharge,1:365);
% edit by e.b.cho 2021.01.05 because of error on last day of year 
if fulltime == 365
dis = daily_discharge(fulltime);
else
dis=daily_discharge(fulltime+1);
end
% original 
% dis=daily_discharge(fulltime+1);


avgflow=mean(dis);
Name = 'HuangHe';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 118.5;
River.lat(r) = 37.5;
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=894;
River.pfact(r)=1;
River.flow_mean(r)=  avgflow ;
River.trans(r,1:totalday)= dis;
% River.trans(r,1:12)= season_totalday.*River.flow_mean(r);

% r3 ~r6 
% Seasonal variations of the Yellow River plume in the Bohai Sea: A model study
% WangQ_2008JGR [Qiang Wang,1 Xinyu Guo,1 and Hidetaka Takeoka1]


r = 3;
season_discharge=[27 23  19  22  13  8  18  283  651 273  66  53  27 23];
daily_discharge=interp1(seasonal_day,season_discharge,1:365);
% edit by e.b.cho 2021.01.05 because of error on last day of year 
if fulltime == 365 
dis = daily_discharge(fulltime);
else
dis=daily_discharge(fulltime+1);
end
% original 
% dis=daily_discharge(fulltime+1);

avgflow=mean(dis);
Name = 'HaiheRiv.';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 117.75; %126.7;
River.lat(r) = 39;
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=30;
River.pfact(r)=1;
River.flow_mean(r)= avgflow ;
River.trans(r,1:totalday)=dis;

r = 4;
season_discharge=[37 3 25 37 33 12 23 341 467 134 76 63 37 3];
daily_discharge=interp1(seasonal_day,season_discharge,1:365);
% edit by e.b.cho 2021.01.05 because of error on last day of year 
if fulltime == 365 
dis = daily_discharge(fulltime);
else
dis=daily_discharge(fulltime+1);
end
% original 
% dis=daily_discharge(fulltime+1);

avgflow=mean(dis);
Name = 'LuanheRiv.';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 119.2; %126.7;
River.lat(r) = 39.5;
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=30;
River.pfact(r)=1;
River.flow_mean(r)= avgflow ;
River.trans(r,1:totalday)=dis;
 
r = 5;
season_discharge=[90 36  40 100 133 134 193 559 1144 513 279 158 90 36];
daily_discharge=interp1(seasonal_day,season_discharge,1:365);
% edit by e.b.cho 2021.01.05 because of error on last day of year 
if fulltime == 365 
dis = daily_discharge(fulltime);
else
dis=daily_discharge(fulltime+1);
end
% original 
% dis=daily_discharge(fulltime+1);

avgflow=mean(dis);
Name = 'LiaoheRiv.';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 121.9; %121.8;
River.lat(r) = 41; %40.9
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=30;
River.pfact(r)=1;
River.flow_mean(r)= avgflow ;
River.trans(r,1:totalday)=dis;

r = 6;
season_discharge=[685 656 657 709 693 695 828 1353 2117 1158 699 678 685 656];
daily_discharge=interp1(seasonal_day,season_discharge,1:365);
% edit by e.b.cho 2021.01.05 because of error on last day of year 
if fulltime == 365 
dis = daily_discharge(fulltime);
else
dis=daily_discharge(fulltime+1);
end
% original 
% dis=daily_discharge(fulltime+1);

avgflow=mean(dis);
Name = 'YaluRiv.';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 124.4; %126.7;
River.lat(r) = 40.2; %40.0
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=30;
River.pfact(r)=1;
River.flow_mean(r)= avgflow ;
River.trans(r,1:totalday)=dis;


r = 7;
season_discharge=[34.57 25.43 23.21 36.86 89.57 84.86 181.36  513.79  800.29  259.71  42.36  48.79 34.57 25.43];
daily_discharge=interp1(seasonal_day,season_discharge,1:365);
% edit by e.b.cho 2021.01.05 because of error on last day of year 
if fulltime == 365 
dis = daily_discharge(fulltime);
else
dis=daily_discharge(fulltime+1);
end
% original 
% dis=daily_discharge(fulltime+1);

avgflow=mean(dis);
Name = 'TaedongRiv.';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 125.8; %126.7;
River.lat(r) = 38.8;
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=30;
River.pfact(r)=1;
River.flow_mean(r)= avgflow   ;
River.trans(r,1:totalday)=dis;


r = 8;
season_discharge=[148.72 137.79  150.58  240.04  482.46  302.92  426.28 ...
               2238.92 1768.71 920.92  273.36  214.92 148.72 137.79] ; % clim
daily_discharge=interp1(seasonal_day,season_discharge,1:365);
% edit by e.b.cho 2021.01.05 because of error on last day of year 
if fulltime == 365 
dis = daily_discharge(fulltime);
else
dis=daily_discharge(fulltime+1);
end
% original 
% dis=daily_discharge(fulltime+1);

avgflow=mean(dis);
Name = 'HanRiv.';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 127.4; %126.7;
River.lat(r) =  37.4;
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=30;
River.pfact(r)=1;
River.flow_mean(r)= avgflow   ;
River.trans(r,1:totalday)=dis;

r = 9;
season_discharge=[82.25 71 89 100.5 140.5 100.5 155 295 347.5 212.5 103 87.5 82.25 71];
daily_discharge=interp1(seasonal_day,season_discharge,1:365);
 % edit by e.b.cho 2021.01.05 because of error on last day of year 
if fulltime == 365 
dis = daily_discharge(fulltime);
else
dis=daily_discharge(fulltime+1);
end
% original 
% dis=daily_discharge(fulltime+1);

avgflow=mean(dis);
Name = 'KeumRiv.';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 127.2;  %126.7;
River.lat(r) = 36.00;
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=30;
River.pfact(r)=1;
River.flow_mean(r)= avgflow   ;
River.trans(r,1:totalday)=dis;

r = 10;
season_discharge=[21.75 20  36.75  26.75  53.75  32  93  52.25  76.5  54.5  25.25  22.75  21.75 20];
daily_discharge=interp1(seasonal_day,season_discharge,1:365);
% edit by e.b.cho 2021.01.05 because of error on last day of year 
if fulltime == 365 
dis = daily_discharge(fulltime);
else
dis=daily_discharge(fulltime+1);
end
% original 
% dis=daily_discharge(fulltime+1);

avgflow=mean(dis);
Name = 'YeongsanRiv.';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 126.6;%126.6;
River.lat(r) = 34.9;%34.8;
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=30;
River.pfact(r)=1;
River.flow_mean(r)= avgflow   ;
River.trans(r,1:totalday)=dis;

r = 11;
season_discharge=[15.25 24.25 37.5 30 53 52.75 92.5 82.5 172.5 65  26.25 20.75 15.25 24.25];
daily_discharge=interp1(seasonal_day,season_discharge,1:365);
% edit by e.b.cho 2021.01.05 because of error on last day of year 
if fulltime == 365 
dis = daily_discharge(fulltime);
else
dis=daily_discharge(fulltime+1);
end
% original 
% dis=daily_discharge(fulltime+1);

avgflow=mean(dis);
Name = 'SumjinRiv.';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 127.56;%126.6;
River.lat(r) = 35.18;%34.8;
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=30;
River.pfact(r)=1;
River.flow_mean(r)= avgflow   ;
River.trans(r,1:totalday)=dis;


r = 12;
season_discharge=[83.3 61.45	83.75	130.25	218.25	149.2	119.65	608.9	404.9	531.65	188.7	121.35	83.3 61.45];
daily_discharge=interp1(seasonal_day,season_discharge,1:365);
% edit by e.b.cho 2021.01.05 because of error on last day of year 
if fulltime == 365 
dis = daily_discharge(fulltime);
else
dis=daily_discharge(fulltime+1);
end
% original 
% dis=daily_discharge(fulltime+1);

avgflow=mean(dis);
Name = 'NakdongRiv.';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 128.95;  %126.6;
River.lat(r) = 35.15;   %35.4; 
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=30;
River.pfact(r)=1;
River.flow_mean(r)= avgflow   ;
River.trans(r,1:totalday)=dis;

r = 13;
season_discharge=[10, 30, 20, 50, 160, 200, 340, 380, 570, 410, 160, 80, 10, 30];
daily_discharge=interp1(seasonal_day,season_discharge,1:365);
% edit by e.b.cho 2021.01.05 because of error on last day of year 
if fulltime == 365 
dis = daily_discharge(fulltime);
else
dis=daily_discharge(fulltime+1);
end
% original 
% dis=daily_discharge(fulltime+1);

avgflow=mean(dis);
Name = 'TumenRiv.';
River.Name(r,1:length(Name)) = Name;
River.lon(r) = 130.6989; 
River.lat(r) = 42.2928;   
River.flag(r) = 3;
filen='RivDis';
River.file(r,1:length(filen))=filen;
River.area(r)=30;
River.pfact(r)=1;
River.flow_mean(r)= avgflow   ;
River.trans(r,1:totalday)=dis;

%}

% save eas_rivers_discharge_YS_EJS River


%add_ocean_toolboxes;

IWRITE=1;
IPLOT=0;

%-----------------------------------------------------------------------
% specify the input files
%-----------------------------------------------------------------------


grdname = [workdir,'/auto01_grid.nc'];

grd_file = grdname ;

% the new netcdf forcing file - river data will be appended
%Fname = 'E:\Working\roms\1_4\input\ecco\roms_eas4_river.nc';

head=[output_dir,testname,'_river_'];
mid=[num2str(year,'%04i'),num2str(month,'%02i'),num2str(day,'%02i')];
foot='.nc';
if (year==0)
    Fname = [head,'climate',foot];
else
    Fname = [head,mid,foot];
end

% % load the river flow data structure
% Rname = 'eas_rivers_discharge_YS_EJS';
% load(Rname)
% if ~exist('River')
%   error([ 'Structure ''River'' does not exist in ' Rname])
% end

% get the roms grid
% we need this to find the grid indices corresponding to the lon/lat
% locations of the dat


Vtransform=2;
Vstretching=4;
theta_s=10;
theta_b=1;
hc=250;
N=40; % # of vertical levels
grd = roms_get_grid(Vtransform, Vstretching, grd_file, [theta_s,theta_b,hc,N]);

%-----------------------------------------------------------------------
%  Set river name, location, and runoff direction.
%-----------------------------------------------------------------------
%
%  Notice that for now the river identification number is that of the
%  river count.  This variable is needed to fool ROMS generic IO
%  interphase; it can be any real number since will never used.
%
%  River.lon  = nominal longitude of river mouth (this routine finds i,j)
%  River.lat  = nominal latitude of river mouth (this routine finds i,j)
%
%  River.dir  = 0 for flow entering cell through u-direction face
%             = 1 for flow entering cell through v-direction face
%
%  River.Xpos,Ypos = the i,j index of the u-point or v-point location on 
%             the ROMS C-grid thyat defines the face of the cell through
%             which the river enters. 
%             The river input is added to the appropriate ubar, vbar, u, 
%             v, and tracer fluxes on this face.
%
%  River.sens = 1 for river flow in the positive u or v direction
%             = -1 for river flow in the negative u or v direction, 
%             This factor multiplies the river flow rate Q (>0) (see
%             sources.h for why this is done)
%
%  River.flag can have any of the following values:
%             = 0,  All Tracer source/sink are off.
%             = 1,  Only temperature is on.
%             = 2,  Only salinity is on.
%             = 3,  Both temperature and salinity are on. 
%
%  This is documented further in ROMS sources.h

Nrivers = length(River.lon);

%-----------------------------------------------------------------------
% Find the ij coordinates of the river lat/lon points
%-----------------------------------------------------------------------

for r = 1:Nrivers
  
  River.num(r) = r;

  % The logic below checks whether the u-face or v-face is the better 
  % approximation to the nominal location of the river mouth, and assigns 
  % River.dir accordingly. 
  % The sign of diff(rhomask) is used to determine whether the flow 
  % enters from the NSEW

  % case flow enters cell through u-direction face
  glon = grd.lon_u;
  glat = grd.lat_u;
  % keep only u-faces that are coastline
  drhomask = diff(grd.mask_rho')';
  notcoast = find(drhomask==0);
  glon(notcoast) = NaN;
  glat(notcoast) = NaN;
  % find the u-face closest to the river mouth
  [J,I,du] = closest(glon,glat,River.lon(r),River.lat(r));

  % assume this is best option until we test v-face
  River.Xpos(r) = I;
  River.Ypos(r) = J-1; % ROMS u points start from index j=0
  River.dir(r)  = 0;
  River.sens(r) = drhomask(J,I);
  River.glon(r) = glon(J,I);
  River.glat(r) = glat(J,I);

  % case flow enters cell through v-direction face
  glon = grd.lon_v;
  glat = grd.lat_v;
  % keep only v-faces that are coastline
  drhomask = diff(grd.mask_rho);
  notcoast = find(drhomask==0);
  glon(notcoast) = NaN;
  glat(notcoast) = NaN;
  % find the v-face closest to the river mouth
  [J,I,dv] = closest(glon,glat,River.lon(r),River.lat(r));
  
  if dv < du 
    % overwrite because v-face result is closer to river mouth
    River.Xpos(r) = I-1; % ROMS v points start from index i=0
    River.Ypos(r) = J;   
    River.dir(r)  = 1;
    River.sens(r) = drhomask(J,I);
    River.glon(r) = glon(J,I);
    River.glat(r) = glat(J,I);
  end
 
end

if IPLOT
  clf
  % plot the original and selected lon/lat to check that the lookup was done 
  % sensibly
  pcolorjw(grd.lon_rho,grd.lat_rho,grd.mask_rho_nan)
% amerc;
  % shading faceted
% plotnenacoast(2)
  hold on
  han = plot(River.lon,River.lat,'r^');
  set(han,'markersize',10,'MarkerFaceColor',get(han,'color'))
  han = plot(River.glon,River.glat,'bd');
  set(han,'markersize',10,'MarkerFaceColor',get(han,'color'))
  han = plot([River.lon; River.glon],[River.lat; River.glat],'r-');
  set(han,'linewidth',2)
  for r=1:length(River.lon)
    han = text(River.lon(r),River.lat(r),...
	[ ' (' int2str(r) ') ' deblank(River.Name(r,:))]);
    set(han,'fontsize',12)
  end  
  hold off
end

for r=1:Nrivers  
  River.vshape(r,1:N)=1/N;
  River.trans(r,:) = River.sens(r)*River.trans(r,:);
end

  detailstr = ['The ' int2str(Nrivers) ' Rivers are : '];
for r=1:Nrivers;  
  detailstr = [detailstr int2str(r) '. ' strcat(River.Name(r,:)) ', '];
end
  detailstr = [detailstr(1:end-2) '.'];
  

%  River.time is evenly spaced through the year of 365.25 days
% River.time =time;
% totalday=365.;
% River.time = [15:30:345];
River.time=time;
River.time_units = 'days';


% temp/salt get used, or not, according to the value of River.flag 
salt = 0;
%temp = 0;
% Ytemp_max=28;
% Ytemp_min=8;
% Yamp=(Ytemp_max-Ytemp_min)/2;
% Htemp_max=25;
% Htemp_min=3;
% Hamp=(Htemp_max-Htemp_min)/2;
% factor=2*pi/365.0;
% 
%  for i=1:length(River.time)
%      Htemp(i)=Hamp*( sin(factor*(River.time(i)) + 1) )+Htemp_min;
%      Ytemp(i)=Yamp*( sin(factor*(River.time(i)) + 1) )+Ytemp_min;
%  end


% for i=1:length(River.time)
%   River.temp(1,:,i)=ones([1 N]).*Ytemp(i);
%   River.temp(2,:,i)=ones([1 N]).*Htemp(i);
%   River.salt(:,:,i)=ones([Nrivers N]).*salt;
% end

% aaaaaaaaaaaaaaaaaa

% Rtemp_max = [28.23 27.52  27.19 27.09 26.86 27    27.23 27.54 27.83  28.02  27.97 27.97 20.49] ;
% Rtemp_min = [6.01  0.12  -1.48  -2.01 -3.51 -2.55 -1.27 0.23  1.73    2.9   2.6   2.63 1.09] ;

% % Tuman river temp(OISST) -> [1.51, 1.09, 1.68, 3.90, 7.87, 13.00, 17.54, 20.49, 18.91, 14.65, 9.37, 4.32]

for i=1:length(River.time)
    for r=1:Nrivers 
%   River.temp(1,:,i)=ones([1 N]).*Ytemp(i);
%         Htemp_max= Rtemp_max(r) ;
%         Htemp_min= Rtemp_min(r) ;
%         Hamp=(Htemp_max-Htemp_min)/2;
%         factor=2*pi/365.0;
%         Htemp(i)=Hamp*( sin(factor*(River.time(i))) + 7/12 * pi)+Htemp_min;
%         River.temp(r,:,i)=ones([1 N]).*Htemp(i);
    end
  River.salt(:,:,i)=ones([Nrivers N]).*salt;
end
 

OISST_lat = ncread(OISST_name,'lat');
OISST_lon = ncread(OISST_name,'lon');
%sst_s = ncread(OISST_name, 'analysed_sst');
%sst_e = ncread(OISST_name, 'analysis_error');
sst_s = ncread(OISST_name, 'sst');
sst_e = ncread(OISST_name, 'err');
if (abs(mean(mean(sst_s, 'omitnan'),'omitnan'))>1000)
    sst_s = sst_s * 0.01; %% scale factor
    sst_e = sst_e * 0.01;
%    sst_s = sst_s - 273.15; % K -> C
else
%    sst_s = sst_s - 273.15;
end

[indw, inde, inds, indn]=findind_Y(1/4, [115, 162, 15, 52], OISST_lon, OISST_lat);
sst_s(sst_s<=-1000) = NaN;
sst_s(sst_s>= 1000) = NaN;

for k=1:r
    for i=indw:inde
        for j=inds:indn
            if (isnan(sst_s(i,j))~=1)
                River.dist(k,i,j)=m_lldist([River.lon(k) OISST_lon(i)], [River.lat(k) OISST_lat(j)]);
            else
                River.dist(k,i,j)=NaN;
            end
        end
    end
    k
end
River.dist(River.dist==0)=NaN;
for k=1:r
    min_dist_val=min(min(River.dist(k,:,:)));
    for i=indw:inde
        for j=inds:indn
            if (River.dist(k,i,j)==min_dist_val)
                River.temp(k,1:N,1:length(River.time))=sst_s(i,j);
                k
            end
        end
    end
end


%River.salt(41,:,:) = 28.9;

%-----------------------------------------------------------------------
%  Create empty river data FORCING NetCDF file.
%-----------------------------------------------------------------------

  disp([ 'Creating ' Fname '...'])

      create_empty_EAS_rivers_Y

%-----------------------------------------------------------------------
%  Write river data into existing FORCING NetCDF file.
%-----------------------------------------------------------------------

  disp([ 'Appending rivers data to ' Fname '...'])
%  disp('paused...');pause
%  [Vname,status]=wrt_rivers(Fname,River);

%     write_rivers
     
     nc = netcdf(Fname,'write');
     
theVarname = 'river';
nc{theVarname}(:) = River.num;

theVarname = 'river_Xposition';
nc{theVarname}(:) = River.Xpos;

theVarname = 'river_Eposition';
nc{theVarname}(:) = River.Ypos;

theVarname = 'river_direction';
nc{theVarname}(:) = River.dir;

theVarname = 'river_flag';
nc{theVarname}(:) = River.flag;

theVarname = 'river_Vshape';
nc{theVarname}(:,:) = River.vshape;

theVarname = 'river_time';
nc{theVarname}(:) = River.time;

theVarname = 'river_transport';
nc{theVarname}(:,:) = River.trans';

theVarname = 'river_temp';
nc{theVarname}(:,:,:) = permute(River.temp,[3 2 1]);

theVarname = 'river_salt';
nc{theVarname}(:,:,:) = permute(River.salt,[3 2 1]);

result = close(nc);  
 
  
 
 
