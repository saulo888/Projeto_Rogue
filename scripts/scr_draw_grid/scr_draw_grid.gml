/// @param {struct} _grid GridManager instance
function draw_grid_overlay(_grid) {
	draw_set_color(make_color_rgb(50, 50, 50));

	for (var _cx = 0; _cx <= _grid.cols; _cx++) {
		var _x = _cx * _grid.cell_size;
		draw_line(_x, 0, _x, _grid.rows * _grid.cell_size);
	}

	for (var _cy = 0; _cy <= _grid.rows; _cy++) {
		var _y = _cy * _grid.cell_size;
		draw_line(0, _y, _grid.cols * _grid.cell_size, _y);
	}
}
