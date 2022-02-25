extends Node



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Intro":
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Interface/LoadingScreen.tscn")
		Global.scene_to_change_to = "res://UI/MainMenu.tscn"
