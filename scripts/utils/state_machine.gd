class_name StateMachine extends Node

@export var initial_state: State = null

@onready var player: Player
@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()

func _ready() -> void:
	# Give every state a reference to the state machine.
	await owner.ready
	player = owner
	
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state.rpc)
		state_node.player = player
		
	if not is_multiplayer_authority():
		set_physics_process(false)
	state = %WithoutCartState
	state.enter("")

@rpc("authority", "call_local", "reliable", 5)
func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return
	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)

@rpc("authority", "call_local", "unreliable", 5)
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

@rpc("authority", "call_local", "unreliable", 5)
func _process(delta: float) -> void:
	state.update(delta)
	
@rpc("authority", "call_remote", "unreliable", 5)
func _send_state(st: String):
	state = get_node(st)
	
func _physics_process(delta: float) -> void:
	_send_state.rpc(state.name)
	state.physics_update(delta)
