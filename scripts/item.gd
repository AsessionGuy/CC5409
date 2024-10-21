extends CustomRigidBody3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var players_inside = Array()
@onready var light = $OmniLight3D
@onready var taken = false

var player_owner = false


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
	# if we have an owner we follow it's anchor position
	if player_owner:
		var dummy = player_owner.give_object_anchor_pos()

		position = dummy


# function to identify when a player enters an area (body_entered does not work)
func _on_area_3d_area_entered(area: Area3D) -> void:

	if area.has_method("give_player"):
		print("ENTRO ALGUIEN")
		# get the player, add to known players and tell the 
		# player that self is available for interaction
		var player = area.give_player()
		players_inside.append(player)
		player.add_object_for_interaction(self)
		print("Player inside:"  ,players_inside)#place with function body.


# same as above but deletion
func _on_area_3d_area_exited(area: Area3D) -> void:

	if area.has_method("give_player"):
		print("SALIO ALGUIEN")
		var player = area.give_player()
		players_inside.erase(player)
		player.remove_object_for_interaction(self)
		print("Players inside:"  ,players_inside)

# function to activate light to simulate that the player is 
# aiming at the object
func selected():
	light.light_energy = 20

# function to deactivate light, the player is not aiming
# at the object
func unselected():
	light.light_energy = 0
	
# send position with rpc
@rpc("any_peer", "call_remote", "reliable")
func send_position(pos):
	global_position = lerp(global_position, pos, 0.5)

# function for a player to take self
@rpc("any_peer", "call_local", "reliable")
func player_took(player):
	if player in players_inside and not taken:
		set_taken.rpc(true)
		for player1 in players_inside:
			player1.remove_object_for_interaction(self)
		
		player_owner = player

@rpc("any_peer", "call_local", "reliable")
func player_release():
	
	position.x += 1
	position.y += 2
	position.z += 1
	
	set_taken.rpc(false)
		
	player_owner = false

# set taken value and disables collision shapes		
@rpc("any_peer", "call_local", "reliable")
func set_taken(new_value):
	taken = new_value
	$Area3D/CollisionShape3D.disabled = new_value
	$CollisionShape3D.disabled = new_value


	
