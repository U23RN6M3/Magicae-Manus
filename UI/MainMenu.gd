extends Control

onready var fade_effect_tween  =$Panel/FadeEffect/Tween

func _ready() -> void:
	$Panel/FadeEffect.visible = true
	fade_effect_tween.interpolate_property($Panel/FadeEffect, "color", Color("#000000"), Color("#00000000"), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	fade_effect_tween.start()
	Global.menu_music.play()


func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if Global.recently_clicked_card != null:
				var element = Global.recently_clicked_card.effect
				$Panel/FadeEffect.mouse_filter = Control.MOUSE_FILTER_STOP
				fade_effect_tween.interpolate_property($Panel/FadeEffect, "color", Color("#00000000"), Color("#000000"), 2, Tween.TRANS_BACK, Tween.EASE_OUT)
				Global.recently_clicked_card.move_to_target(0.5, Global.recently_clicked_card, "global_position", Global.recently_clicked_card.global_position, $Panel/SelectCard/SelectCard/Area2D.global_position)
				print(element)
				Global.recently_clicked_card.click_effect()
				yield(get_tree().create_timer(2), "timeout")
				if element == "campaign":
					get_tree().change_scene("res://Main/Arena.tscn")
				elif element == "extras":
					pass
				elif element == "options":
					pass
				elif element == "credits":
					pass
				elif element == "quit":
					get_tree().quit()
				Global.recently_clicked_card = null
				fade_effect_tween.start()
