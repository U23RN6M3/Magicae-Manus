extends Area2D

const Dialogue = preload("res://Dialogue/Dialogue.tscn")

export var dialog_num_code = 0

var player = null

func _physics_process(_delta):
	if player != null:
		if Input.is_action_just_pressed("interact"):
			var instance = Dialogue.instance()
			instance.dialog = get_tree().get_nodes_in_group("DialogueNode")[0].dialog_to_load[dialog_num_code]
			instance.connect("dialogDone", self, "unpause_player")
			get_tree().get_nodes_in_group("DialogueNode")[0].add_child(instance)
			player.change_state(player.PAUSED)

func unpause_player():
	if player != null:
		player.change_state(player.IDLE)

func _on_DialogSummoner_body_entered(body: Node):
	if body.is_in_group("Player"):
		player = body

func _on_DialogSummoner_body_exited(body: Node):
	if body.is_in_group("Player"):
		player = null
