extends Control

onready var array: Array = [
	$ColorRect,
	null,
	null,
	null,
	null,
]

func _ready():
	print(str(array))

func _on_Button_pressed():
	get_tree().quit()
