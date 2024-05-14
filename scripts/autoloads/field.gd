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
	for b in get_full_rows_of_boxes():
		b.destroy()
	var clusters: Dictionary = clusterize_boxes_by_color()
	for color in clusters.keys():
		for cluster in clusters[color]:
			if len(cluster) >= 3 and cluster.all(func (b: Box): return b.is_in_state("Idle")):
				for b in cluster:
					b.destroy()


func get_full_rows_of_boxes() -> Array[Box]:
	var boxes: Array[Box] = []
	for row in get_rows():
		if row.all(func (b): return b is Box and b.is_in_state("Idle")):
			boxes.append_array(row)
	return boxes


func get_rows() -> Array:
	var rows: Array = []
	for i in range(height):
		var row: Array = []
		for j in range(width):
			row.append(field[j][i])
		rows.append(row)
	return rows


func clusterize_boxes_by_color() -> Dictionary:
	var visited: Array = []
	var clusters: Dictionary = {}
	for i in range(width):
		visited.append([])
		for j in range(height):
			visited[i].append(false)
	for x in range(width):
		for y in range(height):
			if not visited[x][y] and field[x][y] is Box:
				var color: String = field[x][y].color
				var cluster: Array = []
				dfs(x, y, color, cluster, visited)
				var key: String = str(color)
				if not clusters.has(key):
					clusters[key] = []
				clusters[key].append(cluster)
	return clusters


func dfs(x: int, y: int, color: String, cluster: Array, visited: Array) -> void:
	if x < 0 or x >= width or y < 0 or y >= height or visited[x][y] or not field[x][y] or field[x][y].color != color:
		return
	cluster.append(field[x][y])
	visited[x][y] = true
	for direction in [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]:
		dfs(x + direction.x, y + direction.y, color, cluster, visited)


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
