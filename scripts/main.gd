extends Node2D

var EARTH_COEFFICENT = 0.2 #360/(90 * 60)
#360/(time secs) = earth coefficent, so 90 mins would be ^

var between_asteroids: float = 1.5
var asteroid_pre: PackedScene
var player_pre: PackedScene
var bullet_pre: PackedScene
var bull_collect_pre: PackedScene
var point_collect_pre: PackedScene
var playing: bool = false
var first_time: bool
var difficulty_mult: float

var music_vol
var sfx_vol
var default_difficulty

var score: int = 0
var high_score: int
#const SCORE_MULT: float = 1000
var asteroids_destroyed: int = 0
var distance: float #In km
const SPEED: float = 7.66 #km/s
var bullets = 3
var points_collected = 0
var paused: bool = false

var bullet_objs: Array

func save_data(section: String, key: String, value) -> void:
	var data = ConfigFile.new()
	var error = data.load("user://data.cfg")
	if error:
		print(error)
	
	data.set_value(section, key, value)
	data.save("user://data.cfg")

func adjust_bullet_hud() -> void:
	var i = 0
	
	for bullet_obj in bullet_objs:
		i += 1
		if bullets >= i:
			bullet_obj.show()
		else:
			bullet_obj.hide()


func change_via_settings(_paused: bool) -> void: #Change the game based on what settings you have
	var data = ConfigFile.new()
	var error = data.load("user://data.cfg")
	if error:
		print(error)
	
	music_vol = data.get_value("settings", "music_vol", 100)
	sfx_vol = data.get_value("settings", "sfx_vol", 100)
	default_difficulty = data.get_value("settings", "default_difficulty", 1)
	high_score = data.get_value("player", "high_score", 0)
	
	$Menu/Panel/Difficulty.selected = default_difficulty
	$Menu/Panel/High.text = "High Score: " + str(high_score)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_via_settings(false)
	
	bullet_objs = [
	$HUD/All/Bullet1,
	$HUD/All/Bullet2,
	$HUD/All/Bullet3,
	$HUD/All/Bullet4,
	$HUD/All/Bullet5
	]
	
	bull_collect_pre = preload("res://scenes/bullet_collectable.tscn")
	point_collect_pre = preload("res://scenes/point_collectable.tscn")
	asteroid_pre = preload("res://scenes/asteroid.tscn")
	player_pre = preload("res://scenes/player.tscn")
	bullet_pre = preload("res://scenes/bullet.tscn")
	EventBus.connect("death", _on_death)
	EventBus.connect("pause", _on_pause)
	EventBus.connect("start", _on_start)
	EventBus.connect("settings", change_via_settings)
	EventBus.connect("bullets_collected", _on_bullets_collected)
	EventBus.connect("points_collected", _on_points_collected)
	EventBus.connect("asteroid_destroyed", _on_asteroid_destroyed)
	$Menu.z_index = 1000
	$HUD.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not paused:
		if Input.is_action_just_pressed("pause") and playing:
			EventBus.emit_signal("pause")
		$Earth.rotation_degrees -= EARTH_COEFFICENT * delta
	
		if playing:
			distance += delta * SPEED
			$HUD/All/Distance.text = str(int(round(distance))) + " km"
		
			score = round(distance * difficulty_mult) + asteroids_destroyed * 10 + points_collected
			$HUD/All/Score.text = str(score)
		
			if Input.is_action_just_pressed("shoot") and playing and $Player and bullets > 0:
				var new_bullet = bullet_pre.instantiate()
				new_bullet.position = $Player.position + 100 * Vector2.RIGHT#.rotated(deg_to_rad($Player.rotation_degrees))
				new_bullet.rotation_degrees = $Player.rotation_degrees - 90
				add_child(new_bullet)
			
				bullets -= 1
				adjust_bullet_hud()


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
	bullets = 3
	points_collected = 0


func _on_start(difficulty: int) -> void:
	if difficulty == 0:
		between_asteroids = 2
		difficulty_mult = 1
	elif difficulty == 1:
		between_asteroids = 1.5
		difficulty_mult = 1.25
	elif difficulty == 2:
		between_asteroids = 1
		difficulty_mult = 1.5
	$AsteroidTimer.wait_time = between_asteroids
	$AsteroidTimer.start() #Restart
	$CollectableTimer.stop()
	
	playing = true
	$HUD.show()
	adjust_bullet_hud()
	var new_player = player_pre.instantiate()
	new_player.position = Vector2(231, 325) 
	add_child(new_player)


func _on_asteroid_destroyed() -> void:
	asteroids_destroyed += 1


func _on_asteroid_timer_timeout() -> void:
	var new_asteroid = asteroid_pre.instantiate()
	new_asteroid.position = Vector2(1200, randi_range(0, 650))
	add_child(new_asteroid)
	
	if 1 == randi_range(1, 5):
		$CollectableTimer.wait_time = between_asteroids/2
		$CollectableTimer.start()


func _on_collect_timer_timeout() -> void:
	if 1 == randi_range(1, 2):
		var new_bull_collect = bull_collect_pre.instantiate()
		new_bull_collect.position = Vector2(1200, randi_range(0, 650))
		add_child(new_bull_collect)
	else:
		var new_point_collect = point_collect_pre.instantiate()
		new_point_collect.position = Vector2(1200, randi_range(0, 650))
		add_child(new_point_collect)


func _on_pause() -> void:
	paused = not paused
	$AsteroidTimer.paused = paused
	$CollectableTimer.paused = paused


func _on_bullets_collected() -> void:
	bullets = clamp(bullets + 3, 0, 5)
	adjust_bullet_hud()

func _on_points_collected(points: int) -> void:
	points_collected += points
