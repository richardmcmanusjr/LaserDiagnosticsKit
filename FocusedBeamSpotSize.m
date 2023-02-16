% % FocusedBeamSpotSize.m
% A program to estimate focused beam spot size from 
% laser focused through lens

import Gaussian_Width.m.*

cd(fileparts(matlab.desktop.editor.getActiveFilename))
cd('Obj_3')
noPlot = 1;

% Load .tif files
files = dir('**/*.tif');

output = zeros(length(files));

% Extract data from files
for i=1:length(files)
    name = erase(files(i).name,'cm.tif');
    name = erase(name, '.tif');
    name = str2double(name);
    [wx,wy,errx,erry] = Gaussian_Width(files(i).name,noPlot);
    output(i,1) = name;
    output(i,2) = wx * 5.2; % 5.2 um/pixel
    output(i,3) = wy * 5.2;
    output(i,4) = errx;
    output(i,5) = erry;
end

% Sort data
y1 = sortrows(output, 1);

y1_ave = zeros([1,length(files)]);

% Compute averages of x and y widths
for i=1:length(files)
    y1_ave(i) = mean([y1(i,2), y1(i,3)]);
end

plot(y1(:,1),2 .* y1_ave)
title('Beam Width vs. Distance')
xlabel('z (cm)') 
ylabel('2w (uM)') 

focusedSpotSize = 2 * min(y1_ave);
fprintf(string("\n" + 'Focused Beam Spot Size (Diameter): ' + focusedSpotSize + ' um' + '\n'));