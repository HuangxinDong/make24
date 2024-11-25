extends CanvasLayer

@onready var main = $"../"

# Resume the game
func _on_ResumeButton_pressed():
	main.pauseMenu()

# Press Options Button
func _on_options_button_pressed() -> void:
	pass # to do

# Press Quit Button
func _on_quit_button_pressed() -> void:
	get_tree().quit()
