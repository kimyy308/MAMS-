#!/bin/sh
# Updated, 12-Jan-2021 by Yong-Yub Kim (use OSTIA SST)

testname=auto01
fulldate=$1
#fulldate=`date -d "$fulldate 1 days ago" +%Y%m%d`
MAMS=$2
OSTIAdir=$MAMS/Data/OSTIA/daily
obs_EnOIdir=${MAMS}/Data/DA/01_NWP_1_10/OSTIA
echo $OSTIAdir
srcdir=${MAMS}/Source/MATLAB/DA

this_year=`echo $fulldate | cut -c1-4`
this_month=`echo $fulldate | cut -c5-6`

mfile=${srcdir}/${testname}_make_obs_for_EnOI.m
cat > $mfile << EOF
clc;close all;clear all;
warning off;

system_name=computer;
    dropboxpath='/home/auto/MAMS/Source/MATLAB';  %% MEPL2 server    
    addpath(genpath([dropboxpath '/util/m_map']));
    addpath(genpath([dropboxpath '/util/Figure']));
    addpath(genpath([dropboxpath '/util/roms_grid']));
    addpath(genpath([dropboxpath '/Roms_tools/Preprocessing_tools']));    
    addpath(genpath([matlabroot,'/toolbox/matlab/imagesci/'])); %% add new netcdf path

run('nwp_polygon_point.m');

filepath = ['${OSTIAdir}/${this_year}/${this_month}'];

ii=1;
emptyval=0;
    filename = [filepath,'/','OSTIA_${fulldate}.nc'];
    lat = ncread(filename,'lat');
    lon = ncread(filename,'lon');

    sst_s = ncread(filename,'analysed_sst');
    sst_e = ncread(filename,'analysis_error');
    if (abs(mean(mean(sst_s,'omitnan'),'omitnan'))>1000)
       sst_s=sst_s * 0.01; %% scale factor
       sst_e=sst_e * 0.01;
       sst_s=sst_s - 273.15; %Kelvin -> Celcius
    else
       sst_s=sst_s - 273.15; %Kelvin -> Celcius
    end
    lat_s = ncread(filename,'lat');
    lon_s = ncread(filename,'lon');

    sst_s(sst_s<=-1000)=NaN;
    sst_s(sst_s>=1000)=NaN;

    lon1 = lon_s+360;
    lon_s = [lon_s;lon1];
    % sst = sst*scale_factor;
    lon_L = 115; lon_R = 162; lat_H = 52; lat_L = 15;

    [px py] = find(lon_s >=lon_L & lon_s<=lon_R);
    [qx qy] = find(lat_s >=lat_L & lat_s<=lat_H);
    [xi, yi]=meshgrid(lon_s(px),lat_s(qx));
    xi = double(xi);
    yi = double(yi);
    SST = sst_s';
    ERR = sst_e';

    clear sst_s sst_e lon_s 
    SST = [SST SST];
    ERR = [ERR ERR];

    SST_A = SST(qx,px);  %% sampled SST(NWP) from global data
    ERR_A = ERR(qx,px);

    interval= 40; % 2 degree interval
    xi_2d = xi(1:interval:end,1:interval:end);
    yi_2d = yi(1:interval:end,1:interval:end);
    SST_A_2d = SST_A(1:interval:end,1:interval:end);
    ERR_A_2d = ERR_A(1:interval:end,1:interval:end);
    
    interval=20; % 1 degree interval
    xi_2d_es = xi(1:interval:end,1:interval:end);
    yi_2d_es = yi(1:interval:end,1:interval:end);
    SST_A_2d_es = SST_A(1:interval:end,1:interval:end);
    ERR_A_2d_es = ERR_A(1:interval:end,1:interval:end);
    xi_2d_kuro = xi(1:interval:end,1:interval:end);
    yi_2d_kuro = yi(1:interval:end,1:interval:end);
    SST_A_2d_kuro = SST_A(1:interval:end,1:interval:end);
    ERR_A_2d_kuro = ERR_A(1:interval:end,1:interval:end);
    
    interval=10; % 0.5 degree interval
    xi_2d_ekwc = xi(1:interval:end,1:interval:end);
    yi_2d_ekwc = yi(1:interval:end,1:interval:end);
    SST_A_2d_ekwc = SST_A(1:interval:end,1:interval:end);
    ERR_A_2d_ekwc = ERR_A(1:interval:end,1:interval:end);

    clear  SST ERR


    xindex_10 = find(xi_2d(1,:)>117 & xi_2d(1,:)<160);
    yindex_10 = find(yi_2d(:,1)>17 & yi_2d(:,1)<50);


    mask_es = double(inpolygon(xi_2d_es,yi_2d_es,espolygon(:,1),espolygon(:,2)));
    dim1_index_es = find(mask_es==1);
    
    mask_kuro = double(inpolygon(xi_2d_kuro,yi_2d_kuro,kuropolygon(:,1),kuropolygon(:,2)));
    dim1_index_kuro = find(mask_kuro==1);
    
    mask_ekwc = double(inpolygon(xi_2d_ekwc,yi_2d_ekwc,ekwcpolygon(:,1),ekwcpolygon(:,2)));
    dim1_index_ekwc = find(mask_ekwc==1);


    x_10 = xi_2d(yindex_10,xindex_10);
    y_10 = yi_2d(yindex_10,xindex_10);
    x_es = xi_2d_es(dim1_index_es);
    y_es = yi_2d_es(dim1_index_es);
    x_kuro = xi_2d_kuro(dim1_index_kuro);
    y_kuro = yi_2d_kuro(dim1_index_kuro);
    x_ekwc = xi_2d_ekwc(dim1_index_ekwc);
    y_ekwc = yi_2d_ekwc(dim1_index_ekwc);

    SST_A_2d_10=SST_A_2d;
    SST_A_2d(:,:) = nan;
    SST_A_2d(yindex_10,xindex_10) =SST_A_2d_10(yindex_10,xindex_10);
    ERR_A_2d_10=ERR_A_2d;
    ERR_A_2d(:,:) = nan;
    ERR_A_2d(yindex_10,xindex_10) = ERR_A_2d_10(yindex_10,xindex_10);

    SST_es = SST_A_2d_es(dim1_index_es);
    SST_es(y_es>50)=nan;
    ERR_es = ERR_A_2d_es(dim1_index_es);
    ERR_es(y_es>50)=nan;

    SST_kuro = SST_A_2d_kuro(dim1_index_kuro);
    SST_kuro(y_kuro>50)=nan;
    ERR_kuro = ERR_A_2d_kuro(dim1_index_kuro);
    ERR_kuro(y_kuro>50)=nan;
    
    SST_ekwc = SST_A_2d_ekwc(dim1_index_ekwc);
    SST_ekwc(y_ekwc>50)=nan;
    ERR_ekwc = ERR_A_2d_ekwc(dim1_index_ekwc);
    ERR_ekwc(y_ekwc>50)=nan;


    index = 1;
    for i = 1:length(SST_A_2d(:,1))
        for j = 1:length(SST_A_2d(1,:))

            if (isnan(SST_A_2d(i,j)))

            else
                lon_obs(index) = xi_2d(i,j);
                lat_obs(index) = yi_2d(i,j);
                sst_obs(index) = SST_A_2d(i,j);
                obserr(index) = ERR_A_2d(i,j);
                index = index + 1;
            end
        end
    end

    for i = 1:length(SST_es(:,1))
        for j = 1:length(SST_es(1,:))

            if (isnan(SST_es(i,j)))

            else
                lon_obs(index) = x_es(i,j);
                lat_obs(index) = y_es(i,j);
                sst_obs(index) = SST_es(i,j);
                obserr(index) = ERR_es(i,j);
                index = index + 1;
            end
        end
    end
    for i = 1:length(SST_kuro(:,1))
        for j = 1:length(SST_kuro(1,:))

            if (isnan(SST_kuro(i,j)))

            else
                lon_obs(index) = x_kuro(i,j);
                lat_obs(index) = y_kuro(i,j);
                sst_obs(index) = SST_kuro(i,j);
                obserr(index) = ERR_kuro(i,j);
                index = index + 1;
            end
        end
    end
    for i = 1:length(SST_ekwc(:,1))
        for j = 1:length(SST_ekwc(1,:))
            if (isnan(SST_ekwc(i,j)))

            else
                lon_obs(index) = x_ekwc(i,j);
                lat_obs(index) = y_ekwc(i,j);
                sst_obs(index) = SST_ekwc(i,j);
                obserr(index) = ERR_ekwc(i,j);
                index = index + 1;
            end
        end
    end


%     if(emptyval~=1)
        % % % % 2015 (added point)
        wrong_point = [119.125, 25.125 ; 
                        121.125, 25.125 ; 
                        131.125, 31.125 ;  
                        129.125, 33.125 ;  
                        133.125, 33.125 ;
                        135.125, 34.125 ;
                        129.125, 35.125 ;
                        139.125, 35.125 ;
                        140.125, 35.125 ;
                        136.125, 36.125 ;
                        137.125, 37.125 ;
                        138.125, 37.125 ;
                        129.125, 37.625 ;
                        128.625, 38.125 ;
                        127.625, 39.125 ;
                        141.125, 41.125 ;
                        140.125, 42.125 ;
                        132.125, 43.125 ;
                        144.125, 44.125 ;
                        145.125, 44.125 ;
                        148.125, 45.125 ;
                        138.125, 46.125 ;
                        143.125, 47.125 ;
                        142.125, 48.125 ;
                        143.125, 49.125 ]
        for search_i=1:length(lon_obs)
            for search_j=1:length(lon_obs)
                if(search_i<length(lon_obs) && search_j<length(lon_obs) && search_i ~= search_j && lon_obs(search_i)==lon_obs(search_j))%%duplication point
                    if(lat_obs(search_i)==lat_obs(search_j))
                        disp(['duplication point : ', num2str(search_j)])   
                        lon_obs(search_j) = [];
                        lat_obs(search_j) = [];
                        sst_obs(search_j) = [];
                        obserr(search_j) = [];
                    end
                end
            end
        end
        for search_i=1:length(lon_obs)
            for search_j=1:length(lon_obs)
                if(search_i<length(lon_obs) && search_j<length(lon_obs) && search_i ~= search_j && lon_obs(search_i)==lon_obs(search_j))%%duplication point
                    if(lat_obs(search_i)==lat_obs(search_j))
                        disp(['duplication point : ', num2str(search_j)])   
                        lon_obs(search_j) = [];
                        lat_obs(search_j) = [];
                        sst_obs(search_j) = [];
                        obserr(search_j) = [];
                    end
                end
            end
        end
        for wrong_i=1:size(wrong_point,1)
            new_ind=find(lon_obs==wrong_point(wrong_i,1) & lat_obs==wrong_point(wrong_i,2));
            if exist('nn')==0
                nn=new_ind;
            else
                nn=[nn new_ind];
            end
        end
        lon_obs(nn) = [];
        lat_obs(nn) = [];
        sst_obs(nn) = [];
        obserr(nn) = [];

    num_data = length(lon_obs);
filepath = ['${OSTIAdir}/${this_year}/${this_month}'];
    outname = strcat('${OSTIAdir}/${this_year}/${this_month}/','${testname}_obs_${fulldate}.nc')
    if (exist(outname,'file'))
        system(['rm -f ',outname]);
    end
    nccreate(outname,'ixt','Dimensions',{'xt_i',num_data});
   nccreate(outname,'rlon','Dimensions',{'xt_i',num_data,'time',1});
    nccreate(outname,'rlat','Dimensions',{'xt_i',num_data,'time',1});
    nccreate(outname,'rdepth','Dimensions',{'xt_i',num_data,'time',1});
    nccreate(outname,'obsdata','Dimensions',{'xt_i',num_data,'time',1});
    nccreate(outname,'obserr','Dimensions',{'xt_i',num_data,'time',1});
    nccreate(outname,'dindex','Dimensions',{'xt_i',num_data,'time',1});
    nccreate(outname,'ndata','Dimensions',{'time',1});
    ixt = 1:num_data;
    dindex = 2*ones(1,num_data)';
    % obserr = 0.67*ones(1,num_data);
    ncwrite(outname,'ixt',ixt);
    ncwrite(outname,'dindex',dindex);
    ncwrite(outname,'ndata',num_data);
    ncwrite(outname,'rdepth',zeros(num_data,1));
    ncwrite(outname,'rlon',lon_obs');
    ncwrite(outname,'rlat',lat_obs');
    ncwrite(outname,'obsdata',sst_obs');
    ncwrite(outname,'obserr',obserr');

    ii=ii+1;

EOF

cd ${srcdir}
$MAMS/App/runmatlab_auto $fulldate $mfile
ln -sf ${OSTIAdir}/${this_year}/${this_month}/${testname}_obs_${fulldate}.nc ${obs_EnOIdir}/${testname}_obs.nc


