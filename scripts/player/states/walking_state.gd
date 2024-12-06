class_name WalkingState extends PlayerState

# Called when the node enters the scene tree for the first time.
func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play("CharacterArmature|Walk")

func physics_update(_delta: float) -> void:
	var speed = player.velocity.length()
	
	if is_zero_approx(speed):
		finished.emit("IdleState")
	
	var raw_input := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var forward := player._camera.global_basis.z
	var right := player._camera.global_basis.x
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	player.velocity = player.velocity.move_toward(move_direction * player.move_speed, player.acceleration * _delta)
