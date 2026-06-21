var _cfg = (variable_global_exists("pending_monster_spawn")
         && !is_undefined(global.pending_monster_spawn))
         ? global.pending_monster_spawn
         : undefined;

grid_cx = (_cfg != undefined) ? _cfg.cx : 20;
grid_cy = (_cfg != undefined) ? _cfg.cy : 12;

components = new EntityComponents(id, grid_cx, grid_cy, 10, 3, 8);
sprite_index = spr_poring_stand;
image_speed  = 1;
depth = -5;
