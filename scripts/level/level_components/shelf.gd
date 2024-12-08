class_name Shelf extends StaticBody3D

var SIDE = 0
var MAX_ROWS
var MAX_COLS

@onready var item_spawnpoints = $ItemSpawnpoints

func _ready():
	MAX_ROWS = item_spawnpoints.get_child_count()/2
	MAX_COLS = item_spawnpoints.get_child(0).get_child_count()

func is_full() -> bool:
	return SIDE == 2

func spawn_item(item: String) -> void:
	for i in range(MAX_ROWS):
		for j in range(MAX_COLS):
			var spawnpoint: Node3D = item_spawnpoints.get_child(4*SIDE + i).get_child(j)
			GameController.spawn_item.rpc(item, spawnpoint.global_position)
	SIDE += 1        
	
