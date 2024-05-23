extends Node2D


@export var speed: int = 200

var to_right: bool = true
var drop_to_column: int
var drop_position: int
var dropped: bool = false
var selected: Box


func _ready() -> void:
	to_right = randi() & 1
	position.x = -121 if to_right else 2041
	drop_to_column = Field.get_legal_columns().pick_random()
	drop_position = Field.get_tile_position(Vector2i(drop_to_column, 0)).x


func _physics_process(delta: float) -> void:
	if to_right:
		position.x += speed * delta
		if not dropped and position.x >= drop_position:
			if Field.get_legal_columns().has(drop_to_column) \
			and Field.is_col_has_empty_slot(drop_to_column):
				drop(drop_to_column)
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
				drop(drop_to_column)
			else:
				var sliced: Array
				sliced = Field.get_legal_columns().slice(0, drop_to_column)
				if sliced.is_empty():
					dropped = true
				else:
					drop_to_column = sliced.pick_random()
		if position.x <= -221:
			queue_free()


func init(drop_pool: Array[Dictionary], total_weight: float) -> void:
	var roll: float = randf_range(0.0, total_weight)
	for d in drop_pool:
		if d["acc_weight"] > roll:
			selected = d["object"].instantiate()
			break
	selected.init()
	%BoxTexture.texture = selected.texture


func drop(col: int) -> void:
	dropped = true
	%AnimationPlayer.play("drop")
	%BoxTexture.visible = false
	$CollisionShape.queue_free()
	selected.position = Vector2(Field.start_x + Field.tile_size * col, Field.start_y)
	selected.x = col
	selected.y = 0
	selected.to_x = col
	selected.to_y = 0
	Field.field[selected.x][selected.y] = selected
	get_tree().root.get_node("Main/Boxes").add_child(selected)
