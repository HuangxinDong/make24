extends Node

@export var desktop_scene: PackedScene
@onready var desktop_instance: Node2D = null
@onready var pause_menu = $PauseMenu
var paused = false


func _ready():
	load_desktop()


func _process(delta: float):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()


# Load desktop.tscn as instance
func load_desktop():
	if desktop_instance == null:
		desktop_instance = desktop_scene.instantiate()
		add_child(desktop_instance)

# Enable pause menu
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused
