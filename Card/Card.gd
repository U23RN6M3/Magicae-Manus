extends KinematicBody2D

const ClickEffect = preload("res://UI/ClickEffect.tscn")

export var model: bool = false
export var flipped: bool = false
export var usable: bool = true
export var card: String = "+1"

onready var image = $Base/Image
onready var card_effect = $Base/Effect
onready var card_base = $Base

onready var image_tween = $Tween
onready var color_tween = $ColorTween
onready var move_tween = $Move

var shake_x = -0.5

var effect = "0"
var card_owner = null

func _ready() -> void:
	randomize()
	
	print("Card Spawned")

	if model == true:
		card_effect.text = "^"
		effect = card
	else:
		if flipped == true:
			card_base.texture = load("res://Card/CardBack.png")
			for i in card_base.get_children():
				i.hide()
				
		else:
			color_tween.interpolate_property(self, "modulate", Color("#00b7ff"), Color("#ffffff"), 1.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
			color_tween.start()
			
			set_stats()
	
	yield(get_tree().create_timer(rand_range(0.5, 2)), "timeout")
		
	image_tween.interpolate_property(image, "offset", image.offset, Vector2(shake_x, 0), 1.0, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	image_tween.start()

func _physics_process(_delta):
	if Global.recently_clicked_card == self:
		image.modulate = Color("#00b7ff")
	else:
		image.modulate = Color("ffffff")

func set_stats():
	card_effect.text = "[" + card + "]"
	effect = card
	
	
	
	if card.begins_with("#"):
		set_img("res://Card/Block.png")
	elif card.begins_with("+"):
		set_img("res://Card/Charge.png")
	elif card == "-1":
		set_img("res://Card/Abra.png")
	elif card == "-2":
		set_img("res://Card/DoubleAbra.png")

func set_img(path: String):
	image.texture = load(path)

func set_flipped(value: bool):
	flipped = value
	if value == true:
		card_base.texture = load("res://Card/CardBack.png")
		for i in card_base.get_children():
			i.hide()
	else:
		card_base.texture = load("res://Card/CardBase.png")
		for i in card_base.get_children():
			i.show()

func move_to_target(speed: float, object: Object, property: String, initial_point: Vector2, end_point: Vector2):
	move_tween.interpolate_property(object, property, initial_point, end_point, speed, Tween.TRANS_QUART, Tween.EASE_OUT)
	move_tween.start()

func instance_node(node: PackedScene, location: Vector2, parent, delete_in_2_seconds: bool):
	var node_instance = node.instance()
	node_instance.global_position = location
	parent.add_child(node_instance)
	if delete_in_2_seconds == true:
		yield(get_tree().create_timer(2), "timeout")
		node_instance.queue_free()

func click_effect():
	instance_node(ClickEffect, image.global_position, get_tree().get_nodes_in_group("ParticleEffect")[0], true)
	$ParticleSFX.play(0.04)

func card_played():
	$CardPlayed.play()
	image.position = Vector2(0, -9)
	usable = false

func _on_Tween_tween_completed(_object, _key):
	if shake_x == -0.5:
		shake_x = 0.5
	else:
		shake_x = -0.5
	
	image_tween.interpolate_property(image, "offset", image.offset, Vector2(shake_x, 0), 1.0, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	image_tween.start()

func _on_Card_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if flipped == false:
				if usable == true:
					Global.recently_clicked_card = self

func _on_Card_mouse_entered():
	if flipped == false:
		if usable == true:
			$CardHover.play()
			move_to_target(0.1, card_base, "position", card_base.position, Vector2(card_base.position.x, clamp(card_base.position.y - 6, -6, 0)))

func _on_Card_mouse_exited():
	if flipped == false:
		if usable == true:
			move_to_target(0.1, card_base, "position", card_base.position, Vector2(card_base.position.x, clamp(card_base.position.y + 6, -6, 0)))
