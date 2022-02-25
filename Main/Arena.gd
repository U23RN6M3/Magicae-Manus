extends Node

const Card = preload("res://Card/Card.tscn")

enum {
	PLAYING,
	PAUSED,
	TALKING
}

onready var shuffled_deck = $"2DSpace/ShuffledDeck"
onready var player_charge_meter = $UISpace/Board/PlayerPlay/ChargeMeter
onready var enemy_charge_meter = $UISpace/Board/EnemyPlay/ChargeMeter
onready var player_play = $UISpace/Board/PlayerPlay
onready var enemy_play = $UISpace/Board/EnemyPlay
onready var player_play_pos = $UISpace/Board/PlayerPlayPos
onready var enemy_play_pos = $UISpace/Board/EnemyPlayPos
onready var player_deck = get_node("2DSpace/PlayerDeck")
onready var enemy_deck = get_node("2DSpace/EnemyDeck")
onready var cursor_control = $CursorControl

var PlayerDeckPositions = [
	Vector2(140, 145),
	Vector2(164, 145),
	Vector2(188, 145),
	Vector2(212, 145),
	Vector2(236, 145)
]

var EnemyDeckPositions = [
	Vector2(104, 18),
	Vector2(80, 18),
	Vector2(56, 18),
	Vector2(32, 18),
	Vector2(8, 18)
]

onready var PlayerDeckSlots = [
	$"2DSpace/PlayerDeck/Card",
	null,
	null,
	null,
	null,
]

onready var EnemyDeckSlots = [
	$"2DSpace/PlayerDeck/Card",
	null,
	null,
	null,
	null,
]

var state = TALKING
var turns: int = 0

var enemy_selected_card = null

func _ready():
	set_enemy_selected_card()
	
	draw_card("player")
	draw_card("enemy")
	
	#$Dialogue.dialog = DialogSource.tutorial1
	for i in enemy_deck.get_children():
		i.set_flipped(true)
		i.usable = false
# warning-ignore:return_value_discarded
	$Dialogue.connect("dialogDone", self, "change_state", [PLAYING])

func _physics_process(_delta):
	match state:
		TALKING:
			cursor_control_to(true)
		PLAYING:
			cursor_control_to(false)
		PAUSED:
			cursor_control_to(true)

func set_enemy_selected_card(strat: String = "first-to-last"):
	#enemy ai config
	
	#this strategy will need the ai to always pick the first available card and select it
	if strat == "first-to-last":
		if len(enemy_deck.get_children()) > 0:
			enemy_selected_card = enemy_deck.get_children()[0]
		else:
			draw_card("enemy")
			set_enemy_selected_card("first-to-last")

func get_open_slot(deck, return_type):
	#checks for open slots in the appropriate deck
	
	#if the deck is not empty
	if not deck.get_children().empty():
		#then we will perform a for loop to check for open slots
		for i in range(5):
			if deck == player_deck:
				#checks if the player deck slot is available
				if PlayerDeckSlots[i] == null:
					if return_type == "Vec2":
						#then we return the i value of the player deck position array
						return PlayerDeckPositions[i]
					elif return_type == "Place":
						#then we literally return the i value
						return i
					
					#DO NOT FORGET TO break the for loop
					break
					
				elif PlayerDeckSlots[i] != null:
					if i != 4:
						#we print that the slot is full if we havent checked the last slot
						print("player slot full")
					elif i == 4:
						#we print that all the slots are full and return -100, -100 for now,
						print("all player slots full")
						if return_type == "Vec2":
							return Vector2(-100, -100)
						elif return_type == "Place":
							return 5
			elif deck == enemy_deck:
				#checks if the enemy deck slot is available
				if EnemyDeckSlots[i] == null:
					if return_type == "Vec2":
						#then we return the i value of the enemy deck position array
						return EnemyDeckPositions[i]
					elif return_type == "Place":
						#then we literally return the i value
						return i
					#DO NOT FORGET TO break the for loop
					break
					
				elif EnemyDeckSlots[i] != null:
					if i != 4:
						#we print that the slot is full if we havent checked the last slot
						print("enemy slot full")
					elif i == 4:
						#we print that all the slots are full and return -100, -100 for now,
						print("all enemy slots full")
						if return_type == "Vec2":
							return Vector2(-100, -100)
						elif return_type == "Place":
							return 5
	#else if the deck is completely empty
	elif deck.get_children().empty():
		#we return the first value of the specified deck position array
		if deck == player_deck:
			return PlayerDeckPositions[0]
		elif deck == enemy_deck:
			return EnemyDeckPositions[0]

func change_state(state_to):
	#changes state to state_to
	state = state_to

func pick_from_array(array: Array):
	#self explanatory
	randomize()
	array.shuffle()
	return array.front()

func cursor_control_to(value):
	#blocks or unblocks player control
	if value == false:
		cursor_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		cursor_control.mouse_filter = Control.MOUSE_FILTER_STOP

func play_card(who, card):
	#the function that most of the time destroys my braincells
	turns += 1
	
	#if specified player is the player
	if who == "player":
		
		#checks what effect the card has and execute it's effect
		if card.effect.begins_with("+"):
			player_charge_meter.value += int(card.effect.right(0))
			$Charge.play()
		
		for i in range(len(PlayerDeckSlots)):
			if card == PlayerDeckSlots[i]:
				PlayerDeckSlots[i] = null
				break
		
		#set the card's z index to the current turn count
		card.z_index = turns
		
		#card moving animation
		card.move_to_target(0.5, card, "global_position", card.global_position, player_play_pos.global_position)
		#set the card state to "played"
		card.card_played()
		#wait half a second to execute the following below
		yield(get_tree().create_timer(0.5), "timeout")
		#reparenting card and setting it's position to 0, 0
		card.position = Vector2(0, 0)
		player_deck.remove_child(card)
		player_play_pos.add_child(card)
		
	#if specified player is enemy
	elif who == "enemy":
		#unflip the card
		card.set_flipped(false)
		
		#checks what effect the card has and execute it's effect
		if card.effect.begins_with("+"):
			enemy_charge_meter.value += int(card.effect.right(0))
			$Charge.play()
		

		for i in range(len(EnemyDeckSlots)):
			if card == EnemyDeckSlots[i]:
				EnemyDeckSlots[i] = null
				break
		
		#set the card's z index to the current turn count
		card.z_index = turns
		
		#card moving animation
		card.move_to_target(0.5, card, "global_position", card.global_position, enemy_play_pos.global_position)
		#set the card's state to "played"
		card.card_played()
		#wait half a second to execute the following below
		yield(get_tree().create_timer(0.5), "timeout")
		#reparenting card and setting it's position to 0, 0
		card.position = Vector2(0, 0)
		enemy_deck.remove_child(card)
		enemy_play_pos.add_child(card)

func draw_card(who: String):
	#this function adds random possible cards to the specified deck
	
	#if the player is the player
	if who == "player":
		#create a new card scene and save it in a variable
		var new_card = Card.instance()
		#adds the new card to the player's deck
		player_deck.add_child(new_card)
		#sets the card's global position to the shuffled deck's global position
		new_card.global_position = shuffled_deck.global_position
		#Sets the player deck slot's number to be a taken slot
		PlayerDeckSlots[get_open_slot(player_deck, "Place")] = new_card
		#move to the card to an available position on the player's deck
		new_card.move_to_target(0.2, new_card, "global_position", new_card.global_position, get_open_slot(player_deck, "Vec2"))
		#creates the stats for the cards
		new_card.card = pick_from_array(possible_cards_based_off_charges(player_charge_meter.value))
		new_card.set_stats()
		
	#if the player is the enemy
	elif who == "enemy":
		#create a new card scene and save it in a variable
		var new_card = Card.instance()
		#adds the new card to the enemys's deck
		enemy_deck.add_child(new_card)
		#sets the card's global position to the shuffled deck's global position
		new_card.global_position = shuffled_deck.global_position
		#Sets the player deck slot's number to be a taken slot
		PlayerDeckSlots[get_open_slot(enemy_deck, "Place")] = new_card
		#move to the card to an available position on the enemy's deck
		new_card.move_to_target(0.2, new_card, "global_position", new_card.global_position, get_open_slot(enemy_deck, "Vec2"))
		#creates the stats for the cards
		new_card.card = pick_from_array(possible_cards_based_off_charges(enemy_charge_meter.value))
		new_card.set_stats()
		new_card.set_flipped(true)

func possible_cards_based_off_charges(charges: int) -> Array:
	#creates and returns an array of effects for a new card
	
	var array: Array = []
	
	if charges >= 0:
		array.append(pick_from_array(["+1", "#7"]))
	if charges >= 1:
		array.append(pick_from_array(["-1", "#7"]))
	if charges >= 2:
		array.append(pick_from_array(["+2", "-1", "-2"]))
	if charges >= 3:
		array.append(pick_from_array(["-2", "-2", "+2", "+1"]))
	
	return array

func instance_node(node: PackedScene, location: Vector2, parent: Node):
	#basic instancing of a packed scene function
	var node_instance = node.instance()
	node_instance.global_position = location
	parent.add_child(node_instance)
	
	return node_instance

func _on_CardPlayArea_input_event(_viewport, event, _shape_idx):
	#the following gates checks if the input event is a left click
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			#if the game state is playing
			if state == PLAYING:
				#checks if you have a recently clicked card
				if Global.recently_clicked_card != null:
					if enemy_selected_card != null:
						#pauses the game, therefore activating the cursor control
						change_state(PAUSED)
						#play the selected cards of each card player
						play_card("player", Global.recently_clicked_card)
						play_card("enemy", enemy_selected_card)
						#add a new card to each of the card players
						draw_card("player")
						draw_card("enemy")
						#set the recently clicked card to nothing/Nil
						Global.recently_clicked_card = null
						#wait for 1 second to set the state to playing to start the loop all over again
						yield(get_tree().create_timer(1), "timeout")
						#sets the selected enemy card to a new one based off the strat given
						set_enemy_selected_card()
						change_state(PLAYING)
