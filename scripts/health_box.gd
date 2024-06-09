extends Box


func _ready():
	super._ready()
	%BottomSide.body_entered.connect(_on_bottom_side_body_entered)
	%BottomSide.body_entered.disconnect(_on_any_area_body_entered)


func on_consume() -> void:
	var p: Player = get_tree().get_root().get_node("Main/Player")
	p.health = 3
	p.health_changed.emit(3)


func _on_any_area_body_entered(body: PhysicsBody2D) -> void:
	if body.health < 3:
		super._on_any_area_body_entered(body)


func _on_bottom_side_body_entered(body: PhysicsBody2D) -> void:
	if body.health == 3 \
	and body.name == "Player" \
	and not player_on_left \
	and not player_on_right:
		destroy()
