extends Node

signal dialogDone
signal nextDialog

var skippable =  true
var randomization = 0

export(float) var textSpeed = 0.02

var audioSFX = load("res://Dialogue/Voice2.wav")
var pitch: float = 1

onready var timer = $Control/Dialog_Box/Timer
onready var Text = $Control/Dialog_Box/Text
onready var indicator = $Control/Dialog_Box/Indicator
onready var indicatorAnimationPlayer = $Control/Dialog_Box/Indicator/AnimationPlayer
onready var audio = $Control/Dialog_Box/AudioStreamPlayer

var dialog = DialogSource.test

var phraseNum = 0
var finished = false

func _physics_process(_delta):
	indicator.visible = finished
	
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		elif !finished and skippable:
			Text.visible_characters = len(Text.text)
			finished = true

func _ready():
	audio.pitch_scale = pitch
	audio.stream = audioSFX
	
	timer.wait_time = textSpeed
	
	indicatorAnimationPlayer.play("Blink")
	dialog = DialogSource.test
	nextPhrase()

func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		$Control/Dialog_Box/AnimationPlayer.play("Out")
		emit_signal("dialogDone")
		return
	emit_signal("nextDialog")
	
	audio.pitch_scale = dialog[phraseNum]["Pitch"]
	
	finished = false
	
	Text.visible_characters = 0
	
	while Text.visible_characters < len(Text.text):
		
		Text.bbcode_text = dialog[phraseNum]["Text"]
		
		Text.visible_characters += 1
		
		if Text.text[Text.visible_characters - 1] != " " or Text.text[Text.visible_characters - 1] != ",":
			audio.play()
		
		randomize()
		if randomization != 0:
			audio.pitch_scale = rand_range(-pitch, pitch)
		
		timer.start()
		yield(timer, "timeout")
		
	
	finished = true
	phraseNum += 1
	return
