if (player == noone) {
	player = instance_find(obj_player, 0);
}

spawn_timer--;
if (spawn_timer <= 0) {
	spawn_timer = room_speed * 2;
	if (instance_number(obj_monster) < max_monsters) {
		spawn_monster(grid);
	}
}

if (mouse_check_button_pressed(mb_left)) {
	input_handle_grid_click(grid, player);
}
