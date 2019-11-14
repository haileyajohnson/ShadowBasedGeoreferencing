function cost = costFunction(params, xg, yg, zg, im, az, elev)
%% get function params and scale
xrange = size(xg, 2);
yrange = size(yg, 1);
% 
% scale = params(1);
% xshift = params(2);
% yshift = params(3);
% roll = params(4);

scale = params(1)*(.75/2) + (.75/2) + .25;
xshift = floor(params(2) * xrange);
yshift = floor(params(3) * yrange);
roll = params(4) * 180;


%% shift image
% invalid arrangement if shift pushes image outside bounds of lidar
% invalid if non-integer shift
if (abs(xshift/xrange) > scale) || (abs(yshift/yrange) > scale)
    cost = rand()+1;
    disp(cost)
    return;
end
xcenter = floor(xrange/2) + round(xshift);
ycenter = floor(yrange/2) + round(yshift);

%% rotate image
rot_im = imrotate((im), roll, 'loose');

%% scale image
numpointsx = floor((size(xg, 2) * scale)/2);
numpointsy = floor((size(yg, 1) * scale)/2);
xtrim = xg(max(ycenter-numpointsy, 1):min(ycenter+numpointsy, yrange),...
    max(xcenter-numpointsx, 1):min(xcenter+numpointsx, xrange));
ytrim = yg(max(ycenter-numpointsy, 1):min(ycenter+numpointsy, yrange),...
    max(xcenter-numpointsx, 1):min(xcenter+numpointsx, xrange));
ztrim = zg(max(ycenter-numpointsy, 1):min(ycenter+numpointsy, yrange),...
    max(xcenter-numpointsx, 1):min(xcenter+numpointsx, xrange));
% set min threshold of textured points
[h, w] = size(xtrim);
if (h*w) < .5*(xrange*yrange)
    cost = rand()+1;
    disp(cost)
    return;
end

%% create texture mapping
warp(xtrim, ytrim, ztrim, rot_im);
set(gca, 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none');
axis equal
view(az, elev)
F = getframe;
viewIm = frame2im(F);

%% get cost of view im 
num_textured_points = sum(sum(sum(viewIm, 3) > 0));
% get shadow mask
shadow_threshhold = 0.15;
shadow_mask = getShadows(viewIm, shadow_threshhold);
num_shadowed_points = sum(sum(shadow_mask));
cost = num_shadowed_points/num_textured_points;

disp(cost);

end

