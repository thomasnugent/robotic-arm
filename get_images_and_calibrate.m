function [cameraParams, imagesUsed, estimationErrors, undistortedImage] ...
    = get_images_and_calibrate(checkerSize)
%GET_IMAGES_AND_CALIBRATE Captures 20 images of a checkerboard and
%calibrates the camera

% See Elliot's top down camera implementation
for i = 1:20
    im = get_image()
    images(i) = im
end

[imagePoints, boardSize, imagesUsed] = ...
    detectCheckerboardPoints(images);

% Read the first image to obtain image size
originalImage = imread(images(1));
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates of the corners of the squares
squareSize = checkerSize;  % in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = ...
    estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of 
% lens distortion.
undistortedImage = undistortImage(originalImage, cameraParams);

end

