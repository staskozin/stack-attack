extends Node


func _ready() -> void:
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		Field.reset()
		SceneLoader.load_scene("res://scenes/main.tscn")


# Спавнер
func _on_spawner_timeout() -> void:
	if not Field.legal_columns.is_empty():
		var crane: Node2D = preload("res://scenes/crane.tscn").instantiate()
		%Cranes.add_child(crane)
