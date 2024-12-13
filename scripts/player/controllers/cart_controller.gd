class_name CartController extends PlayerController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	move_speed = 20
	tilt_upper_limit = PI / 6.0
	tilt_lower_limit = -PI / 3.0
	acceleration = 50.0
	mouse_sensitivity = 0.25

func input(event: InputEvent) -> void:
	if event.is_action_pressed("run"):
		move_speed = 30
	elif event.is_action_released("run"):
		move_speed = 20
	if event.is_action_pressed("interact"):
		player._controller.unset_cart.rpc()

@rpc("any_peer","call_local","reliable")
func reset_interactable() -> void:
	interactable = null
	
