/// @param {Id.Instance} _owner
/// @param {struct} _grid GridManager instance
/// @param {real} _grid_cx
/// @param {real} _grid_cy
/// @param {struct} _opts { max_hp, damage, move_delay }
function EntityComponents(_owner, _grid, _grid_cx, _grid_cy, _opts) constructor {
	health = new ComponentHealth(_owner, _opts.max_hp);
	movement = new ComponentMovement(_owner, _grid, _grid_cx, _grid_cy, (_opts.move_delay != undefined) ? _opts.move_delay : 8);

	if (_opts.damage > 0) {
		attack = new ComponentAttack(_owner, _opts.damage);
	}

	movement.register();
}
