% Place close and clears if necessary
%% Constants
L1 = 1; L2 = 1; % Link Lengths
port = 'COM4'; % COM-port
% IDs should be hard coded

%% Creation and Calibration
err = hw.start(port);
if err ~= 1
    disp("Error Opening Port");
    hw.stop();
    return;
end
hw.set_on_all();

% Origin
[x0, y0] = get_origin(L1, L2)
beth = make_robot(L1, L2);

%% Loop
while 1
   [x,y] = [1, 1]; % Get position to move to here
   xa = x + x0; ya = y + y0;
   [t1, t2] = get_inverse_kinematics(L1, L2, xa, ya);
   hw.set_position(1, t1);
   hw.set_position(2, t2);
end

%% Terminate
hw.disconnect();
hw.stop();