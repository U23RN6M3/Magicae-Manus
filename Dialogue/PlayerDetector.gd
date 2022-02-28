extends Area2D

var player = null

func _on_PlayerDetector_body_entered(body: Node):
	if body.is_in_group("Player"):
		player = body

func _on_PlayerDetector_body_exited(body: Node):
	if body.is_in_group("Player"):
		player = null
