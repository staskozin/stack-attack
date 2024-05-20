extends Node2D


@export var speed: int = 200

var to_right: bool = true
var drop_to_column: int
var drop_position: int
var dropped: bool = false
var box_color: String
var selected_box: String
var choices: Dictionary = {
	"box": spawn_box,
	"metal_box": spawn_metal_box
}


func _ready() -> void:
	to_right = randi() & 1
	position.x = -121 if to_right else 2041
	drop_to_column = Field.get_legal_columns().pick_random()
	drop_position = Field.get_tile_position(Vector2i(drop_to_column, 0)).x
	# Решаем что дропнуть
	var roll: float = randf()
	if roll <= 0.83:
		selected_box = "box"
		box_color = ["brown", "red", "green", "blue", "purple"].pick_random()
	else:
		selected_box = "metal_box"
		box_color = "metal"
	%BoxTexture.texture = ResourceLoader.load("res://assets/sprites/box/" + box_color + str(randi_range(0, 3)) + ".png")


func _physics_process(delta: float) -> void:
	if to_right:
		position.x += speed * delta
		if not dropped and position.x >= drop_position:
			if Field.get_legal_columns().has(drop_to_column) \
			and Field.is_col_has_empty_slot(drop_to_column):
				drop()
			else:
				var sliced: Array
				sliced = Field.get_legal_columns().slice(drop_to_column + 1)
				if sliced.is_empty():
					dropped = true
				else:
					drop_to_column = sliced.pick_random()
		if position.x >= 2141:
			queue_free()
	else:
		position.x -= speed * delta
		if  not dropped and position.x <= drop_position:
			if Field.get_legal_columns().has(drop_to_column) \
			and Field.is_col_has_empty_slot(drop_to_column):
				drop()
			else:
				var sliced: Array
				sliced = Field.get_legal_columns().slice(0, drop_to_column)
				if sliced.is_empty():
					dropped = true
				else:
					drop_to_column = sliced.pick_random()
		if position.x <= -221:
			queue_free()


func drop() -> void:
	dropped = true
	%AnimationPlayer.play("drop")
	%BoxTexture.visible = false
	$CollisionShape.queue_free()
	choices[selected_box].call(drop_to_column)


func spawn_box(col: int) -> void:
	var box: Box = preload("res://scenes/box.tscn").instantiate()
	box.get_node("Texture").texture = %BoxTexture.texture
	box.get_node("Explosion").texture = ResourceLoader.load("res://assets/sprites/box/" + box_color + str(3) + ".png")
	box.color = box_color
	box.position = Vector2(Field.start_x + Field.tile_size * col, Field.start_y)
	box.x = col
	box.y = 0
	box.to_x = col
	box.to_y = 0
	Field.field[box.x][box.y] = box
	get_tree().root.get_node("Main/Boxes").add_child(box)


func spawn_metal_box(col: int) -> void:
	var box: MetalBox = preload("res://scenes/metal_box.tscn").instantiate()
	box.get_node("Texture").texture = %BoxTexture.texture
	box.get_node("Explosion").texture = ResourceLoader.load("res://assets/sprites/box/metal" + str(3) + ".png")
	box.color = "metal"
	box.position = Vector2(Field.start_x + Field.tile_size * col, Field.start_y)
	box.x = col
	box.y = 0
	box.to_x = col
	box.to_y = 0
	Field.field[box.x][box.y] = box
	get_tree().root.get_node("Main/Boxes").add_child(box)
