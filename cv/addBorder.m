function [BW] = addBorder(BW, val)
% adds a white/black border to a binary image given the val

[row, col] = size(BW);
BW(1, :) = val; %top row
BW(row, :) = val; % bottom row
BW(:, 1) = val; % first column
BW(:, col) = val; % last column

end
