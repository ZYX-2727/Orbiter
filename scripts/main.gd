extends Node2D

var time_passed: float = 0
var between_asteroids = 1.5
var asteroid_pre: PackedScene
var player_pre: PackedScene
var playing: bool = false
var first_time: bool

var score: int = 0
var high_score: int
#const SCORE_MULT: float = 1000
var asteroids_destroyed: int = 0
var distance: float #In km
const SPEED: float = 7.66 #km/s

func save_data(section: String, key: String, value) -> void:
	var data = ConfigFile.new()
	data.set_value(section, key, value)
	data.save("user://data.cfg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var data = ConfigFile.new()
	var error = data.load("user://data.cfg")
	
	if error != OK:
		#First time playing
		first_time = true
	
	print(first_time)
	
	high_score = data.get_value("player", "high_score", 0)
	$Menu/Panel/High.text = "High Score: " + str(high_score)
	
	asteroid_pre = preload("res://scenes/asteroid.tscn")
	player_pre = preload("res://scenes/player.tscn")
	EventBus.connect("death", _on_death)
	EventBus.connect("start", _on_start)
	$Menu.z_index = 1000
	$HUD.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	if time_passed > between_asteroids:
		time_passed -= between_asteroids
		var new_asteroid = asteroid_pre.instantiate()
		new_asteroid.position = Vector2(1200, randi_range(50, 600))
		add_child(new_asteroid)
	if playing:
		distance += delta * SPEED
		$HUD/Screen/Distance.text = str(int(round(distance))) + " km"
		
		score = distance + asteroids_destroyed * 10
		$HUD/Screen/Score.text = str(score)


func _on_death() -> void:
	playing = false
	
	#Display
	$HUD.hide()
	$Menu.show()
	$Menu/Panel/Score.text = "Score: " + str(score)
	$Menu/Panel/High.text = "High Score: " + str(high_score)
	
	if score > high_score:
		high_score = score
		save_data("player", "high_score", high_score)
		$Menu/Panel/High.text = "New High!"
		$Menu/Panel/High.add_theme_color_override("font_color", Color(255, 255, 0))
	else:
		$Menu/Panel/High.add_theme_color_override("font_color", Color(255, 255, 255))
	
	#Cleanup vars
	score = 0
	distance = 0
	asteroids_destroyed = 0


func _on_start(_difficulty: int) -> void:
	playing = true
	$HUD.show()
	var new_player = player_pre.instantiate()
	new_player.position = Vector2(231, 325) 
	add_child(new_player)
