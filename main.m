%% load lidar
load('trimmed_lidar.mat');

%% load image
aerial = imread('gnv_aerial.jpg');

%% get shadow mask
shadow_threshhold = 0.4;
shadow_mask = getShadows(aerial, shadow_threshhold);

%% get sun position
az = -19.3;
elev = 39;

%% parameterize camera position
heading = 0;
pitch = 0;
roll = 0;
dx = 0;
dy = 0;
zoom = 1;

params0 = [heading, pitch, roll, dx, dy, zoom];

%% minimize cost function
ObjectiveFunction = @(params) costFunction(params, x_grid, y_grid, z_grid, aerial, az, elev);
[params,fval] = simulannealbnd(ObjectiveFunction, params0);

%% render model
warp(x_grid, y_grid, z_grid, aerial);
set(gca, 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none');
axis equal
view(az, elev)
F = getframe;
I = frame2im(F);

%% TODO
% loop optimization
% input guesses for starting params
