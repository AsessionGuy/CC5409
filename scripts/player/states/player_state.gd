class_name PlayerState extends State

@onready var player: Player
@onready var animation_player:= %AnimationPlayer
@onready var animation_tree:AnimationNodeStateMachinePlayback = %AnimationTree["parameters/playback"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
