class_name RunningWithoutCartState extends WithoutCartState
@onready var running_sound: AudioStreamPlayer3D = %RunningSound
@onready var walking_sound: AudioStreamPlayer3D = %WalkingSound
# Called when the node enters the scene tree for the first time.
func enter(previous_state_path: String, data := {}) -> void:
	animation_tree.travel("running")
	if not running_sound.playing:
		if walking_sound.playing:
			walking_sound.stop()
		running_sound.play()


func physics_update(_delta: float) -> void:
	super(_delta)
