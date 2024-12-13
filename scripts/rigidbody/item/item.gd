class_name Item extends MultiplayerRigidBody3D

signal collided

@onready var mesh: MeshInstance3D = $mesh
@onready var outline: MeshInstance3D = $mesh/outline
@onready var collision_sound: AudioStreamPlayer3D = AudioStreamPlayer3D.new()

var player: Player
var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.wait_time = 1
	timer.one_shot = true
	outline.visible = false
	
	add_child(collision_sound)
	collision_sound.stream = preload("res://assets/sfx/item_colission.mp3")
	connect("collided", Callable(self, "_on_collided"))
	connect("body_entered", Callable(self, "_on_collided"))
	
func set_outline(active: bool):
	outline.visible = active

@rpc("any_peer", "call_local", "reliable")
func set_player(index: int):
	if player:
		player._controller.interactable = null
	player = GameController.get_player_from_index(index)
	player._controller.interactable = self
	global_position = player._socket.global_position
	global_rotation = player._socket.global_rotation
	self.reparent(player._socket)
	timer.start()
	if is_multiplayer_authority():
		freeze = true

@rpc("any_peer", "call_local", "reliable")
func unset_player(index: int):
	player = GameController.get_player_from_index(index)
	Debug.log("player " + str(index) + " drops item " + name, 1)
	self.reparent(GameController.level)
	linear_velocity = 10 * (player._ray_cast_3d.target_position - global_position).normalized()
	player._controller.interactable = null
	player = null
	if is_multiplayer_authority():
		freeze = false

@rpc("any_peer", "call_local", "reliable")
func set_cart(index:int):
	if timer.time_left == 0:
		if player:
			Debug.log("player " + str(index) + " drops item " + name, 1)
			player._controller.interactable = null
			player = null
			if is_multiplayer_authority():
				freeze = false
		var cart: Cart = GameController.get_cart_from_index(index)
		self.reparent(cart._items)
		global_position = cart._items.global_position

func _physics_process(delta: float) -> void:
	super(delta)
	
	
func _integrate_forces(state) -> void:
	for i in range(state.get_contact_count()):
		var contact = state.get_contact_collider_object(i)
		if contact:
			emit_signal("collided")
			
			
func _on_body_entered(body: Node) -> void:
	emit_signal("collided")
func _on_collided() -> void:
	if not collision_sound.playing:
		print("Collided")
		collision_sound.play()
