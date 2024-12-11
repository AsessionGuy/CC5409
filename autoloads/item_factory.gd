class_name ItemFactory extends Node

@export var items: Dictionary = {}

func _init() -> void:
	items = {
		"soda_can": preload("res://scenes/items/soda_can.tscn"),
		"cereal_box": preload("res://scenes/items/cereal_box.tscn"),
		"juice_box": preload("res://scenes/items/juice_box.tscn"),
		"cookies": preload("res://scenes/items/cookies_snack.tscn"),
		"milk": preload("res://scenes/items/milk_box.tscn"),
		"banana": preload("res://scenes/items/banana.tscn"),
		"pumpkin": preload("res://scenes/items/pumpkin.tscn")
	}

func get_available_items() -> Array:
	return items.keys()
