%% bioloid access functions% by Adam Lukomski, 2013%
function set_on(id)
    calllib('libdxl', 'dxl_write_word', id, 24, 1);  