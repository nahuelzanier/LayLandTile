extends StateManager

@onready var current_state : Node = $StateWalking

var player : Node2D

func resolve_axis(vector2) -> void:
	current_state.resolve_axis(vector2)
