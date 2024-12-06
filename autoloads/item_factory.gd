class_name ItemFactory extends Node

@export var items: Dictionary = {}

func _init() -> void:
	items = {
		"soda_can": preload("res://scenes/items/soda_can.tscn"),
	}

func get_available_items() -> Array:
	return items.keys()
