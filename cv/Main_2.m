%% Cleaing:
clc; close all;

%% Variables:
conv = 2; % 2 pixels for every mm.
numImages = 5; % Number of images to take to calibrate.
checkerSize = 22; %22mm sized checkerboard
c = 1; % Keeps tracks of figure numbers.
A3height = 300; %mm
A3width = 420; %mm
penDiameter = conv*20; % 10mm into pixels

%% Step 1: Get images from camera and calibrate:
if (exist('cameraParams') ~= 1)
    fprintf("Calibrating camera, place checkerboard into view and press a button in terminal...\n");
    pause();
    [cameraParams, calibrationImages] = getParams(numImages, checkerSize, 0);
end
%% Step 2: Get undistorted scene image (Testing for now):
fprintf("Add the scene and press button in terminal to take a photo...\n");
% pause();
if (exist('scene') ~= 1)
    scene = get_image();
end

fprintf("Getting undistorted images..., press button in terminal to continue\n");
% pause();
undistImg = undistort(scene, cameraParams, 0);

%% Step 3: Performing top down view of scene:
fprintf("Getting top down view of images...\n");
% topViewImage = topView(undistImg, A3height, A3width, 1); % normal view
[topViewImage, worldPoints, imagePoints, H] = topView(undistImg, A3width, A3height, conv, 0); % 90 view

% Segment objects in colour:
BW = sceneMask(topViewImage); %************ MASK HERE ***************%
BW = bwareaopen(BW, 5000);
filtImg = zeros([size(BW), 3]);
[row, col] = find(BW == 1);
for i = 1:length(row)
    filtImg(row(i), col(i), :) = topViewImage(row(i), col(i), :);
end
filtImg = filtImg/255;
s = regionprops(BW, 'all');
figure; imshowpair(topViewImage, filtImg, 'montage');

% Get the top face of the objects:
h1;
for i = 1:length(s)
    newObject = zeros([size(s(i).Image), 3]);
    minRow = min(s(i).PixelList(:, 2))-1;
    minCol = min(s(i).PixelList(:, 1))-1;
    for j = 1:length(s(i).PixelList)
        newObject(s(i).PixelList(j, 2)-minRow, s(i).PixelList(j, 1)-minCol, :) = filtImg(s(i).PixelList(j, 2), s(i).PixelList(j, 1), :);
    end
    
    newObject = imwarp(newObject, H); 
    blue = newObject(:, :, 1);
    red = newObject(:, :, 2);
    green = newObject(:, :, 3);
    
    figure,
    subplot(2, 3, 1); imshow(red);
    subplot(2, 3, 2); imshow(green);
    subplot(2, 3, 3); imshow(blue);
    m = 'log';
    edge1 = edge(red, m); subplot(2, 3, 4); imshow(edge1);
    edge2 = edge(green, m); subplot(2, 3, 5); imshow(edge2);
    edge3 = edge(blue, m); subplot(2, 3, 6); imshow(edge3);
    
    edge4 = or(or(edge1, edge2), edge3);
    %    st1 = strel('rectangle', [3 3]);
    st2 = strel('disk', 4);
    BW = imdilate(edge4, st1);
    figure; imshowpair(edge4, BW, 'montage');
    
    pause();
    %     sorted = sort(newObjectGray(:));
    %     idx1 = find(sorted ~= 0);
    %     h1 = histogram(newObjectGray, 100, 'BinLimits',[sorted(idx1(1)), sorted(idx1(end))]);
    %     [val, idx2] = max(h1.Values);
    %     Sum = cumsum(h1.Values);
    %     idx3 = find(Sum > sum(h1.Values)/2);
    %     medVal = h1.Values(idx3(1)-1);
    %     medXVal = find(h1.Values == medVal);
    %
    %     thresh = h1.BinWidth*(medXVal+1);
    %     BW = imbinarize(newObjectGray, thresh);
    %     figure; imshowpair(newObjectGray, BW, 'montage');
    %     figure; imshow(faceImg);
    %     pause()
    
    %     faceImg = faceMask(newObject);
    %     faceColour = zeros(size(newObject));
    %     [row, col] = find(faceImg == 1);
    %     newObjectGray = rgb2gray(newObject);
    %     for k = 1:length(row)
    %         faceColour(row(k), col(k), :) = newObjectGray(row(k), col(k), :);
    %     end
    %     newObjectGray = imadjust(newObjectGray);
end

% %% Step 4: Object recogntion: (perhaps another view, horizontal/parallel to table?)
% % if we take a horizontal view we can determin object heights? -> can find
% % 35cm cylinder?
% minPoint = 2; % point 2 from the getCorners array is the top left hence min point
% croppedImage = imcrop(topViewImage,...
%     [worldPoints(minPoint, 1), worldPoints(minPoint, 2), A3height*conv, A3width*conv]);
% figure; imshow(croppedImage);
%
% %% Preprocess top down image
% fprintf('Preprocessing top down images..., press button in terminal to continue\n');
% pause();
% BW = preprocessImage(croppedImage, penDiameter/2, 1);
% % BW = (BW*3)-1
% size(BW)
%
% %% Find path through image:
% fprintf('Finding Path...,  press button in terminal to continue\n');
% pause();
% % Image coordinates:
% startXY = [30 30];
% endXY = [430 801];
% % find path:
% nodes = getNodes(BW, startXY, endXY, 1);
% worldCoordsNodes = nodes/conv;
%
% %% MOVE ROBOT ALONG THESE NODES!
