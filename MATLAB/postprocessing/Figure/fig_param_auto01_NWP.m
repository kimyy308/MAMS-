% % this script is for north western pacific region figure
% %  Updated 27-Apr-2018 by Yong-Yub Kim


% % set colorbar parameter
load jet_mod  % % set colormap (jet_modified)
run('bwr_map')  % % set colormap (blue and white)
colorbar_fontsize = 15;
colorbar_title_fontsize = 15;
colormap_style = jet;  % % default

% % set varname
switch(var)
    case('SST')
        varname = 'temp'
        colorbar_title = '(^oC)';
        shadlev=[0 35];
        conlev=[0:5:35];
    case('YSBCW')
        varname = 'temp'
        colorbar_title = '(^oC)';
    case('SSS')
        varname = 'salt'
        colorbar_title = ' ';
        shadlev=[25 35];
        conlev=[26:2:34];
    case('SSH')
        varname = 'zeta'
        colorbar_title = '(m)';
        colormap_style = bwrmap;
    case('vert_temp')
        varname = 'temp'
        colorbar_title = '(^oC)';
        colormap_style = jet;
    case('vert_salt')
        varname = 'salt'
        colorbar_title = ' ';
        colormap_style = jet;
    case('vert_u')
        varname = 'u'
        colorbar_title = '(m/s)';
        colormap_style = bwrmap;
    case('vert_v')
        varname = 'v'
        colorbar_title = '(m/s)';
        colormap_style = bwrmap;
    case('vert_rho')
        varname = 'zeta'
        colorbar_title = '(kg/m^3)';
    otherwise
        varname = var;
        colorbar_title = ' ';
end

% % set calendar name
% calendarname=cell(1,12); calendarname{1} = 'January'; calendarname{2} = 'February'; calendarname{3} = 'March'; calendarname{4} = 'April'; calendarname{5} = 'May'; calendarname{6} = 'June';
% calendarname{7} = 'July'; calendarname{8} = 'August'; calendarname{9} = 'September'; calendarname{10} = 'October'; calendarname{11} = 'November'; calendarname{12} = 'December';
calendarname=cell(1,12); calendarname{1} = 'Jan'; calendarname{2} = 'Feb'; calendarname{3} = 'Mar'; calendarname{4} = 'Apr'; calendarname{5} = 'May'; calendarname{6} = 'Jun';
calendarname{7} = 'Jul'; calendarname{8} = 'Aug'; calendarname{9} = 'Sep'; calendarname{10} = 'Oct'; calendarname{11} = 'Nov'; calendarname{12} = 'Dec';


% % set m_proj parameter
m_proj_name='mercator';

% % set m_grid parameter
m_grid_fontsize = 13;
m_grid_box_type = 'fancy';
m_grid_tickdir_type = 'in';

% % set m_pcolor parameter
m_pcolor_title_fontsize = 20;
m_pcolor_shading_method = 'interp';

% % set m_gshhs parameter
m_gshhs_line_color = 'k';
m_gshhs_land_color = [0.8 0.8 0.8]; % % gray

% % set m_contour parameter
m_contour_color = 'k';
m_contour_title_fontsize = 20;
m_contour_label_fontsize = 13;
m_contour_label_color = 'k';
m_contour_linewidth = 1.5;
m_contour_rotation = 0;
m_contour_labelspacing = 100000;
m_contour_fontweight = 'bold';

% % set m_quiver parameter
m_quiver_title_fontsize = 20;
m_quiver_x_interval = 7;
m_quiver_y_interval = 7;
m_quiver_vector_size = 1.5;
m_quiver_vector_color = 'k';
m_quiver_LineWidth = 0.5;
m_quiver_AutoScale = 'off';
m_quiver_ref_u_value = 2;
m_quiver_ref_v_value = 0.001;
m_quiver_ref_vec_x_range = 200:205;
m_quiver_ref_vec_y_range = 700:705;
m_quiver_ref_text = '2 m/s';
m_quiver_ref_text_fontsize = 15;
m_quiver_ref_text_x_location = 125;
m_quiver_ref_text_y_location = 43.7;


% % set gcf parameter
hor_paper_size_x = lonlat(2)-lonlat(1);
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
