class_name Player extends CharacterBody3D

var _camera_input_direction := Vector2.ZERO
var index
var id

@onready var _camera: Camera3D = %Camera3D
@onready var _spring_arm_3d: SpringArm3D = %SpringArm3D
@onready var _camera_pivot: Node3D = %SpringArm3D
@onready var _ray_cast_3d: RayCast3D = %RayCast3D
@onready var _state_machine: StateMachine = %StateMachine
@onready var _controller: PlayerController

var is_interacting = false

func _ready() -> void:
	_camera.clear_current(false)

func setup(player_data: Statics.PlayerData) -> void:
	set_online_player_data(player_data)

func post_setup() -> void:
	if is_multiplayer_authority():
		set_camera()
	else:
		_ray_cast_3d.enabled = false

# Sets online player data, i. e. name, authority
func set_online_player_data(player_data: Statics.PlayerData) -> void:
	name = str(player_data.name) if str(player_data.name).is_empty() else str(player_data.index)
	index = player_data.index
	id = player_data.id
	set_multiplayer_authority(player_data.id)

# Spawns camera and set it up only for local player
func set_camera() -> void:
	_camera = Camera3D.new()
	_camera.make_current()
	_spring_arm_3d.add_child(_camera)

@rpc("authority", "call_remote", "unreliable", 2)
func send_state(vel: Vector3, rot: Vector3):
	velocity = vel
	rotation = rot

var target_velocity = Vector3.ZERO

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		_controller.input(event)

func _unhandled_input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		_controller.unhandled_input(event)

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		_state_machine.physics_process(delta)
		_controller.physics_process(delta)
		velocity.y = get_gravity().y
		send_state.rpc(velocity, rotation)
	move_and_slide()
