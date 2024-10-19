extends Node

@onready var timer: Timer = $Timer
@onready var countdown: Timer = $Countdown
@onready var ui: GameUI = %UI
@onready var player: Player

@export var items: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_multiplayer_authority(0)
	pass
	
func setup(player_data):
	set_multiplayer_authority(player_data.id)

@rpc("authority", "call_local")
func start_game():
	ui.show_countdown()
	countdown.timeout.connect(on_countdown_timeout)
	timer.timeout.connect(on_timer_timeout)
	self.player.lock_movement()
	
	items = [
		Color(1, 0, 0),
		Color(0, 1, 0),
		Color(0, 0, 1),
				]
				
	if is_multiplayer_authority():
		items.shuffle()
		for item in items:
			Level.spawn_item.rpc(item)
		start_countdown.rpc()
		
@rpc("any_peer", "call_local", "reliable")
func start_countdown():
	countdown.start()

func on_countdown_timeout() -> void:
	ui.hide_countdown()
	player.unlock_movement()
	ui.show_timer()
	timer.start()

func on_timer_timeout() -> void:
	ui.hide_timer()
	player.lock_movement.rpc()
	
func set_player(player: Player) -> void:
	if is_multiplayer_authority():
		self.player = player

func _physics_process(delta: float) -> void:
	if not countdown.is_stopped() or not timer.is_stopped():
		if is_multiplayer_authority():
			ui.update_label_countdown.rpc(countdown.time_left)
			ui.update_label_timer.rpc(timer.time_left)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
