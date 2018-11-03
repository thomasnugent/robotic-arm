function [P, skeleton_coords, nodes] = get_vernoli_path(sceny, startXY, endXY) %, worldCoords)
%Gets the vernoli path based on a vernoli scene, sceny.

% Just so I can write this function independently. Eventually it'd be good
% to overlay the nodes and path on the original photo, but this can be done
% outside of the function.
sceny = 0;
load('sceny.mat', 'sceny');

BW = 1 - sceny; % Inverts binary
figure
imshow(BW);
skel = bwmorph(BW, 'skel', Inf);

goalPoints = [47, 387; 534 673]; % startXY; endXY

% Need to replace these values with function arguments, but must also
% search for the best entry point (i.e. closest point that is part of the
% skeleton and can be reached from startXY).

c1 = 47;  % startXY(1)
r1 = 387; % startXY(2)

c2 = 534; % endXY(1)
r2 = 673; % endXY(2)

hold on
plot(c1, r1, 'g*', 'MarkerSize', 15)
plot(c2, r2, 'g*', 'MarkerSize', 15)
hold off

D1 = bwdistgeodesic(skel, c1, r1, 'quasi-euclidean');
D2 = bwdistgeodesic(skel, c2, r2, 'quasi-euclidean');

D = D1 + D2;
D = round(D * 8) / 8;

D(isnan(D)) = inf;
skeleton_path = imregionalmin(D);
P = imoverlay(skel, imdilate(skeleton_path, ones(3,3)), [1 0 0]);
imshow(P, 'InitialMagnification', 200)
hold on
plot(c1, r1, 'g*', 'MarkerSize', 15)
plot(c2, r2, 'g*', 'MarkerSize', 15)
hold off

% Extract the points where the line was drawn
[height, width] = size(skeleton_path);
skeleton_coords = zeros(1, 2);
nodes = [];
count = 1;
for i = 1:height
    for j = 1:width
        if skeleton_path(i, j) == 1
            skeleton_coords(count, 1) = i;
            skeleton_coords(count, 2) = j;
            
            hold on
            
%             plot(skeleton_coords(count, 2), ...
%                  skeleton_coords(count, 1), ...
%                  'rd', 'MarkerSize', 4)
%             
            % We can change this so it takes a value more regularly. For
            % now, every 50 pixels seems reasonable.
            if mod(count, 50) == 0
                plot(skeleton_coords(count, 2), ...
                 skeleton_coords(count, 1), ...
                 'cd', 'MarkerSize', 10);
                node = [skeleton_coords(count, 2), ...
                        skeleton_coords(count, 1)];
                % Append new node (x, y) to next row of nodes.    
                nodes = [nodes; node];
            end
            
            count = count + 1;
            
            
            
        end
    end
end

%% ALL FAILED ATTEMPTS lmao
% 
% MIDDLE = 300;
% for i = 1:2
%     i
%     if goalPoints(i, 1) <= MIDDLE
%         BW = draw_line_from_left(BW, goalPoints(i,:));
%     else
%         BW = draw_line_from_right(BW, goalPoints(i,:));
%     end
% end


% solution_path = bwmorph(BW, 'thin', Inf);
% figure
% imshow(solution_path)
% 
% thick_solution_path = imdilate(solution_path, ones(3,3));
% P = imoverlay(sceny, thick_solution_path, [1 0 0]);
% figure
% imshow(P, 'InitialMagnification', 'fit')
% 
% BW1 = edge(BW, 'canny');
% figure
% imshow(BW1)
% % BW2 = bwmorph(BW1,'remove');
% % figure
% % imshow(BW2)
% % 
% BW3 = bwmorph(BW1,'skel',Inf);
% figure
% imshow(BW3)
% 
% BW4 = bwmorph(BW3,'endpoints',Inf);
% figure
% imshow(BW4)
% BW4 = bwmorph(BW1,'branchpoints',Inf);
% figure
% imshow(BW4)


% [H,T,R] = hough(BW);
% imshow(H,[],'XData',T,'YData',R,...
%             'InitialMagnification','fit');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;
% 
% P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
% x = T(P(:,2)); y = R(P(:,1));
% plot(x,y,'s','color','white');
% 
% lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
% figure, imshow(sceny), hold on
% max_len = 0;
% 
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%    % Determine the endpoints of the longest line segment
%    len = norm(lines(k).point1 - lines(k).point2);
%    if ( len > max_len)
%       max_len = len;
%       xy_long = xy;
%    end
% end

%im = P;

end

