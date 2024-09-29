extends Node

@onready var timer: Timer = $Timer
@onready var countdown: Timer = $Countdown
@onready var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_multiplayer_authority(0)
	pass
	
func setup(player_data):
	set_multiplayer_authority(player_data.id)

@rpc("any_peer", "call_remote")
func start_game():
	self.player.lock_movement.rpc()
	self.player.show_countdown.rpc()
	timer.timeout.connect(func(): 
		self.player.toggle_lock_movement.rpc()
		self.player.hide_timer.rpc())
	countdown.timeout.connect(func(): 
		self.player.hide_countdown.rpc()
		self.player.show_timer.rpc()
		self.player.unlock_movement.rpc()
		timer.start())
	countdown.start()
	
func set_player(player: Player) -> void:
	self.player = player

func _physics_process(delta: float) -> void:
	if self.player != null:
		player.update_label_countdown.rpc(countdown.time_left)
		player.update_label_timer.rpc(timer.time_left)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
