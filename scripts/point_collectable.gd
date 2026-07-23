extends Area2D

const SPEED = 350
var points: int
var paused: bool = false

func _ready() -> void:
	points = randi_range(1, 10) * 10
	$PointsValue.text = str(points)
	EventBus.connect("start", _on_start)
	EventBus.connect("pause", _on_paused)


func _physics_process(delta: float) -> void:
	if not paused:
		position.x -= SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body.identifier == "player":
		EventBus.emit_signal("points_collected", points)
		queue_free()

func _on_start(_difficulty: int) -> void:
	queue_free()

func _on_paused() -> void:
	paused = not paused
