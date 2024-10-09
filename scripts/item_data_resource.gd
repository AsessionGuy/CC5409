extends Resource
class_name ItemResource


@export var id: Statics.ItemType
@export var mesh_id: Statics.MeshType
@export var item_name: String
@export_multiline var description: String

@export var mesh: Mesh
@export var collision_shape: Shape3D



func get_item_mesh() -> Mesh:
	return mesh

func get_collision_shape() -> Shape3D:
	return collision_shape
