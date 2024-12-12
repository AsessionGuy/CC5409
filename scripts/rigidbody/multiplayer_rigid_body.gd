class_name MultiplayerRigidBody3D extends RigidBody3D

func setup(multiplayer_id: int) -> void:
	set_multiplayer_authority(multiplayer_id)
	sleeping = true

func set_custom_integrator_true() -> void:
	if not is_multiplayer_authority():
		custom_integrator = true

@rpc("any_peer", "call_local", "reliable")
func post_setup() -> void:
	set_custom_integrator_true()

@rpc("authority", "call_remote", "unreliable", 3)
func send_state(pos: Vector3, rot: Vector3, linear_vel: Vector3, angular_vel: Vector3) -> void:
	global_position = pos
	global_rotation = rot
	linear_velocity = linear_vel
	angular_velocity = angular_vel

func _physics_process(delta) -> void:
	if is_multiplayer_authority() and not sleeping:
		send_state.rpc(global_position, global_rotation, linear_velocity, angular_velocity)
	
