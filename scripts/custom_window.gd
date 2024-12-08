extends CharacterBody2D

signal window_closed

@export var window_name := "Window"

var offset = Vector2()
var dragging = false
var mouse_in = false


func _ready():
	# customize window's name
	$NinePatchRect/Label.text = window_name


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && mouse_in:
			dragging = true
			offset = get_local_mouse_position()  # 记录偏移量
		elif not event.is_pressed():
			dragging = false


func _physics_process(delta):
	if dragging:
		position = get_global_mouse_position() - offset  # 更新窗口位置


 # Set these two functions through the Area2D Signals
func mouse_entered():
	mouse_in = true


func mouse_exited():
	mouse_in = false


# close button
func _on_close_pressed():
	window_closed.emit()
	get_parent().remove_child(self)
	self.queue_free()
