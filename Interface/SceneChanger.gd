extends Area2D

export var scene_to_change_to: String = "res://Developer_Mode/Error.tscn"
export var enabled: bool = true

func _on_SceneChanger_body_entered(body):
	if enabled == true:
		body.change_state(body.PAUSED)
		Global.fade_start()
# warning-ignore:return_value_discarded
		Global.connect("fade_ended", self, "change_scene")

func change_scene():
# warning-ignore:return_value_discarded
	get_tree().change_scene(scene_to_change_to)
