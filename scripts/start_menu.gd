extends Control

signal play_pressed

func _on_play_button_pressed() -> void:
	emit_signal("play_pressed")
	hide()

# Press Options Button
func _on_options_button_pressed() -> void:
	pass # to do

# Press Quit Button
func _on_quit_button_pressed() -> void:
	get_tree().quit()
