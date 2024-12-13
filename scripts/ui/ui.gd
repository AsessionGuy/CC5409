class_name UserInterface extends Control

@onready var MatchStartTimerLabel: RichTextLabel = $MatchStartTimerContainer/MatchStartTimerLabel
@onready var MatchTimerLabel: Label = $MatchTimerContainer/MatchTimerLabel
@onready var GameEndedMessageLabel: RichTextLabel = $GameEndedMessageContaner/GameEndedMessage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	MatchStartTimerLabel.hide()
	MatchTimerLabel.hide()
	GameEndedMessageLabel.hide()


func hide_start_timer() -> void:
	MatchStartTimerLabel.hide()
	
func show_start_timer() -> void:
	MatchStartTimerLabel.show()
	
func hide_match_timer() -> void:
	MatchTimerLabel.hide()
	
func show_match_timer() -> void:
	MatchTimerLabel.show()

func hide_game_ended_message() -> void:
	GameEndedMessageLabel.hide()
	
func show_game_ended_message() -> void:
	GameEndedMessageLabel.show()

func set_start_timer(remaining_time: String) -> void:
	MatchStartTimerLabel.text = "Game starting in: "+ remaining_time

func set_match_timer(remaining_time: String) -> void:
	MatchTimerLabel.text = "Game ends in: "+ remaining_time
	

func set_game_ended_message(message: String) -> void:
	GameEndedMessageLabel.text = message
	
