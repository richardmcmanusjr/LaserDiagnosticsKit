function [wx,wy,errx,erry] = Gaussian_Width(filename,noplot)
% Fits a Gaussian to an image and returns the x width and y width (in units
% of pixels). Also returns errx and erry, the RMS fit of
% the error.
% To disable plotting, set noplot=1

d=imread(filename);
d=double(d(:,:,1));

% [~,ml]=max(d(:));
% [mr,mc]=ind2sub(size(d),ml);
[xs,ys]=meshgrid([1:size(d,2)],[1:size(d,1)]);

pxth = 3; % pixel threshold for center of mass calculation
cmx = sum(xs(d>pxth).*d(d>pxth))./sum(d(d>pxth));
cmy = sum(ys(d>pxth).*d(d>pxth))./sum(d(d>pxth));

% sx = sqrt(sum( (xs(d>pxth)-cmx).^2 .*d(d>pxth))./sum(d(d>pxth)));
% sy = sqrt(sum( (ys(d>pxth)-cmy).^2 .*d(d>pxth))./sum(d(d>pxth)));

[~,mc] = min(abs([1:size(d,2)]-cmx));
[~,mr] = min(abs([1:size(d,1)]-cmy));

xc = [1:size(d,2)]'; yc = [1:size(d,1)]';
dx = d(mr,:)'; dy = d(:,mc);
dx = (dx-min(dx))/(max(dx)-min(dx));
dy = (dy-min(dy))/(max(dy)-min(dy));
fx=fit(xc,dx,'gauss1');
fy=fit(yc,dy,'gauss1');
wx = fx.c1*sqrt(2); wy = fy.c1*sqrt(2);

errx = sqrt(mean(abs(fx(xc)-dx).^2));
erry = sqrt(mean(abs(fy(yc)-dy).^2));

if nargin<2 | noplot==0
    figure('Color','white');
    plot(xc,fx(xc),xc,dx,...
         yc,fy(yc),yc,dy);
    legend('Fit x','Data x','Fit y','Data y');
    title({['RMS fit error x: ',num2str(errx)],['RMS fit error y: ',num2str(erry)]});
end

if any(d(:)>=255)
    fprintf('Image is saturated! Retake data.');
end
end