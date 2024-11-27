extends Control


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func get_main_node():
	return get_tree().root.get_child(0)
	
# Press Resume Button
func _on_resume_button_pressed() -> void:
	var main = get_main_node()
	if main:
		main.pauseMenu()

# Press Options Button
func _on_options_button_pressed() -> void:
	pass # to do

# Press Quit Button
func _on_quit_button_pressed() -> void:
	get_tree().quit()
