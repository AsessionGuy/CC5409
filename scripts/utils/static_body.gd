class_name CustomRigidBody3D extends RigidBody3D

@onready var player

func set_player(player: Player):
	self.player = player
	set_multiplayer_authority(player.get_multiplayer_authority())

func setup(player: Player):
	self.set_player(player)
	if not is_multiplayer_authority():
		custom_integrator = true

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		send_state.rpc(position, rotation, angular_velocity, linear_velocity)

@rpc("any_peer", "call_remote", "unreliable")
func send_state(pos, rot, ang_vel, lin_vel):
	position = lerp(position, pos, 0.5)
	rotation = lerp(rotation, rot, 0.5)
	angular_velocity = lerp(angular_velocity, ang_vel, 0.5)
	linear_velocity = lerp(linear_velocity, lin_vel, 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
