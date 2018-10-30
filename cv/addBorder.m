function [BW] = addBorder(BW, width, val)
% adds a white/black border to a binary image given the val

[row, col] = size(BW);
BW(1:width, :) = val; %top row
BW(row-width:row, :) = val; % bottom row
BW(:, 1:width) = val; % first column
BW(:, col-width:col) = val; % last column

end
