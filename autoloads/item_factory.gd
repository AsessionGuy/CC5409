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
		"pumpkin": preload("res://scenes/items/pumpkin.tscn"),
		"orange": preload("res://scenes/items/orange.tscn"),
		"pear": preload("res://scenes/items/pear.tscn"),
		"grapes": preload("res://scenes/items/grapes.tscn"),
		"coconut": preload("res://scenes/items/coconut.tscn"),
		"lemon": preload("res://scenes/items/lemon.tscn"),
		"toilet_paper": preload("res://scenes/items/toilet_paper.tscn"),
		"shampoo": preload("res://scenes/items/shampoo.tscn"),
		"chips": preload("res://scenes/items/chips.tscn"),
		"lettuce": preload("res://scenes/items/lettuce.tscn"),
		"tomato": preload("res://scenes/items/tomato.tscn"),
		"potato": preload("res://scenes/items/potato.tscn"),
		"pineapple": preload("res://scenes/items/pineapple.tscn"),
		"peach": preload("res://scenes/items/peach.tscn"),
		"onion": preload("res://scenes/items/onion.tscn")
	}

func get_available_items() -> Array:
	return items.keys()
