extends KinematicBody2D

enum {
	IDLE,
	PAUSED,
	HURT
}

onready var animationPlayer = $AnimationPlayer
onready var color_tween = $ColorTween

var speed = 45
var velocity = Vector2.ZERO

export(String, "Down", "Up", "Right", "Left") var facing = "Down"

var state = IDLE

func _physics_process(_delta):
	match state:
		IDLE:
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
				if not facing.empty():
					animationPlayer.play("Stand" + facing)
			
		PAUSED:
			velocity = Vector2.ZERO
			animationPlayer.play("Stand" + facing)
		HURT:
			velocity = Vector2.ZERO
			animationPlayer.play("Stand" + facing)
	
	velocity = move_and_slide(velocity)

func change_state(state_to):
	state = state_to

func damaged(damage: int = 10):
	change_state(HURT)
	Global.data["game"]["health"] -= damage
	color_tween.interpolate_property(self, "modulate", Color("#ff0000"), Color("#ffffff"), 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	yield(get_tree().create_timer(1), "timeout")
	change_state(IDLE)
