class_name Level extends Node3D

var current_shelf = 4

@onready var shelves: Array = get_shelves()
@onready var player_spawners: Array = get_player_spawners()

func setup(player_data: Statics.PlayerData) -> void:
	set_multiplayer_authority(player_data.id)

func get_shelves() -> Array:
	var shelves = []
	for aisle in %Aisles.get_children():
		for shelf in aisle.get_children():
			shelves.append(shelf)
	return shelves

func get_shelf() -> Shelf:
	var shelf: Shelf = shelves[current_shelf]
	if shelf.is_full():
		current_shelf += 1
	return shelves[current_shelf]

func get_player_spawners() -> Array:
	var players_spawners = []
	for player_spawner in %PlayerSpawners.get_children():
		players_spawners.append(player_spawner)
	return players_spawners

func get_player_spawner() -> PlayerSpawner:
	var player_spawner: PlayerSpawner = player_spawners.pop_front()
	player_spawner.set_occupied.rpc(true)
	return player_spawner
	
