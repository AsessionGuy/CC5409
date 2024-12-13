extends WithCartState

func enter(previous_state_path: String, data := {}) -> void:
	animation_tree.travel("walking")

func physics_update(_delta: float) -> void:
	super(_delta)
