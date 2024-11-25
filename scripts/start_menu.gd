extends Control
signal game_started

func _ready():
	$VBoxContainer/PlayButton.grab_focus()

func _on_play_button_mouse_entered() -> void:
	$VBoxContainer/PlayButton.grab_focus()

func _on_options_button_mouse_entered() -> void:
	$VBoxContainer/OptionsButton.grab_focus()

func _on_quit_button_mouse_entered() -> void:
	$VBoxContainer/QuitButton.grab_focus()

func _on_play_button_pressed() -> void:
	emit_signal("game_started")
	get_tree().change_scene_to_file("res://scenes/main.tscn")

# Press Options Button
func _on_options_button_pressed() -> void:
	pass # to do

# Press Quit Button
func _on_quit_button_pressed() -> void:
	get_tree().quit()
