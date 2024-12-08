extends RayCast3D

var collider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var new_collider = get_collider()
	if new_collider != collider:
		if new_collider:
			new_collider.set_outline(true)
		else:
			collider.set_outline(false)
	collider = new_collider
	
	
