extends Node2D

var time_passed: float = 0
var between_asteroids = 1.5
var asteroid_pre: PackedScene
var player_pre: PackedScene
var playing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	asteroid_pre = preload("res://scenes/asteroid.tscn")
	player_pre = preload("res://scenes/player.tscn")
	EventBus.connect("death", _on_death)
	EventBus.connect("start", _on_start)
	$Menu.z_index = 1000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	if time_passed > between_asteroids:
		time_passed -= between_asteroids
		var new_asteroid = asteroid_pre.instantiate()
		new_asteroid.position = Vector2(1200, randi_range(50, 600))
		add_child(new_asteroid)


func _on_death() -> void:
	playing = false
	$Menu.show()


func _on_start(_difficulty: int) -> void:
	playing = true
	var new_player = player_pre.instantiate()
	new_player.position = Vector2(231, 325) 
	add_child(new_player)
