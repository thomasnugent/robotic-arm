function [scene2D, Objects] = get2DScene(Image, Objects, Goals)

%% Internal variables:
[nrows, ncols, ~] = size(Image);
scene2D = zeros(nrows, ncols);
scale = 2;
%% Step 1: getting the centroids of the top faces and whole objects.
% Will use an interpolation to get the base face centroid using the
% total objects centroid and top face centroid.
for i = 1:length(Objects)-1
    for j = 1:length(Objects(i).Shape)
        
        C1 = Objects(i).Shape(j).C1;
        C2 = Objects(i).Shape(j).C2;
        
        dx = (C2(1) - C1(1))*scale;
        dy = (C2(2) - C1(2))*scale;
        
        C3 = [C2(1)+dx, C2(2)+dy];
        Objects(i).Shape(j).C3 = C3;
        
        reconstructed = zeros(nrows, ncols);
        b = Objects(i).stats(j).BoundingBox;
        [rows, cols] = size(Objects(i).Shape(j).Shape2D);
        xs = floor((b(1) : b(1)+cols-1) + dx);
        ys = floor((b(2) : b(2)+rows-1) + dy);
        
        
        reconstructed(ys, xs) = Objects(i).Shape(j).Shape2D;
        scene2D = or(scene2D, reconstructed);
        
    end
end

if (isstruct(Goals))
    figure; imshowpair(scene2D, Image, 'montage'); 
    hold on;
    for k = 1:length(Goals)
        theta = 0:0.1:2*pi;
        r = Goals(k).Radius;
        s = Goals(k).Centroid; %A3 size
        x = r.*cos(theta) + s(1);
        y = r.*sin(theta) + s(2);
        plot(x, y, 'r');
    end
    hold off;
end
end

