class_name Player extends CharacterBody3D
	
const SPEED = 800.0
const JUMP_VELOCITY = 100.0
const ACCELERATION = 2.0

@export var YAW_SENSITIVITY = 0.5
@export var PITCH_SENSITIVITY = 0.1

@onready var yaw = 0
@onready var pitch = 0
@onready var skeleton_3d: Skeleton3D = $PhysicsPlayer/RootNode/CharacterArmature/Skeleton3D
@onready var label_3d: Label3D = $Label3D
@onready var spring_arm_3d: SpringArm3D = %SpringArm3D

var player_data

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	pass

func toggle_lock_movement():
	axis_lock_linear_x = not axis_lock_linear_x
	axis_lock_linear_y = not axis_lock_linear_y
	axis_lock_linear_z = not axis_lock_linear_z

func post_setup():
	if is_multiplayer_authority():
		var camera_3d = Camera3D.new()
		spring_arm_3d.add_child(camera_3d)	
		#camera_3d.rotation = spring_arm_3d.rotation
		#camera_3d.position += Vector3(0, 0, spring_arm_3d.spring_length)
		camera_3d.make_current()
		GameController.set_player(self)
	

func _physics_process(delta: float) -> void:				
	if is_multiplayer_authority():
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED * delta
			velocity.z = direction.z * SPEED * delta
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
			velocity.z = move_toward(velocity.z, 0, SPEED * delta)
		send_position.rpc(global_position, velocity)
		
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
