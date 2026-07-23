extends CharacterBody2D

const ACCELERATION = 2000 #px/s2
const identifier = "player"
var paused: bool = false
var sfx_vol: float = 100

func get_sfx() -> void:
	var data = ConfigFile.new()
	var error = data.load("user://data.cfg")
	if error:
		print(error)
	sfx_vol = data.get_value("settings", "sfx_vol", 100)
	$AudioStreamPlayer.volume_linear = sfx_vol/100

func _ready() -> void:
	get_sfx()
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
			if not $AudioStreamPlayer.playing:
				$AudioStreamPlayer.play()
		else:
			$AudioStreamPlayer.stop()
	
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
	$AudioStreamPlayer.stop()
	paused = not paused
	get_sfx()
	
