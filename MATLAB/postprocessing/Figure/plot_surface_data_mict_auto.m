%function status=plot_ROMS_hourly_surface_data(testname, outfile, filedir, lonlat, tempyear, inputhour, shadlev, conlev, var, param_script)
% %  Updated 18-Jul-2019 by Yong-Yub Kim

% fulldate=20200305;
MAMS='/home/auto/MAMS';

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
%     dropboxpath='/home01/kimyy/Dropbox'; %% ROMS server
    dropboxpath=[MAMS,'/Source/MATLAB']; %% DAMO server
    addpath(genpath([dropboxpath '/util/m_map']));
    addpath(genpath([dropboxpath '/util/Figure']));
    addpath(genpath([dropboxpath '/util/netcdf_old']));
    addpath(genpath([dropboxpath '/util/roms_grid']));
    addpath(genpath([dropboxpath '/source/matlab/Model/ROMS/Analysis/Figure/nwp_1_20/run']));
    addpath(genpath([dropboxpath '/Roms_tools/Preprocessing_tools']));
    addpath(genpath([matlabroot,'/toolbox/matlab/imagesci/'])); %% add new netcdf path
end

lonlat=[125 145 32 50 -0 -0];

% tempday=num2str(fulldate);
% runtime(1)=str2num(tempday(1:4));
% runtime(2)=str2num(tempday(5:6));
% runtime(3)=str2num(tempday(7:8));

% fulldate=20190618
vars={'SST', 'SSS', 'UV', 'WIND'};
% vars={'SSS'};

% vars={'WIND'};

for vari=1:length(vars)
    var=vars{vari};
    for datei=0:3
        % runtime=datevec(datenum(date)+datei);
        % tempday=num2str(fulldate+datei);
        fulldatestr=num2str(fulldate);
        tempday=datestr(datenum(str2num(fulldatestr(1:4)),str2num(fulldatestr(5:6)),str2num(fulldatestr(7:8)))+datei,'YYYYmmDD');
        runtime(1)=str2num(tempday(1:4));
        runtime(2)=str2num(tempday(5:6));
        runtime(3)=str2num(tempday(7:8));

        if datei==0
            fruntime=runtime;
            fyear=fruntime(1); fmonth=fruntime(2); fday=fruntime(3);
        end
        year=runtime(1); month=runtime(2); day=runtime(3);
        firstdofy=datenum(['01-Jan-',num2str(year)]); % dd-mmm-yyyy
        presenttime=datenum([num2str(month),'-',num2str(day),'-',num2str(year)]); % mm-dd-yyyy
        filenum = presenttime - firstdofy + 1
        workdir=[MAMS,'/Data/01_NWP_1_10'];
        datadir=[workdir, '/Output/Daily/', num2str(fyear,'%04i'), '/', num2str(fmonth,'%02i'), '/', num2str(fyear,'%04i'), num2str(fmonth,'%02i'), num2str(fday, '%02i')];
        run('fig_param_mict01_ES.m');
        
        avgfilename = [datadir, '/', 'auto01_avg_', num2str(filenum, '%04i'),  '.nc'];
        lon = ncread(avgfilename,'lon_rho');
        lat = ncread(avgfilename,'lat_rho');
        
        if (strcmp(var,'SSH'))
            data_info = ncinfo(avgfilename, varname);
            data = ncread(avgfilename,varname,[1 1 1], [data_info.Size(1) data_info.Size(2) 1]);
        elseif (strcmp(var,'YSBCW'))
            data_info = ncinfo(avgfilename, varname);
            data = ncread(avgfilename,varname,[1 1 1 1], [data_info.Size(1) data_info.Size(2) 1 1]);
        elseif (strcmp(var,'UV'))
            u_info = ncinfo(avgfilename, 'u');
            v_info = ncinfo(avgfilename, 'v');
            u = ncread(avgfilename,'u',[1 1 u_info.Size(3) 1], [u_info.Size(1) u_info.Size(2) 1 1]);
            v = ncread(avgfilename,'v',[1 1 v_info.Size(3) 1], [v_info.Size(1) v_info.Size(2) 1 1]);
            lon_u = ncread(avgfilename,'lon_u');
            lat_u = ncread(avgfilename,'lat_u');
            lon_v = ncread(avgfilename,'lon_v');
            lat_v = ncread(avgfilename,'lat_v');
        elseif (strcmp(var,'WIND'))
            uwind_info = ncinfo(avgfilename, 'Uwind');
            vwind_info = ncinfo(avgfilename, 'Vwind');
            uwind = ncread(avgfilename,'Uwind',[1 1 1], [uwind_info.Size(1) uwind_info.Size(2) 1]);
            vwind = ncread(avgfilename,'Vwind',[1 1 1], [vwind_info.Size(1) vwind_info.Size(2) 1]);
        else
            data_info = ncinfo(avgfilename, varname);
            data = ncread(avgfilename,varname,[1 1 data_info.Size(3) 1], [data_info.Size(1) data_info.Size(2) 1 1]);
        end
        
        if (strcmp(var, 'UV'))
            u_rho(2:u_info.Size(1),:) = 0.5 * (u(1:u_info.Size(1)-1,:) + u(2:u_info.Size(1),:));
            u_rho(1,:)=u_rho(2,:);
            u_rho(u_info.Size(1)+1,:)=u_rho(u_info.Size(1)-1,:);
            v_rho(:,2:v_info.Size(2)) = 0.5 * (v(:,1:v_info.Size(2)-1) + v(:,2:v_info.Size(2)));
            v_rho(:,1)=v_rho(:,2);
            v_rho(:,v_info.Size(2)+1)=v_rho(:,v_info.Size(2)-1);
            if (exist('ref_vec_x_range' , 'var') ~= 1)
                ref_vec_x_ind = find(abs(lon(:,1)-m_quiver_ref_text_x_location) == min(abs(lon(:,1)-m_quiver_ref_text_x_location)));
                ref_vec_y_ind = find(abs(lat(1,:)-m_quiver_ref_text_y_location) == min(abs(lat(1,:)-m_quiver_ref_text_y_location)))+m_quiver_y_interval*2;
                ref_vec_x_range = round(ref_vec_x_ind-(m_quiver_x_interval/2)) : round(ref_vec_x_ind-(m_quiver_x_interval/2))+m_quiver_x_interval-1;
                ref_vec_y_range = round(ref_vec_y_ind-(m_quiver_y_interval/2)) : round(ref_vec_y_ind-(m_quiver_y_interval/2))+m_quiver_y_interval-1;
            end
            u_rho(ref_vec_x_range, ref_vec_y_range) = m_quiver_ref_u_value;
            v_rho(ref_vec_x_range, ref_vec_y_range) = m_quiver_ref_v_value;   
            m_proj(m_proj_name,'lon',[lonlat(1) lonlat(2)],'lat',[lonlat(3) lonlat(4)]);
            hold on;
            m_gshhs_i('color',m_gshhs_line_color);  
            m_gshhs_i('patch',m_gshhs_land_color);   
            uvplot=m_quiver(lon(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end), ...
                            lat(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end), ...
                            u_rho(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end) * m_quiver_vector_size, ...
                            v_rho(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end) * m_quiver_vector_size, ...
                            'color',m_quiver_vector_color, 'AutoScale','off','LineWidth', m_quiver_LineWidth);
            m_text(m_quiver_ref_text_x_location, m_quiver_ref_text_y_location, m_quiver_ref_text, 'FontSize', m_quiver_ref_text_fontsize); 
            titlename = strcat(var, ' (', num2str(year), '-', char(calendarname(month)), '-', num2str(day,'%02i'), ')');
            title(titlename,'fontsize',m_pcolor_title_fontsize);  %%title
        elseif (strcmp(var, 'WIND'))
            if (exist('ref_vec_x_range' , 'var') ~= 1)
                ref_vec_x_ind = find(abs(lon(:,1)-m_quiver_ref_text_x_location) == min(abs(lon(:,1)-m_quiver_ref_text_x_location)));
                ref_vec_y_ind = find(abs(lat(1,:)-m_quiver_ref_text_y_location) == min(abs(lat(1,:)-m_quiver_ref_text_y_location)))+m_quiver_y_interval*2;
                ref_vec_x_range = round(ref_vec_x_ind-(m_quiver_x_interval/2)) : round(ref_vec_x_ind-(m_quiver_x_interval/2))+m_quiver_x_interval-1;
                ref_vec_y_range = round(ref_vec_y_ind-(m_quiver_y_interval/2)) : round(ref_vec_y_ind-(m_quiver_y_interval/2))+m_quiver_y_interval-1;
            end
            uwind(ref_vec_x_range, ref_vec_y_range) = m_quiver_ref_wind_u_value;
            vwind(ref_vec_x_range, ref_vec_y_range) = m_quiver_ref_wind_v_value;   
            m_proj(m_proj_name,'lon',[lonlat(1) lonlat(2)],'lat',[lonlat(3) lonlat(4)]);
            hold on;
            m_gshhs_i('color',m_gshhs_line_color);  
            m_gshhs_i('patch',m_gshhs_land_color);   
            uvplot=m_quiver(lon(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end), ...
                            lat(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end), ...
                            uwind(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end) * m_quiver_wind_vector_size, ...
                            vwind(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end) * m_quiver_wind_vector_size, ...
                            'color',m_quiver_vector_color, 'AutoScale','off','LineWidth', m_quiver_LineWidth);
            m_text(m_quiver_ref_text_x_location, m_quiver_ref_text_y_location, m_quiver_wind_ref_text, 'FontSize', m_quiver_ref_text_fontsize); 
            titlename = strcat(var, ' (', num2str(year), '-', char(calendarname(month)), '-', num2str(day,'%02i'), ') [UM]');
            title(titlename,'fontsize',m_pcolor_title_fontsize);  %%title
        else
            % plot
            m_proj(m_proj_name,'lon',[lonlat(1) lonlat(2)],'lat',[lonlat(3) lonlat(4)]);
            hold on;
            m_pcolor(lon,lat,data);
            shading(gca,m_pcolor_shading_method);
            m_gshhs_i('color',m_gshhs_line_color)  
            m_gshhs_i('patch',m_gshhs_land_color);   % gray colored land
    %         titlename = strcat(var, ' (',num2str(temphour,'%02i'), ':00-', num2str(day,'%02i'), '-', char(calendarname(month)), '-', num2str(year),')');
            titlename = strcat(var, ' (', num2str(year), '-', char(calendarname(month)), '-', num2str(day,'%02i'), ')');
            title(titlename,'fontsize',m_pcolor_title_fontsize);  %%title

            % contour
%            [C,h2]=m_contour(lon,lat, data, conlev, m_contour_color, 'linewidth', m_contour_linewidth);
%            clabel(C,h2,'FontSize',m_contour_label_fontsize,'Color',m_contour_label_color, ...
%                'labelspacing',m_contour_labelspacing,'Rotation',m_contour_rotation,'fontweight',m_contour_fontweight);
%                clabel(C,h2,'FontSize',m_contour_label_fontsize,'Color',m_contour_label_color);
            
            colormap(colormap_style);
            colorbar;
            if (strcmp(var, 'SST'))
                caxis([-2 35])
            elseif (strcmp(var, 'SSS'))
                caxis([30 35])
            end
        end
        % set grid
        m_grid('fontsize', m_grid_fontsize, 'box', m_grid_box_type, 'tickdir', m_grid_tickdir_type);

        set(gcf, 'PaperUnits', 'points');
        set(gcf, 'PaperSize', [hor_paper_size_x, hor_paper_size_y]);
        set(gcf,'PaperPosition', [paper_position_hor paper_position_ver paper_position_width paper_position_height]) 

        figdir=[MAMS,'/Figure/01_NWP_1_10', '/', num2str(fyear,'%04i'), '/', num2str(fmonth,'%02i'), '/', num2str(fyear,'%04i'), num2str(fmonth,'%02i'), num2str(fday, '%02i'), '/ES'];
        if (exist(figdir, 'dir')~=7)
          mkdir(figdir)
        end
        tempstr=[num2str(year,'%04i'),num2str(month,'%02i'),num2str(day,'%02i')];
        pngname=[figdir,'/AVG_',var,'_', tempstr, '.png']; %% ~_year_hour.jpg
%         pause(2); %% prevent too short time between previous command and save command
        drawnow; %% prevent too short time between previous command and save command
%             saveas(gcf,jpgname,'jpg');
        pause(3)
        print(pngname, '-dpng', '-r110')


        disp(' ')
        disp([num2str(year), '_', num2str(month,'%02i'), '_', num2str(day,'%02i'), '_', var, ' plot is created.'])
        disp(' ')
        disp([' File path is : ',pngname])
        disp(' ')

        hold off
        close all;
        clf;

        inputhour = [3 6 9 12 15 18 21 24];
        for hourij2 = 1:length(inputhour)
            if (datei==-2)
              hourij=hourij2+1;
              temphour = inputhour(hourij-1);
            else
              hourij=hourij2;
              temphour = inputhour(hourij);
            end

            % ex : rootdir\test37\data\2001\test37_hourly_2001_01.nc
    %         filename = strcat(filedir, num2str(tempyear,'%04i'), '\', ...
    %                 testname, '_hourly_', num2str(tempyear,'%04i'), '_', ...
    %                 num2str(temphour,'%02i'), '.nc');  ~ test37
            filename = [datadir, '/', 'auto01_his_', num2str(filenum, '%04i'),  '.nc'];
            
            if (strcmp(var,'SSH'))
                data_info = ncinfo(filename, varname);
                data = ncread(filename,varname,[1 1 hourij], [data_info.Size(1) data_info.Size(2) 1]);
            elseif (strcmp(var,'YSBCW'))
                data_info = ncinfo(filename, varname);
                data = ncread(filename,varname,[1 1 1 hourij], [data_info.Size(1) data_info.Size(2) 1 1]);
            elseif (strcmp(var,'UV'))
                u_info = ncinfo(filename, 'u');
                v_info = ncinfo(filename, 'v');
                u = ncread(filename,'u',[1 1 u_info.Size(3) hourij], [u_info.Size(1) u_info.Size(2) 1 1]);
                v = ncread(filename,'v',[1 1 v_info.Size(3) hourij], [v_info.Size(1) v_info.Size(2) 1 1]);
                lon_u = ncread(filename,'lon_u');
                lat_u = ncread(filename,'lat_u');
                lon_v = ncread(filename,'lon_v');
                lat_v = ncread(filename,'lat_v');
            elseif (strcmp(var,'WIND'))
                uwind_info = ncinfo(filename, 'Uwind');
                vwind_info = ncinfo(filename, 'Vwind');
                uwind = ncread(filename,'Uwind',[1 1 hourij], [uwind_info.Size(1) uwind_info.Size(2) 1]);
                vwind = ncread(filename,'Vwind',[1 1 hourij], [vwind_info.Size(1) vwind_info.Size(2) 1]);
            else
                data_info = ncinfo(filename, varname);
                data = ncread(filename,varname,[1 1 data_info.Size(3) hourij], [data_info.Size(1) data_info.Size(2) 1 1]);
            end
            
            if (strcmp(var, 'UV'))
                u_rho(2:u_info.Size(1),:) = 0.5 * (u(1:u_info.Size(1)-1,:) + u(2:u_info.Size(1),:));
                u_rho(1,:)=u_rho(2,:);
                u_rho(u_info.Size(1)+1,:)=u_rho(u_info.Size(1)-1,:);
                v_rho(:,2:v_info.Size(2)) = 0.5 * (v(:,1:v_info.Size(2)-1) + v(:,2:v_info.Size(2)));
                v_rho(:,1)=v_rho(:,2);
                v_rho(:,v_info.Size(2)+1)=v_rho(:,v_info.Size(2)-1);
                if (exist('ref_vec_x_range' , 'var') ~= 1)
                    ref_vec_x_ind = find(abs(lon(:,1)-m_quiver_ref_text_x_location) == min(abs(lon(:,1)-m_quiver_ref_text_x_location)));
                    ref_vec_y_ind = find(abs(lat(1,:)-m_quiver_ref_text_y_location) == min(abs(lat(1,:)-m_quiver_ref_text_y_location)))+m_quiver_y_interval*2;
                    ref_vec_x_range = round(ref_vec_x_ind-(m_quiver_x_interval/2)) : round(ref_vec_x_ind-(m_quiver_x_interval/2))+m_quiver_x_interval-1;
                    ref_vec_y_range = round(ref_vec_y_ind-(m_quiver_y_interval/2)) : round(ref_vec_y_ind-(m_quiver_y_interval/2))+m_quiver_y_interval-1;
                end
                u_rho(ref_vec_x_range, ref_vec_y_range) = m_quiver_ref_u_value;
                v_rho(ref_vec_x_range, ref_vec_y_range) = m_quiver_ref_v_value;   
                m_proj(m_proj_name,'lon',[lonlat(1) lonlat(2)],'lat',[lonlat(3) lonlat(4)]);
                hold on;
                m_gshhs_i('color',m_gshhs_line_color);  
                m_gshhs_i('patch',m_gshhs_land_color);   
		        uvplot=m_quiver(lon(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end), ...
		                        lat(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end), ...
		                        u_rho(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end) * m_quiver_vector_size, ...
		                        v_rho(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end) * m_quiver_vector_size, ...
		                        'color',m_quiver_vector_color, 'AutoScale','off','LineWidth', m_quiver_LineWidth);
		        m_text(m_quiver_ref_text_x_location, m_quiver_ref_text_y_location, m_quiver_ref_text, 'FontSize', m_quiver_ref_text_fontsize); 
                titlename = strcat(var, ' (', num2str(year), '-', char(calendarname(month)), '-', num2str(day,'%02i'), '-', num2str(temphour,'%02i'), ':00','(UTC))');
                title(titlename,'fontsize',m_pcolor_title_fontsize);  %%title
            elseif (strcmp(var, 'WIND'))
                if (exist('ref_vec_x_range' , 'var') ~= 1)
                    ref_vec_x_ind = find(abs(lon(:,1)-m_quiver_ref_text_x_location) == min(abs(lon(:,1)-m_quiver_ref_text_x_location)));
                    ref_vec_y_ind = find(abs(lat(1,:)-m_quiver_ref_text_y_location) == min(abs(lat(1,:)-m_quiver_ref_text_y_location)))+m_quiver_y_interval*2;
                    ref_vec_x_range = round(ref_vec_x_ind-(m_quiver_x_interval/2)) : round(ref_vec_x_ind-(m_quiver_x_interval/2))+m_quiver_x_interval-1;
                    ref_vec_y_range = round(ref_vec_y_ind-(m_quiver_y_interval/2)) : round(ref_vec_y_ind-(m_quiver_y_interval/2))+m_quiver_y_interval-1;
                end
                uwind(ref_vec_x_range, ref_vec_y_range) = m_quiver_ref_wind_u_value;
                vwind(ref_vec_x_range, ref_vec_y_range) = m_quiver_ref_wind_v_value;   
                m_proj(m_proj_name,'lon',[lonlat(1) lonlat(2)],'lat',[lonlat(3) lonlat(4)]);
                hold on;
                m_gshhs_i('color',m_gshhs_line_color);  
                m_gshhs_i('patch',m_gshhs_land_color);   
                uvplot=m_quiver(lon(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end), ...
                                lat(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end), ...
                                uwind(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end) * m_quiver_wind_vector_size, ...
                                vwind(1:m_quiver_x_interval:end,1:m_quiver_y_interval:end) * m_quiver_wind_vector_size, ...
                                'color',m_quiver_vector_color, 'AutoScale','off','LineWidth', m_quiver_LineWidth);
                m_text(m_quiver_ref_text_x_location, m_quiver_ref_text_y_location, m_quiver_wind_ref_text, 'FontSize', m_quiver_ref_text_fontsize); 
                titlename = strcat(var, ' (', num2str(year), '-', char(calendarname(month)), '-', num2str(day,'%02i'), '-', num2str(temphour,'%02i'), ':00','(UTC)) [UM])');
                title(titlename,'fontsize',m_pcolor_title_fontsize);  %%title
            else
                % plot
                m_proj(m_proj_name,'lon',[lonlat(1) lonlat(2)],'lat',[lonlat(3) lonlat(4)]);
                hold on;
                m_pcolor(lon,lat,data);
                shading(gca,m_pcolor_shading_method);
                m_gshhs_i('color',m_gshhs_line_color)  
                m_gshhs_i('patch',m_gshhs_land_color);   % gray colored land
        %         titlename = strcat(var, ' (',num2str(temphour,'%02i'), ':00-', num2str(day,'%02i'), '-', char(calendarname(month)), '-', num2str(year),')');
                titlename = strcat(var, ' (', num2str(year), '-', char(calendarname(month)), '-', num2str(day,'%02i'), '-', num2str(temphour,'%02i'), ':00','(UTC))');
                title(titlename,'fontsize',m_pcolor_title_fontsize);  %%title

                % contour
%                [C,h2]=m_contour(lon,lat, data, conlev, m_contour_color, 'linewidth', m_contour_linewidth);
%                clabel(C,h2,'FontSize',m_contour_label_fontsize,'Color',m_contour_label_color, ...
%                    'labelspacing',m_contour_labelspacing,'Rotation',m_contour_rotation,'fontweight',m_contour_fontweight);
%                clabel(C,h2,'FontSize',m_contour_label_fontsize,'Color',m_contour_label_color);

                colormap(colormap_style);
                colorbar;
                if (strcmp(var, 'SST'))
                    caxis([-2 35])
                elseif (strcmp(var, 'SSS'))
                    caxis([30 35])
                end
            end
            % set grid
            m_grid('fontsize', m_grid_fontsize, 'box', m_grid_box_type, 'tickdir', m_grid_tickdir_type);

            set(gcf, 'PaperUnits', 'points');
            set(gcf, 'PaperSize', [hor_paper_size_x, hor_paper_size_y]);
            set(gcf,'PaperPosition', [paper_position_hor paper_position_ver paper_position_width paper_position_height]) 

            figdir=[MAMS,'/Figure/01_NWP_1_10', '/', num2str(fyear,'%04i'), '/', num2str(fmonth,'%02i'), '/', num2str(fyear,'%04i'), num2str(fmonth,'%02i'), num2str(fday, '%02i'), '/ES'];
            if (exist(figdir, 'dir')~=7)
              mkdir(figdir)
            end
            tempstr=[num2str(year,'%04i'),num2str(month,'%02i'),num2str(day,'%02i'),num2str(temphour,'%02i')];
            pngname=[figdir,'/',var,'_', tempstr, '.png']; %% ~_year_hour.jpg
    %         pause(2); %% prevent too short time between previous command and save command
            drawnow; %% prevent too short time between previous command and save command
%             saveas(gcf,jpgname,'jpg');
            pause(3)
            print(pngname, '-dpng', '-r110')


            disp(' ')
            disp([num2str(year), '_', num2str(month,'%02i'), '_', num2str(day,'%02i'), '_', num2str(temphour), '_', var, ' plot is created.'])
            disp(' ')
            disp([' File path is : ',pngname])
            disp(' ')

            hold off
            close all;
	    clf
        end
        

    %return
    end
end
status=1;
