extends Node

const DRAW_SCENE = preload("res://scenes/ui/draw_scene.tscn")
const VICTORY_SCENE = preload("res://scenes/ui/victory_scene.tscn")

@onready var timer: Timer = $Timer
@onready var countdown: Timer = $Countdown
@onready var ui: GameUI = %UI
@onready var player: Player
@onready var is_game_running = false

@export var items: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_multiplayer_authority(0)
	pass
	
func setup(player_data):
	set_multiplayer_authority(player_data.id)

@rpc("authority", "call_local")
func start_game():
	is_game_running = true
	ui.show_countdown()
	countdown.timeout.connect(on_countdown_timeout)
	timer.timeout.connect(on_timer_timeout)
	self.player.lock_movement()
	
	items = [
		Color(1, 0, 0),
		Color(0, 1, 0),
		Color(0, 0, 1),
		Color(1, 0, 1),
		Color(1, 1, 0)
				]
				
	if is_multiplayer_authority():
		items.shuffle()
		send_items.rpc(items)
	
	if is_multiplayer_authority():
		for item in items:
			Level.spawn_item.rpc(item)
		start_countdown.rpc()

@rpc("authority", "call_local","reliable")
func send_items(shuffled_items):
	var new_shuffled_items = Array(shuffled_items)
	new_shuffled_items.shuffle()
	player.set_items(new_shuffled_items)
	

@rpc("any_peer", "call_local", "reliable")
func start_countdown():
	countdown.start()

func on_countdown_timeout() -> void:
	ui.hide_countdown()
	player.unlock_movement()
	ui.show_timer()
	timer.start()

func on_timer_timeout() -> void:
	is_game_running = false
	ui.hide_timer()
	player.lock_movement.rpc()
	Level.add_child(DRAW_SCENE.instantiate())
	ui.queue_free()
	
func set_player(player: Player) -> void:
	if is_multiplayer_authority():
		self.player = player

func _physics_process(delta: float) -> void:
	if not countdown.is_stopped() or not timer.is_stopped():
		if is_multiplayer_authority() and GameController.is_game_running:
			ui.update_label_countdown.rpc(countdown.time_left)
			ui.update_label_timer.rpc(timer.time_left)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@rpc("any_peer","call_local")
func announce_winner(player_name: String):
	is_game_running = false
	player.lock_movement.rpc()
	var victory_scene = VICTORY_SCENE.instantiate()
	Level.add_child(victory_scene)
	victory_scene.set_winner.rpc(player_name)
	ui.queue_free()	
