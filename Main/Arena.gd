extends Node

const Card = preload("res://Card/Card.tscn")

enum {
	PLAYING,
	PAUSED,
	TALKING,
	FINISHED
}

onready var screen_shake = $Camera/ScreenShake
onready var winner_prompt = $UISpace/WinnerPrompt2D/Control/WinnerPrompt
onready var winner_prompt2d = $UISpace/WinnerPrompt2D

onready var shuffled_deck = $"2DSpace/ShuffledDeck"
onready var player_charge_meter = $UISpace/Board/PlayerPlay/ChargeMeter
onready var enemy_charge_meter = $UISpace/Board/EnemyPlay/ChargeMeter
onready var player_health = $UISpace/Board/PlayerPlay/Health
onready var enemy_health = $UISpace/Board/EnemyPlay/Health
onready var player_play = $UISpace/Board/PlayerPlay
onready var enemy_play = $UISpace/Board/EnemyPlay
onready var player_play_pos = $UISpace/Board/PlayerPlayPos
onready var enemy_play_pos = $UISpace/Board/EnemyPlayPos
onready var player_deck = get_node("2DSpace/PlayerDeck")
onready var enemy_deck = get_node("2DSpace/EnemyDeck")
onready var cursor_control = $CursorControl

var PlayerDeckPositions = [
	Vector2(236, 145),
	Vector2(212, 145),
	Vector2(188, 145),
	Vector2(164, 145),
	Vector2(140, 145),
]

var EnemyDeckPositions = [
	Vector2(104, 18),
	Vector2(80, 18),
	Vector2(56, 18),
	Vector2(32, 18),
	Vector2(8, 18)
]

onready var PlayerDeckSlots = [
	null,
	null,
	null,
	null,
	null,
]

onready var EnemyDeckSlots = [
	null,
	null,
	null,
	null,
	null,
]

var state = TALKING
var turns: int = 0

var shake_x = -128

var enemy_selected_card = null

var player_recently_played_card = null
var enemy_recently_played_card = null

func _ready():
	$BattleMusic.stream = Global.battle_music_stream
	$BattleMusic.play()
	
	$UISpace/BackGround/GreenMaskTween.interpolate_property($UISpace/BackGround/GreenMask, "rect_position", Vector2(-64, 0), Vector2(-64, -128), 10, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	$UISpace/BackGround/GreenMaskTween.start()
	
	$Dialogue.audio.stream = load("res://SFX/LionVoice.mp3")
	
	draw_card("player", true)
	draw_card("enemy", true)
	
	set_enemy_selected_card()
	
	draw_card("enemy", false)
	draw_card("enemy", false)
	draw_card("enemy", false)
	draw_card("player", false)
	draw_card("player", false)
	draw_card("player", false)
	
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
		FINISHED:
			cursor_control_to(true)

func set_enemy_selected_card(strat: String = "first-to-last"):
	#enemy ai config
	
	#this strategy will need the ai to always pick the first available card and select it
	if strat == "first-to-last":
		if len(EnemyDeckSlots) > 0:
			enemy_selected_card = enemy_deck.get_child(0)
		else:
			draw_card("enemy", false)
			set_enemy_selected_card("first-to-last")

func get_open_slot(deck, return_type):
	#checks for open slots in the appropriate deck
	
	if deck == player_deck:
		for i in range(len(PlayerDeckSlots)):
			if PlayerDeckSlots[i] != null:
				if return_type == "Vec2":
					if i == len(PlayerDeckSlots):
						
						if return_type == "Vec2":
							return Vector2(-100, -100)
							
						elif return_type == "Place":
							return 5
							
			elif PlayerDeckSlots[i] == null:
				if return_type == "Vec2":
					return PlayerDeckPositions[i]
					
				elif return_type == "Place":
					return i
					
	elif deck == enemy_deck:
		for i in range(len(PlayerDeckSlots)):
			if EnemyDeckSlots[i] != null:
				if return_type == "Vec2":
					if i == len(EnemyDeckSlots):
						if return_type == "Vec2":
							return Vector2(-100, -100)
							
						elif return_type == "Place":
							return 5
							
			elif EnemyDeckSlots[i] == null:
				if return_type == "Vec2":
					return EnemyDeckPositions[i]
					
				elif return_type == "Place":
					return i
					
				

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
	
	#if specified player is the player
	if who == "player":
		
		#checks what effect the card has and execute it's effect
		if card.effect.begins_with("+"):
			player_charge_meter.value += int(card.effect.right(0))
			$Charge.play()
		elif card.effect.begins_with("-"):
			player_charge_meter.value += int(card.effect.right(0))
			$Charge.play()
			if enemy_health.value > 0:
				if not enemy_recently_played_card.effect == "#":
					if not enemy_recently_played_card.effect.begins_with("-"):
						screen_shake.start()
						$Damaged.play(0.06)
						$Loose.play()
						enemy_health.value += int(card.effect.right(0))
					elif enemy_recently_played_card.effect.begins_with("-"):
						if int(enemy_recently_played_card.effect) > int(card.effect):
							screen_shake.start()
							$Damaged.play(0.06)
							$Loose.play()
							enemy_health.value += int(card.effect.right(0))
		elif card.effect.begins_with("~"):
			if not enemy_recently_played_card.effect.begins_with("##"):
				screen_shake.start()
				$Damaged.play(0.06)
				$Loose.play()
				$Charge.play()
				player_charge_meter.value += enemy_charge_meter.value
				enemy_charge_meter.value = 0
			elif enemy_recently_played_card.effect.begins_with("##"):
				$Damaged.play(0.06)
				$Loose.play()
				player_health.value += -3
		
		for i in range(len(PlayerDeckSlots)):
			if PlayerDeckSlots[i] == card:
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
		elif card.effect.begins_with("-"):
			enemy_charge_meter.value += int(card.effect.right(0))
			$Charge.play()
			if player_health.value > 0:
				if not player_recently_played_card.effect.begins_with("#"):
					if not player_recently_played_card.effect.begins_with("-"):
						screen_shake.start()
						$Damaged.play(0.06)
						$Loose.play()
						player_health.value += int(card.effect.right(0))
					elif player_recently_played_card.effect.begins_with("-"):
						if int(player_recently_played_card.effect) > int(card.effect):
							screen_shake.start()
							$Damaged.play(0.06)
							$Loose.play()
							player_health.value += int(card.effect.right(0))
		elif card.effect.begins_with("~"):
			if not player_recently_played_card.effect.begins_with("##"):
				screen_shake.start()
				$Damaged.play(0.06)
				$Loose.play()
				$Charge.play()
				enemy_charge_meter.value += player_charge_meter.value
				player_charge_meter.value = 0
			elif player_recently_played_card.effect.begins_with("##"):
				$Damaged.play(0.06)
				$Loose.play()
				enemy_health.value += -3
		
		for i in range(len(EnemyDeckSlots)):
			if EnemyDeckSlots[i] == card:
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

func draw_card(who: String, first_move_card: bool):
	#this function adds random possible cards to the specified deck
	
	#if the player is the player
	if who == "player":
		#create a new card scene and save it in a variable
		var new_card = Card.instance()
		var open_slot_num = get_open_slot(player_deck, "Place")
		var open_slot = get_open_slot(player_deck, "Vec2")
		
		new_card.card_owner = "player"
		#adds the new card to the player's deck
		player_deck.add_child(new_card)
		#sets the card's global position to the shuffled deck's global position
		new_card.global_position = shuffled_deck.global_position
		#Sets the player deck slot's number to be a taken slot
		PlayerDeckSlots[open_slot_num] = new_card
		#move to the card to an available position on the player's deck
		new_card.move_to_target(0.5, new_card, "global_position", new_card.global_position, open_slot)
		#creates the stats for the cards
		if first_move_card == false:
			new_card.card = pick_from_array(possible_cards_based_off_charges(player_charge_meter.value))
		else:
			new_card.card = "+1"
		new_card.set_stats()
		
	#if the player is the enemy
	elif who == "enemy":
		#create a new card scene and save it in a variable
		var new_card = Card.instance()
		var open_slot_num = get_open_slot(enemy_deck, "Place")
		var open_slot = get_open_slot(enemy_deck, "Vec2")
		
		new_card.card_owner = "enemy"
		#adds the new card to the enemys's deck
		enemy_deck.add_child(new_card)
		#sets the card's global position to the shuffled deck's global position
		new_card.global_position = shuffled_deck.global_position
		#Sets the player deck slot's number to be a taken slot
		PlayerDeckSlots[open_slot_num] = new_card
		#move to the card to an available position on the enemy's deck
		new_card.move_to_target(0.5, new_card, "global_position", new_card.global_position, open_slot)
		#creates the stats for the cards
		new_card.card = pick_from_array(possible_cards_based_off_charges(enemy_charge_meter.value))
		new_card.set_stats()
		new_card.set_flipped(true)

func possible_cards_based_off_charges(charges: int) -> Array:
	#creates and returns an array of effects for a new card
	
	var array: Array = []
	
	if charges >= 0:
		array.append(pick_from_array(["+1", "#"]))
	if charges >= 1:
		array.append(pick_from_array(["-1", "+1"]))
	if charges >= 2:
		array.append(pick_from_array(["+2", "-2"]))
	if charges >= 3:
		array.append(pick_from_array(["-1", "+2"]))
	if charges >= 4:
		array.append(pick_from_array(["##", "~", "-2"]))
	if charges >= 5:
		array.append(pick_from_array(["~", "+2", "+1", "-2"]))
	
	return array

func next_turn():
	player_recently_played_card = Global.recently_clicked_card
	enemy_recently_played_card = enemy_selected_card
	#pauses the game, therefore activating the cursor control
	change_state(PAUSED)
	#play the selected cards of each card player
	play_card("player", Global.recently_clicked_card)
	play_card("enemy", enemy_selected_card)
	yield(get_tree().create_timer(0.5), "timeout")
	#add a new card to each of the card players
	draw_card("player", false)
	draw_card("enemy", false)
	#set the recently clicked card to nothing/Nil
	Global.recently_clicked_card = null
	#wait for 1 second to set the state to playing to start the loop all over again
	yield(get_tree().create_timer(0.5), "timeout")
	#sets the selected enemy card to a new one based off the strat given
	set_enemy_selected_card()
	
	if player_health.value == 0:
		end_game("enemy")
		$Defeat.play()
		$Damaged.play(0.06)
	elif enemy_health.value == 0:
		end_game("player")
		$Win.play()
	elif player_health.value == 0 and enemy_health.value == 0:
		end_game("draw")
		$Defeat.play()
		$Damaged.play(0.06)
	else:
		change_state(PLAYING)

func end_game(winner: String):
	winner_prompt.show()
	winner_prompt2d.get_child(1).start()
	screen_shake.start()
	$BattleMusic.stop()
	change_state(FINISHED)
	if winner == "player":
		winner_prompt.get_child(0).text = "win"
	elif winner == "enemy":
		winner_prompt.get_child(0).text = "defeat"
	elif winner == "draw":
		winner_prompt.get_child(0).text = "draw"
	
	yield(get_tree().create_timer(5), "timeout")
	$UISpace/FadeTween.interpolate_property($UISpace/Fade, "color", Color("#00000000"), Color("#000000"), 3.5, Tween.TRANS_QUART, Tween.EASE_OUT)
	$UISpace/FadeTween.start()
	

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
						turns += 1
						next_turn()


func _on_GreenMaskTween_tween_all_completed():
	if shake_x == -128:
		$UISpace/BackGround/GreenMaskTween.interpolate_property($UISpace/BackGround/GreenMask, "rect_position", $UISpace/BackGround/GreenMask.rect_position, Vector2(0, $UISpace/BackGround/GreenMask.rect_position.y), 10, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
		$UISpace/BackGround/GreenMaskTween.start()
		shake_x = 0
	elif shake_x == 0:
		$UISpace/BackGround/GreenMaskTween.interpolate_property($UISpace/BackGround/GreenMask, "rect_position", $UISpace/BackGround/GreenMask.rect_position, Vector2(-128, $UISpace/BackGround/GreenMask.rect_position.y), 10, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
		$UISpace/BackGround/GreenMaskTween.start()
		shake_x = -128
