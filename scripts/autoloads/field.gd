extends Node


var field: Array[Array]
var width: int = 12
var height: int = 7
var start_x: int = 256
var start_y: int = 120
var tile_size: int = 128
var legal_columns: Array = range(0, width)


func _ready() -> void:
	reset()


func reset() -> void:
	field.resize(width)
	for i in range(width):
		field[i] = []
		field[i].resize(height)
	legal_columns = range(0, width)


func get_tile_position(v: Vector2i) -> Vector2i:
	return Vector2i(start_x + tile_size * v.x, start_y + tile_size * v.y)


func move(object: AnimatableBody2D, to: Vector2i) -> void:
	to = to.clamp(Vector2i(0, 0), Vector2i(width - 1, height - 1))
	if Field.field[to.x][to.y] == null:
		Field.field[object.x][object.y] = null
		Field.field[to.x][to.y] = object
		object.x = to.x
		object.y = to.y
	else:
		object.destroy()


# Уничтожение ящиков
# TODO: подумать как начислять очки

func destroy_matching_boxes() -> void:
	for b in get_matching_boxes():
		b.destroy()


func get_matching_boxes() -> Array[Box]:
	var boxes: Array[Box] = []
	for col in field:
		if col[height - 1] == null or not col[height - 1] is Box:
			return []
		boxes.append(col[height - 1])
	return boxes


# Проверки на пустоту

func is_top_empty(v: Vector2i) -> bool:
	if v.y - 1 < 0:
		return false
	return field[v.x][v.y - 1] == null


func is_top_right_empty(v: Vector2i) -> bool:
	if v.x + 1 >= width or v.y - 1 < 0:
		return false
	return field[v.x + 1][v.y - 1] == null


func is_right_empty(v: Vector2i) -> bool:
	if v.x + 1 >= width:
		return false
	return field[v.x + 1][v.y] == null


func is_bottom_right_empty(v: Vector2i) -> bool:
	if v.x + 1 >= width or v.y + 1 >= height:
		return false
	return field[v.x + 1][v.y + 1] == null


func is_bottom_empty(v: Vector2i) -> bool:
	if v.y + 1 >= height:
		return false
	return field[v.x][v.y + 1] == null


func is_bottom_left_empty(v: Vector2i) -> bool:
	if v.y + 1 >= height or v.x - 1 < 0:
		return false
	return field[v.x - 1][v.y + 1] == null


func is_left_empty(v: Vector2i) -> bool:
	if v.x - 1 < 0:
		return false
	return field[v.x - 1][v.y] == null


func is_top_left_empty(v: Vector2i) -> bool:
	if v.y - 1 < 0 or v.x - 1 < 0:
		return false
	return field[v.x - 1][v.y - 1] == null


# Проверки на состояние клетки

func is_top_in_state(v: Vector2i, states: Array[String]) -> bool:
	if v.y - 1 < 0 or field[v.x][v.y - 1] == null:
		return false
	for s in states:
		if field[v.x][v.y - 1].is_in_state(s):
			return true
	return false


func is_top_right_in_state(v: Vector2i, states: Array[String]) -> bool:
	if v.x + 1 >= width or v.y - 1 < 0 or field[v.x + 1][v.y - 1] == null:
		return false
	for s in states:
		if field[v.x + 1][v.y - 1].is_in_state(s):
			return true
	return false


func is_right_in_state(v: Vector2i, states: Array[String]) -> bool:
	if v.x + 1 >= width or field[v.x + 1][v.y] == null:
		return false
	for s in states:
		if field[v.x + 1][v.y].is_in_state(s):
			return true
	return false


func is_bottom_right_in_state(v: Vector2i, states: Array[String]) -> bool:
	if v.x + 1 >= width or v.y + 1 >= height or field[v.x + 1][v.y + 1] == null:
		return false
	for s in states:
		if field[v.x + 1][v.y + 1].is_in_state(s):
			return true
	return false


func is_bottom_in_state(v: Vector2i, states: Array[String]) -> bool:
	if v.y + 1 >= height or field[v.x][v.y + 1] == null:
		return false
	for s in states:
		if field[v.x][v.y + 1].is_in_state(s):
			return true
	return false


func is_bottom_left_in_state(v: Vector2i, states: Array[String]) -> bool:
	if v.x - 1 < 0 or v.y + 1 >= height or field[v.x - 1][v.y + 1] == null:
		return false
	for s in states:
		if field[v.x - 1][v.y + 1].is_in_state(s):
			return true
	return false


func is_left_in_state(v: Vector2i, states: Array[String]) -> bool:
	if v.x - 1 < 0 or field[v.x - 1][v.y] == null:
		return false
	for s in states:
		if field[v.x - 1][v.y].is_in_state(s):
			return true
	return false


func is_top_left_in_state(v: Vector2i, states: Array[String]) -> bool:
	if v.x - 1 < 0 or v.y - 1 < 0 or field[v.x - 1][v.y - 1] == null:
		return false
	for s in states:
		if field[v.x - 1][v.y - 1].is_in_state(s):
			return true
	return false
