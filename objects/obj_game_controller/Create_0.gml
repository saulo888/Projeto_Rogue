depth = 100;
grid = new GridManager(42, 24, 32);
global.grid = grid;
global.pending_monster_spawn = undefined;

player        = noone;
max_monsters  = 3;
spawn_timer   = room_speed * 2;
