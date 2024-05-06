extends Node2D


@export var speed: int = 200

var to_right: bool = true
var drop_to_column: int
var drop_position: int
var dropped: bool = false


func _ready() -> void:
	to_right = randi() & 1
	position.x = -121 if to_right else 2041
	drop_to_column = Field.legal_columns.pick_random()
	drop_position = Field.get_tile_position(Vector2i(drop_to_column, 0)).x
	%BoxTexture.texture = ResourceLoader.load("res://assets/box" + str(randi_range(1, 4)) + ".png")


func _physics_process(delta: float) -> void:
	if to_right:
		position.x += speed * delta
		if not dropped and position.x >= drop_position:
			if Field.legal_columns.has(drop_to_column):
				spawn_box()
			else:
				var sliced: Array
				sliced = Field.legal_columns.slice(drop_to_column + 1)
				if sliced.is_empty():
					dropped = true
				else:
					drop_to_column = sliced.pick_random()
		if position.x >= 2041:
			queue_free()
	else:
		position.x -= speed * delta
		if  not dropped and position.x <= drop_position:
			if Field.legal_columns.has(drop_to_column):
				spawn_box()
			else:
				var sliced: Array
				sliced = Field.legal_columns.slice(0, drop_to_column)
				if sliced.is_empty():
					dropped = true
				else:
					drop_to_column = sliced.pick_random()
		if position.x <= -121:
			queue_free()


func spawn_box() -> void:
	dropped = true
	%AnimationPlayer.play("drop")
	%BoxTexture.visible = false
	$CollisionShape.queue_free()
	var box: AnimatableBody2D = preload("res://scenes/box.tscn").instantiate()
	box.get_node("Texture").texture = %BoxTexture.texture
	box.position = Vector2(Field.start_x + Field.tile_size * drop_to_column, Field.start_y)
	box.x = drop_to_column
	box.y = 0
	box.to_x = drop_to_column
	box.to_y = 0
	Field.field[box.x][box.y] = box
	get_tree().root.get_node("Main/Boxes").add_child(box)
