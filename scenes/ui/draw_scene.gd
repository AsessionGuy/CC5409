extends Control

@onready var button: Button = $MarginContainer/VBoxContainer/Button
@onready var label: Label = $MarginContainer/VBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	button.pressed.connect(_on_button_pressed)
	
func _on_button_pressed():
	multiplayer.peer_disconnected.emit(get_multiplayer_authority())
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	queue_free()

@rpc("any_peer", "call_local")
func set_winner(player_name):
	label.text = player_name + " WINS!"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
