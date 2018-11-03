function [outputNodes] = getNodes(BW, startXY, endXY, show)

BW = double(BW);

prm = PRM(BW);        % create navigation object
% prm.plot('goal', 'nooverlay');
prm.plan();             % create roadmaps
figure; imshow(BW); hold on;
outputNodes = prm.query(startXY, endXY);  % animate path from this start location

for i = 1:length(outputNodes)
    plot(outputNodes(:, 1), outputNodes(:, 2), 'r', 'lineWidth', 2);
end

hold off;
end