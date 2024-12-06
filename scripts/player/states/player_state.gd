class_name PlayerState extends State

@onready var player: Player 
@onready var animation_player: AnimationPlayer = %AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await(owner.ready)
	player = _state_machine.player
	assert(player != null)
