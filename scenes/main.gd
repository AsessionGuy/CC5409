extends Node3D

@onready var main: Node3D = $"."
@onready var players: Node3D = %Players
@onready var level: Level = %Level

const PLAYER = preload("res://scenes/player.tscn")

func _ready() -> void:
	for player_data in Game.players:
		var player_inst = PLAYER.instantiate()
		var spawner = level.get_free_spawner()
		spawner.set_player(player_inst)
		players.add_child(player_inst)
		player_inst.setup(player_data)
		
