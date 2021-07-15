%==========================================================================
% % This script is based on MATLAB R2017a
% Updated 14-Feb-2019 by Y.Y.Kim
% NOMADS CFSR(v1) to ROMS Surface forcing file
% NOMADS CFSR(v1) --> available for 01 Jan 1979 - 31 Mar 2011
% 
% dataset description
% https://www.ncdc.noaa.gov/data-access/model-data/model-datasets/climate-forecast-system-version2-cfsv2
% 
% ftp link
% ftp://nomads.ncdc.noaa.gov/CFSR/HP_time_series/
% 
% and we make roms forcing files with that netcdf file 
% orginated from grib2 file using kwgrib
% spatial domain : global, 0.5 degree resolution
% time frequency : 1 hour
%==========================================================================

% clear all;close all; clc;
warning off;

%==========================================================================
% set path depending on O/S                                       by silver
%==========================================================================
system_name=computer;
if (strcmp(system_name,'PCWIN64'))
% % for windows
elseif (strcmp(system_name,'GLNXA64'))
% % for linux server
    addpath(genpath([matlabroot,'/toolbox/matlab/imagesci/'])); %% add new netcdf path
    addpath(genpath(['/home/auto/MAMS/Source/MATLAB/util/roms_grid/'])); %% add kyy grid tool
    addpath(genpath(['/home/auto/MAMS/Source/MATLAB/util/m_map/'])); %% add m_map
end
% start

%==========================================================================
% model information                                               by silver
%==========================================================================
expname='nwp_1_10';
testname='auto01';

grdfile=['/home/auto/MAMS/Data/01_NWP_1_10/Input/',testname,'_grid.nc'];
disp(['grdfile : ', grdfile])

%==========================================================================
% variable name for SBC                                           by silver
%==========================================================================
% varname={'TMP_2maboveground',  ...  %% 2m temperature
%     'PRES_surface', ...   %% surface atmospheric pressure
%     'SPFH_2maboveground', ...  %% humidity
%     'DSWRF_surface', ...  %% downward short wave radiation
%     'UGRD_10maboveground', ...  %% U direction wind
%     'VGRD_10maboveground'};  %% V direction wind

varname={'rhum', 'swrad', 'tmp', 'psl', 'u10m', 'v10m'};
% varname={'UGRD_10maboveground', ...  %% U direction wind
%     'VGRD_10maboveground'};  %% V direction wind

%==========================================================================
% set time: runtime - year, month, day (2 days ago)               by silver
%==========================================================================
tempday=num2str(fulldate);
runtime(1)=str2num(tempday(1:4));
runtime(2)=str2num(tempday(5:6));
runtime(3)=str2num(tempday(7:8));

%==========================================================================
output_dir=['/home/auto/MAMS/Data/01_NWP_1_10/Input/SBC/', ...
    num2str(runtime(1),'%04i'),num2str(runtime(2),'%02i'),'/'];

if (exist(output_dir,'dir')~=7) % 7: if name is a folder          by silver
    mkdir(output_dir)
end

%==========================================================================
% call fun for making SBC.nc - each variable                      by silver
%==========================================================================
for j=1:length(varname)
    status = func_ROMS_surface_forcing_auto(testname, grdfile, runtime(1), runtime(2), runtime(3), ...
        varname{j}, output_dir);
end
