/// @param {Id.Instance} _owner Player instance
/// @return {struct}
function PlayerController(_owner) {
	return {
		owner: _owner,
		state: "IDLE",
		pending_attack_target: noone,

		can_accept_input: function() {
			return state == "IDLE" && !owner.components.movement.is_moving;
		},

		queue_move: function(_path) {
			pending_attack_target = noone;
			owner.components.movement.queue_path(_path);
			state = "MOVING";
		},

		queue_move_and_attack: function(_path, _target) {
			pending_attack_target = _target;
			owner.components.movement.queue_path(_path);
			state = "MOVING";
		},

		try_attack: function() {
			state = "ATTACKING";
			var _target = pending_attack_target;
			pending_attack_target = noone;

			if (!instance_exists(_target)) {
				state = "IDLE";
				return;
			}

			var _grid = owner.components.movement.grid;
			var _player_cell = owner.components.movement.get_cell();
			var _target_cell = _target.components.movement.get_cell();

			if (!_grid.are_adjacent_8(_player_cell, _target_cell)) {
				state = "IDLE";
				return;
			}

			if (variable_struct_exists(owner.components, "attack")) {
				owner.components.attack.perform_attack(_target);
			}

			state = "IDLE";
		},

		update: function() {
			var _mov = owner.components.movement;

			if (_mov.is_moving) {
				state = "MOVING";
				var _finished = _mov.step();
				if (_finished && pending_attack_target != noone) {
					try_attack();
				} else if (_finished) {
					state = "IDLE";
				}
			} else if (state == "MOVING") {
				state = "IDLE";
			}
		},
	};
}
