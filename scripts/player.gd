class_name Player extends CharacterBody3D
	
const SPEED = 800.0
const JUMP_VELOCITY = 100.0
const ACCELERATION = 2.0


@onready var animationtree = $AnimatedPlayer/AnimationTree
@export var YAW_SENSITIVITY = 0.5
@export var PITCH_SENSITIVITY = 0.1

@onready var yaw = 0
@onready var pitch = 0
#@onready var skeleton_3d: Skeleton3D = $PhysicsPlayer/RootNode/CharacterArmature/Skeleton3D
@onready var label_3d: Label3D = $Label3D
@onready var spring_arm_3d: SpringArm3D = %SpringArm3D

@onready var ui: GameUI = %UI
@onready var can_move: bool = true

var player_data

enum {IDLE, RUN, WALKING, INTERACT}
var current_anim = IDLE
var rot_value = 0
var double = 1

@export var blend_speed = 15

var run_val = 0
var walk_val = 0
var interact_val = 0

var interacting := false

var idle = true
var running = false
var walking = false
var interaction = false

func handle_animations(delta):
	match current_anim:
		IDLE:
			#print("idle")
			idle = true
			running = false
			walking = false
			interaction = false
		WALKING:
			#print("walking")
			idle = false
			walking = true
			running = false
			interaction = false
		RUN:
			#print("running")
			idle = false 
			walking = false
			running = true
			interaction = false
		INTERACT:
			idle = false
			walking = false
			running = false
			interaction = true
			
			


#@onready var skeleton_3d: Skeleton3D = $PhysicsPlayer/RootNode/CharacterArmature/Skeleton3D
#@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $PhysicsPlayer/RootNode/CharacterArmature/Skeleton3D/PhysicalBoneSimulator3D
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animationtree.active = true
	#update_tree.rpc()
	#ui.hide_countdown()
	#ui.hide_timer()

@rpc("any_peer", "call_local")
func lock_movement():
	can_move = false
	
@rpc("any_peer", "call_local")
func unlock_movement():
	can_move = true

@rpc("any_peer", "call_local")
func hide_timer():
	ui.hide_timer()
	
@rpc("any_peer", "call_local")
func show_timer():
	ui.show_timer()
	
@rpc("any_peer", "call_local")
func hide_countdown():
	ui.hide_countdown()
	
@rpc("any_peer", "call_remote")
func show_countdown():
	ui.show_countdown()

func post_setup():
	if is_multiplayer_authority():
		var camera_3d = Camera3D.new()
		spring_arm_3d.add_child(camera_3d)	
		#camera_3d.rotation = spring_arm_3d.rotation
		#camera_3d.position += Vector3(0, 0, spring_arm_3d.spring_length)
		camera_3d.make_current()
		GameController.set_player(self)
		
	
@rpc("any_peer", "call_local", "reliable")
func update_label_timer(time: int):
	ui.update_label_timer(time)

@rpc("any_peer", "call_local", "reliable")
func update_label_countdown(time: int):
	ui.update_label_countdown(time)

func _physics_process(delta: float) -> void:				
	if is_multiplayer_authority() and can_move:
		handle_animations(delta)
		
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := (-1 if Input.is_action_pressed("move_forward") else 0) + (1 if Input.is_action_pressed("move_backward") else 0)
		var run_bool := Input.is_action_pressed("run")
		interacting = Input.is_action_just_pressed("test") or interacting
		var direction := (transform.basis * Vector3(0, 0, input_dir)).normalized()
		
		if interacting:
			current_anim = INTERACT
			velocity.x = 0
			velocity.z = 0
		
		elif direction:
			print(run_bool)
			current_anim = RUN if run_bool else WALKING
			velocity.x = direction.x * SPEED * delta * (2 if current_anim == RUN else 1)
			velocity.z = direction.z * SPEED * delta * (2 if current_anim == RUN else 1)
		else:
			current_anim = IDLE
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
			velocity.z = move_toward(velocity.z, 0, SPEED * delta)
			
		send_position.rpc(global_position, velocity)
		
		
		send_run_value.rpc(idle,running,walking,interaction, input_dir)
	
	
		spring_arm_3d.rotation.x = pitch * delta
		spring_arm_3d.rotation.x = clampf(spring_arm_3d.rotation.x, deg_to_rad(-90), deg_to_rad(15))
		rotation.y = yaw * delta
		
		send_rotation.rpc(transform.basis.get_rotation_quaternion())
		
	move_and_slide()

func setup(player_data: Statics.PlayerData) -> void:
	self.player_data = player_data
	name = str(player_data.id)
	set_multiplayer_authority(player_data.id)
	label_3d.text = player_data.name
	post_setup()

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event is InputEventMouseMotion:
			yaw -= event.relative.x * YAW_SENSITIVITY
			pitch -= event.relative.y *	PITCH_SENSITIVITY
			#spring_arm_3d.rotation.x -= event.relative.y / MOUSE_SENSITIVITY
			#spring_arm_3d.rotation.x = clamp(spring_arm_3d.rotation.x, deg_to_rad(45), deg_to_rad(90))
			
		if event.is_action_pressed("ui_accept"):
			Debug.add_message("Jump", 1)	
		
@rpc("authority", "call_local")
func jump() -> void:
	print("hola")

@rpc("any_peer", "call_remote", "reliable")
func send_position(pos, vel):
	global_position = lerp(global_position, pos, 0.5)
	velocity = lerp(velocity, vel, 0.5)


@rpc("any_peer", "call_remote", "reliable")
func send_rotation(rot: Quaternion):
	rotation = rot.slerp(transform.basis.get_rotation_quaternion(), 0.5).get_euler()
	
@rpc("any_peer","call_local", "reliable")
func send_run_value(idle, running, walking, interaction, direction):
	animationtree["parameters/StateMachine/conditions/idle"] = idle
	animationtree["parameters/StateMachine/conditions/running"] = running
	animationtree["parameters/StateMachine/conditions/walk"] = walking 
	animationtree["parameters/StateMachine/conditions/interaction"] = interaction
	animationtree["parameters/StateMachine/running/blend_position"] = direction
	
func _on_interaction_finished() -> void:
	if current_anim == INTERACT:
		interacting = false
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "CharacterArmature|Interact":
		print("a")
		interacting = false
		current_anim = IDLE

		
		
