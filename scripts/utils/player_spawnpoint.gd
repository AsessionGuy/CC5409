class_name PlayerSpawner extends Node3D

var is_occupied = false

func _ready():
	set_physics_process(false)

@rpc("any_peer", "call_local", "reliable")
func set_occupied(occupied: bool) -> void:
	is_occupied = occupied
