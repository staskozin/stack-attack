extends HBoxContainer


@onready var heart: Resource = preload("res://assets/sprites/ui/heart.svg")
@onready var empty_heart: Resource = preload("res://assets/sprites/ui/empty_heart.svg")


func _ready() -> void:
	%Player.health_changed.connect(change_hearts)
	change_hearts(%Player.health)


func change_hearts(h: int) -> void:
	for i in range(1, 4):
		get_node("Heart" + str(i)).texture = heart if i <= h else empty_heart
