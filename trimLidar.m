close all; clear all;

load('gv_lidar.mat');
arr = table2array(GainesvilleLidar);

maxx = 370445.205;
minx = 368875.696;
maxy = 3281393.736;
miny = 3279917.206;

x = arr(:, 1);
y = arr(:, 2);
z = arr(:, 3);

dx = linspace(minx, maxx, 1000); 
dy = linspace(miny, maxy, 1000); 
[xq,yq] = meshgrid(dx,dy);

vq = griddata(x,y,z,xq,yq);
% surf(xq,yq,vq);
% shading interp
% hold on

im = imread('gnv_aerial.jpg');
warp(xq, yq, vq, I);
axis equal