/// @param {Id.Instance} _owner
/// @param {struct} _grid GridManager instance
/// @param {real} _start_cx
/// @param {real} _start_cy
/// @param {real} _move_delay Frames between cell steps
/// @return {struct}
function ComponentMovement(_owner, _grid, _start_cx, _start_cy, _move_delay) {
	return {
		owner: _owner,
		grid: _grid,
		grid_cx: _start_cx,
		grid_cy: _start_cy,
		move_delay: _move_delay,
		move_timer: 0,
		path: [],
		is_moving: false,

		sync_world_pos: function() {
			var _pos = grid.cell_to_world(grid_cx, grid_cy);
			owner.x = _pos.wx;
			owner.y = _pos.wy;
		},

		register: function() {
			grid.set_occupant(grid_cx, grid_cy, owner);
			sync_world_pos();
		},

		unregister: function() {
			grid.set_occupant(grid_cx, grid_cy, noone);
		},

		get_cell: function() {
			return { cx: grid_cx, cy: grid_cy };
		},

		queue_path: function(_path) {
			path = _path;
			is_moving = array_length(path) > 0;
			move_timer = 0;
		},

		step: function() {
			if (!is_moving || array_length(path) == 0) {
				is_moving = false;
				return true;
			}

			move_timer--;
			if (move_timer > 0) return false;

			move_timer = move_delay;
			var _next = path[0];
			array_delete(path, 0, 1);

			grid.set_occupant(grid_cx, grid_cy, noone);
			grid_cx = _next.cx;
			grid_cy = _next.cy;
			grid.set_occupant(grid_cx, grid_cy, owner);
			sync_world_pos();

			if (array_length(path) == 0) {
				is_moving = false;
				return true;
			}

			return false;
		},
	};
}
