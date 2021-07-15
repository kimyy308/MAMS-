clear all; close all; clc;
ncid = netcdf.open('/home/auto/MAMS/Data/01_NWP_1_10/Input/auto01_ini.nc','WRITE');
netcdf.reDef(ncid);
netcdf.endDef(ncid);
%%%%tyear=${tempY};
%%%%ncwriteatt('auto01_ini.nc','ocean_time','units',['seconds since ',num2str(tyear+1,'%04i'),'-01-01 00:00:00']);
tvarid = netcdf.inqVarID(ncid,'ocean_time');
%netcdf.putVar(ncid,tvarid,0,1,13996800); % start, count, value
%netcdf.putVar(ncid,tvarid,0,1,14601600); % start, count, value
netcdf.putVar(ncid,tvarid,0,1,0); % start, count, value
netcdf.close(ncid);
exit
