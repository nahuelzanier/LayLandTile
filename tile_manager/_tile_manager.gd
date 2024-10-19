extends Node

@onready var behaviors = {
	-1: $Empty,
	0 : $Empty,
	1 : $BlockDefault,
}

func _ready():
	Game.tile_behavior = behaviors
