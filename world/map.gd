extends Node2D

const MAP_LAYER = preload("res://world/map_layer.tscn")

@onready var layers = {}
@onready var bottom = $Bottom

var lowest_layer = -20
var top_layer = 20
var render_distance = 10

func _ready():
	Game.map = self

func should_render(column_pos, iso_pos):
	var x = abs(iso_pos.x - column_pos.x)
	var y = abs(iso_pos.y - column_pos.y)
	return x + y <= render_distance+4

func render_map_static(iso_pos):
	for i in range(lowest_layer, top_layer+1):
		layers[i] = MAP_LAYER.instantiate()
		layers[i].position.y = - Game.y_offset*i
		add_child(layers[i])
	for x in range(-render_distance, render_distance +1):
		for y in range(-render_distance, render_distance +1): 
			var draw_pos = iso_pos + Vector2i(x, y)
			if should_render(draw_pos, iso_pos):
				render_column(draw_pos)

func render_map_dynamic(iso_pos, new_pos):
	var dir = new_pos - iso_pos
	if dir.x == 0 or dir.y == 0:
		render_map_dynamic_iso(iso_pos, new_pos, dir)
	else:
		render_map_dynamic_iso(iso_pos, new_pos-Vector2i(0, dir.y), Vector2i(dir.x, 0))
		render_map_dynamic_iso(new_pos-Vector2i(0, dir.y), new_pos, Vector2i(0, dir.y))

func render_map_dynamic_iso(iso_pos, new_pos, dir):
	var rev_dir = Vector2i(dir.y, dir.x)
	for i in range(-render_distance, render_distance+1):
		var erase_pos = iso_pos - Vector2i((render_distance)*dir.x, (render_distance)*dir.y) + rev_dir*i
		var draw_pos = new_pos + Vector2i((render_distance)*dir.x, (render_distance)*dir.y) + rev_dir*i
		var adj = max(0, abs(i)-4)
		erase_column(erase_pos + Vector2i(adj*dir.x, adj*dir.y))
		render_column(draw_pos - Vector2i(adj*dir.x, adj*dir.y))

func render_column(iso_pos):
	var x = iso_pos.x
	var y = iso_pos.y
	for z in range(lowest_layer, top_layer + 1):
		if Game.map_manager._MAP.has(Vector3i(x, y, z)):
			layers[z].set_cell(Vector2i(x, y), 0, Vector2i(0, 0), Game.map_manager._MAP[Vector3i(x, y, z)])

func erase_column(iso_pos):
	var x = iso_pos.x
	var y = iso_pos.y
	for z in range(lowest_layer, top_layer + 1):
		if Game.map_manager._MAP.has(Vector3i(x, y, z)):
			layers[z].set_cell(Vector2i(x, y), -1, Vector2i(0, 0), 0)

func set_tile(layer, iso_pos, id):
	layers[layer].set_cell(iso_pos, 0, Vector2i(0, 0), id)
	Game.map_manager._MAP[Vector3i(iso_pos.x, iso_pos.y, layer)] = id

func get_tile(layer, iso_pos):
	return layers[layer].get_cell_alternative_tile(iso_pos)

func get_top_layer(iso_pos):
	var i = top_layer
	var cell_id = layers[i].get_cell_alternative_tile(iso_pos)
	while  i > lowest_layer and (cell_id == 0 or cell_id == -1):
		i -= 1
		if layers.has(i):
			cell_id = layers[i].get_cell_alternative_tile(iso_pos)
	return i

func update_layers(layer_var):
	if layer_var < 0:
		lowest_layer -= 1
		layers[lowest_layer] = MAP_LAYER.instantiate()
		layers[lowest_layer].position.y = -Game.y_offset*lowest_layer
		bottom.add_sibling(layers[lowest_layer])
		for x in range(-render_distance, render_distance):
			for y in range(-render_distance, render_distance):
				if Game.map_manager._MAP.has(Vector3i(x, y, lowest_layer)):
					layers[lowest_layer].set_cell(Vector2i(x, y), 0, Vector2i(0, 0), Game.map_manager._MAP[Vector3i(x, y, lowest_layer)])
	if layer_var > 0:
		top_layer += 1
		layers[top_layer] = MAP_LAYER.instantiate()
		layers[top_layer].position.y = -Game.y_offset*top_layer
		add_child(layers[top_layer])
		for x in range(-render_distance, render_distance):
			for y in range(-render_distance, render_distance):
				if Game.map_manager._MAP.has(Vector3i(x, y, top_layer)):
					layers[top_layer].set_cell(Vector2i(x, y), 0, Vector2i(0, 0), Game.map_manager._MAP[Vector3i(x, y, top_layer)])

func update_layer_modulate():
	for k in layers.keys():
		var white = Color(1, 1, 1, 1)
		var dark = ((20-float(k - Game.player.layer)) / 50) / 1.1
		layers[k].modulate = white.darkened(dark)
