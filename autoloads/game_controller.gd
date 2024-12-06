extends Node

var _player : Player
var level : Level
var items : Array
var item_factory : ItemFactory = ItemFactory.new()

func spawn_items() -> void:
	var available_items = item_factory.get_available_items()
	available_items.shuffle()
	for item in available_items:
		level.get_shelf().spawn_item(item)

@rpc("any_peer", "call_local", "reliable")
func spawn_item(item_name: String, pos: Vector3, rot: Vector3) -> void:
	var item = item_factory.items[item_name].instantiate()
	item.setup(1)
	GameController.level.add_child(item)
	item.global_position = pos
	item.global_rotation = rot
	
@rpc("any_peer", "call_local", "reliable")
func spawn_player() -> void:
	var player_spawners = level.get_node("PlayerSpawners").get_children()
	var player_list = level.get_node("Players").get_children()
	for player_idx in len(player_list):
		var player: Player = player_list[player_idx]
		player.global_position = player_spawners[player_idx].global_position
		Debug.log(player.get_multiplayer_authority())
		if player.is_multiplayer_authority():
			player.post_setup()

func start() -> void:
	if is_multiplayer_authority():
		spawn_player.rpc()
		spawn_items()
