function [rgb] = getHDRImage(expTimes, show)

% Create a working directory if one doesnt exist:
workingDir = 'HDR_Images';
try
    addpath(workingDir);
end
if (exist(workingDir) ~= 7)
    mkdir(workingDir)
end


for i = 1:length(expTimes)
    files{i} = ['image', num2str(i), '.png'];
    image = get_image(expTimes(i));
    if (show)
        imshow(image);
    end
    imwrite(image, [workingDir, '/', files{i}]);
end

hdr = makehdr(files,'ExposureValues',expTimes./expTimes(1));
% hdr = makehdr(files);
rgb = tonemap(hdr);

if (show)
    imshow(rgb)
end

end

