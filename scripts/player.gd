extends CharacterBody2D

const ACCELERATION = 2000 #px/s2

func _physics_process(delta: float) -> void:
	var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle going up
	if Input.is_action_pressed("up"):
		velocity.y -= ACCELERATION * delta

	move_and_slide()
