extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer

var speed = 45  # speed in pixels/sec
var velocity = Vector2.ZERO

var facing = "Down"

func _physics_process(_delta):
	velocity = Vector2.ZERO
	
	velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = velocity.normalized() * speed
	
	if velocity != Vector2.ZERO:
		if Input.is_action_pressed('right'):
			facing = "Right"
			animationPlayer.play("WalkRight")
		if Input.is_action_pressed('left'):
			facing = "Left"
			animationPlayer.play("WalkLeft")
		if Input.is_action_pressed('down'):
			facing = "Down"
			animationPlayer.play("WalkDown")
		if Input.is_action_pressed('up'):
			facing = "Up"
			animationPlayer.play("WalkUp")
		
	else:
		animationPlayer.play("Stand" + facing)
	
	velocity = move_and_slide(velocity)


