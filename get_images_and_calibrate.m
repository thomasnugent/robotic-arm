function [cameraParams, imagesUsed, estimationErrors, undistortedImage] ...
    = get_images_and_calibrate()
%GET_IMAGES_AND_CALIBRATE Captures 20 images of a checkerboard and
%calibrates the camera

% See Elliot's top down camera implementation
for i = 1:20
    im = get_image()
    imagesUsed(i) = im
end

% Now calibrate

end

