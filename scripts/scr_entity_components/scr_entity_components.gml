/// @param {Id.Instance} _owner
/// @param {struct} _grid GridManager instance
/// @param {real} _grid_cx
/// @param {real} _grid_cy
/// @param {real} _max_hp
/// @param {real} _damage
/// @param {real} _move_delay Frames between cell steps
function EntityComponents(_owner, _grid, _grid_cx, _grid_cy, _max_hp, _damage, _move_delay) constructor {
	health = new ComponentHealth(_owner, _max_hp);
	movement = new ComponentMovement(_owner, _grid, _grid_cx, _grid_cy, _move_delay);

	if (_damage > 0) {
		attack = new ComponentAttack(_owner, _damage);
	}

	movement.register();
}
