extends Node

func _ready():
	yield(get_tree(), "idle_frame")
	if Global.data["game"]["save_point"] == "starting_point":
		Global.data["game"]["save_point"] = "roomfred"
		Global.save_data()
		
