extends CharacterBody2D

const ACCELERATION = 2000 #px/s2

func _ready() -> void:
	EventBus.connect("death", _on_death)

func _physics_process(delta: float) -> void:
	var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle going up
	if Input.is_action_pressed("up"):
		velocity.y -= ACCELERATION * delta
	
	#if not is_on_floor() and not is_on_ceiling():
	rotation_degrees = (velocity.y / 20) + 90

	move_and_slide()


func _on_death() -> void:
	queue_free()
