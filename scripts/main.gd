extends Node


var drop_pool: Array[Dictionary] = [
	{
		"object": preload("res://scenes/box/red_box.tscn"),
		"weight": 20
	},
	{
		"object": preload("res://scenes/box/green_box.tscn"),
		"weight": 20
	},
	{
		"object": preload("res://scenes/box/blue_box.tscn"),
		"weight": 20
	},
	{
		"object": preload("res://scenes/box/purple_box.tscn"),
		"weight": 20
	},
	{
		"object": preload("res://scenes/box/brown_box.tscn"),
		"weight": 20
	},
	{
		"object": preload("res://scenes/box/metal_box.tscn"),
		"weight": 20
	},
	{
		"object": preload("res://scenes/box/red_bomb_box.tscn"),
		"weight": 1
	},
	{
		"object": preload("res://scenes/box/green_bomb_box.tscn"),
		"weight": 1
	},
	{
		"object": preload("res://scenes/box/blue_bomb_box.tscn"),
		"weight": 1
	},
	{
		"object": preload("res://scenes/box/purple_bomb_box.tscn"),
		"weight": 1
	},
	{
		"object": preload("res://scenes/box/brown_bomb_box.tscn"),
		"weight": 1
	},
	{
		"object": preload("res://scenes/box/metal_bomb_box.tscn"),
		"weight": 1
	},
	{
		"object": preload("res://scenes/box/mega_bomb_box.tscn"),
		"weight": 0.1
	},
]
var total_weight: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# TODO: делать подсчет весов не тут, а в _ready уровня (режима)
	for drop in drop_pool:
		total_weight += drop["weight"]
		drop["acc_weight"] = total_weight


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		Field.reset()
		SceneLoader.load_scene("res://scenes/main.tscn")


# Спавнер
func _on_spawner_timeout() -> void:
	if not Field.get_legal_columns().is_empty():
		var crane: Node2D = preload("res://scenes/crane.tscn").instantiate()
		crane.init(drop_pool, total_weight)
		%Cranes.add_child(crane)
