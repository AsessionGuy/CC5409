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
	if len(player.get_node("CartAnchor").get_children()):
		finished.emit("WithCartState")
	
