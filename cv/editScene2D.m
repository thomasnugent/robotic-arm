function [newScene2D, newCent] = editScene2D(scene2D, centroid, show)
centroid = round(centroid);

% c = sub2ind([size(scene2D, 2), size(scene2D, 1)], centroid(2), centroid(1));
c = sub2ind(size(scene2D), centroid(2), centroid(1));
stats = regionprops(scene2D, 'PixelIdxList',...
    'PixelList', 'Image', 'BoundingBox', 'Centroid');

for i = 1:length(stats)
    k = find(stats(i).PixelIdxList == c);
    if (~isempty(k))
        break;
    end
end

newCent = stats(i).Centroid;
newScene2D = scene2D;

b = stats(i).BoundingBox;
[rows, cols] = size(stats(i).Image);
xs = floor((b(1)+1 : b(1)+cols));
ys = floor((b(2)+1 : b(2)+rows));
newScene2D(ys, xs) = 0;

if (show)
    figure; imshowpair(scene2D, newScene2D, 'montage'); hold on;
    plot(newCent(1), newCent(2), 'r.', 'LineWidth', 30); hold off;
end
