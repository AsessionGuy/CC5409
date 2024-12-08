extends Node2D

var player_scene = preload("res://scenes/player/player.tscn")
var cart_scene = preload("res://scenes/cart/cart.tscn")

func _ready() -> void:
	GameController.set_multiplayer_authority(1)
	GameController.level = %Level
	
	for player_data in Game.players:
		var level_inst = %Level
		var player_inst = player_scene.instantiate()
		var cart_inst = cart_scene.instantiate()
		player_inst.setup(player_data)
		cart_inst.setup(player_data)
		var player_list = %Level/Players
		var cart_list = %Level/Carts
		player_list.add_child(player_inst)
		cart_list.add_child(cart_inst)
		if player_data.id == multiplayer.get_unique_id():
			GameController._player = player_inst
	
	GameController.start()
