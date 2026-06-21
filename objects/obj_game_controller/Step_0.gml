if (player == noone) {
	player = instance_find(obj_player, 0);
}

if (mouse_check_button_pressed(mb_left)) {
	input_handle_grid_click(grid, player);
}
