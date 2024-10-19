extends Node

var _MAP = {}

func _ready():
	Game.map_manager = self
	generate_random_map()

func generate_random_map():
	for z in range(-15, 16):
		for x in range(-50, 51):
			for y in range(-50, 51):
				if z < 0:
					_MAP[Vector3i(x, y, z)] = 1
				else:
					_MAP[Vector3i(x, y, z)] =0
	for x in range(-50, 51):
		for y in range(-50, 51):
			if randi()%500 == 0:
				draw_hill(10, x, y, 0)

func draw_hill(size, x, y, z):
	for i in range(0, size):
		draw_patch(size-i, x, y, z+i)

func draw_patch(size, x, y, z):
	for xp in range(-size, size):
		for yp in range(-size, size):
			if _MAP.has(Vector3i(x + xp, y + yp, z)) and _MAP[Vector3i(x + xp, y + yp, z)] == 0:
				_MAP[Vector3i(x + xp, y + yp, z)] = 1
