extends Area2D

const SPEED = 350
var SCALE
var ROTATION

func _ready() -> void:
	#SPEED = 200
	SCALE = randf_range(0.3, 0.8)
	scale = Vector2(SCALE, SCALE)
	ROTATION = randf_range(-3, 3)
	EventBus.connect("start", _on_start)

func _physics_process(delta: float) -> void:
	rotation_degrees += ROTATION
	
	position.x -= SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	EventBus.emit_signal("death")

func _on_start(_difficulty: int) -> void:
	queue_free()
