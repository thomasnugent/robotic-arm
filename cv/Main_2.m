%% Cleaing:
clc; close all; clear all; w = warning ('off','all');

%% Variables:
conv = 2; % 2 pixels for every mm.
numImages = 5; % Number of images to take to calibrate.
checkerSize = 22; %22mm sized checkerboard
c = 1; % Keeps tracks of figure numbers.
A3height = 300; %mm
A3width = 420; %mm
penDiameter = conv*20; % 10mm into pixels

%% Step 1: Get images from camera and calibrate:
try
    load cameraParams
    load scene1
end

if (exist('cameraParams') ~= 1)
    try
        load calibrationImages
    end
    if (exist('calibrationImages') ~= 1)
        fprintf("Calibrating camera, place checkerboard into view and press a button in terminal...\n");
        pause();
        [cameraParams, calibrationImages] = getParams(numImages, checkerSize, 0);
    end
end

%% Step 2: Get undistorted scene image:
if (exist('scene') ~= 1)
    fprintf("Add the scene and press button in terminal to take a photo...\n");
    pause();
    Exposure = 1.3*50000;
    scene = get_image(Exposure);
    %     power = 1.3;
    %     expTimes = (power.^(1))*lowExp;
    %     scene = getHDRImage(expTimes, 1);
end

% fprintf("Getting undistorted images..., press button in terminal to continue\n");
% pause();
undistImg = undistort(scene, cameraParams, 0);

%% Step 3: Performing top down view of scene:
fprintf("Getting top down view of images...\n");
[topViewImage, worldPoints, imagePoints, H] = topView(undistImg, A3width, A3height, conv, 0);
% topViewImage = imrotate(topViewImage, 90);
figure; imshow(topViewImage);

%% Step4: Segment objects in colour:
% BW = sceneMask1(topViewImage); %************ MASK HERE ***************%
% BW = bwareaopen(BW, 5000);
Objects = getObjects(topViewImage, 0, 0);

minPoint = 2; % point 2 from the getCorners array is the top left hence min point
croppedImage = imcrop(topViewImage,...
    [worldPoints(minPoint, 1), worldPoints(minPoint, 2), A3height*conv, A3width*conv]);
figure; imshow(croppedImage);
scene2D = get2DScene(croppedImage, Objects);

figure; imshowpair(croppedImage, scene2D, 'montage');
%% Get object heights: DONE

%% Clear the Scene:

%% Identify centroid of blue 35cm cyclinder:


%% Step 4: Object recogntion: (perhaps another view, horizontal/parallel to table?)
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
