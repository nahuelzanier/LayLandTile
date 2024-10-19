extends Node2D
class_name Item

var pivot
@onready var sprite_2d = $Sprite2D

func item_z_index(rotation):
	sprite_2d.z_index = Game.player.animated_sprite_2d.z_index + rotation

func activate(layer, iso_pos):
	pass
