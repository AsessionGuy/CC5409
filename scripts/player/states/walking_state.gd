class_name WalkingWithoutCartState extends WithoutCartState

# Called when the node enters the scene tree for the first time.
func enter(previous_state_path: String, data := {}) -> void:
	animation_tree.travel("walking")

func physics_update(_delta: float) -> void:
	super(_delta)
	var speed = player.velocity.length()
	
	if is_zero_approx(speed):
		finished.emit("IdleWithoutCartState")
	
