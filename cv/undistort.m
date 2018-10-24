function [undistortedImages] = undistort(images, cameraParams, show)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

% c=1;
numImages = size(images, 4);
for i = 1:numImages
    undistortedImages(:, :, :, i) = undistortImage(images(:, :, :, i),...
        cameraParams);%, 'OutputView', 'full');
    if (show)
        figure;
        imshowpair(images(:, :, :, i),...
            undistortedImages(:, :, :, i), 'montage');
        title(['Image', num2str(i), ': Original (left), Undistorted (right)']);
    end
end

end

