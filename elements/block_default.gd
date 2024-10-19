extends Element

func _ready():
	iso_pos = Game.map.layers[0].local_to_map(position)
	z_index = iso_pos.x + iso_pos.y
