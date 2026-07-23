extends Node2D

var difficulty: int = 0

func _ready() -> void:
	EventBus.connect("settings", _on_settings)

func _on_play_pressed() -> void:
	difficulty = $Panel/Difficulty.selected
	EventBus.emit_signal("start", difficulty)
	hide()


func _on_settings_pressed() -> void:
	EventBus.emit_signal("settings", false)

func _on_settings(paused: bool) -> void:
	if not paused and not visible:
		show()
	else:
		hide()
