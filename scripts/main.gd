extends Node2D

var time_passed: float = 0
var between_asteroids = 1.5
var asteroid_pre: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	asteroid_pre = preload("res://scenes/asteroid.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	if time_passed > between_asteroids:
		time_passed -= between_asteroids
		var new_asteroid = asteroid_pre.instantiate()
		new_asteroid.position = Vector2(1500, randi_range(50, 600))
		add_child(new_asteroid)
