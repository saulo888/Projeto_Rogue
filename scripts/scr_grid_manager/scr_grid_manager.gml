/// @desc Grid occupancy, coordinate conversion, and 8-way BFS pathfinding.
function GridManager(_cols, _rows, _cell_size) constructor {
	cols = _cols;
	rows = _rows;
	cell_size = _cell_size;
	occupancy = ds_grid_create(_cols, _rows);
	ds_grid_clear(occupancy, 0);

	static _DIRS = [
		[1, 0], [-1, 0], [0, 1], [0, -1],
		[1, 1], [1, -1], [-1, 1], [-1, -1],
	];

	destroy = function() {
		if (ds_exists(occupancy, ds_type_grid)) {
			ds_grid_destroy(occupancy);
		}
	};

	is_in_bounds = function(_cx, _cy) {
		return _cx >= 0 && _cy >= 0 && _cx < cols && _cy < rows;
	};

	world_to_cell = function(_wx, _wy) {
		return { cx: floor(_wx / cell_size), cy: floor(_wy / cell_size) };
	};

	cell_to_world = function(_cx, _cy) {
		return {
			wx: _cx * cell_size + cell_size * 0.5,
			wy: _cy * cell_size + cell_size * 0.5,
		};
	};

	get_occupant = function(_cx, _cy) {
		if (!is_in_bounds(_cx, _cy)) return noone;
		var _id = ds_grid_get(occupancy, _cx, _cy);
		if (_id == 0 || !instance_exists(_id)) return noone;
		return _id;
	};

	is_walkable = function(_cx, _cy, _ignore_inst = noone) {
		if (!is_in_bounds(_cx, _cy)) return false;
		var _occ = ds_grid_get(occupancy, _cx, _cy);
		if (_occ == 0) return true;
		if (_ignore_inst != noone && _occ == _ignore_inst) return true;
		return false;
	};

	set_occupant = function(_cx, _cy, _inst) {
		if (!is_in_bounds(_cx, _cy)) return;
		ds_grid_set(occupancy, _cx, _cy, _inst == noone ? 0 : _inst);
	};

	clear_occupant = function(_inst) {
		for (var _cy = 0; _cy < rows; _cy++) {
			for (var _cx = 0; _cx < cols; _cx++) {
				if (ds_grid_get(occupancy, _cx, _cy) == _inst) {
					ds_grid_set(occupancy, _cx, _cy, 0);
				}
			}
		}
	};

	get_neighbors_8 = function(_cx, _cy) {
		var _result = [];
		for (var i = 0; i < array_length(_DIRS); i++) {
			var _ncx = _cx + _DIRS[i][0];
			var _ncy = _cy + _DIRS[i][1];
			if (is_in_bounds(_ncx, _ncy)) {
				array_push(_result, { cx: _ncx, cy: _ncy });
			}
		}
		return _result;
	};

	are_adjacent_8 = function(_a, _b) {
		return max(abs(_a.cx - _b.cx), abs(_a.cy - _b.cy)) == 1;
	};

	can_step_diagonal = function(_from_cx, _from_cy, _to_cx, _to_cy) {
		var _dx = _to_cx - _from_cx;
		var _dy = _to_cy - _from_cy;
		if (abs(_dx) + abs(_dy) != 2) return true;
		var _block_a = !is_walkable(_from_cx + _dx, _from_cy);
		var _block_b = !is_walkable(_from_cx, _from_cy + _dy);
		return !(_block_a && _block_b);
	};

	find_path = function(_from, _to) {
		if (_from.cx == _to.cx && _from.cy == _to.cy) return [];
		if (!is_walkable(_to.cx, _to.cy)) return [];

		var _visited = ds_grid_create(cols, rows);
		ds_grid_clear(_visited, 0);
		var _parent_cx = ds_grid_create(cols, rows);
		var _parent_cy = ds_grid_create(cols, rows);
		ds_grid_clear(_parent_cx, -1);
		ds_grid_clear(_parent_cy, -1);

		var _queue = ds_queue_create();
		ds_queue_enqueue(_queue, _from.cx);
		ds_queue_enqueue(_queue, _from.cy);
		ds_grid_set(_visited, _from.cx, _from.cy, 1);

		var _found = false;

		while (!ds_queue_empty(_queue)) {
			var _cx = ds_queue_dequeue(_queue);
			var _cy = ds_queue_dequeue(_queue);

			if (_cx == _to.cx && _cy == _to.cy) {
				_found = true;
				break;
			}

			for (var i = 0; i < array_length(_DIRS); i++) {
				var _ncx = _cx + _DIRS[i][0];
				var _ncy = _cy + _DIRS[i][1];
				if (!is_in_bounds(_ncx, _ncy)) continue;
				if (ds_grid_get(_visited, _ncx, _ncy)) continue;
				if (!is_walkable(_ncx, _ncy)) continue;
				if (!can_step_diagonal(_cx, _cy, _ncx, _ncy)) continue;

				ds_grid_set(_visited, _ncx, _ncy, 1);
				ds_grid_set(_parent_cx, _ncx, _ncy, _cx);
				ds_grid_set(_parent_cy, _ncx, _ncy, _cy);
				ds_queue_enqueue(_queue, _ncx);
				ds_queue_enqueue(_queue, _ncy);
			}
		}

		var _path = [];
		if (_found) {
			var _cx = _to.cx;
			var _cy = _to.cy;
			while !(_cx == _from.cx && _cy == _from.cy) {
				array_push(_path, { cx: _cx, cy: _cy });
				var _pcx = ds_grid_get(_parent_cx, _cx, _cy);
				var _pcy = ds_grid_get(_parent_cy, _cx, _cy);
				_cx = _pcx;
				_cy = _pcy;
			}
			array_reverse(_path);
		}

		ds_queue_destroy(_queue);
		ds_grid_destroy(_visited);
		ds_grid_destroy(_parent_cx);
		ds_grid_destroy(_parent_cy);

		return _path;
	};

	find_best_adjacent_cell = function(_from, _target_inst) {
		if (!instance_exists(_target_inst)) return undefined;
		if (!variable_instance_exists(_target_inst, "components")) return undefined;
		if (!variable_struct_exists(_target_inst.components, "movement")) return undefined;

		var _target_cell = _target_inst.components.movement.get_cell();
		var _neighbors = get_neighbors_8(_target_cell.cx, _target_cell.cy);
		var _best = undefined;
		var _best_len = infinity;

		for (var i = 0; i < array_length(_neighbors); i++) {
			var _cell = _neighbors[i];
			if (!is_walkable(_cell.cx, _cell.cy)) continue;

			var _len = 0;
			var _path = [];

			if (_cell.cx == _from.cx && _cell.cy == _from.cy) {
				_len = 0;
			} else {
				_path = find_path(_from, _cell);
				_len = array_length(_path);
				if (_len == 0) continue;
			}

			if (_len < _best_len) {
				_best_len = _len;
				_best = { cell: _cell, path: _path };
			}
		}

		return _best;
	};
}
