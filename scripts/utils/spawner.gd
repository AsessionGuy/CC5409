class_name Spawner extends Node3D

@export var free: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_player(player: Node3D) -> void:
	player.global_position = self.global_position
	self.free = false

func is_free() -> bool:
	return free
