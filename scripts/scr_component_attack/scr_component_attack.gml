/// @param {Id.Instance} _owner
/// @param {real} _damage
function ComponentAttack(_owner, _damage) constructor {
	owner = _owner;
	damage = _damage;

	perform_attack = function(_target) {
		if (!instance_exists(_target)) return false;
		if (!variable_instance_exists(_target, "components")) return false;
		if (!variable_struct_exists(_target.components, "health")) return false;

		_target.components.health.take_damage(damage);

		if (!_target.components.health.is_alive()) {
			if (variable_struct_exists(_target.components, "movement")) {
				_target.components.movement.unregister();
			}
			instance_destroy(_target);
		}

		return true;
	};
}
