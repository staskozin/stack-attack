extends Area2D


var counter: int = 0
var boxes: Array = []


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("box"):
		counter += 1
		boxes.append(body)


func _on_body_exited(body: PhysicsBody2D) -> void:
	if body.is_in_group("box"):
		counter -= 1
		boxes.erase(body)


func _on_area_2d_body_entered(_body: PhysicsBody2D) -> void:
	if counter >= 12:
		for b in boxes:
			b.destroy()
