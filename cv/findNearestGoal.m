function [endNode] = findNearestGoal(startNode, Goals)

nodes = cat(1, Goals(:).Centroid);
d = (nodes(:, 1).^2 + nodes(:, 2).^2).^0.5;
[val, idx] = min(d);
endNode = Goals(idx).Centroid;

end