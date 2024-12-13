class_name Card
extends Node2D
signal card_selected
signal card_deselected
enum Suits { HEART,CLUB,DIAMOND,SPADE }

@export var suit: Suits
@export var background: Texture = preload("res://assets/sprites/cards/card_blank_face.png")
@export var is_interactive: bool = true

var number: Array = []
var is_selected: bool = false
var tween_hover: Tween
var suit_name: String

@onready var card_background: Sprite2D = $CardBackground
@onready var card_image: Sprite2D = $CardImage


func _ready() -> void:
	card_background.texture = background


func make_card(card_suit: Card.Suits, card_num: Array)->Card:
	# Create a new card using suits and number
	self.suit = card_suit
	self.number = card_num
	
	# Get suit name
	match card_suit:
		Suits.HEART: suit_name = "Heart"
		Suits.CLUB: suit_name = "Club"
		Suits.DIAMOND: suit_name = "Diamond"
		Suits.SPADE: suit_name = "Spade"
	self.suit_name = suit_name
	
	# Check if card_num is a fraction
	if card_num[1] != 1:
		card_image.texture = null
		$Control/CardNumber.add_theme_font_size_override("font_size", 96)
		$Control/CardNumber.text = "%s/%s" % [card_num[0], card_num[1]]
		
	else:
		# Show Card image if in 1~13
		if card_num[0] >= 1 and card_num[0] <= 13:
			$Control/CardNumber.text = ""
			var image_path = "res://assets/sprites/cards/%s-%d.png" % [suit_name, card_num[0]]
			var card_texture = ResourceLoader.load(image_path)
			if card_texture:
				card_image.texture = card_texture
			else:
				print("Failed to load card image at: ", image_path)
		# Show Card24
		elif card_num[0] == 24:
			$Control/CardNumber.text = ""
			var card_texture = ResourceLoader.load("res://assets/sprites/cards/card24.png")
			if card_texture:
				card_image.texture = card_texture
			else:
				print("Failed to load card24 image")
		# Show CardNumber if not in 1~13 after operations
		else:
			card_image.texture = null
			$Control/CardNumber.add_theme_font_size_override("font_size", 128)
			$Control/CardNumber.text = str(card_num[0])
	return self


func flip():
	$AnimationPlayer.play("card_flip")

# Hover on mouse entered or selected
func hover():
	if not is_interactive:
		return
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT)
	tween_hover.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)


# Reset scale on mouse exited or deselected
func cancel_hover():
	if not is_interactive:
		return
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT)
	tween_hover.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)


func select() -> void:
	if is_interactive:
		hover()
		is_selected = true
		$Border.visible = true
		card_selected.emit(self)


func deselect() -> void:
	if is_interactive:
		cancel_hover()
		is_selected = false
		$Border.visible = false
		card_deselected.emit(self)


func _on_area_2d_mouse_entered() -> void:
	hover()


func _on_area_2d_mouse_exited() -> void:
	if not is_selected:
		cancel_hover()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_selected:
			deselect()
		else:
			select()
