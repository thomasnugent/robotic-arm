function [Objects, Goals] = getObjects(Image, show, showHistogram)
%% Internal variables:
threshArea = [7500, 20000]; %threshold on area for triangle
cnt = 1; % index for Goals structure

%% Seperate the scene into red, blue, green and yellow:
red.Name = 'red'; red.BW = redMask(Image);
blue.Name = 'blue'; blue.BW = blueMask(Image);
green.Name = 'green'; green.BW = greenMask(Image);
yellow.Name = 'yellow'; yellow.BW = yellowMask(Image);
white.Name = 'GoalandCards'; white.BW = getWhiteMask(Image);

%% Categorise shapes and pre process further
Objects(1) = red; Objects(2) = green; Objects(3) = blue;
Objects(4) = yellow; Objects(5) = white;
% Gets the region props for each coloured object
for i = 1:length(Objects)
    BW = bwareaopen(Objects(i).BW, 300);
    Objects(i).BW = imfill(BW, 'holes');
    Objects(i).stats = regionprops(Objects(i).BW, 'all');
end

%% Finding the Faces of prismed shapes:
for i = 1:length(Objects)
    
    s = Objects(i).stats;
    for k = 1:length(s)
        
        coloured = zeros([size(s(k).Image), 3]);
        minRow = min(s(k).PixelList(:, 2))-1;
        minCol = min(s(k).PixelList(:, 1))-1;
        for j = 1:length(s(k).PixelList)
            coloured(s(k).PixelList(j, 2)-minRow, s(k).PixelList(j, 1)-minCol, :) = Image(s(k).PixelList(j, 2), s(k).PixelList(j, 1), :);
        end
        c = coloured/255;
        Objects(i).segmented(k).Image = c;
        
        %% Extract the faces:
        c = rgb2gray(c);
        c = imadjust(c, [0.3, 1], []); %************** FRAGILE! ***********
        
        if (showHistogram) % If you want to view the histogram:
            figure; h1 = histogram(c, 'BinLimits', [0.0001, max(max(c))]);
            maxima = islocalmax(h1.Values, 'MaxNumExtrema',2);
            f1 = find(maxima == 1);
            vals = h1.Values(f1(1):f1(2));
            minima = islocalmin(vals, 'MaxNumExtrema', 1);
            f2 = find(minima == 1);
            bin = imbinarize(c, h1.BinWidth*(f2+f1(1)));
            
        else
            if (i ~= length(Objects))
                [N, edges]  = histcounts(c, 'BinLimits', [0.001, max(max(c))]);
                maxima = islocalmax(N, 'MaxNumExtrema',2);
                f1 = find(maxima == 1);
                vals = N(f1(1):f1(2));
                minima = islocalmin(vals, 'MaxNumExtrema', 1);
                f2 = find(minima == 1);
                bin = imbinarize(c, edges(f2+f1(1)));
            else
                bin = imbinarize(c, 0.001);
            end
        end
        
        st1 = strel('disk', 4);
        bin = imclose(bin, st1);
        bin = bwareaopen(bin, 50);
        bin = imfill(bin, 'holes');
        rp = regionprops(bin, 'Area', 'Centroid');
        shift = s(k).BoundingBox(1:2);
        
        [~, col] = size(c);
        [center, radii, metric] = imfindcircles(bin, [25, ceil(col/2)], 'ObjectPolarity', 'bright');
        
        if (~(isempty(center)) && (metric(1) > 0))
            if (i == length(Objects)) % This is a goal!
                Goals(cnt).Centroid = shift + rp.Centroid;
                Goals(cnt).Radius = radii;
                cnt = cnt+1;
                continue;
            end
            %% Check for circles first:
            cent = center(1, :); rad = radii(1); % Getting the strongest circle.
            Objects(i).Shape(k).Type = 'circle';
            [height, cent2] = getHeight(c);
            Objects(i).Shape(k).C1 = cent + shift;
            Objects(i).Shape(k).C2 = cent2 + shift;
            Objects(i).Shape(k).Height = height;
            if (height == 35)
                Objects(i).Shape(k).Target = 1; % Set Objects.Shape.Target to true
            else
                Objects(i).Shape(k).Target = 0; % Set Objects.Shape.Target to false
            end
            
            if (show)
                figure; imshowpair(Objects(i).segmented(k).Image, bin, 'montage'); hold on;
                viscircles(cent, rad, 'EdgeColor', 'k');
                hold off;
                str = sprintf("%s %s, C1 = [%2.2f, %2.2f], C2 = [%2.2f, %2.2f], metric = %2.2f",...
                    Objects(i).Name, Objects(i).Shape(k).Type,...
                    Objects(i).Shape(k).C1(1), Objects(i).Shape(k).C1(2),...
                    Objects(i).Shape(k).C2(1), Objects(i).Shape(k).C2(2), metric(1));
                title(str);
            end
            
        else
            %% Else squares or triangles or cards:
            if (rp.Area < threshArea(1)) % Square
                Objects(i).Shape(k).Type = 'square';
                [height, cent2] = getHeight(c);
                Objects(i).Shape(k).Height = height;
                
            elseif (rp.Area < threshArea(2)) % Triangle
                Objects(i).Shape(k).Type = 'triangle';
                [~, cent2] = getHeight(c);
                Objects(i).Shape(k).Height = 35; %35mm
                
            else % card
                Objects(i).Shape(k).Type = 'card';
                cent2 = rp.Centroid;
                Objects(i).Shape(k).Height = 1; % 1mm
                
            end
            Objects(i).Shape(k).C1 = rp.Centroid + shift;
            Objects(i).Shape(k).C2 = cent2 + shift;
            Objects(i).Shape(k).Target = 0; % Set Objects.Shape.Target to false
            
            if (show)
                figure; imshowpair(Objects(i).segmented(k).Image, bin, 'montage');
                str = sprintf("%s %s, C1 = [%2.2f, %2.2f], C2 = [%2.2f, %2.2f], Area = %2.0f",...
                    Objects(i).Name, Objects(i).Shape(k).Type,...
                    Objects(i).Shape(k).C1(1), Objects(i).Shape(k).C1(2),...
                    Objects(i).Shape(k).C2(1), Objects(i).Shape(k).C2(2), rp.Area);
                title(str);
            end
        end
        Objects(i).Shape(k).Shape2D = bin; %Binary image of object top face
        Objects(i).Shape(k).Movable = 0; %Set all objects 'Movable' initially false
    end
end

end

