class_name item extends MultiplayerRigidBody3D

@onready var mesh: MeshInstance3D = $mesh
@onready var outline: MeshInstance3D = $mesh/outline

func _ready() -> void:
	outline.visible = false
	
func set_outline(active: bool):
	outline.visible = active
