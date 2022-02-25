extends Control

onready var array: Array = [
	$ColorRect,
	null,
	null,
	null,
	null,
]

onready var player_deck = $PD
onready var PlayerDeckSlots = [
	$ColorRect,
	null,
	null,
	null,
	null,
]
onready var PlayerDeckPositions = [
	Vector2(140, 145),
	Vector2(164, 145),
	Vector2(188, 145),
	Vector2(212, 145),
	Vector2(236, 145)
]

func _ready():
	print(get_open_slot(player_deck, "Vec2"))
	PlayerDeckSlots[3] = $Label
	yield(get_tree().create_timer(1), "timeout")
	print(get_open_slot(player_deck, "Vec2"))
	PlayerDeckSlots[2] = $Button
	yield(get_tree().create_timer(1), "timeout")
	print(get_open_slot(player_deck, "Vec2"))
	PlayerDeckSlots[3] = null
	yield(get_tree().create_timer(1), "timeout")
	print(get_open_slot(player_deck, "Vec2"))
	yield(get_tree().create_timer(1), "timeout")

func get_open_slot(deck, return_type):
	#checks for open slots in the appropriate deck
	
	if deck == player_deck:
		for i in range(5):
			if PlayerDeckSlots[i] == null:
				if return_type == "Vec2":
					return PlayerDeckPositions[i]
				elif return_type == "Place":
					return i
				break
			elif PlayerDeckSlots[i] != null:
				if return_type == "Vec2":
					if i != 4:
						print("taken_slot")
					elif i == 4:
						print("all slots taken")
						if return_type == "Vec2":
							return Vector2(-100, -100)
						elif return_type == "Place":
							return 5
							

func _on_Button_pressed():
	get_tree().quit()
