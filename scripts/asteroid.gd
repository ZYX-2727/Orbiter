extends CharacterBody2D

var SPEED
var SCALE
var ROTATION

func _ready() -> void:
	SPEED = randi_range(100, 1000) # In px/sec
	SCALE = randf_range(0.3, 1.5)
	scale = Vector2(SCALE, SCALE)
	ROTATION = randf_range(-10, 10)

func _physics_process(delta: float) -> void:
	rotation_degrees += ROTATION
	velocity.x = -SPEED
	
	move_and_slide()
