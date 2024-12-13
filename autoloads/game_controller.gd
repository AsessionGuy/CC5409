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

@onready var MatchTimer = $MatchTimer
@onready var MatchStartTimer = $MatchStartTimer
@onready var MatchStartTimerLabel = $Ui/MatchStartTimerContainer/MatchStartTimerLabel
@onready var MatchTimerLabel = $Ui/MatchTimerContainer/MatchTimerLabel


enum GameState {STARTING, START_TO_ONGOING, ONGOING, ONGOING_TO_FINISHED, FINISHED}

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
	var available_items = item_factory.get_available_items()
	available_items.shuffle()
	for item in available_items:
		level.get_shelf().spawn_item(item)

@rpc("any_peer", "call_local", "reliable")
func spawn_item(item_name: String, pos: Vector3) -> void:
	var item = item_factory.items[item_name].instantiate()
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
		MatchStartTimer.start()

	
	#set_process(true)
	state = GameState.STARTING
	


	
	ui.show()
	ui.show_start_timer()
		
func get_player_from_index(index: int) -> Player:
	assert(index < len(level.get_node("Players").get_children()))
	return level.get_node("Players").get_children()[index]
		
