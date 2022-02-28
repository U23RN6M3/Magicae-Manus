extends StaticBody2D

const Dialogue = preload("res://Dialogue/Dialogue.tscn")

onready var player_detector = $PlayerDetector

export var enable_dialog = true
export var dialog_num_code = 0

func _physics_process(_delta):
	if player_detector.player != null:
		if Input.is_action_just_pressed("interact"):
			if enable_dialog == true:
				enable_dialog = false
				var instance = Dialogue.instance()
				instance.dialog = DialogSource.npc_dialogue_list[dialog_num_code]
				change_player_state(player_detector.player.PAUSED)
				instance.connect("dialogDone", self, "change_player_state", [player_detector.player.IDLE])
				instance.connect("dialogDone", self, "set_deferred", ["enable_dialog", true])
				get_tree().get_nodes_in_group("MainInstance")[0].add_child(instance)

func change_player_state(state):
	if player_detector.player != null:
		player_detector.player.change_state(state)

# fnaf reference omg
