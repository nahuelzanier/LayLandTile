extends Item

var swing_rotation = 0
var swing_angle = PI/2
var swing_speed = PI/20

var swing = false
var recoil = false

var tile_pos = null

func _ready():
	if Game.player:
		Game.player.lift_position.set_cell(Vector2(-1, 0), 0, Vector2(0, 0), 0)

func _process(delta):
	if swing:
		if not recoil and swing_rotation <= swing_angle:
			rotation += swing_speed
			swing_rotation += swing_speed
		elif not recoil:
			recoil = true
			mine_tile(tile_pos)
		elif recoil and swing_rotation >= 0:
			rotation -= swing_speed
			swing_rotation -= swing_speed
		else:
			swing = false
			recoil = false

func activate(layer, iso_pos):
	if not swing:
		tile_pos = Vector3(iso_pos.x, iso_pos.y, layer)
		swing = true

func mine_tile(v3):
	if Game.map.layers[Game.player.layer+3].get_cell_alternative_tile(Vector2i(v3.x, v3.y)) != 0:
		Game.map.set_tile(Game.player.layer+3, Vector2i(v3.x, v3.y), 0)
		#Game.tile_behavior[0].render_adjacents(Game.player.layer+3, Vector2i(v3.x, v3.y))
	elif Game.map.layers[Game.player.layer+2].get_cell_alternative_tile(Vector2i(v3.x, v3.y)) != 0:
		Game.map.set_tile(Game.player.layer+2, Vector2i(v3.x, v3.y), 0)
		#Game.tile_behavior[0].render_adjacents(Game.player.layer+2, Vector2i(v3.x, v3.y))
	elif Game.map.layers[Game.player.layer+1].get_cell_alternative_tile(Vector2i(v3.x, v3.y)) != 0:
		Game.map.set_tile(Game.player.layer+1, Vector2i(v3.x, v3.y), 0)
		#Game.tile_behavior[0].render_adjacents(Game.player.layer+1, Vector2i(v3.x, v3.y))
	elif Game.map.layers[Game.player.layer].get_cell_alternative_tile(Vector2i(v3.x, v3.y)) != 0:
		Game.map.set_tile(Game.player.layer, Vector2i(v3.x, v3.y), 0)
		#Game.tile_behavior[0].render_adjacents(Game.player.layer, Vector2i(v3.x, v3.y))
	else:
		Game.map.set_tile(Game.player.layer-1, Vector2i(v3.x, v3.y), 0)
		#Game.tile_behavior[0].render_adjacents(Game.player.layer-1, Vector2i(v3.x, v3.y))
