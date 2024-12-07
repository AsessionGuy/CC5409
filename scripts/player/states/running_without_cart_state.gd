class_name RunningWithoutCartState extends WithoutCartState

# Called when the node enters the scene tree for the first time.
func enter(previous_state_path: String, data := {}) -> void:
	animation_tree.travel("running")

func physics_update(_delta: float) -> void:
	super(_delta)
