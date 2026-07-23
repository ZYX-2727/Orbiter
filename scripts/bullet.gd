extends Area2D

const identifier = "bullet"
const SPEED = 400
var paused

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.connect("start", _on_start)
	EventBus.connect("pause", _on_pause)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not paused:
		position += Vector2.RIGHT.rotated(rotation) * delta * SPEED


func _on_area_entered(area: Area2D) -> void:
	EventBus.emit_signal("asteroid_destroyed")
	area.destroyed = true
	queue_free()

func _on_start(_difficulty: int) -> void:
	queue_free()

func _on_pause() -> void:
	paused = not paused
