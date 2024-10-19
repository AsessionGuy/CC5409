class_name metal_shelf extends StaticBody3D

@onready var item_spawnpoints: Node3D = $itemSpawnpoints

var current_row = -1
var N_ROWS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	N_ROWS = item_spawnpoints.get_child(0).get_child_count()
	pass # Replace with function body.

func get_items_spawnpoints():
	var spawnpoints = []
	var rows = item_spawnpoints.get_children()
	for row in rows:
		spawnpoints.append(row.get_children())
	
	return spawnpoints

func get_n_rows():
	return N_ROWS

func get_current_row():
	current_row += 1
	if current_row >= N_ROWS - 1:
		return false
	return current_row % (N_ROWS / 2)

func get_current_row_nodes():
	return item_spawnpoints.get_child(current_row).get_children()

@warning_ignore("native_method_override")
func get_class() -> String:
	return "metal_shelf"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
