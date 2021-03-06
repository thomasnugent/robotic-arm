%% Cleaing:
clc; close all; clear all; w = warning ('off','all');

%% TASK VARIABLES!

%% Variables:
conv = 2; % 2 pixels for every mm.
numImages = 5; % Number of images to take to calibrate.
checkerSize = 22; %22mm sized checkerboard
c = 1; % Keeps tracks of figure numbers.
A3height = 300; %mm
A3width = 420; %mm
penDiameter = conv*20; % 10mm into pixels
Exposure = 230000;


%% Task 1 and 2: Common code:
%% Step 1: Get images from camera and calibrate:
try
    load cameraParamsHome
    load scene1Home
end

if (exist('cameraParams') ~= 1)
    try
        load calibrationImagesHome
    end
    if (exist('calibrationImages') ~= 1)
        fprintf("Calibrating camera, place checkerboard into view and press a button in terminal...\n");
        pause();
        [cameraParams, calibrationImages] = getParams(numImages, checkerSize,Exposure, 0);
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

%% Step 4: Get object in Scene:
[Objects, Goals] = getObjects(topViewImage, 0, 0);

%% Step 5: Get a 2D scene:
minPoint = 2; % point 2 from the getCorners array is the top left hence min point
croppedImage = imcrop(topViewImage,...
    [worldPoints(minPoint, 1), worldPoints(minPoint, 2), A3height*conv, A3width*conv]);
% [scene2D, Objects] = get2DScene(croppedImage, Objects, Goals);
[scene2D, Objects] = get2DScene(croppedImage, Objects, 0);

% decided = 0;
% while(~decided)
%     taskIn = input('Which task number? [1, 2, 3] \n>>> ');
%     if (taskIn == 1 || taskIn == 2 || taskIn == 3)
%         task = taskIn;
%         decided = 1;
%     end
% end

task = 1;

%% Task 1:
if (task == 1)
    %% Find path through image:
    fprintf('Finding Path...\n');
    %This will be a funciton:
    cnt = 1;
    for i = 1:length(Objects)
        for j = 1:length(Objects(i).Shape)
            if (Objects(i).Shape(j).Target == 1)
                [currentScene, startXY] = editScene2D(scene2D, Objects(i).Shape(j).C3, 0); % does some centroid shifting
                [endXY, Goals] = findNearestGoal(startXY, Goals);
                nodes = getNodes(currentScene, round(startXY), round(endXY), 1);
                worldCoordsNodes(cnt).Nodes = nodes/conv; cnt = cnt + 1;
            end
        end
    end
end

%% Task 2:
if (task == 2)
    %% Step 6: Specify whether Object is a target and movable (TESTING FOR NOW)
    Objects = promptMovable(Objects); % <-- Give it a go!
    % Do the BRUCEY SEARCH!
end


%% Robot
num = 1; %Path number
L1 = 280;
L2 = 215;
shiftX = 170;
shiftY = -220;
worldCoordsNodes(num).Nodes(:, 1) = shiftX + worldCoordsNodes(num).Nodes(:, 1);
worldCoordsNodes(num).Nodes(:, 2) = shiftY + worldCoordsNodes(num).Nodes(:, 2);
for i = 1:length(worldCoordsNodes(num).Nodes)
    poses = get_inverse_kinematics(L1, L2, worldCoordsNodes(num).Nodes(i, 1), worldCoordsNodes(num).Nodes(i, 2));
    Poses(i).Pose = poses;
end


%% Vernoli diagram:
% figure;
% sceny = scene2D;
% for i = 1:50
%     sceny = bwmorph(sceny, 'thicken', 5);
% %     sceny = bwmorph(sceny, 'hbreak', 6);
%     imshow(sceny);
% end
% sceny = bwmorph(sceny, 'erode', 5);
% sceny = addBorder(sceny, 10, 1);
% imshow(sceny);

%% Print centroids
% figure; imshow(scene2D); hold on;
% for i = 1:length(Objects)
%     for j = 1:length(Objects(i).Shape)
%         x = Objects(i).Shape(j).C3(1);
%         y = Objects(i).Shape(j).C3(2);
%         plot(x, y, 'r.', 'LineWidth', 30);
%         str = sprintf("[%s %2.0f %s] @ [x, y] = [%2.0f, %2.0f]\n",...
%             Objects(i).Name, Objects(i).Shape(j).Height, Objects(i).Shape(j).Type, x/conv, y/conv);
%         fprintf(str);
%     end
% end
% hold off;

%% ANOTHER STEP HERE FOR MAKING THE IMAGE DILATED WITH THE PEN -> done before this is passed to getNodes.
% EXAMPLE:
% fprintf('Preprocessing top down images..., press button in terminal to continue\n');
% BW = preprocessImage(croppedImage, penDiameter/2, 1);
% size(BW)
%
% %% Find path through image:
% fprintf('Finding Path...\n");
% % Image coordinates:
% startXY = [30 30];
% endXY = [430 801];
% % find path:
% nodes = getNodes(BW, startXY, endXY, 1);
% worldCoordsNodes = nodes/conv;
%
% MOVE ROBOT ALONG THESE NODES!
