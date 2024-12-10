class_name Item extends MultiplayerRigidBody3D

@onready var mesh: MeshInstance3D = $mesh
@onready var outline: MeshInstance3D = $mesh/outline

var player: Player

func _ready() -> void:
	outline.visible = false
	
func set_outline(active: bool):
	outline.visible = active

@rpc("any_peer", "call_local", "reliable")
func set_player(index: int):
	if player:
		player._controller.interactable = null
	player = GameController.get_player_from_index(index)
	global_position = player._socket.global_position
	# global_rotation = player._socket.global_rotation
	self.reparent(player._socket)
	if is_multiplayer_authority():
		freeze = true

@rpc("any_peer", "call_local", "reliable")
func unset_player(index: int):
	player = GameController.get_player_from_index(index)
	self.reparent(GameController.level)
	player._controller.interactable = null
	player = null
	if is_multiplayer_authority():
		freeze = false

func _physics_process(delta: float) -> void:
	super(delta)
