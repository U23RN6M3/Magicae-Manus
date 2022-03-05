extends Node

signal fade_started
signal fade_ended

const SAVE_DIR = "user://MagicaeManus/"
const default_data = {
	"settings" : {
		"highscore" : 0,
		"volume" : 1,
		"music" : "Magic"
	},
	
	"game" : {
		"fort":"bjrans",
		"save_point":"starting_point",
		"health":100,
	}
	
	}

var data = { }
var save_path = SAVE_DIR + "save.save"

var recently_clicked_card = null

var scene_to_change_to: String = "res://"

var player_position = null
var battle_music_stream = load("res://The Game of Time.mp3")
var battle_scene_to_change_to = "res://Developer_Mode/Error.tscn"
onready var battle_dialog = DialogSource.test

onready var fade = $CanvasLayer/Fade
onready var fade_tween = $FadeTween
onready var menu_music = $MenuMusic

func _ready():
	load_data()

func ready_battle():
	$ReadyBattle.play()

func save_data():
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "marga")
	if error == OK:
		file.store_var(data)
		file.close()
	
	print("data_saved")

func fade_start(duration: float = 0.5):
	fade_tween.interpolate_property(fade, "color", Color("#00000000"), Color("#000000"), duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	fade_tween.start()
	emit_signal("fade_started")
	yield(get_tree().create_timer(duration), "timeout")
	fade_tween.interpolate_property(fade, "color", Color("#000000"), Color("#00000000"), duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	fade_tween.start()
	emit_signal("fade_ended")

func load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, "marga")
		if error == OK:
			var player_data = file.get_var()
			file.close()
			print(player_data)
			data = player_data
	else:
		reset_data()
		save_data()
		load_data()

func reset_data():
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "marga")
	if error == OK:
		file.store_var(default_data)
		data = default_data
		file.close()
	
	print("data_reset_and_saved")
