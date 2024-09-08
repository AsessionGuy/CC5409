extends Node3D

@onready var spawners: Node3D = %Spawners
@onready var spawners_array = Array()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func get_free_spawner() -> Spawner:
	return spawners.get_children().filter(func(x: Spawner): return x.is_free()).pick_random()	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
