class_name Box
extends AnimatableBody2D


@export var speed: int = 200
## Если ящик тяжелый, то его нельзя толкать
@export var is_heavy: bool = false
@export var textures: Array[CompressedTexture2D]
@export var explosion_texture: CompressedTexture2D
## Уникален для каждого ящика во всей игре
@export var color: String

var x: int
var y: int
var to_x: int
var to_y: int
var player_on_left: bool = false
var player_on_right: bool = false
var player: Player = null
var texture: CompressedTexture2D


func _ready() -> void:
	%LeftSide.body_entered.connect(_on_left_side_body_entered)
	%RightSide.body_entered.connect(_on_right_side_body_entered)
	%LeftSide.body_exited.connect(_on_left_side_body_exited)
	%RightSide.body_exited.connect(_on_right_side_body_exited)
	$Texture.texture = texture
	$Explosion.texture = explosion_texture


func init():
	texture = textures.pick_random()


func destroy() -> void:
	%StateMachine.current_state.transitioned.emit(%StateMachine.current_state, "exploding")


func _physics_process(_delta: float) -> void:
	$DEBUG/Position.text = str(position)
	$DEBUG/State.text = %StateMachine.current_state.name
	$DEBUG/FieldPos.text = "(" + str(x) + ", " + str(y) + ")"
	$DEBUG/ToFieldPos.text = "(" + str(to_x) + ", " + str(to_y) + ")"


func is_in_state(state: String) -> bool:
	if not %StateMachine.current_state:
		return false
	return %StateMachine.current_state.name.to_lower() == state.to_lower()


func _on_bottom_side_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player" and not player_on_left and not player_on_right:
		destroy()
		if body.destroy_timer <= 0.0:
			body.hit()


func _on_left_side_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		player_on_left = true
		player = body


func _on_right_side_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		player_on_right = true
		player = body


func _on_left_side_body_exited(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		player_on_left = false
		player = null


func _on_right_side_body_exited(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		player_on_right = false
		player = null
