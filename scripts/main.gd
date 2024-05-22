extends Node


var drop_pool: Array[Dictionary] = [
	{
		"object": preload("res://scenes/box/red_box.tscn"),
		"weight": 1
	},
	{
		"object": preload("res://scenes/box/green_box.tscn"),
		"weight": 1
	},
	{
		"object": preload("res://scenes/box/blue_box.tscn"),
		"weight": 1
	},
	{
		"object": preload("res://scenes/box/purple_box.tscn"),
		"weight": 1
	},
	{
		"object": preload("res://scenes/box/brown_box.tscn"),
		"weight": 1
	},
	{
		"object": preload("res://scenes/box/metal_box.tscn"),
		"weight": 1
	},
]


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		Field.reset()
		SceneLoader.load_scene("res://scenes/main.tscn")


# Спавнер
func _on_spawner_timeout() -> void:
	if not Field.get_legal_columns().is_empty():
		var crane: Node2D = preload("res://scenes/crane.tscn").instantiate()
		crane.init(drop_pool)
		%Cranes.add_child(crane)
