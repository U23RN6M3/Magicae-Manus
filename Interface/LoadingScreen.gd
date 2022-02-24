extends Control

onready var tween = $Tween

var replay = true

func _ready():
	tween.interpolate_property($TextureProgress, "value", 0, 100, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()



func _on_Tween_tween_all_completed():
	if replay == true:
		tween.interpolate_property($TextureProgress, "value", 100, 0, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		$TextureProgress.fill_mode = 5
		replay = false
	else:
		tween.interpolate_property($TextureProgress, "value", 0, 100, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
		$TextureProgress.fill_mode = 4
		replay = true


func _on_Timer_timeout():
	if File.new().file_exists(Global.scene_to_change_to) == true:
# warning-ignore:return_value_discarded
		get_tree().change_scene(Global.scene_to_change_to)
		Global.scene_to_change_to = "res://"
	else:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Developer_Mode/Error.tscn")
