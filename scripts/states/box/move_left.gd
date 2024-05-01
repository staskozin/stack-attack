class_name BoxMoveLeft
extends BoxState


func physics_update(delta: float) -> void:
	if root.x > root.to_x:
		root.position.x -= root.speed * delta
		if root.position.x <= Field.get_tile_position(Vector2(root.to_x, root.y)).x:
			Field.move(root, Vector2i(root.x - 1, root.y))
	elif root.y < root.to_y:
		root.position.x = Field.get_tile_position(Vector2(root.x, root.y)).x
		transitioned.emit(self, "MoveDown")
	else:
		transitioned.emit(self, "Idle")
