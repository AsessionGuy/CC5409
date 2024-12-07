class_name PlayerController extends Node

@onready var player: Player

@export var move_speed = 10
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 3.0
@export var acceleration := 100.0
@export_range(0.0, 1.0) var mouse_sensitivity := 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await(owner.ready)
	player = owner
	if not is_multiplayer_authority():
		set_process_unhandled_input(false)
		set_physics_process(false)

func unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := event is InputEventMouseMotion
	if is_camera_motion:
		player._camera_input_direction = event.screen_relative * mouse_sensitivity

func input(event: InputEvent) -> void:
	if event.is_action_pressed("run"):
		move_speed *= 2
	elif event.is_action_released("run"):
		move_speed /= 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(_delta: float) -> void:
	player._camera_pivot.rotation.x -= player._camera_input_direction.y * _delta
	player._camera_pivot.rotation.x = clamp(player._camera_pivot.rotation.x, tilt_lower_limit, tilt_upper_limit)
	player.rotation.y -= player._camera_input_direction.x * _delta

	player._camera_input_direction = Vector2.ZERO	
	
	var raw_input := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var forward := player._camera.global_basis.z
	var right := player._camera.global_basis.x
	var move_direction := forward * raw_input.y
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	player.velocity = player.velocity.move_toward(move_direction * move_speed, acceleration * _delta)
