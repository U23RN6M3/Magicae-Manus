tool
extends VBoxContainer



func _on_GenerateButton_pressed():
	var new_name = NameGenerator.new_name()
	$HBoxContainer/LineEdit.text = new_name
	print(new_name)

func _on_CopyButton_pressed():
	OS.clipboard = $HBoxContainer/LineEdit.text


