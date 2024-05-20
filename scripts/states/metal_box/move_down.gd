class_name MetalBoxMoveDown
extends MetalBoxState


func physics_update(delta: float) -> void:
	if root.y < root.to_y:
		root.position.y += root.speed * delta
		if root.position.y >= Field.get_tile_position(Vector2(root.x, root.to_y)).y:
			Field.move(root, Vector2i(root.x, root.y + 1))
			var coords = Vector2i(root.x, root.y)
			if not Field.is_bottom_left_in_state(coords, ["MoveRight"]) \
			and not Field.is_bottom_right_in_state(coords, ["MoveLeft"]) \
			and (Field.is_bottom_empty(coords) \
			or Field.is_bottom_in_state(coords, ["MoveDown"])):
				if Field.is_bottom_empty(coords):
					root.to_y += 1
	else:
		transitioned.emit(self, "Idle")
