class_name InteractingWithoutCartState extends WithoutCartState

@onready var timer: Timer = $Timer

func _ready() -> void:
	super()
	timer.wait_time = 1.3
	timer.one_shot = true

func enter(previous_state_path: String, data := {}) -> void:
	animation_tree.travel("interacting")
	timer.start()

func physics_update(_delta: float) -> void:
	if timer.time_left == 0:
		player.is_interacting = false
		super(_delta)
