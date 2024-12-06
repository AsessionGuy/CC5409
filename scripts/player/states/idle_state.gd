class_name IdleState extends PlayerState

# Called when the node enters the scene tree for the first time.
func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play("CharacterArmature|Idle")

func physics_update(_delta: float) -> void:	
	player._camera_pivot.rotation.x -= player._camera_input_direction.y * _delta
	player._camera_pivot.rotation.x = clamp(player._camera_pivot.rotation.x, player.tilt_lower_limit, player.tilt_upper_limit)
	player.rotation.y -= player._camera_input_direction.x * _delta

	player._camera_input_direction = Vector2.ZERO
	
	if not is_zero_approx(Input.get_vector("move_left", "move_right", "move_forward", "move_backward").length()):
		finished.emit("WalkingState")
	
	
