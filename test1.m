comportNo = 4; % Change this as necessary
testId = 1; % Motor ID

err = hw.start(comportNo);
if err == 1
    disp(strcat('Current Position', num2str(  hw.get_position(testId)  )));
    hw.set_on_all();
    hw.set_position(testId, 2); % in rad
    hw.set_position(3, 2); % in rad
    pause(1);
    hw.set_position(testId, 1);
    hw.set_position(3, 1);
    hw.disconnect();
    hw.stop(); % Unload Library
end