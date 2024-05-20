class_name MetalBoxIdle
extends MetalBoxState


func enter() -> void:
	root.position = Field.get_tile_position(Vector2i(root.x, root.y))
	Field.destroy_matching_boxes()


func physics_update(_delta: float) -> void:
	var coords: Vector2i = Vector2i(root.x, root.y)
	if not Field.is_bottom_left_in_state(coords, ["MoveRight"]) \
	and not Field.is_bottom_right_in_state(coords, ["MoveLeft"]) \
	and (Field.is_bottom_empty(coords) \
	or Field.is_bottom_in_state(coords, ["MoveDown"])):
		root.to_y += 1
		transitioned.emit(self, "MoveDown")
