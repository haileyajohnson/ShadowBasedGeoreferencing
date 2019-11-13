function [shadow_mask] = getShadows(im, threshhold)
% NOTE: You might need different median filter size for your test image.
r = medfilt2(double(im(:,:,1)), [3,3]); 
g = medfilt2(double(im(:,:,2)), [3,3]);
b = medfilt2(double(im(:,:,3)), [3,3]);

%% Calculate Shadow Ratio:
shadow_ratio = ((4/pi).*atan(((b-g))./(b+g)));

% NOTE: You might need a different threshold value for your test image.
% You can also consider using automatic threshold estimation methods.
shadow_mask = shadow_ratio>threshhold;
end

