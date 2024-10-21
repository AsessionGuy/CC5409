class_name GameUI extends Control

const ITEM_COLOR_RECT = preload("res://scenes/ui/item_color_rect.tscn")

@onready var tab_bar: HBoxContainer = %TabBar
@onready var label_timer: Label = %LabelTimer
@onready var label_countdown: Label = %LabelCountdown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_countdown.hide()
	label_timer.hide()

func hide_timer():
	label_timer.hide()

func show_timer():
	label_timer.show()

func hide_countdown():
	label_countdown.hide()
	
func show_countdown():
	label_countdown.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
@rpc("authority", "call_local", "reliable")
func update_label_timer(time: int):
	label_timer.text = seconds_to_mm_ss(time)

@rpc("authority", "call_local", "reliable")
func update_label_countdown(time: int):
	label_countdown.text = seconds_to_mm_ss(time)

# gets the time in seconds and formats it as MM:SS
func seconds_to_mm_ss(seconds: int) -> String:
	var minutes = seconds / 60
	var remaining_seconds = seconds % 60
	return str(minutes).pad_zeros(2) + ":" + str(remaining_seconds).pad_zeros(2)

func add_item(item):
	var item_tab_scene = ITEM_COLOR_RECT.instantiate()
	item_tab_scene.color = item
	tab_bar.add_child(item_tab_scene)

func remove_item(item):
	for tab in tab_bar.get_children():
		var rect: ColorRect = tab
		if rect.color == item:
			tab_bar.remove_child(tab)
			break
