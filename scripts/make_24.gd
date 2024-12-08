extends Node2D

signal make24_started
enum Operators { PLUS,MINUS,MULTIPLY,DIVIDE }
enum Modes { NORMAL, LIMITEDTIME }
const HAND = 4

@export var card_scene: PackedScene

var selected_cards: Array = []
var cards: Array = []  # 保存当前的4张卡牌
var undo_stack: Array = []
var all_cards: Array = []
var selected_operator: Operators
var operation_text: String = ""
var result = 0
var current_mode = Modes.NORMAL

@onready var custom_window: CharacterBody2D = $CustomWindow
@onready var card_container = $CustomWindow/CardContainer
@onready var card_deck: Sprite2D = $CustomWindow/CardDeck
@onready var upcoming_card: Card = $CustomWindow/UpcomingCard
@onready var score_lbl: Label = $CustomWindow/Score
@onready var timer: Timer = $Timer


func _ready():
	$CustomWindow/Control/UndoButton.disabled = true
	$CustomWindow/UpcomingCard.is_interactive = false

func _process(delta: float) -> void:
	if timer:
		$CustomWindow/Countdown.text = "%02d : %02d" % countdown()


func clear_cards():
	# Clear previous cards
	cards.clear()
	undo_stack.clear()
	for i in card_container.get_children():
		if i is Card:
			i.card_image.texture = null


func prepare_deck():
	# Draw 4 random cards from deck
	# Create a list that includes all cards
	for suit in Card.Suits.values():
		for number in range(1, 14):  # from A to K
			all_cards.append({ "suit": suit, "number": number })
	
	# Shuffle and then draw cards
	all_cards.shuffle()
	return all_cards


func update_upcoming_card():
	if all_cards.size() < HAND:
		prepare_deck()
	else:
		# Card4 is the first card to be dealed in animation
		var next_card = all_cards[3]
		upcoming_card.make_card(next_card["suit"], next_card["number"])


func draw_cards(all_cards):
	# Check left cards
	if all_cards.size() < HAND:
		all_cards = prepare_deck()

	# Pop 4 cards
	for i in range(HAND):
		var card_data = all_cards.pop_front()
		var card_node = card_container.get_child(i) as Card
		if card_node:
			card_node.make_card(card_data["suit"], card_data["number"])
			cards.append(card_node)
	for card in cards:
		card.card_selected.connect(_on_card_selected)
		card.card_deselected.connect(_on_card_deselected)
	update_upcoming_card()
	$DealCardSFX.play()
	$AnimationPlayer.play("deal_cards")
	


func select_card(card: Card):
	# Select first card
	if selected_cards.is_empty():
		selected_cards.append(card)
		print("First card selected: %s-%d" % [card.suit_name, card.number])
		for i in cards:
			i.is_interactive = false
		card.is_interactive = true
		return
	# Select second card and perform operation
	elif selected_cards.size() == 1 and selected_operator != null:
		selected_cards.append(card)
		print("Second card selected: %s-%d" % [card.suit_name, card.number])
		result = calculate(selected_cards[0].number, selected_cards[1].number)
		merge_cards(selected_cards[0], selected_cards[1], result)
		check_24(result)
		return
	else:
		print("Cannot be selected")


func calculate(a, b):
	var operator ="" # to be print in $Operation Label
	match selected_operator:
		Operators.PLUS:
			operator ="+"
			result = a + b
		Operators.MINUS:
			operator ="-"
			result = a - b
		Operators.MULTIPLY:
			operator ="×"
			result = a * b
		Operators.DIVIDE:
			operator ="÷"
			if b != 0:
				result = float(a) / float(b)
			else:
				print("Cannot divide by zero")
				return 0
		_:
			print("No operator selected")
			return 0
	operation_text = "%s %s %s = %s \n" % [str(a), operator, str(b), str(result)]
	return result


func merge_cards(card1:Card, card2:Card, result):
	# Savr current state to undo_stack
	var card1_index = card_container.get_children().find(card1)
	var card2_index = card_container.get_children().find(card2)
	var state_snapshot = {
		"card1": {
			"suit": card1.suit, 
			"number": card1.number,
			"index": card1_index, },
		"card2": { 
			"suit": card2.suit, 
			"number": card2.number,
			"index": card2_index, },
		"Operation": $CustomWindow/Operation.text
	}
	undo_stack.append(state_snapshot)

	# "Merge" two selected cards
	card2.deselect()
	card2.hide()
	card1.deselect()
	card1.make_card(card1.suit, result)
	selected_cards.clear()
	$CustomWindow/Operation.text += operation_text
	$CustomWindow/Control/UndoButton.disabled = false


func undo_merge():
	var previous_state = undo_stack.pop_back()
	var card1 = card_container.get_child(previous_state["card1"]["index"])
	card1.make_card(previous_state["card1"]["suit"], previous_state["card1"]["number"])
	var card2 = card_container.get_child(previous_state["card2"]["index"])
	card2.make_card(previous_state["card2"]["suit"], previous_state["card2"]["number"])
	card2.show()
	$CustomWindow/Operation.text = previous_state["Operation"]


func check_24(result):
	var visible_cards = []
	for card in cards:
		if card.is_visible() and card not in visible_cards:
			visible_cards.append(card)
	if result == 24 and visible_cards.size() == 1:
		# Switch score between modes
		var score: String = ""
		match current_mode:
			Modes.NORMAL:
				score = "make24_score"
			Modes.LIMITEDTIME:
				score = "limited_time_score"
			
		# Update score on label
		Database.player[score] += 1
		score_lbl.text = "Score: "+str(Database.player[score])
		if Database.player["limited_time_score"] > Database.player["limited_time_best"]:
			Database.player["limited_time_best"] = Database.player["limited_time_score"]
		for card in cards:
			card.flip()


func enable_cards():
	for i in cards:
		i.is_interactive = true

func countdown():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]


func redraw():
	$CustomWindow/Operation.text = "Operation:\n"
	$CustomWindow/Control/UndoButton.disabled = true
	selected_cards.clear()
	undo_stack.clear()
	for card in cards:
		card.show()
		if card.is_selected:
			card.deselect()
	draw_cards(all_cards)


func _on_make_24_started() -> void:
	# add instructions?
	pass


func _on_custom_window_window_closed() -> void:
	Database.save_data()
	# remove make24 window from desktop
	if self.get_parent():
		self.get_parent().remove_child(self)


func _on_play_button_pressed() -> void:
	make24_started.emit()
	current_mode = Modes.NORMAL
	score_lbl.text = "Score: "+str(Database.player["make24_score"])
	clear_cards()
	all_cards = prepare_deck()
	draw_cards(all_cards)
	
	# Change to redraw button
	$CustomWindow/BlankCard.hide()
	$CustomWindow/Control/PlayButton.hide()
	$CustomWindow/Control/RedrawButton.show()
	$CustomWindow/Control/LimitedTimeCheckBox.disabled = false


func _on_redraw_button_pressed() -> void:
	redraw()


func _on_undo_button_pressed() -> void:
	undo_merge()
	if undo_stack.is_empty():
		$CustomWindow/Control/UndoButton.disabled = true


func _on_plus_pressed() -> void:
	selected_operator = Operators.PLUS
	enable_cards()

func _on_minus_pressed() -> void:
	selected_operator = Operators.MINUS
	enable_cards()

func _on_multiply_pressed() -> void:
	selected_operator = Operators.MULTIPLY
	enable_cards()

func _on_divide_pressed() -> void:
	selected_operator = Operators.DIVIDE
	enable_cards()


func _on_card_selected(card: Card) -> void:
	select_card(card)


func _on_card_deselected(deselected_card: Card) -> void:
	selected_cards.pop_back()
	enable_cards()


func _on_limited_time_check_box_toggled(toggled_on: bool) -> void:
	current_mode = Modes.LIMITEDTIME
	$CustomWindow/Watch.play("hands_move")
	$CustomWindow/Countdown.show()
	timer.start()
	
	# Renew limited time score
	Database.player["limited_time_score"] = 0
	redraw()
