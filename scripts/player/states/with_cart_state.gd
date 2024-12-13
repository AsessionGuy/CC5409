class_name WithCartState extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if is_multiplayer_authority():
		player._controller = %CartController
		player._controller.cart = GameController.get_cart_from_index(data["cart_index"])

func physics_update(_delta: float) -> void:
	var speed = player.get_real_velocity().length()
	
	if player.is_interacting:
		player.has_cart = false
		finished.emit("WithoutCartState")
	
	elif speed > 12:
		finished.emit("RunningWithCartState")
	
	elif not is_zero_approx(speed):
		finished.emit("WalkingWithCartState")
		
	elif is_zero_approx(speed):
		finished.emit("IdleWithCartState")
