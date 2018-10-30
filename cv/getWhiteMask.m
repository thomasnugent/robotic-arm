function [BW] = getWhiteMask(Image)

BW = whiteMask(Image);
BW = bwpropfilt(BW, 'Area', [3000, 50000]); %*********** FRAGILE ***********
BW = imfill(BW, 'holes');
BW = bwconvhull(BW, 'objects');

end