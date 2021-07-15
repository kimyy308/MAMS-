% close all; clear all; clc;

MAMS='/home/auto/MAMS';
addpath(genpath([MAMS, '/Source/MATLAB/util/']));
testname = 'auto01';

dayinfofile=[MAMS, '/Model/LTRANS/Input/dayinfo'];
dayinfo=textread(dayinfofile);

% fulldate=dayinfo(1);
tempday=num2str(fulldate);
runtime(1)=str2num(tempday(1:4));
runtime(2)=str2num(tempday(5:6));
runtime(3)=str2num(tempday(7:8));

totalday=dayinfo(2); 

col_lat = 40; % latitude 40N
calendarname=cell(1,12); calendarname{1} = 'January'; calendarname{2} = 'February'; calendarname{3} = 'March'; calendarname{4} = 'April'; calendarname{5} = 'May'; calendarname{6} = 'June';
calendarname{7} = 'July'; calendarname{8} = 'August'; calendarname{9} = 'September'; calendarname{10} = 'October'; calendarname{11} = 'November'; calendarname{12} = 'December';
folder_name = {'1_Jan','2_Feb','3_Mar'};

% for nyear=1:length(totyear)
%     for nmonth =1:length(totmonth)
        year=runtime(1);
        month=runtime(2);
        day=runtime(3);
        
        workdir=[MAMS,'/Model/LTRANS/Output/',tempday(1:4),'/', tempday(5:6), '/', tempday];
        filename = [workdir, '/', 'ltrans_output_', tempday, '.nc'];
        
        lon = ncread(filename,'lon');
        lat = ncread(filename,'lat');
        gridname = [MAMS, '/Data/01_NWP_1_10/Input/', testname, '_grid.nc'];

        mask_rho = ncread(gridname,'mask_rho');
        lon_rho = ncread(gridname,'lon_rho');
        lat_rho = ncread(gridname,'lat_rho');
        
        figdir = [MAMS, '/Figure/LTRANS/', tempday(1:4),'/', tempday(5:6), '/', tempday];
        if (exist([figdir] , 'dir') ~= 7)
            mkdir([figdir]);
        end
        outfile = [figdir, '/ltrans_fig_', tempday];
        
        lonlat = [127 133 35.5 44.5];
        [size_p, size_t] = size(lat);

        
        hor_paper_size_x= lonlat(2)-lonlat(1);
        hor_paper_size_y = lonlat(4)-lonlat(3);
        halt = 1;
        while(halt)
            if (hor_paper_size_x > 500 || hor_paper_size_y > 500)
                halt = 0;
            else
                hor_paper_size_x = hor_paper_size_x * 1.2;
                hor_paper_size_y = hor_paper_size_y * 1.2;
            end
        end
        paper_position_hor = 0; % % distance from left
        paper_position_ver = 0; % % distance from bottom
        paper_position_width = hor_paper_size_x ;
        paper_position_height = hor_paper_size_y ;
        vert_paper_size_y = 400;
        
        vid_fps=3;
        vid_qty=100;
        flag_record_mp4=0;
        flag_record_gif=0;
        
        plot_dir = [figdir,num2str(year,'%04i')];
        
        exp_name = 'pollack';
        plot_type = 'passive'
        k=90;
        %
        if(flag_record_mp4),    % prepare video object
            vidName = [plot_dir,'',exp_name,'_',plot_type,'_',num2str(year,'%04i'),'_',num2str(month,'%02i'),'_',num2str(day,'%02i'),'_',num2str(totalday,'%04i'), '.mp4'];
            vidObj = VideoWriter(vidName,'MPEG-4');
            %         vidObj = VideoWriter(vidName,'wmv');
            vidObj.Quality = vid_qty;
            vidObj.FrameRate = vid_fps;
            open(vidObj);
        end
        if(flag_record_gif), vidName = [plot_dir,'',exp_name,'_',plot_type,'_',num2str(year,'%04i'),'_',num2str(month,'%02i'),'_',num2str(day,'%02i'),'_',num2str(totalday,'%04i'), '.gif']; end
        
        
        for t = 1:totalday
            m_proj('mercator','lon',[lonlat(1) lonlat(2)],'lat',[lonlat(3) lonlat(4)]);
            m_grid('xtick',[127:2:133],'ytick',[36:1:44]);
            m_gshhs_c('color','k')
            m_gshhs_c('patch',[.8 .8 .8]);
            hold on;
            
            if t < 5
                for i=1:size_p
                    if lat(i,1) >= col_lat
                        col = 'r';
                    else col = 'b';
                    end
                    m_line(squeeze(lon(i,2*24+1:(2+t)*24)),squeeze(lat(i,2*24+1:(2+t)*24)),...
                        'marker', 'o', 'color',col, 'linewidth', 1, 'markersize', 1, 'markerfacecolor',col);
                end
            else
                for i=1:size_p
                    if lat(i,1) >= col_lat
                        col = 'r';
                    else col = 'b';
                    end
                    m_line(squeeze(lon(i,(t+2-4)*24+1:(t+2)*24)),squeeze(lat(i,(t+2-4)*24+1:(t+2)*24)),...
                        'marker', 'o', 'color',col, 'linewidth', 1, 'markersize', 1, 'markerfacecolor', 'k');
                end
            end
            
            m_text(127.2,44,['initial particles : ',num2str(size_p)],'fontweig','bold')
            %m_text(127.2,43.5,['surviving particles : ',num2str(survive_p)],'fontweig','bold')
            
                xlabel('longitude');
                ylabel('latitude');
                set(gca,'fontsize',15)
                set(gcf, 'PaperUnits', 'points');
                set(gcf, 'PaperSize', [hor_paper_size_x, hor_paper_size_y]);
                set(gcf,'PaperPosition', [paper_position_hor paper_position_ver paper_position_width paper_position_height])
                pngname=strcat(outfile, '_', num2str(t,'%04i'), '.png'); %% ~_year_month.png
                %             pause
                %            plot_google_map('MapType','hybrid', 'Alpha', 1, 'Scale', 2)
                %             ylim([lonlat(3) lonlat(4)]);
                %             xlim([lonlat(1) lonlat(2)]);
                set(gcf,'PaperPositionMode','auto');
                
                %             titlename = strcat(num2str(year,'%04i'),'y, ',num2str(month,'%02i'),'m, ',num2str(t,'%04i'), 'day particles');
                
                [status, output]=system(['date -d ', '"', tempday, ' ', num2str(t-1), ' day"', ' +%Y%m%d'])
                
                
                titlename = [output(1:4), '-', output(5:6), '-', output(7:8)];
                title(titlename,'fontsize',17);  %%title
                
                if(flag_record_mp4), writeVideo(vidObj,getframe(gcf)); end
                if(flag_record_gif)
                    f = getframe(gcf);
                    if( ~exist('map','var') ),  [im,map] = rgb2ind(f.cdata,256,'nodither');
                    else  im(:,:,1,t) = rgb2ind(f.cdata,map,'nodither');
                    end
                end
                
                drawnow; %% prevent too short time between previous command and save command
                pause(2); %% cocolink server is really slow
%                 saveas(gcf,pngname,'png');
                print(pngname, '-dpng', '-r70')

                hold off;
                %             pause
                %             close figure 100;
                close all;
                disp(t)
            end
            if(flag_record_mp4), close(vidObj); end
            if(flag_record_gif), imwrite(im,map,vidName,'delaytime',0.33,'loopcount',inf);   end
            
            % plot_google_map('MapType','satellite', 'Alpha', 1, 'Scale', 2)
            
            hold off;
            close all
%         end
%     end
    
