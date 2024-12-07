class_name IdleWithoutCartState extends WithoutCartState

func _ready() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func enter(previous_state_path: String, data := {}) -> void:
	animation_tree.travel("idle")

func physics_update(_delta: float) -> void:	
	super(_delta)
	if not is_zero_approx(Input.get_vector("move_left", "move_right", "move_forward", "move_backward").length()):
		finished.emit("WalkingWithoutCartState")
	
	
