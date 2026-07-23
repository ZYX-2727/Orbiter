extends Node2D

var difficulty: int = 0

func _on_play_pressed() -> void:
	difficulty = $Panel/Difficulty.selected
	EventBus.emit_signal("start", difficulty)
	hide()
