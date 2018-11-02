close all; clear;

% Open COM 4
err = hw.start(4);

% Run robot if connection succeeds
if err == 1
    hw.set_speed(1,0.05);
    hw.set_speed(2,0.05);
    
    %beth = make_robot(280, 216);
    
    for i=1:5
       hw.set_position(1, 300);
       hw.set_position(2,500);
       pause(2);
       hw.set_position(1,500);
       hw.set_position(2,700);
       pause(2);
    end
end

hw.disconnect();
hw.stop();