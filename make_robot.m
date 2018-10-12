function bot = make_robot(link1Length, link2Length)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Make my robot
L1 = Link('d', 0, 'a', link1Length, 'alpha', 0);
L2 = Link('d', 0, 'a', link2Length, 'alpha', 0);

bot = SerialLink([L1 L2], 'name', '4 Link Stamper Robot');
end

