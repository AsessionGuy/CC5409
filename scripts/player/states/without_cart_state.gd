class_name WithoutCartState extends PlayerState

func _ready() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func enter(previous_state_path: String, data := {}) -> void:
	if is_multiplayer_authority():
		player._controller = %PlayerController
	else:
		player._controller = %NullPlayerController
	
func physics_update(_delta: float) -> void:
	var speed = player.get_real_velocity().length()
	
	if player.has_cart:
		finished.emit("WithCartState", {"cart_index": player._controller.cart.index})
	
	elif player.is_interacting:
		finished.emit("InteractingWithoutCartState")
	
	elif speed > 12:
		finished.emit("RunningWithoutCartState")
	
	elif not is_zero_approx(speed):
		finished.emit("WalkingWithoutCartState")
		
	elif is_zero_approx(speed):
		finished.emit("IdleWithoutCartState")
	
