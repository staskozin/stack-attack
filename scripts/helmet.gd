extends Sprite2D


@export var side: bool = false:
	set(value):
		if value:
			texture = cracked_helmet_side if is_cracked else helmet_side
			position.x = -4 if flip_h else 4
		else:
			texture = cracked_helmet if is_cracked else helmet
			position.x = 0
		side = value


var helmet: Texture2D = preload("res://assets/sprites/player/helmet.png")
var helmet_side: Texture2D = preload("res://assets/sprites/player/helmet_side.png")
var cracked_helmet: Texture2D = preload("res://assets/sprites/player/cracked_helmet.png")
var cracked_helmet_side: Texture2D = preload("res://assets/sprites/player/cracked_helmet_side.png")
var is_cracked: bool = false


func _ready() -> void:
	get_parent().health_changed.connect(change)
	change(get_parent().health)


func change(h: int) -> void:
	if h >= 3:
		visible = true
		texture = helmet_side if side else helmet
		is_cracked = false
	elif h == 2:
		visible = true
		texture = cracked_helmet_side if side else cracked_helmet
		is_cracked = true
	else:
		visible = false
