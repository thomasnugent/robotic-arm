function [endNode, Goals] = findNearestGoal(startNode, Goals)

nodes = cat(1, Goals(:).Centroid);
d = (nodes(:, 1).^2 + nodes(:, 2).^2).^0.5;
% [val, idx] = min(d);

currMin = 1000000;
for i = 1:length(d)
    if ((Goals(i).Filled == 0) && (d(i) < currMin))
        currMin = d(i);
        idx = i;
    end
end

Goals(idx).Filled = 1;
endNode = Goals(idx).Centroid;

end