extends Node


var _player : Player
var player_list = []
var level : Level
var items : Array
var item_factory : ItemFactory = ItemFactory.new()
var remaining_start_time = 5
var remaining_match_time = 10
var ui: UserInterface
var state 
var winner

var items_for_players = null
var my_items
var opp_items



var available_items: Array
var items_setted = false

@onready var MatchTimer = $MatchTimer
@onready var MatchStartTimer = $MatchStartTimer
@onready var MatchStartTimerLabel = $Ui/MatchStartTimerContainer/MatchStartTimerLabel
@onready var MatchTimerLabel = $Ui/MatchTimerContainer/MatchTimerLabel


enum GameState {ITEM_GENERATION, STARTING, START_TO_ONGOING, ONGOING, ONGOING_TO_FINISHED, FINISHED}

func _ready() -> void:
	ui = $Ui
	ui.hide()

	#set_process(false)

func _process(delta) -> void:
	
	match state:
		
		GameState.STARTING:
			
			if is_multiplayer_authority():
		
				send_match_start_time.rpc(MatchStartTimer.time_left)
				
			ui.set_start_timer(str(int(remaining_start_time)))
		
		GameState.START_TO_ONGOING:
			
			if not is_multiplayer_authority():
				var splited = items_for_players.split(";")
				
				items_for_players = splited[1] + ";" + splited[0]
			
			
			var splited = items_for_players.split(";")
			
			my_items = splited[0].split(",")
			opp_items = splited[0].split(",")
			
			ui.set_items(my_items)
			
			ui.hide_start_timer()
			ui.show_match_timer()
			state = GameState.ONGOING
			
			if is_multiplayer_authority():
				
				MatchTimer.start()
		
		
		GameState.ONGOING:
			
			if is_multiplayer_authority():
				
				send_match_time.rpc(MatchTimer.time_left)
				
			ui.set_match_timer(str(int(remaining_match_time)))
			
		GameState.ONGOING_TO_FINISHED:
		
			state = GameState.FINISHED
			ui.hide_match_timer()
			
			if winner:
				pass
				
			else:
				
				ui.set_game_ended_message("DRAW")
				
			ui.show_game_ended_message()
	
	
			
		GameState.FINISHED:
			
			# boton para volver al menu yadayada
			pass
			
func generate_item_player_list() -> void:
	
	items_for_players = ""
	
	for i in range(0,5):
		
		items_for_players += available_items[randi_range(0,60)] + ("," if i !=4 else "")
		
	items_for_players += ";"
	
	for i in range(0,5):
		
		items_for_players += available_items[randi_range(0,60)] + ("," if i !=4 else "")
			
	
			
@rpc("authority","call_remote","reliable")
func send_item_list(items):
	
	items_for_players = items
	
	
@rpc("authority","call_local","reliable")
func start_game():
	state = GameState.STARTING
	
	
@rpc("authority","call_local","unreliable")
func send_match_start_time(time: float):
	remaining_start_time = time + 1

@rpc("authority","call_local","reliable")
func hide_match_start_time() -> void:
	state = GameState.START_TO_ONGOING
	
func call_hide_match_start_timer():
	hide_match_start_time.rpc()


@rpc("authority","call_local","unreliable")
func send_match_time(time: float):
	remaining_match_time = time + 1

@rpc("authority","call_local","reliable")
func hide_match_time() -> void:
	state = GameState.ONGOING_TO_FINISHED
	
func call_hide_match_timer():
	hide_match_time.rpc()


func spawn_items() -> void:
	available_items= item_factory.get_available_items()
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
	player_list = level.get_node("Players").get_children()
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
		generate_item_player_list()
		send_item_list.rpc(items_for_players)
		start_game.rpc()
		MatchStartTimer.start()

	ui.show()
	ui.show_start_timer()
	#set_process(true)
	
	
func get_player_from_index(index: int) -> Player:
	assert(index < len(level.get_node("Players").get_children()))
	return level.get_node("Players").get_children()[index]
		
func get_cart_from_index(index: int) -> Cart:
	return level.get_node("Carts").get_children()[index]
