extends Node2D

var slides: Array
var slide: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slides = [
		$Slide1,
		$Slide2,
		$Slide3,
		$Slide4,
		$Slide5,
		$Slide6,
		$Slide7,
	]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skip_tutorial"):
		EventBus.emit_signal("tutorial_done")
		queue_free()
	
	if Input.is_action_just_pressed("next_tutorial"):
		slides[slide].queue_free()
		slide += 1
		if slide == 7:
			EventBus.emit_signal("tutorial_done")
			queue_free()
