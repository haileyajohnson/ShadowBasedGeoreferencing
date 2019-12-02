%% close and clear
close all; clear all;

%% add path
datapath = genpath('data');
addpath('functions', datapath);

%% load lidar
load('stadium.mat');
% load('trimmed_lidar.mat');
% xg = x_grid;
% yg = y_grid;
% zg = z_grid;

%% load image
load('cropped_im.mat');
im = cropped;
%im = imread('gnv_aerial.jpg');

%% get shadows
shadow_threshhold = 0.15;
shadow_mask = getShadows(im, shadow_threshhold);
r = im(:, :, 1);
g = im(:, :, 2);
b = im(:, :, 3);
r(shadow_mask) = 255;
g(shadow_mask) = 255;
b(shadow_mask) = 255;
im = cat(3, r, g, b);
im = imrotate(im, 15);

%% get sun position
% az = -19.3; % full gnv aerial
% elev = 39;

az = 83.75;  % stadium aerial
elev = 35.63; 

%% parameterize camera position
scale = 1; % ratio of picture/lidar
xshift = 0; % horizontal shift in number of lidar points
yshift = 0; % vertical shift in number of lidar points
pitch = 0; % rotation around x
heading = 0; % rotation around y
roll = 0; % rotation around z

xrange = size(xg, 2);
yrange = size(yg, 1);

params0 = [scale, xshift, yshift, roll];
% lb = [1/4, -xrange/4, -yrange/4, -180];
% ub = [1, xrange/4, yrange/4, 180];
lb = [-1 -1 -1 -1];
ub = [1 1 1 1];

%% minimize cost function
ObjectiveFunction = @(params) costFunction(params, xg, yg, zg, im, az, elev);
%[params,fval] = anneal(ObjectiveFunction, params0);
[params,fval] = simulannealbnd(ObjectiveFunction, params0, lb, ub);

%% render model
displaySolution(params, xg, yg, zg, im, az, elev);

%% TODO
% loop optimization
% input guesses for starting params
% input threshold values
