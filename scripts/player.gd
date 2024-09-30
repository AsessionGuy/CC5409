extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var animationtree = $AnimatedPlayer/AnimationTree

enum {IDLE, RUN}
var current_anim = IDLE
var rot_value = 0

@export var blend_speed = 15

var run_val = 0

func handle_animations(delta):
	match current_anim:
		IDLE:
			#print("idle")
			run_val = lerpf(run_val, 0, blend_speed*delta)
		RUN:
			print("running")
			run_val = lerpf(run_val, 1, blend_speed*delta)
	
		
func update_tree():
	animationtree["parameters/running/blend_amount"] = run_val

#@onready var skeleton_3d: Skeleton3D = $PhysicsPlayer/RootNode/CharacterArmature/Skeleton3D
#@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $PhysicsPlayer/RootNode/CharacterArmature/Skeleton3D/PhysicalBoneSimulator3D
func _ready():
	update_tree()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#physical_bone_simulator_3d.physical_bones_start_simulation()

func _physics_process(delta: float) -> void:
	handle_animations(delta)
	update_tree()
	# Add the gravity.
	#if not is_on_floor():
	#	print(get_gravity())
	#	velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("right", "left", "backwards", "forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()


	if direction != Vector3(0,0,0):
		print(1)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		current_anim = RUN
		
	else:
	
		velocity = Vector3(0,0,0)
		
		current_anim = IDLE
		
		#position.x = move_toward(velocity.x, 0, SPEED)
		#position.z = move_toward(velocity.z, 0, SPEED)

		#position = position.move_toward(velocity, delta)
	move_and_slide()
	
	rotate_y(rot_value)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x*0.0025)
