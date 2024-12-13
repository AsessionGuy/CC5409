class_name Cart extends VehicleBody3D

@onready var cart: MeshInstance3D = $Cart
@onready var outline: MeshInstance3D = $Cart/Outline
@onready var _items: Node3D = %items
@onready var area_3d: Area3D = $Area3D

var player: Player
var index
var id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	outline.visible = false
	
func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		send_state.rpc()

func setup(player_data: Statics.PlayerData) -> void:
	set_online_player_data(player_data)

func set_online_player_data(player_data: Statics.PlayerData) -> void:
	set_multiplayer_authority(player_data.id)
	index = player_data.index
	id = player_data.id

@rpc("authority", "call_remote", "unreliable", 4)
func send_state() -> void:
	pass

func set_outline(active: bool):
	outline.visible = active

@rpc("any_peer", "call_local", "reliable")
func set_player(index: int):
	if not player:
		player = GameController.get_player_from_index(index)
		player._controller.set_cart.rpc(index)
		self.reparent(player._cart_anchor)
		self.global_position = player._cart_anchor.global_position
		self.global_rotation = player._cart_anchor.global_rotation
		self.axis_lock_angular_y = true
		freeze = true
		area_3d.monitoring = false

@rpc("any_peer", "call_local", "reliable")
func unset_player(index: int):
	player = GameController.get_player_from_index(index)
	player._controller.interactable = null
	player = null
	self.reparent(GameController.level.carts)
	self.axis_lock_angular_y = false
	freeze = false
	area_3d.monitoring = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_multiplayer_authority():
		if body.has_method("set_cart"):
			body.set_cart.rpc(index)
	
