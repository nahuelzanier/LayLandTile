extends TileMapLayer

@onready var sprite_2d = $Sprite2D
var iso_pos = Vector2.ZERO

func _ready():
	Game.cursor = self

func _process(delta):
	global_position = map_to_local(local_to_map(get_global_mouse_position() + Game.y_offset*Vector2(0, Game.player.layer)))
	iso_pos = local_to_map(get_global_mouse_position() + Game.player.layer*Game.y_offset*Vector2(0, 1))
	sprite_2d.z_index = iso_pos.x + iso_pos.y
	sprite_2d.position.y = Game.y_offset - Game.player.layer*Game.y_offset
	

func _input(event):
	if event.is_action_pressed("left_click"):
		var top_layer = Game.map.get_top_layer(iso_pos)
		Game.player.action(top_layer, iso_pos)
