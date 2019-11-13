load('gv_lidar.mat');
arr = table2array(GainesvilleLidar);

easting = 369460.65; % east/west position in meters
northing = 3280752.61; % north/south position in meters

x = arr(:, 1);
y = arr(:, 2);
z = arr(:, 3);
dx = linspace(min(arr(:, 1)), max(arr(:,1)), 5000); 
dy = linspace(min(arr(:, 2)), max(arr(:,2)), 5000); 
[xq,yq] = meshgrid(dx,dy);

vq = griddata(x,y,z,xq,yq);
surf(xq,yq,vq);
hold on


plot3(easting, northing, 100, 'r*', 'markersize', 10);