if (player == noone) {
	player = instance_find(obj_player, 0);
}

var _monster_count = instance_number(obj_monster);
if (_monster_count < max_monsters) {
	repeat (max_monsters - _monster_count) {
		spawn_monster(grid);
	}
}

if (mouse_check_button_pressed(mb_left)) {
	input_handle_grid_click(grid, player);
}
