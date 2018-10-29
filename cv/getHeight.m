function [height, centroid] = getHeight(image)

% [rows, cols] = size(image);

BW = imbinarize(image, 0.001);

stats = regionprops(BW, 'MinorAxisLength', 'MajorAxisLength', 'Eccentricity', 'Centroid');

% rP = stats.MinorAxisLength/stats.MajorAxisLength;

if stats.Eccentricity < 0.665
    height = 35;
else
    height = 70;
end

centroid = stats.Centroid;

% fprintf("ratio = %2.5f\n", rP);
% fprintf("eccen = %2.5f\n", stats.Eccentricity);
end

