extends Node3D

@onready var spawners: Node3D = %Spawners
@onready var spawners_array = Array()

@onready var aisles: Node3D = %Aisles

const ITEM = preload("res://scenes/item.tscn")

var N_AISLES
var N_SHELVES

var current_aisle = 1
var current_shelf = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	N_AISLES = aisles.get_child_count()
	N_SHELVES = aisles.get_child(2).get_child_count()
		

func get_free_spawner() -> Spawner:
	return spawners.get_children().filter(func(x: Spawner): return x.is_free()).pick_random()	

func get_item_spawners():
	var spawnpoints = []
	for aisle in aisles.get_children():
		spawnpoints.append(aisle.get_children())
			
	return spawnpoints

@rpc('any_peer', 'call_local', "reliable")
func spawn_item(item):
	var spawnpoints = get_item_spawners()
	if current_shelf == N_SHELVES - 1:
		current_shelf = 0
		current_aisle += 1
	if current_aisle >= N_AISLES:
		return
	var shelf:metal_shelf = spawnpoints[current_aisle][current_shelf]

	while shelf.get_current_row() is not bool:
		for spawn in shelf.get_current_row_nodes():
			var item_inst:CustomRigidBody3D = ITEM.instantiate()
			item_inst.setup(GameController.player)
			item_inst.change_material(item)
			item_inst.global_position = spawn.global_position
			self.add_child(item_inst)
	current_shelf += 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
