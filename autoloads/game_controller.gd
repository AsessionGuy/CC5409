extends Node

@onready var ui: GameUI = %UI
@onready var timer: Timer = $Timer
@onready var countdown: Timer = $Countdown
@onready var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_multiplayer_authority(0)
	if is_multiplayer_authority():
		timer.timeout.connect(func(): self.player.toggle_lock_movement())
		countdown.timeout.connect(func(): timer.start())
		countdown.start()
	
func set_player(player: Player) -> void:
	self.player = player

func _physics_process(delta: float) -> void:
	if is_node_ready():
		ui.update_label_countdown.rpc(countdown.time_left)
		ui.update_label_timer.rpc(timer.time_left)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
