extends Camera2D

onready var topLeft = $Limits/UpperLeft
onready var bottomRight = $Limits/LowerRight

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
