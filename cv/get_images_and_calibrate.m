function [cameraParams, undistortedImages, imagesUsed, estimationErrors, ] ...
    = get_images_and_calibrate(numImages, checkerSize)
%GET_IMAGES_AND_CALIBRATE Captures 20 images of a checkerboard and
%calibrates the camera

% See Elliot's top down camera implementation
c = 1; % Figure handles
show = 0; % if show = 1; the errors and extrinsic figures are shown.
for i = 1:numImages
    images(:, :, :, i) = get_image();
    if (i ~= numImages)
        fprintf("Reorient checkerboard for image %d\n", i+1);
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
    h1=figure(c); c=c+1; showReprojectionErrors(cameraParams);
    
    % Visualize pattern locations
    h2=figure(c); c=c+1; showExtrinsics(cameraParams, 'CameraCentric');
    
    % Display parameter estimation errors
    displayErrors(estimationErrors, cameraParams);
end

% For example, you can use the calibration data to remove effects of
% lens distortion.
for j = 1:numImages
    undistortedImages(:, :, :, i) = undistortImage(images(:, :, :, j),...
        cameraParams);
    figure(c); c = c+1;
    imshowpair(images(:, :, :, i),...
        undistortedImages(:, :, :, i), 'montage');
end

end