function set_on_all
for i=1:18
	calllib('libdxl', 'dxl_write_word', i, 24, 1);
end