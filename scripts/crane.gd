extends Node2D


@export var speed: int = 200

var to_right: bool = true
var drop_to_column: int
var drop_position: int
var dropped: bool = false
var box_color: String


func _ready() -> void:
	to_right = randi() & 1
	position.x = -121 if to_right else 2041
	drop_to_column = Field.get_legal_columns().pick_random()
	drop_position = Field.get_tile_position(Vector2i(drop_to_column, 0)).x
	var colors = ["brown", "red", "green", "blue", "purple", "metal"]
	box_color = colors.pick_random()
	%BoxTexture.texture = ResourceLoader.load("res://assets/box/" + box_color + str(randi_range(0, 3)) + ".png")


func _physics_process(delta: float) -> void:
	if to_right:
		position.x += speed * delta
		if not dropped and position.x >= drop_position:
			if Field.get_legal_columns().has(drop_to_column) \
			and Field.is_col_has_empty_slot(drop_to_column):
				spawn_box()
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
				spawn_box()
			else:
				var sliced: Array
				sliced = Field.get_legal_columns().slice(0, drop_to_column)
				if sliced.is_empty():
					dropped = true
				else:
					drop_to_column = sliced.pick_random()
		if position.x <= -221:
			queue_free()


func spawn_box() -> void:
	dropped = true
	%AnimationPlayer.play("drop")
	%BoxTexture.visible = false
	$CollisionShape.queue_free()
	var box: AnimatableBody2D = preload("res://scenes/box.tscn").instantiate()
	box.get_node("Texture").texture = %BoxTexture.texture
	box.color = box_color
	box.position = Vector2(Field.start_x + Field.tile_size * drop_to_column, Field.start_y)
	box.x = drop_to_column
	box.y = 0
	box.to_x = drop_to_column
	box.to_y = 0
	Field.field[box.x][box.y] = box
	get_tree().root.get_node("Main/Boxes").add_child(box)
