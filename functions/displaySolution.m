function h = displaySolution(params, xg, yg, zg, im, az, elev)
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
xcenter = floor(xrange/2) + xshift;
ycenter = floor(yrange/2) + yshift;

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

%% create texture mapping
warp(xtrim, ytrim, ztrim, rot_im);
axis equal
view(az, elev)

h = figure();

warp(xtrim, ytrim, ztrim, rot_im);
axis equal
view(0, 90)

end

