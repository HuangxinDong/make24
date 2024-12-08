extends Control


@export var make24: PackedScene
@onready var window_container: Control = $WindowContainer

var make24_instance: Node2D

func _process(delta: float) -> void:
	pass

func _on_math_24_button_pressed() -> void:
	# avoid opening duplicate windows
	for child in window_container.get_children():
		if child.name == "make24":
			return
	make24_instance = make24.instantiate()
	window_container.add_child(make24_instance)
