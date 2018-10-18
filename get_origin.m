function [x, y] = get_origin(id_L1, id_L2, L1, L2, x0, y0)
% [x, y] = get_origin(id_L1, id_L2, L1, L2, x0, y0)
% Get the origin of the robot
% Input Arguments:
% id_L1     Servo ID for the first joint
% id_L2     Servo ID for the second joint
% L1        Length of Joint 1
% L2        Length of Joint 2
% x0        Current x-position of the End Effector
% y0        Current y-position of the End Effector
% Outputs:
% (x, y)    Co-ordinates of the origin
% Requires the hw Dynamixel Library
% Requires the COM Port to already be open (this is not checked)
% This is unit indiscriminant, working purely off numbers
% Assumes the servo 0 deg is aligned with the +ve x-axis
t1 = hw.get_position(id_L1);
t2 = h2.getposition(id_L2);
fkx = L1*cos(t1)+L2*cos(t1+t2);
fky = L1*sin(t1)+L2*sin(t1+t2);
x = x0 - fkx;
y = y0 - fky;