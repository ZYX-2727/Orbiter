extends Node2D

var paused: bool
var default_difficulty
var music_vol
var sfx_vol


func save_data(section: String, key: String, value) -> void:
	var data = ConfigFile.new()
	var error = data.load("user://data.cfg")
	if error:
		print(error)
	data.set_value(section, key, value)
	data.save("user://data.cfg")


func change_via_settings() -> void: #Change the game based on what settings you have
	var data = ConfigFile.new()
	var error = data.load("user://data.cfg")
	if error:
		print(error)
	
	music_vol = data.get_value("settings", "music_vol", 100)
	sfx_vol = data.get_value("settings", "sfx_vol", 100)
	default_difficulty = data.get_value("settings", "default_difficulty", 1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.connect("settings", _on_settings)
	change_via_settings()
	
	$Panel/DefDiff.selected = default_difficulty
	$Panel/MusicVol.value = music_vol
	$Panel/SFXVol.value = sfx_vol


func _on_settings(paused_arg: bool):
	paused = paused_arg
	if not visible:
		z_index = 500
		show()
	else:
		hide()


func _on_music_vol_value_changed(value: float) -> void:
	$Panel/MusicVol/Percentage.text = str(int(value)) + "%"
	music_vol = value


func _on_sfx_vol_value_changed(value: float) -> void:
	$Panel/SFXVol/Percentage.text = str(int(value)) + "%"
	sfx_vol = value


func _on_difficulty_selected(index: int) -> void:
	default_difficulty = index


func _on_save_pressed() -> void:
	save_data("settings", "default_difficulty", default_difficulty)
	save_data("settings", "music_vol", music_vol)
	save_data("settings", "sfx_vol", sfx_vol)
	EventBus.emit_signal("settings", paused)
