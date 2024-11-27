extends Control

@onready var window_container = $WindowContainer
@export var make24: PackedScene

func _on_math_24_button_pressed() -> void:
	if not make24:
		return
	var make24_instance = make24.instantiate()
	window_container.add_child(make24_instance)
