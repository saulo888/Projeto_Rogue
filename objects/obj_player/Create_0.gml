grid_cx = 5;
grid_cy = 12;

components = new EntityComponents(id, global.grid, grid_cx, grid_cy, 20, 5, 8);
controller = new PlayerController(id);
depth = -10;

if (instance_exists(obj_game_controller)) {
	obj_game_controller.player = id;
}
