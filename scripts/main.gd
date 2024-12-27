extends Node

@onready var desktop = $Desktop
@onready var pause_menu = $CanvasLayer/PauseMenu


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	desktop.visible = true
	pause_menu.hide()
	Database.load_data()
	

func _input(event):
	if event.is_action_pressed("pause"):
		$PauseSound.play()
		pauseMenu()


func _process(delta: float):
	pass


# Enable pause menu
func pauseMenu():
	if get_tree().paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	get_tree().paused = !get_tree().paused
