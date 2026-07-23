extends Area2D

var SPEED = 350

func _ready() -> void:
	EventBus.connect("start", _on_start)


func _physics_process(delta: float) -> void:
	position.x -= SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body.identifier == "player":
		EventBus.emit_signal("bullets_collected")
		queue_free()

func _on_start(_difficulty: int) -> void:
	queue_free()
