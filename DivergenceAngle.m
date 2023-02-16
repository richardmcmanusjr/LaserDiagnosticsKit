% % UnfocusedBeamIncrementalLaserDiagnostic.m
% A program to estimate divergance angle from incremental beam images

import Gaussian_Width.m.*

cd(fileparts(matlab.desktop.editor.getActiveFilename))
cd('Obj_1')
noPlot = 1;

% Load .tif files 
files = dir('**/*.tif');
y1 = zeros(length(files));

% Extract data from .tif files
for i=1:length(files)
    name = erase(files(i).name,'_cm.tif');
    name = erase(name, '.tif');
    name = str2double(name);
    [wx,wy,errx,erry] = Gaussian_Width(files(i).name,noPlot);
    y1(i,1) = name;
    y1(i,2) = wx * 5.2; % 5.2um/pixel
    y1(i,3) = wy * 5.2;
    y1(i,4) = errx;
    y1(i,5) = erry;
end

y1 = sortrows(y1, 1); % sort image data
y1_ave = zeros([length(files),1]);

% Take average of x and y widths
for i=1:length(y1_ave)
    y1_ave(i,1) = mean([y1(i,2), y1(i,3)]);
end

% Generate Linear Fit
x = linspace(y1(3,1),y1(length(y1),1),length(y1) - 2); % x values for linear region
y1_linear_region_2w = 2*y1_ave(3:length(y1_ave)); % y values for linear region
P = polyfit(x,y1_linear_region_2w,1); 
yfit = polyval(P,x);

hold on;
plot(x,yfit,'b-.');
eqn = string(" Linear: y = " + P(1)) + "x + " + string(P(2));
text(min(x),max(y1_linear_region_2w),eqn,"HorizontalAlignment","left","VerticalAlignment","top")
plot(y1(:,1),2 .* y1_ave, 'ro-');
ylim([2 * min(y1_ave) 2 * max(y1_ave)])
hold off
title('Beam Width vs. Distance')
xlabel('z (cm)') 
ylabel('2w (uM)')

divergence = atan(inv(P(1))*10^-2);
fprintf(string("\n" + 'Divergence Angle: ' + divergence + ' radians' + '\n'));
