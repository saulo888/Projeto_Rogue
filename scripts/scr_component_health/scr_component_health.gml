/// @param {Id.Instance} _owner
/// @param {real} _max_hp
/// @return {struct}
function ComponentHealth(_owner, _max_hp) {
	return {
		owner: _owner,
		max_hp: _max_hp,
		hp: _max_hp,
		take_damage: function(_amount) {
			hp = max(0, hp - _amount);
			return hp;
		},
		is_alive: function() {
			return hp > 0;
		},
	};
}
