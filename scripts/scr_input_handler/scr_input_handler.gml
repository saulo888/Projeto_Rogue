/// @param {struct} _grid GridManager instance
/// @param {Id.Instance} _player_inst
function input_handle_grid_click(_grid, _player_inst) {
	if (!instance_exists(_player_inst)) return;
	if (!variable_instance_exists(_player_inst, "controller")) return;
	if (!_player_inst.controller.can_accept_input()) return;

	var _cell = _grid.world_to_cell(mouse_x, mouse_y);
	if (!_grid.is_in_bounds(_cell.cx, _cell.cy)) return;

	var _occupant = _grid.get_occupant(_cell.cx, _cell.cy);
	var _player_cell = _player_inst.components.movement.get_cell();

	if (_occupant != noone && _occupant.object_index == obj_monster) {
		var _adj = _grid.find_best_adjacent_cell(_player_cell, _occupant);
		if (_adj == undefined) return;

		if (array_length(_adj.path) == 0) {
			_player_inst.controller.pending_attack_target = _occupant;
			_player_inst.controller.try_attack();
		} else {
			_player_inst.controller.queue_move_and_attack(_adj.path, _occupant);
		}
		return;
	}

	if (!_grid.is_walkable(_cell.cx, _cell.cy)) return;
	if (_cell.cx == _player_cell.cx && _cell.cy == _player_cell.cy) return;

	var _path = _grid.find_path(_player_cell, _cell);
	if (array_length(_path) == 0) return;

	_player_inst.controller.queue_move(_path);
}
