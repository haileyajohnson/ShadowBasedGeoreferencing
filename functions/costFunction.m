function cost = costFunction(params, pt_cld, im, az, elev)
%% get function params
horz_shift = params(1);
vert_shift = params(2);
rotate = params(3);
cam_pos = params(4:6);

%% get points visible from camera position
vis = HPR(pt_cld, cam_pos, 1);
vis_pt_cld = pt_cld(vis, :);

%% regrid
x = vis_pt_cld(:, 1);
y = vis_pt_cld(:, 2);
z = vis_pt_cld(:, 3);

dx = linspace(min(x), max(x), 1000); 
dy = linspace(min(y), max(y), 1000); 
[xg,yg] = meshgrid(dx,dy);

zg = griddata(x,y,z,xg,yg);

%% shift image
if horz_shift > 0
    xg = xg(:, 1+horz_shift:end);
    yg = yg(:, 1+horz_shift:end);
    zg = zg(:, 1+horz_shift:end);
else
    xg = xg(:, 1:end+horz_shift);
    yg = yg(:, 1:end+horz_shift);
    zg = zg(:, 1:end+horz_shift);
end
    
if vert_shift > 0
    xg = xg(1+vert_shift:end, :);
    yg = yg(1+vert_shift:end, :);
    zg = zg(1+vert_shift:end, :);
else
    xg = xg(1:end+vert_shift, :);
    yg = yg(1:end+vert_shift, :);
    zg = zg(1:end+vert_shift, :);
end

%% rotate image
rot_im = imrotate(double(im), rotate, 'loose');
mrot = ~imrotate(true(size(double(im))), rotate, 'loose');
rot_im(mrot&~imclearborder(mrot)) = nan;

%% create texture mapping
warp(xg, yg, zg, rot_im);
set(gca, 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none');
axis equal
view(az, elev)
F = getframe;
viewIm = frame2im(F);
close

%% get cost of view im
t = .5 * length(vis); % set min threshold of textured points
num_textured_points = length(squeeze(sum(~isnan(viewIm))));
if num_textured_points < t
    cost = 1;
else
    % get shadow mask
    shadow_threshhold = 0.4;
    shadow_mask = getShadows(viewIm, shadow_threshhold);
    num_shadowed_points = sum(sum(shadow_mask));
    cost = num_shadowed_points/num_textured_points;
end

end

