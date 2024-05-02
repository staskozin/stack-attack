class_name BoxIdle
extends BoxState


func enter() -> void:
	root.position = Field.get_tile_position(Vector2i(root.x, root.y))
	%LeftSide.body_entered.connect(_on_left_side_body_entered)
	%RightSide.body_entered.connect(_on_right_side_body_entered)


func exit() -> void:
	%LeftSide.body_entered.disconnect(_on_left_side_body_entered)
	%RightSide.body_entered.disconnect(_on_right_side_body_entered)


func physics_update(_delta: float) -> void:
	var coords: Vector2i = Vector2i(root.x, root.y)
	if not Field.is_bottom_left_in_state(coords, ["MoveRight"]) \
	and not Field.is_bottom_right_in_state(coords, ["MoveLeft"]) \
	and (Field.is_bottom_empty(coords) \
	or Field.is_bottom_in_state(coords, ["MoveDown"])):
		root.to_y += 1
		transitioned.emit(self, "MoveDown")


func _on_right_side_body_entered(body: PhysicsBody2D) -> void:
	if body.name != "Player":
		return
	var coords: Vector2i = Vector2i(root.x, root.y)
	if Field.is_top_left_in_state(coords, ["MoveDown"]) \
	or not Field.is_top_empty(coords) \
	and Field.is_top_in_state(coords, ["Idle", "MoveRight", "MoveLeft"]):
		return
	if (Field.is_left_empty(coords) \
	or Field.is_left_in_state(coords, ["MoveLeft"])) \
	and (Field.is_top_left_empty(coords) \
	or Field.is_top_left_in_state(coords, ["MoveLeft"])):
		root.to_x -= 1
		transitioned.emit(self, "MoveLeft")


func _on_left_side_body_entered(body: PhysicsBody2D) -> void:
	if body.name != "Player":
		return
	var coords: Vector2i = Vector2i(root.x, root.y)
	if Field.is_top_right_in_state(coords, ["MoveDown"]) \
	or not Field.is_top_empty(coords) \
	and Field.is_top_in_state(coords, ["Idle", "MoveRight", "MoveLeft"]):
		return
	if (Field.is_right_empty(coords) \
	or Field.is_right_in_state(coords, ["MoveRight"])) \
	and (Field.is_top_right_empty(coords) \
	or Field.is_top_right_in_state(coords, ["MoveRight"])):
		root.to_x += 1
		transitioned.emit(self, "MoveRight")
