extends Node

@export var start_menu: PackedScene
@export var desktop_scene: PackedScene
@onready var pause_menu = $PauseMenu
var paused = false

func startMenu():
	# Create a new instance of the startmenu.
	var start = start_menu.instantiate()
	add_child(start)
	start.connect("play_pressed", Callable(self, "_on_play_button_pressed"))

func _on_play_button_pressed() -> void:
	# 加载 desktop_scene
	var desktop = desktop_scene.instantiate()
	add_child(desktop)
	
func _ready():
	startMenu()
	
func _process(delta: float):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused
