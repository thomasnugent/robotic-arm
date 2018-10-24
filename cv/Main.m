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
pause();
scene = get_image();

fprintf("Getting undistorted images..., press button in terminal to continue\n");
% pause();
undistImg = undistort(scene, cameraParams, 1);

%% Step 3: Performing top down view of scene:
fprintf("Getting top down view of images...\n");
% topViewImage = topView(undistImg, A3height, A3width, 1); % normal view
[topViewImage, worldPoints, imagePoints] = topView(undistImg, A3width, A3height, conv, 1); % 90 view

%% Step 4: Object recogntion: (perhaps another view, horizontal/parallel to table?)
% if we take a horizontal view we can determin object heights? -> can find
% 35cm cylinder?
minPoint = 2; % point 2 from the getCorners array is the top left hence min point
croppedImage = imcrop(topViewImage,...
    [worldPoints(minPoint, 1), worldPoints(minPoint, 2), A3height*conv, A3width*conv]);
figure; imshow(croppedImage);

%% Preprocess top down image
fprintf('Preprocessing top down images..., press button in terminal to continue\n');
pause();
BW = preprocessImage(croppedImage, penDiameter/2, 1);
% BW = (BW*3)-1
size(BW)

%% Find path through image:
fprintf('Finding Path...,  press button in terminal to continue\n');
pause();
% Image coordinates:
startXY = [30 30]; 
endXY = [430 801];
% find path:
nodes = getNodes(BW, startXY, endXY, 1);
worldCoordsNodes = nodes/conv; 

%% MOVE ROBOT ALONG THESE NODES!
 