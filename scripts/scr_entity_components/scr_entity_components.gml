/// @param {Id.Instance} _owner
/// @param {real} _grid_cx
/// @param {real} _grid_cy
/// @param {real} _max_hp
/// @param {real} _damage
/// @param {real} _move_delay Frames between cell steps
/// @return {struct}
function EntityComponents(_owner, _grid_cx, _grid_cy, _max_hp, _damage, _move_delay) {
	var _grid = global.grid;
	var _components = {
		health: ComponentHealth(_owner, _max_hp),
		movement: ComponentMovement(_owner, _grid, _grid_cx, _grid_cy, _move_delay),
	};

	if (_damage > 0) {
		_components.attack = ComponentAttack(_owner, _damage);
	}

	_components.movement.register();
	return _components;
}
