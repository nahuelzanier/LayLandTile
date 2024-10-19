extends Item

func _ready():
	Game.player.lift_position.set_cell(Vector2(-1, 0), 0, Vector2(0, 0), 1)

func activate(layer, iso_pos):
	drop_block(Vector3(iso_pos.x, iso_pos.y, layer))

func drop_block(v3):
	var block = Game.player.lift_position.get_cell_alternative_tile(Vector2i(-1, 0))
	if block != 0:
		if Game.player.layer-1 < Game.map.top_layer and Game.map.layers[Game.player.layer-1].get_cell_alternative_tile(Vector2i(v3.x, v3.y)) == 0:
			Game.map.set_tile(Game.player.layer-1, Vector2i(v3.x, v3.y), block)
		elif Game.player.layer < Game.map.top_layer and Game.map.layers[Game.player.layer].get_cell_alternative_tile(Vector2i(v3.x, v3.y)) == 0:
			Game.map.set_tile(Game.player.layer, Vector2i(v3.x, v3.y), block)
		elif Game.player.layer+1 < Game.map.top_layer and Game.map.layers[Game.player.layer+1].get_cell_alternative_tile(Vector2i(v3.x, v3.y)) == 0:
			Game.map.set_tile(Game.player.layer+1, Vector2i(v3.x, v3.y), block)
		elif Game.player.layer+2 < Game.map.top_layer and Game.map.layers[Game.player.layer+2].get_cell_alternative_tile(Vector2i(v3.x, v3.y)) == 0:
			Game.map.set_tile(Game.player.layer+2, Vector2i(v3.x, v3.y), block)
		elif Game.player.layer+3 < Game.map.top_layer and Game.map.layers[Game.player.layer+3].get_cell_alternative_tile(Vector2i(v3.x, v3.y)) == 0:
			Game.map.set_tile(Game.player.layer+3, Vector2i(v3.x, v3.y), block)
