extends CharacterBody2D

const ACCELERATION = 2000 #px/s2
const identifier = "player"
var paused: bool = false

func _ready() -> void:
	EventBus.connect("death", _on_death)
	EventBus.connect("pause", _on_pause)

func _physics_process(delta: float) -> void:
	if not paused:
		var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
	
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle going up
		if Input.is_action_pressed("up"):
			velocity.y -= ACCELERATION * delta
	
		#Handle glitch if play is clicked too fast
		if position.x != 231:
			EventBus.emit_signal("death")
	
		#Handle too low or too high
		if position.y < 0 or position.y > 650:
			EventBus.emit_signal("death")
	
		#if not is_on_floor() and not is_on_ceiling():
		rotation_degrees = (velocity.y / 20) + 90

		move_and_slide()


func _on_death() -> void:
	queue_free()

func _on_pause() -> void:
	paused = not paused
