extends Node2D

var paused: bool = false

func _ready() -> void:
	hide()
	EventBus.connect("pause", _on_pause)


func _on_pause() -> void:
	paused = not paused
	print($Panel/Resume.disabled)
	if paused:
		show()
		z_index = 500
	else:
		hide()


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	EventBus.emit_signal("pause") #Unpause
	EventBus.emit_signal("death")


func _on_resume_pressed() -> void:
	EventBus.emit_signal("pause") #Unpause
