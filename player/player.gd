extends Node2D

@onready var state_manager = $StateManager
@onready var lift_position = $LiftPosition
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var center_pivot = $CenterPivot

var layer = 6

var SPEED : float = 50
var direction = Vector2.ZERO
var last_iso_pos

func _ready():
	Game.player = self
	state_manager.player = self
	last_iso_pos = lift_position.local_to_map(global_position)
	Game.map.update_layer_modulate()

func _input(event) -> void:
	var h_axis = Input.get_axis("left", "right")
	var v_axis = Input.get_axis("up", "down")
	direction = Vector2(2*h_axis, v_axis)
	if event.is_action_pressed("swap"):
		center_pivot.swap_item()

func _physics_process(delta) -> void:
	var iso_pos = lift_position.local_to_map(global_position)
	animated_sprite_2d.z_index = iso_pos.x + iso_pos.y
	animated_sprite_2d.position.y = -12 - layer*Game.y_offset
	center_pivot.position.y = -12 - layer*Game.y_offset
	lift_position.z_index = iso_pos.x + iso_pos.y
	lift_position.position.y = -45 - layer*Game.y_offset
	face_direction()
	check_collision(direction.normalized(), delta)
	if iso_pos != last_iso_pos:
		Game.map.render_map_dynamic(last_iso_pos, iso_pos)
		last_iso_pos = iso_pos

func check_collision(direction, delta):
	var old_layer = layer
	if layer > Game.map.lowest_layer and layer <= Game.map.top_layer:
		var move_dir = lift_position.local_to_map(global_position + direction.normalized())
		var standing_on = Game.map.layers[layer-1].get_cell_alternative_tile(lift_position.local_to_map(global_position))
		var floor_data = Game.map.layers[layer-1].get_cell_alternative_tile(move_dir)
		var obstacle_data = Game.map.layers[layer].get_cell_alternative_tile(move_dir)
		var obstacle_layer = Game.map.get_top_layer(move_dir)
		if Game.tile_behavior[standing_on].hole():
			layer -= 1
			Game.map.update_layer_modulate()
		elif Game.tile_behavior[floor_data].entity_walk() and not Game.tile_behavior[obstacle_data].obstacle():
			position += direction * SPEED * delta
		elif obstacle_layer-layer <= Game.tile_behavior[obstacle_data].step_height():
			position += direction * SPEED * delta
			layer += 1
			Game.map.update_layer_modulate()
		elif Game.tile_behavior[floor_data].hole() and not Game.tile_behavior[obstacle_data].obstacle():
			position += direction * SPEED * delta
			layer -= 1
			Game.map.update_layer_modulate()

func face_direction():
	center_pivot.rotation = center_pivot.global_position.direction_to(get_global_mouse_position()).angle()
	if center_pivot.rotation >= -PI/8 and center_pivot.rotation <= PI/8:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("idle_side")
	elif center_pivot.rotation > PI/8 and center_pivot.rotation < 3*PI/8:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("idle_side_down")
	elif center_pivot.rotation < -PI/8 and center_pivot.rotation > -3*PI/8:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("idle_side_up")
	elif center_pivot.rotation >= 3*PI/8 and center_pivot.rotation <= 5*PI/8:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("idle_down")
	elif center_pivot.rotation > 5*PI/8 and center_pivot.rotation < 7*PI/8:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("idle_side_down")
	elif center_pivot.rotation < -5*PI/8 and center_pivot.rotation > -7*PI/8:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("idle_side_up")
	elif center_pivot.rotation <= -7*PI/8 or center_pivot.rotation >= 7*PI/8:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("idle_side")
	elif center_pivot.rotation <= -3*PI/8 and center_pivot.rotation >= 5*PI/8:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("idle_up")

func action(layer, iso_pos):
	center_pivot.activate_item(layer, iso_pos)

func iso_pos():
	return lift_position.local_to_map(global_position)
