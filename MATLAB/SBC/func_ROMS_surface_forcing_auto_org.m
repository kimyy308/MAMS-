function status=func_ROMS_surface_forcing_auto(testname, grdfile, year, month, day, varname_short, outfiledir)
%==========================================================================
% This function is based on MATLAB 2017a
% Updated 14-Feb-2019 by Y.Y.Kim
 
% NOMADS_root_dir = ['/home/auto/MAMS/Data/NOMADS/gfs_0p25/', ...
%         num2str(year,'%04i'),num2str(month,'%02i'), num2str(day, '%02i'), '/nc_pieces/'];
% 
% UM_root_dir = ['/home/auto/MAMS/Data/NOMADS/gfs_0p25/', ...
%         num2str(year,'%04i'),num2str(month,'%02i'), num2str(day, '%02i'), '/nc_pieces/'];  
%     
%     outfiledir = '/data1/kimyy/Model/ROMS/roms_nwp/nwp_1_20/forcing_matlab/';
%     testname = 'nwp_1_20';

% Example of filename
%     tmp_20190501_00h.nc
%     psl_20190501_00h.nc
%     swrad_20190501_00h.nc
%     rhum_20190501_00h.nc
%     u10_20190501_00h.nc
%     v10_20190501_00h.nc
%==========================================================================

atm_name = 'um_nomads_ ';
% % from varname, define filename, units,
% % varname in the file, varname in the ROMS forcing file,

switch varname_short
    case 'tmp'
        varname_um = 'TMP_1_5maboveground';
        varname_nomads = 'TMP_2maboveground';
        varname_um_filename = 'tmp';
        varname_nomads_filename = 't2m';

        varname_output = 'Tair';
        long_name = [atm_name, ' 2 meter Temperature'];
        units = 'Celsius';           
    case 'rhum'
        varname_um = 'RH_1_5maboveground';
        varname_nomads = 'RH_2maboveground';
        varname_um_filename = 'rhum';
        varname_nomads_filename = 'rhum';

        varname_output = 'Qair';
        long_name = [atm_name, ' Relative humidity'];
        units = 'Percentage';   
    case 'psl'
        varname_um = 'PRMSL_meansealevel';
        varname_nomads = 'PRMSL_meansealevel';
        varname_um_filename = 'psl';
        varname_nomads_filename = 'psl';

        varname_output = 'Pair';
        long_name = [atm_name, ' Mean Sea Level pressure'];
        units = 'mbar';   
    case 'swrad'
        varname_um = 'var0_4_192_surface';
        varname_nomads = 'DSWRF_surface';
        varname_um_filename = 'swrad';
        varname_nomads_filename = 'swrad';

        varname_output = 'swrad';
        long_name = [atm_name, ' Short Wave RAdiation Downwards'];
        units = 'W/m^2';
    case 'u10m'
        varname_um = 'UGRD_10maboveground';
        varname_nomads = 'UGRD_10maboveground';
        varname_um_filename = 'u10m';
        varname_nomads_filename = 'u10m';

        varname_output = 'Uwind';
        long_name = [atm_name, ' 10 Meter zonal wind velocity'];
        units = 'm/s';
    case 'v10m'
        varname_um = 'VGRD_10maboveground';
        varname_nomads = 'VGRD_10maboveground';
        varname_um_filename = 'v10m';
        varname_nomads_filename = 'v10m';

        varname_output = 'Vwind';
        long_name = [atm_name, ' 10 Meter meridional wind velocity'];
        units = 'm/s';
    otherwise
% %     If unknown varname is used, return
        '?'
        return
end

% %     ROMS forcing file config
varname_time = 'time';
outfile = strcat(outfiledir,testname,'_',num2str(year,'%04i'),num2str(month,'%02i'),num2str(day,'%02i'),'_',varname_output,'.nc');
disp(['ROMS forcing file is the ',outfile])

% %  read model grid
lon_rho = ncread(grdfile,'lon_rho');
lat_rho = ncread(grdfile,'lat_rho');
data_info = ncinfo(grdfile, 'lon_rho'); 

lon_grd_max = lon_rho(data_info.Size(1),data_info.Size(2));
lat_grd_max = lat_rho(data_info.Size(1),data_info.Size(2));
lon_grd_min = lon_rho(1,1);
lat_grd_min = lat_rho(1,1);

% if (exist(NOMADS_root_dir, 'dir')~=7)
%     NOMADS_root_dir = ['/home/auto/MAMS/Data/NOMADS/gfs_0p25/', ...
%         num2str(year,'%04i'),num2str(month,'%02i'), num2str(day, '%02i'), '_forecast/nc_pieces/'];
% end

% %     UM & NOMADS set filename for reading grid, data
for dayind = 1:4
    temp_runtime=datevec(datenum([num2str(month),'-',num2str(day),'-',num2str(year)])+dayind -1);
    
%==========================================================================
% make folder name for UM & NOMAD
% 1. current name
% 2. forecast name                                       edited by silver
%==========================================================================
% 1. current dir name
    
    UM_root_dir = ['/home/auto/MAMS/Data/UM_global_10km/', ...
        num2str(temp_runtime(1),'%04i'),num2str(temp_runtime(2),'%02i'), ...
        num2str(temp_runtime(3), '%02i'), '/nc_pieces/'];
    NOMADS_root_dir = ['/home/auto/MAMS/Data/NOMADS/gfs_0p25/', ...
        num2str(temp_runtime(1),'%04i'),num2str(temp_runtime(2),'%02i'), ...
        num2str(temp_runtime(3), '%02i'), '/nc_pieces/'];
    
% 2. forecast dir name

    if (exist(UM_root_dir, 'dir')~=7)
        UM_root_dir = ['/home/auto/MAMS/Data/UM_global_10km/', ...
            num2str(temp_runtime(1),'%04i'),num2str(temp_runtime(2),'%02i'), ...
            num2str(temp_runtime(3), '%02i'), '_forecast/nc_pieces/'];
    end
    if (exist(NOMADS_root_dir, 'dir')~=7)
        NOMADS_root_dir = ['/home/auto/MAMS/Data/NOMADS/gfs_0p25/', ...
            num2str(temp_runtime(1),'%04i'),num2str(temp_runtime(2),'%02i'), ...
            num2str(temp_runtime(3), '%02i'), '_forecast/nc_pieces/'];
    end
%==========================================================================

    switch varname_short
        case 'swrad'
            for hourind = 1:4
                UM_filenames{dayind*4-4 + hourind} = [UM_root_dir, varname_um_filename, '_', ...
                    num2str(temp_runtime(1),'%02i'), num2str(temp_runtime(2),'%02i'), num2str(temp_runtime(3),'%02i'), ...
                    '_', num2str(hourind * 6 - 3, '%02i'), 'h.nc'];
                NOMADS_filenames{dayind*4-4 + hourind} = [NOMADS_root_dir, varname_nomads_filename, '_', ...
                    num2str(temp_runtime(1),'%02i'), num2str(temp_runtime(2),'%02i'), num2str(temp_runtime(3),'%02i'), ...
                    '_', num2str(hourind * 6 - 3, '%02i'), 'h.nc'];
                if (dayind==1 && hourind ==1)
                    % %     read UM grids
                    UM_lon   = ncread(UM_filenames{1},'longitude');
                    UM_lat   = ncread(UM_filenames{1},'latitude');
                    [UM_lon_min, UM_lon_max, UM_lat_min, UM_lat_max] =  ...
                        findind_Y(1/10, [lon_grd_min, lon_grd_max, lat_grd_min, lat_grd_max], ...
                        UM_lon, UM_lat);

                    % %     read NOMADS grids
                    NOMADS_lon   = ncread(NOMADS_filenames{1},'longitude');
                    NOMADS_lat   = ncread(NOMADS_filenames{1},'latitude');
                    [NOMADS_lon_min, NOMADS_lon_max, NOMADS_lat_min, NOMADS_lat_max] =  ...
                        findind_Y(1/10, [lon_grd_min, lon_grd_max, lat_grd_min, lat_grd_max], ...
                        NOMADS_lon, NOMADS_lat);
                end
                UM_lon_d = UM_lon_max - UM_lon_min + 2;
                UM_lat_d = UM_lat_max - UM_lat_min + 1;
                UM_data_cut(:,:,dayind*4-4 + hourind) = ...
                    ncread(UM_filenames{dayind*4-4 + hourind}, varname_um, ...
                    [UM_lon_min-1, UM_lat_min, 1], [UM_lon_d, UM_lat_d, 1]);
                NOMADS_lon_d = NOMADS_lon_max - NOMADS_lon_min + 2;
                NOMADS_lat_d = NOMADS_lat_max - NOMADS_lat_min + 2;
                NOMADS_data_cut(:,:,dayind*4-4 + hourind) = ...
                    ncread(NOMADS_filenames{dayind*4-4 + hourind}, varname_nomads, ...
                    [NOMADS_lon_min-1, NOMADS_lat_min-1, 1], [NOMADS_lon_d, NOMADS_lat_d, 1]);
            end
        otherwise
            for hourind = 1:8
                UM_filenames{dayind*8-8 + hourind} = [UM_root_dir, varname_um_filename, '_', ...
                    num2str(temp_runtime(1),'%02i'), num2str(temp_runtime(2),'%02i'), num2str(temp_runtime(3),'%02i'), ...
                    '_', num2str(hourind * 3 - 3, '%02i'), 'h.nc'];
                NOMADS_filenames{dayind*8-8 + hourind} = [NOMADS_root_dir, varname_nomads_filename, '_', ...
                    num2str(temp_runtime(1),'%02i'), num2str(temp_runtime(2),'%02i'), num2str(temp_runtime(3),'%02i'), ...
                    '_', num2str(hourind * 3 - 3, '%02i'), 'h.nc'];
                if (dayind==1 && hourind ==1)
                    % %     read UM grids
                    UM_lon   = ncread(UM_filenames{1},'longitude');
                    UM_lat   = ncread(UM_filenames{1},'latitude');
                    [UM_lon_min, UM_lon_max, UM_lat_min, UM_lat_max] =  ...
                        findind_Y(1/10, [lon_grd_min, lon_grd_max, lat_grd_min, lat_grd_max], ...
                        UM_lon, UM_lat);

                    % %     read NOMADS grids
                    NOMADS_lon   = ncread(NOMADS_filenames{1},'longitude');
                    NOMADS_lat   = ncread(NOMADS_filenames{1},'latitude');
                    [NOMADS_lon_min, NOMADS_lon_max, NOMADS_lat_min, NOMADS_lat_max] =  ...
                        findind_Y(1/10, [lon_grd_min, lon_grd_max, lat_grd_min, lat_grd_max], ...
                        NOMADS_lon, NOMADS_lat);
                end
                UM_lon_d = UM_lon_max - UM_lon_min + 2;
                UM_lat_d = UM_lat_max - UM_lat_min + 1;
                UM_data_cut(:,:,dayind*8-8 + hourind) = ...
                    ncread(UM_filenames{dayind*8-8 + hourind}, varname_um, ...
                    [UM_lon_min-1, UM_lat_min, 1], [UM_lon_d, UM_lat_d, 1]);
                NOMADS_lon_d = NOMADS_lon_max - NOMADS_lon_min + 2;
                NOMADS_lat_d = NOMADS_lat_max - NOMADS_lat_min + 2;
                NOMADS_data_cut(:,:,dayind*8-8 + hourind) = ...
                    ncread(NOMADS_filenames{dayind*8-8 + hourind}, varname_nomads, ...
                    [NOMADS_lon_min-1, NOMADS_lat_min-1, 1], [NOMADS_lon_d, NOMADS_lat_d, 1]);
            end
    end
    
end

UM_lon_cut=UM_lon(UM_lon_min-1 : UM_lon_max, UM_lat_min : UM_lat_max);
UM_lat_cut=UM_lat(UM_lon_min-1 : UM_lon_max, UM_lat_min : UM_lat_max);
NOMADS_lon_cut=NOMADS_lon(NOMADS_lon_min-1 : NOMADS_lon_max);
NOMADS_lat_cut=NOMADS_lat(NOMADS_lat_min-1 : NOMADS_lat_max);

switch varname_short
    case 'tmp'
        UM_data_cut = UM_data_cut - 273.15;
        NOMADS_data_cut = NOMADS_data_cut - 273.15;
    case 'psl'
        UM_data_cut = UM_data_cut / 100.0;
        NOMADS_data_cut = NOMADS_data_cut / 100.0;
    case 'swrad'
        temp_UM_data_cut = UM_data_cut;
        temp_NOMADS_data_cut = NOMADS_data_cut;
        clear UM_data_cut NOMADS_data_cut
        for dayi=1:4
            UM_data_cut(:,:,dayi) = mean(temp_UM_data_cut(:,:,dayi*4-3:dayi*4),3);
            NOMADS_data_cut(:,:,dayi) = mean(temp_NOMADS_data_cut(:,:,dayi*4-3:dayi*4),3);
        end
end


for timei=1:length(UM_data_cut(1,1,:))

    UM_data_interpolated(:,:,timei)= ...
        griddata(double(UM_lon_cut),double(UM_lat_cut), ...
        double(UM_data_cut(:,:,timei)),lon_rho,lat_rho);

    NOMADS_data_interpolated(:,:,timei)= ...
        griddata(double(NOMADS_lon_cut),double(NOMADS_lat_cut), ...
        double(NOMADS_data_cut(:,:,timei)'),lon_rho(:,1),lat_rho(1,:))'; %% [x y v'(y,x) xv yv]
    
    tempdata = UM_data_interpolated(:,:,timei);
    tempdata2 = NOMADS_data_interpolated(:,:,timei);
    
    if (timei==1)
        lon_lim = [lon_grd_min, lon_grd_max];
        lat_lim = [lat_grd_min, lat_grd_max];

        width=.5;

        clear xa xb xc xd x ya yb yc yd y
        xa = linspace(147, 162, 300);
        xb = linspace(162, 192, 300);
    %     xc = linspace(162, 147, 150);
        xd = linspace(130, 115, 150);
        x= [xa,  xb, xd];

        ya = linspace(15, 45, 300);
        yb = linspace(45, 15, 300);
    %     yc(1:150) = 15;
        yd = linspace(15, 18, 150);
        y = [ya,  yb, yd];

        mask  = zeros( size(lon_rho) );
        for ii=1:size(mask,1)
            for jj=1:size(mask,2)
                dist = min( ( (lon_rho(ii,jj) - x).^2 + (lat_rho(ii,jj) - y ).^2 ).^.5 );
                isinside = InsidePolygon(x,y,lon_rho(ii,jj),lat_rho(ii,jj));
                mask(ii,jj) = 1 / (1+exp(- (-1)^isinside/width*dist )) + 1;      % sigmoid function
        %         mask(ii,jj) = (-1)^isinside * dist + 1.5;
            end
        end
        mask( mask >= 2 ) = 2;
        mask( mask <= 1 ) = 1;
    %     figure; pcolor(lon_rho,lat_rho,mask-1); shading flat; colorbar; daspect([1 1 1]);

        UM_mask= mask -1;
        NOMADS_mask = -mask +2;
    end
%     tempdata(isnan(tempdata)) = tempdata2(isnan(tempdata));
    
    tempdata(isnan(tempdata))=0;
    combined_data_interpolated(:,:,timei) = tempdata .* UM_mask + tempdata2 .* NOMADS_mask;
%     figure; pcolor(lon_rho,lat_rho,combined_data_interpolated(:,:,timei)); shading flat; colorbar; daspect([1 1 1]);
    
    
    tempdata2=combined_data_interpolated(:,:,timei);
    ismask=isnan(tempdata2);
    tempdata2(ismask) = ...
            griddata(lon_rho(~ismask),lat_rho(~ismask),tempdata2(~ismask), ...
            lon_rho(ismask), lat_rho(ismask), 'nearest');

    combined_data_interpolated(:,:,timei) = tempdata2;
end



% pcolor(UM_lon_cut, UM_lat_cut, UM_data_cut(:,:,1))
% pcolor(NOMADS_lon_cut, NOMADS_lat_cut, NOMADS_data_cut(:,:,1)')

totalday  = 4; %% -2, yesterday, today, tomorrow
firstdofy=datenum(['01-Jan-',num2str(year)]); % dd-mmm-yyyy
presenttime=datenum([num2str(month),'-',num2str(day),'-',num2str(year)]); % mm-dd-yyyy
runtime = presenttime - firstdofy;
ftime = runtime : 0.125 : runtime + 3.875;
switch varname_short
    case 'swrad'
        ftime = runtime+0.5 : 1.0 : runtime + 3.5;
end


ncid = netcdf.create(outfile,'CLOBBER');

eta_rho_dimid = netcdf.defDim(ncid,'eta_rho',data_info.Size(2));
xi_rho_dimid = netcdf.defDim(ncid, 'xi_rho', data_info.Size(1));
eta_u_dimid = netcdf.defDim(ncid,'eta_u',data_info.Size(2));
xi_u_dimid = netcdf.defDim(ncid, 'xi_u', data_info.Size(1)-1);
eta_v_dimid = netcdf.defDim(ncid,'eta_v',data_info.Size(2)-1);
xi_v_dimid = netcdf.defDim(ncid, 'xi_v', data_info.Size(1));
eta_psi_dimid = netcdf.defDim(ncid,'eta_psi',data_info.Size(2)-1);
xi_psi_dimid = netcdf.defDim(ncid, 'xi_psi', data_info.Size(1)-1);
time_dimid = netcdf.defDim(ncid, varname_time, 0);

netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'), ...
    'type', ' ROMS Surface forcing file for auto');
netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'), ...
    'title', ' Bulk Formular Forcing file (UTC)');
netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'), ...
    'source', [' UM + NOMADS', atm_name]);
netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'), ...
    'author', 'Created by Y.Y.Kim');
netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'), ...
    'date', date);

timevarid=netcdf.defVar(ncid, varname_time, 'NC_DOUBLE', time_dimid);
netcdf.putAtt(ncid,timevarid,'long_name','cyclic day');
netcdf.putAtt(ncid,timevarid,'units','day');
% netcdf.putAtt(ncid,timevarid,'cycle_length', year2day(year));
netcdf.putAtt(ncid,timevarid,'cycle_length', 4.0);


dvarid=netcdf.defVar(ncid,varname_output, 'NC_FLOAT', [xi_rho_dimid eta_rho_dimid time_dimid]);  %% [x y t]
netcdf.putAtt(ncid,dvarid,'long_name',long_name);
netcdf.putAtt(ncid,dvarid,'units',units);
netcdf.putAtt(ncid,dvarid,'time',varname_time);

netcdf.endDef(ncid);

for i=1:length(UM_data_cut(1,1,:))
    netcdf.putVar(ncid, timevarid, i-1, 1, ftime(i));
    netcdf.putVar(ncid, dvarid, [0 0 i-1], [data_info.Size(1) data_info.Size(2) 1], combined_data_interpolated(:,:,i)); %%[x y t], Z'(x,y)
end

netcdf.close(ncid);
status=1;
end

function c = InsidePolygon( xp, yp, x, y )
    c = false;
	for i=2:length(xp)
        if( ( ((yp(i) <= y) && y < yp(i-1)) || ((yp(i-1) <= y ) && y < yp(i)) ) && ...
            ( x < (xp(i-1) - xp(i)) * (y - yp(i)) / (yp(i-1) - yp(i)) + xp(i) ) )
            c = ~c;
        end
    end
end
