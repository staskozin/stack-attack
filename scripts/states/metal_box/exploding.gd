class_name MetalBoxExploding
extends MetalBoxState


func enter() -> void:
	var collision_shape: CollisionShape2D = root.get_node_or_null("CollisionShape")
	if collision_shape:
		collision_shape.queue_free()
	%BottomSide.queue_free()
	%LeftSide.queue_free()
	%RightSide.queue_free()
	Field.field[root.x][root.y] = null
	root.get_node("Texture").visible = false
	var explosion: GPUParticles2D = root.get_node("Explosion")
	explosion.emitting = true
	await get_tree().create_timer(explosion.lifetime).timeout
	root.queue_free()
