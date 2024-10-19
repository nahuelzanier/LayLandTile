extends Node2D

const ITEM_BLOCK_RESERVE = preload("res://player/item_block_reserve.tscn")
const ITEM_PICK_AXE = preload("res://player/item_pick_axe.tscn")

var items = [
	ITEM_BLOCK_RESERVE,
	ITEM_PICK_AXE,
]

var current_item
var item_index = 1

func _ready():
	current_item = ITEM_PICK_AXE.instantiate()
	add_child(current_item)
	current_item.pivot = self

func _process(delta):
	current_item.item_z_index(abs(rotation))

func activate_item(layer, iso_pos):
	current_item.activate(layer, iso_pos)

func swap_item():
	item_index = (item_index + 1)%items.size()
	current_item.queue_free()
	current_item = items[item_index].instantiate()
	add_child(current_item)
	current_item.pivot = self
