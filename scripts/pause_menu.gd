extends Control


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func get_main_node():
	for child in get_tree().root.get_children():
		if child.name == "Main":
			return child
		else:
			print("Cannot find main")
	
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
	Database.save_data()
	get_tree().quit()
