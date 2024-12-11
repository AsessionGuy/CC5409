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
	global_rotation = player._socket.global_rotation
	self.reparent(player._socket)
	if is_multiplayer_authority():
		freeze = true

@rpc("any_peer", "call_local", "reliable")
func unset_player(index: int):
	player = GameController.get_player_from_index(index)
	self.reparent(GameController.level)
	linear_velocity = 10 * (player._ray_cast_3d.target_position - global_position).normalized()
	player._controller.interactable = null
	player = null
	if is_multiplayer_authority():
		freeze = false

@rpc("any_peer", "call_local", "reliable")
func set_cart(index:int):
	if player:
		player._controller.interactable = null
		player = null
		if is_multiplayer_authority():
			freeze = false
	var cart: Cart = GameController.get_cart_from_index(index)
	self.reparent(cart._items)
	global_position = cart._items.global_position

func _physics_process(delta: float) -> void:
	super(delta)
