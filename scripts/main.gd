extends Node


var legal_columns: Array = range(0, 12)


func _ready() -> void:
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	for c in $Columns.get_children():
		c.col_filled.connect(_on_column_filled)
		c.col_freed.connect(_on_column_freed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		Field.reset()
		SceneLoader.load_scene("res://scenes/main.tscn")


# Спавнер
func spawn_box() -> void:
	var box: AnimatableBody2D = preload("res://scenes/box.tscn").instantiate()
	var picked_col: int = legal_columns.pick_random()
	box.position = Vector2(Field.start_x + Field.tile_size * picked_col, Field.start_y)
	box.x = picked_col
	box.y = 0
	box.to_x = picked_col
	box.to_y = 0
	%Boxes.add_child(box)
	Field.field[box.x][box.y] = box


func _on_spawner_timeout() -> void:
	if not legal_columns.is_empty():
		spawn_box()


# Проверка на возможность спавна в столбце
func _on_column_filled(n: int) -> void:
	legal_columns.erase(n)


func _on_column_freed(n: int) -> void:
	legal_columns.append(n)
