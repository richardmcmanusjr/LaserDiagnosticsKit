% % GaussianFitComparison.m
% A program to Gaussian Fit of Multiple Lasers

import Gaussian_Width.m.*

cd(fileparts(matlab.desktop.editor.getActiveFilename))
cd('Obj_2')
noPlot = 1;

% Load .tif files
files = dir('**/*.tif');

output = {};

% Extract data from .tif files
for i=1:length(files)
    name = erase(files(i).name,'Obj_2_');
    name = erase(name, '_1meter.tif');
    [wx,wy,errx,erry] = Gaussian_Width(files(i).name,noPlot);
    output(i,1) = {name};
    output(i,2) = {wx}; % in pixels
    output(i,3) = {wy};
    output(i,4) = {errx};
    output(i,5) = {erry};
    output(i,6) = {wx/wy}; % Ellipticity Ratio
end

