class_name Cart extends VehicleBody3D

@onready var cart: MeshInstance3D = $Cart
@onready var outline: MeshInstance3D = $Cart/Outline
@onready var _items: Node3D = %items
@onready var picked_sound: AudioStreamPlayer3D = %PickedSound
@onready var moving_sound: AudioStreamPlayer3D = %MovingSound

var player: Player
var index
var id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	outline.visible = false
	
func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		send_state.rpc()
	if linear_velocity.length() > 1:
		if not moving_sound.playing:
			moving_sound.play()
		else:
			if moving_sound.playing:
				moving_sound.stop()

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
		if _items.get_child_count() > 0:
			var item: Item = _items.get_children()[0]
			var player: Player = GameController.get_player_from_index(index)
			Debug.log("player " + str(index) + " grabs item " + item.name, 1)
			item.set_player.rpc(index)
			player._controller.interactable = item
		else:
			player = GameController.get_player_from_index(index)
			Debug.log("setting item " + name + "with player " + str(index), 1)
			player._controller.set_cart.rpc()
			picked_sound.play()

@rpc("any_peer", "call_local", "reliable")
func unset_player(index: int):
	player = GameController.get_player_from_index(index)
	player._controller.unset_cart.rpc()
	player._controller.interactable = null
	player = null

func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_multiplayer_authority():
		body.set_cart.rpc(index)
	
