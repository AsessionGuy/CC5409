class_name WalkingWithoutCartState extends WithoutCartState

@onready var walking_sound: AudioStreamPlayer3D = %WalkingSound
@onready var running_sound: AudioStreamPlayer3D = %RunningSound
# Called when the node enters the scene tree for the first time.
func enter(previous_state_path: String, data := {}) -> void:
	animation_tree.travel("walking")
	if not walking_sound.playing:
		if running_sound.playing:
			running_sound.stop()
		walking_sound.play()

func physics_update(_delta: float) -> void:
	super(_delta)

	
