class_name IdleWithoutCartState extends WithoutCartState

@onready var walking_sound: AudioStreamPlayer3D = %WalkingSound
@onready var running_sound: AudioStreamPlayer3D = %RunningSound

func _ready() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func enter(previous_state_path: String, data := {}) -> void:
	animation_tree.travel("idle")
	if walking_sound.playing:
		walking_sound.stop()
	if running_sound.playing:
		running_sound.stop()

func physics_update(_delta: float) -> void:	
	super(_delta)
	
	
