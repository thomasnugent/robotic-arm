%% Does not chcek if port open
function disconnect
calllib('libdxl', 'dxl_terminate');