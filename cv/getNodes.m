function [outputNodes] = getNodes(BW, startXY, endXY, show)

prm = PRM(BW, 'npoints', 150);        % create navigation object
prm.plan()             % create roadmaps
outputNodes = prm.query(startXY, endXY);  % animate path from this start location

if (show)
    figure(gcf); hold on;
    for i = 1:length(outputNodes)
        plot(outputNodes(:, 1), outputNodes(:, 2), 'r', 'lineWidth', 2);
    end
end

end