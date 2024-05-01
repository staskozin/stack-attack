extends Area2D


signal col_filled(n: int)
signal col_freed(n: int)

@export var num: int

var stored: int = 0
var is_free: bool = true


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("box"):
		stored += 1
	if stored >= 6:
		col_filled.emit(num)
		is_free = false


func _on_body_exited(body: PhysicsBody2D) -> void:
	if body.is_in_group("box"):
		stored -= 1
	if stored < 6 and not is_free:
		col_freed.emit(num)
		is_free = true
