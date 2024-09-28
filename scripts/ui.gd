class_name GameUI extends Node

@onready var label_timer: Label = %LabelTimer
@onready var label_countdown: Label = %LabelCountdown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_countdown.show()
	label_timer.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
@rpc("authority", "call_local")
func update_label_timer(time: int):
	if time != 0:
		label_timer.text = seconds_to_mm_ss(time)
	label_timer.hide()
@rpc("authority", "call_local")
func update_label_countdown(time: int):
	if time != 0:
		label_countdown.text = seconds_to_mm_ss(time)
	label_countdown.hide()
	label_timer.show()

# gets the time in seconds and formats it as MM:SS
func seconds_to_mm_ss(seconds: int) -> String:
	var minutes = seconds / 60
	var remaining_seconds = seconds % 60
	return str(minutes).pad_zeros(2) + ":" + str(remaining_seconds).pad_zeros(2)
