extends Control


@export var make24: PackedScene
var make24_instance: Node2D = null

func _on_math_24_button_pressed() -> void:
	if not make24:
		return
	var make24_instance = make24.instantiate()
	add_child(make24_instance)
