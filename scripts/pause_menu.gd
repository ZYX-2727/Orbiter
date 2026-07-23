extends Node2D

var paused: bool = false

func _ready() -> void:
	hide()
	EventBus.connect("pause", _on_pause)
	EventBus.connect("settings", _on_settings)


func _on_pause() -> void:
	paused = not paused
	if paused:
		show()
		z_index = 500
	else:
		hide()


func _on_settings(_paused_arg: bool) -> void:
	if not visible and paused:
		show()
	else:
		hide()


func _on_settings_pressed() -> void:
	EventBus.emit_signal("settings", true)


func _on_quit_pressed() -> void:
	EventBus.emit_signal("pause") #Unpause
	EventBus.emit_signal("death")


func _on_resume_pressed() -> void:
	EventBus.emit_signal("pause") #Unpause
