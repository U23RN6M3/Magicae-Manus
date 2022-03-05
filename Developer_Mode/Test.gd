extends Node2D

func _ready():
	if Global.player_position != null:
		$YSort/Lion.global_position = Global.player_position
		Global.player_position = null
		

func _on_Wrig_dialog_done():
	$YSort/Lion.change_state($YSort/Lion.PAUSED)
	Global.ready_battle()
	$Camera2D/ScreenShake.start()
	yield(get_tree().create_timer(0.5), "timeout")
	Global.fade_start()
	yield(get_tree().create_timer(0.5), "timeout")
	Global.player_position = Vector2(152, 88)
	Global.battle_music_stream = load("res://SFX/Abra.mp3")
	Global.battle_dialog = DialogSource.npc_dialogue_list[3]
	Global.battle_scene_to_change_to = "res://Developer_Mode/Test.tscn"
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main/Arena.tscn")
