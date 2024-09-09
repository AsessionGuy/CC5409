extends Node3D

@onready var main: Node3D = $"."
@onready var players: Node3D = %Players
@onready var level: Level = %Level
@onready var carts: Node3D = $Carts

const PLAYER = preload("res://scenes/player.tscn")
const CART = preload("res://scenes/shopping_cart.tscn")

func _ready() -> void:
	for player_data in Game.players:
		var player_inst = PLAYER.instantiate()
		var spawner = level.get_free_spawner()
		spawner.set_player(player_inst)
		players.add_child(player_inst)
		player_inst.setup(player_data)
		var cart_inst = CART.instantiate()
		carts.add_child(cart_inst)
		spawner.set_cart(player_inst, cart_inst)
		
