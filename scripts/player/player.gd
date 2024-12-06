class_name Player extends CharacterBody3D

@export var move_speed = 50
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 8.0
@export var acceleration := 100.0
@export_range(0.0, 1.0) var mouse_sensitivity := 0.5

var _camera_input_direction := Vector2.ZERO
@onready var _camera := Camera3D.new()

var index
var id

@onready var _spring_arm_3d: SpringArm3D = %SpringArm3D
@onready var _camera_pivot: Node3D = %SpringArm3D
@onready var _state_machine: StateMachine = %StateMachine

func _ready() -> void:
	_state_machine.player = self

func setup(player_data: Statics.PlayerData) -> void:
	set_online_player_data(player_data)

func post_setup() -> void:
	if is_multiplayer_authority():
		set_camera()

# Sets online player data, i. e. name, authority
func set_online_player_data(player_data: Statics.PlayerData) -> void:
	name = str(player_data.name)
	index = player_data.index
	id = player_data.id
	set_multiplayer_authority(player_data.id)

# Spawns camera and set it up only for local player
func set_camera() -> void:
	_camera = Camera3D.new()
	_spring_arm_3d.add_child(_camera)

@rpc("authority", "call_remote", "unreliable", 2)
func send_state(vel: Vector3, rot: Vector3):
	velocity = vel
	rotation = rot

var target_velocity = Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		var is_camera_motion := event is InputEventMouseMotion
		if is_camera_motion:
			_camera_input_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		_state_machine._physics_process.rpc(delta)
		velocity.y = get_gravity().y
		send_state.rpc(velocity, rotation)
	move_and_slide()
