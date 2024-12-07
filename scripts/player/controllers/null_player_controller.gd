class_name NullPlayerController extends PlayerController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func unhandled_input(event: InputEvent) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(_delta: float) -> void:
	pass
