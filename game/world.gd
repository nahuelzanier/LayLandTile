extends Node2D

@onready var map = $Map

func _ready():
	var player = Preloads.PLAYER.instantiate()
	add_child(player)
	map.render_map_static(player.iso_pos())
	
