extends State

signal walk(direction : Vector2)

func resolve_axis(vector2) -> void:
	emit_signal("walk", Vector2(2*vector2.x, vector2.y))
