extends Node

const SAVE_DIR = "user://MagicaeManus/"
const default_data = {
	"settings" : {
		"highscore" : 0,
		"volume" : 1,
		"music" : "Magic"
	},
	
	"game" : {
		"world":1,
		"level":1
	}
	
	}

var data = { }
var save_path = SAVE_DIR + "save.save"

var recently_clicked_card = null

var scene_to_change_to: String = "res://"

var battle_music_stream = load("res://The Game of Time.mp3")
var battle_scene_to_change_to = load("res://Developer_Mode/Error.tscn")

onready var menu_music = $MenuMusic

func _ready():
	load_data()

func _process(_delta):
	#if recently_clicked_card != null:
		#recently_clicked_card.image.modulate = Color("#f7ff00")
	pass

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

func load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, "marga")
		if error == OK:
			var player_data = file.get_var()
			file.close()
			print(player_data)
			data = player_data

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
