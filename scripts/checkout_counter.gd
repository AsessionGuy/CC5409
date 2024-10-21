extends StaticBody3D

@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var area_3d: Area3D = $Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_3d.body_entered.connect(check_item_collision)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_item_collision(body):
	if body.last_player_owner:
		var player: Player = body.last_player_owner
		var color: Color = body.get_color()
		var items = player.my_items
		if body.get_color() in player.my_items:
			player.remove_item(body)
