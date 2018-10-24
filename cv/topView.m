function [topViewImage, worldPoints, imagePoints, H] = topView(image, height, width, conv, show)
% This function will take an undistorted input image and
% return the top down view of it

%% Local variables:
worldPoints = [width, 0; 0, 0; 0, height; width, height]*(conv); %(x,y) points.
fraction = 0.3; %the fraction of white pixels to clear from binary image.
st1 = strel('square', 4);
st2 = strel('disk', 8);
minLength = 0.8*min([size(image, 1), size(image, 2)]); %80% of image height
fillGap = 400; % 20 pixels to fil gap
thresh = 0.6; % threshold for houghpeaks
numPeaks = 5; % number of peaks to get from houghpeaks

%% Preprocessing: (Willchange depending on envirnoment)
adj = imadjust(rgb2gray(image));
BW = imbinarize(adj, 'global');
BW = imcomplement(BW);
numWhiteixelsPixels = sum(sum(BW));
numToClear = ceil(fraction*numWhiteixelsPixels);
BW = bwareaopen(BW, numToClear);
BW = imerode(BW, st1);
BW = imfill(BW, 'holes');
BW = bwmorph(BW, 'remove');
BW = imdilate(BW, st2);

if (show)
    figure; imshowpair(image, BW, 'montage'); % for debugging
    title("For debugging scene mask");
end
%% Hough transform:
[H, T, R] = hough(BW, 'ThetaResolution', 0.1);
P  = houghpeaks(H,numPeaks,'threshold',ceil(thresh*max(H(:))));
lines = houghlines(BW,T,R,P,'FillGap',fillGap,'MinLength',minLength);

% Plotting hough lines:
if (show)
    figure; imshow(BW); hold on;
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
        
    end
    hold off;
end

%% Get the corners of the card:
%use fliplr to sway columns from (y, x) to (x, y).
%Otherwise fitgeotrans doenst work.
imagePoints = fliplr(getCorners(lines));

if (show)
    figure; imshowpair(BW, image, 'montage'); hold on;
    for m = 1:length(imagePoints)
        plot(imagePoints(m, 1), imagePoints(m, 2), 'g*', 'linewidth', 10);
        text(imagePoints(m, 1), imagePoints(m, 2), num2str(m), 'fontSize', 30, 'color', 'red');
    end
end

%% Performing transforms:
% perform affine transform from world points to image points:
H = fitgeotrans(imagePoints, worldPoints, 'projective');
RA = imref2d([size(image, 1), size(image, 2)]);
topViewImage = imwarp(image, H,'OutputView',RA);

% SHOW THE ORTHONORMAL VIEW:
if (show)
    %shows the image to world transform with scale:
%     figure; imshowpair(image, topViewImage,'montage');
    figure; imshow(topViewImage);
    title('Transformation of image:');
    
end

end