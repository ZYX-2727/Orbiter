extends Area2D

const identifier = "bullet"
const SPEED = 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * delta * SPEED


func _on_area_entered(area: Area2D) -> void:
	EventBus.emit_signal("asteroid_destroyed")
	area.destroyed = true
	queue_free()
