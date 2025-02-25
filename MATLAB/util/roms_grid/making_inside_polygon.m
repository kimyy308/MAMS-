%%% for bgkim2
% close all;

lon_lim=[120, 133];
lat_lim=[28, 41];
lon_dim=[124, 130];
lat_dim=[32, 39];
width=.2;

%%% make boundary curve
%-- curve 1
% x = [cosd(0:90)+lon_dim(2)-1, (lon_dim(2)-1.05:-.05:lon_dim(1)+1.05),    cosd(90:180)+lon_dim(1)+1, lon_dim(1)*ones(1,(diff(lat_dim)-2)*20-1), cosd(180:270)+lon_dim(1)+1, (lon_dim(1)+1.05:.05:lon_dim(2)-1.05),     cosd(270:360)+lon_dim(2)-1, lon_dim(2)*ones(1,(diff(lat_dim)-2)*20-1), lon_dim(2)];
% y = [sind(0:90)+lat_dim(2)-1, lat_dim(2)*ones(1,(diff(lon_dim)-2)*20-1), sind(90:180)+lat_dim(2)-1, (lat_dim(2)-1.05:-.05:lat_dim(1)+1.05),    sind(180:270)+lat_dim(1)+1, lat_dim(1)*ones(1,(diff(lon_dim)-2)*20-1), sind(270:360)+lat_dim(1)+1, (lat_dim(1)+1.05:.05:lat_dim(2)-1.05),     lat_dim(2)-1];
%-- curve 2
x = cosd(0:10:360)*.5*diff(lon_dim) + mean(lon_dim);
y = sind(0:10:360)*.5*diff(lat_dim) + mean(lat_dim);
xp = x(1); yp = y(1);
for ii=1:length(x)-1
    xp = [xp, linspace(x(ii),x(ii+1),10)];
    yp = [yp, linspace(y(ii),y(ii+1),10)];
end
x = xp; y = yp;
    
% figure; scatter(x,y); xlim(lon_lim); ylim(lat_lim); daspect([1 1 1]);

[lon,lat] = meshgrid( lon_lim(1):.05:lon_lim(2), lat_lim(1):.05:lat_lim(2) );
mask  = zeros( size(lon) );
for ii=1:size(mask,1)
    for jj=1:size(mask,2)
        dist = min( ( (lon(ii,jj) - x).^2 + (lat(ii,jj) - y ).^2 ).^.5 );
        isinside = InsidePolygon(x,y,lon(ii,jj),lat(ii,jj));
        mask(ii,jj) = 1 / (1+exp(- (-1)^isinside/width*dist )) + 1;      % sigmoid function
%         mask(ii,jj) = (-1)^isinside * dist + 1.5;
    end
end
mask( mask >= 2 ) = 2;
mask( mask <= 1 ) = 1;

figure; pcolor(lon,lat,mask); shading flat; colorbar; daspect([1 1 1]);

% determine if (x,y) is inside of polygon (xp,yp)
% see http://www.eecs.umich.edu/courses/eecs380/HANDOUTS/PROJ2/InsidePoly.html
function c = InsidePolygon( xp, yp, x, y )
    c = false;
	for i=2:length(xp)
        if( ( ((yp(i) <= y) && y < yp(i-1)) || ((yp(i-1) <= y ) && y < yp(i)) ) && ...
            ( x < (xp(i-1) - xp(i)) * (y - yp(i)) / (yp(i-1) - yp(i)) + xp(i) ) )
            c = ~c;
        end
    end
end