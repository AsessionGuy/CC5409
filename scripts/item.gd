extends CustomRigidBody3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var new_material = StandardMaterial3D.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh_instance_3d.material_override = new_material
	pass # Replace with function body.

@rpc("authority", "call_local")
func change_material(color: Color):
	new_material.albedo_color = color
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
