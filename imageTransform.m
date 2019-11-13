function newIm = imageTransform(im,params, az, elev)
%% 
% zoom: ratio of pixels to points
% translate: which point matches which pizel
% rotate: imTransform


% lay new image on surface
warp(x_grid, y_grid, z_grid, im);
set(gca, 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none');
axis equal

% view from sun position and save as new image
view(az, elev)
F = getframe;
newIm = frame2im(F);

end

