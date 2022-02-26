extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0

var property = "offset"
var property_path = null

onready var camera = get_parent()

func _ready():
	property_path = camera.offset

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func start(duration = 0.2, frequency = 25, amplitude = 5, priority = 0):
	if priority >= self.priority:
		self.amplitude = amplitude
		$Duration.wait_time = duration
		$Frequency.wait_time = 1 / float(frequency)
		$Duration.start()
		$Frequency.start()
		
		new_shake(property)

# warning-ignore:shadowed_variable
func new_shake(property: String):
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	$ShakeTween.interpolate_property(camera, property, property_path, rand, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()

func reset():
	$ShakeTween.interpolate_property(camera, property, property_path, Vector2(), $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()
	
	priority = 0

func _on_Frequency_timeout():
	new_shake(property)

func _on_Duration_timeout():
	reset()
	$Frequency.stop()
