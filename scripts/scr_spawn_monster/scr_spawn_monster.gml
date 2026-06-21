/// @param {struct} _grid  GridManager instance
/// @return {Id.Instance|noone}
function spawn_monster(_grid) {
	var _cx = -1;
	var _cy = -1;

	repeat (100) {
		var _try_cx = irandom(_grid.cols - 1);
		var _try_cy = irandom(_grid.rows - 1);
		if (_grid.is_walkable(_try_cx, _try_cy)) {
			_cx = _try_cx;
			_cy = _try_cy;
			break;
		}
	}

	if (_cx == -1) return noone;

	var _pos = _grid.cell_to_world(_cx, _cy);

	global.pending_monster_spawn = { cx: _cx, cy: _cy };
	var _inst = instance_create_layer(_pos.wx, _pos.wy, "Instances", obj_monster);
	global.pending_monster_spawn = undefined;

	return _inst;
}
