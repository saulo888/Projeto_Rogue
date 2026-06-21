draw_self();

if (variable_instance_exists(id, "components")) {
	var _half = global.grid.cell_size * 0.5 - 2;
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_text(x, y - _half - 2, string(components.hp_comp.hp));
}
