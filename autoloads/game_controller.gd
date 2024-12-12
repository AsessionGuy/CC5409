extends Node

var _player : Player
var level : Level
var items : Array
var item_factory : ItemFactory = ItemFactory.new()

func spawn_items() -> void:
	var available_items: Array = item_factory.get_available_items()
	available_items.append_array(available_items)
	available_items.append_array(available_items)
	available_items.shuffle()
	var item_idx = 0
	while item_idx < 60:
		level.get_shelf().spawn_item(available_items[item_idx])
		item_idx += 1

@rpc("any_peer", "call_local", "reliable", 3)
func spawn_item(item_name: String, pos: Vector3) -> void:
	var item: Item = item_factory.items[item_name].instantiate()
	item.setup(1)
	GameController.level.add_child(item)
	item.global_position = pos
	
@rpc("any_peer", "call_local", "reliable")
func spawn_player() -> void:
	var player_spawners = level.get_node("PlayerSpawners").get_children()
	var player_list = level.get_node("Players").get_children()
	var cart_list = level.get_node("Carts").get_children()
	for player_idx in len(player_list):
		var player: Player = player_list[player_idx]
		var cart: Cart = cart_list[player_idx]
		player.global_position = player_spawners[player_idx].global_position
		player.rotation.y += deg_to_rad(90)
		cart.global_position = player.global_position + Vector3(0, 0, 10)
		cart.rotation.y += deg_to_rad(90)
		if player.is_multiplayer_authority():
			player.post_setup()

func start() -> void:
	if is_multiplayer_authority():
		spawn_player.rpc()
		spawn_items()

func get_player_from_index(index: int) -> Player:
	assert(index < len(level.get_node("Players").get_children()))
	return level.get_node("Players").get_children()[index]
		
func get_cart_from_index(index: int) -> Cart:
	return level.get_node("Carts").get_children()[index]
