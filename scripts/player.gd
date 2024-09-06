extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

#@onready var skeleton_3d: Skeleton3D = $PhysicsPlayer/RootNode/CharacterArmature/Skeleton3D
#@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $PhysicsPlayer/RootNode/CharacterArmature/Skeleton3D/PhysicalBoneSimulator3D
func _ready():
	pass
	#physical_bone_simulator_3d.physical_bones_start_simulation()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		print(get_gravity())
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		print(1)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		print(2)
		#position.x = move_toward(velocity.x, 0, SPEED)
		#position.z = move_toward(velocity.z, 0, SPEED)

		#position = position.move_toward(velocity, delta)
		

	move_and_slide()
