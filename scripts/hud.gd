extends CanvasLayer

var paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.connect("pause", _on_pause)


func _on_pause_pressed() -> void:
	EventBus.emit_signal("pause")

func _on_pause() -> void:
	paused = not paused
	$All/Pause.disabled = paused
	if paused:
		$All.modulate.a = 0.5
	else:
		$All.modulate.a = 1
