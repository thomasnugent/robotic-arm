function [retCorners] = getCorners(lines)
% getCorners extracts the corners from the line structs that are created
% using houghlines. It orders them such that the top-right corner is 1 and 
% continuation is in an anti-clockwise direction.

%% Variables:
corners = [];
points = [];
len = 1;
thresh = 40; %40 pixels away

%% Add all points to array:
max_len = 0;
for i = 1:length(lines)
    points(len, 1) = lines(i).point1(2);
    points(len, 2) = lines(i).point1(1); len = len + 1;
    points(len, 1) = lines(i).point2(2);
    points(len, 2) = lines(i).point2(1); len = len + 1;
    
    % Find which line is longest:
    leng = norm(lines(i).point1 - lines(i).point2);
    if ( leng > max_len)
        max_len = leng;
        theta = lines(i).theta;
    end
end

%% Simplify down to four corners:
index = 1;
for j = 1:length(points)
    if (j == 1)
        % add the first point in:
        corners(1, :) = points(1, :);
    else % looped case
        row = points(j, 1);
        col = points(j, 2);
        if ((col > (corners(:, 2) + thresh)) | (col < (corners(:, 2) - thresh)) |...
                (row > (corners(:, 1) + thresh)) | (row < (corners(:, 1) - thresh))) % in bounds
            index = index+1;
            corners(index, :) = [row, col];
        end
    end
end

%% Get correct points:
% sort on y position:
corners = sortrows(corners, 1);
if ((theta >= 0) && (theta < 90))
    i = 2;
else
    i = 1;
end

%% Order the corners correctly:
closedSet(1) = i;
retCorners(1, :) = corners(i, :);
found = 1;
while (found ~= 4)
    minLen = 1000000;
    for j = 1:length(corners)
        dist = norm(corners(i, :) - corners(j, :));
        if ((dist ~= 0) && (dist < minLen) && (length(find(closedSet == j)) == 0))
            minLen = dist;
            nextCorner = corners(j, :);
            next = j;
        end
    end
    found = found+1;
    closedSet(end) = i;
    i = next;
    retCorners(found, :) = nextCorner;
end

end

