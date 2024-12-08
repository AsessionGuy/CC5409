class_name Cart extends VehicleBody3D

@onready var cart: MeshInstance3D = $Cart
@onready var outline: MeshInstance3D = $Cart/Outline

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

@rpc("authority", "call_remote", "unreliable", 4)
func send_state() -> void:
	pass

func set_outline(active: bool):
	outline.visible = active
