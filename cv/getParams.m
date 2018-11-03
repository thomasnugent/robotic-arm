function [cameraParams, images] ...
    = getParams(numImages, checkerSize, exp, show)
%GET_IMAGES_AND_CALIBRATE Captures 20 images of a checkerboard and
%calibrates the camera

% See Elliot's top down camera implementation
c = 1; % Figure handles
% if show = 1; the errors and extrinsic figures are shown.
for i = 1:numImages
    images(:, :, :, i) = get_image(exp);
    if (i ~= numImages)
        fprintf("Reorient checkerboard for image %d then press a button in cmd window\n", i+1);
        pause();
    end
end

[imagePoints, boardSize, imagesUsed] = ...
    detectCheckerboardPoints(images);

% Read the first image to obtain image size
[rows, cols, ~] = size(images);

% Generate world coordinates of the corners of the squares
% in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, checkerSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = ...
    estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [rows, cols]);

if (show)
    % View reprojection errors
    h1=figure; showReprojectionErrors(cameraParams);
    
    % Visualize pattern locations
    h2=figure; showExtrinsics(cameraParams, 'CameraCentric');
    
    % Display parameter estimation errors
    displayErrors(estimationErrors, cameraParams);
end

end