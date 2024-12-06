extends Node2D

var player_scene = preload("res://scenes/player/player.tscn")

func _ready() -> void:
	GameController.set_multiplayer_authority(1)
	GameController.level = %Level
	
	for player_data in Game.players:
		var level_inst = %Level
		var player_inst = player_scene.instantiate()
		player_inst.setup(player_data)
		var player_list = %Level/Players
		player_list.add_child(player_inst)
		if player_data.id == multiplayer.get_unique_id():
			GameController._player = player_inst
			player_inst.post_setup()
	
	GameController.start()
