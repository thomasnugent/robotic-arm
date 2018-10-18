function [BW] = preprocessImage(image, endEffectorRadius, show)

%% Local Variables:
minSize = min(size(image, 1), size(image, 2));
toClear = 0.05; % 5% of the amount of white pixels for bwareaopen
st1 = strel('disk', 3);
st2 = strel('disk', endEffectorRadius); % account for marker radius

%% Preprocessing:
adj = imadjust(rgb2gray(image));
BW = imbinarize(adj);
BW = imcomplement(BW);
BW = imfill(BW, 'holes');
numWhite = sum(sum(BW));
BW = bwareaopen(BW, ceil(toClear*numWhite));
BW = addBorder(BW, 1);
BW = imdilate(BW, st2);
% BW = imcomplement(BW);

if (show)
    figure; imshow(BW);
end

end