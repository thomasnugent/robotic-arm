%% Cleaing:
clc; clear all; close all;

%% Variables:
numImages = 2; % Number of images to take to calibrate.
checkerSize = 22; %22mm sized checkerboard
c = 1; % Keeps tracks of figure numbers.

%% Step 1: Get images from camera and calibrate:
fprintf("Getting images from camera and calibrating...\n");
[cameraParams, images] = getParams(numImages, checkerSize, 0);

%% Step 2: Get undistorted checkerboard images (Testing for now):
fprintf("Getting undistorted images...\n");
undistImgs = undistort(images, cameraParams, 0);

%% Step 3: Performing top down view of scene:
fprintf("Getting top down view of images...\n");
topViewImgs = topView(images, 1);

%% Step 4: Object recogntion: (perhaps another view, horizontal/parallel to table?)
% if we take a horizontal view we can determin object heights? -> can find
% 35cm cylinder?
