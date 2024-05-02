class_name BoxExploding
extends BoxState


func enter() -> void:
	var collision_shape: CollisionShape2D = root.get_node_or_null("CollisionShape")
	if collision_shape:
		collision_shape.queue_free()
	%BottomSide.queue_free()
	%LeftSide.queue_free()
	%RightSide.queue_free()
	Field.field[root.x][root.y] = null
	root.get_node("Texture").visible = false
	root.get_node("Explosion").emitting = true
	await get_tree().create_timer(0.3).timeout
	root.queue_free()
