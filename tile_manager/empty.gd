extends TileBehaviour

var adjacents = [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]

###############################

func render(layer, iso_pos):
	if Game.map.get_tile(layer, iso_pos) == -1:
		Game.map.set_tile(layer, iso_pos, 0)
		for v in adjacents:
			if abs(iso_pos.x) < 15 and abs(iso_pos.y) < 15:
				Game.tile_behavior[Game.map_manager._MAP[Vector3i(iso_pos.x + v.x, iso_pos.y + v.y, layer)]].render(layer, iso_pos+v)
		if layer < 10:
			Game.tile_behavior[Game.map_manager._MAP[Vector3i(iso_pos.x, iso_pos.y, layer + 1)]].render(layer+1, iso_pos)
		if layer > -10:
			Game.tile_behavior[Game.map_manager._MAP[Vector3i(iso_pos.x, iso_pos.y, layer - 1)]].render(layer-1, iso_pos)

func render_adjacents(layer, iso_pos):
	for v in adjacents:
		if abs(iso_pos.x) < 15 and abs(iso_pos.y) < 15:
			Game.tile_behavior[Game.map_manager._MAP[Vector3i(iso_pos.x + v.x, iso_pos.y + v.y, layer)]].render(layer, iso_pos+v)
	if layer < 10:
		Game.tile_behavior[Game.map_manager._MAP[Vector3i(iso_pos.x, iso_pos.y, layer + 1)]].render(layer+1, iso_pos)
	if layer > -10:
		Game.tile_behavior[Game.map_manager._MAP[Vector3i(iso_pos.x, iso_pos.y, layer - 1)]].render(layer-1, iso_pos)
