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
	if is_multiplayer_authority():
		send_state.rpc(global_position, global_rotation, target_position)
	
@rpc("authority", "call_remote", "unreliable",4)
func send_state(pos: Vector3, rot: Vector3, target_pos) -> void:
	global_position = pos
	global_rotation = rot
	target_position = target_pos
	
