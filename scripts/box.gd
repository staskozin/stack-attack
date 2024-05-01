extends AnimatableBody2D


@export var speed: int = 200

var x: int
var y: int
var to_x: int
var to_y: int


func _ready() -> void:
	$Texture.texture = ResourceLoader.load("res://assets/box" + str(randi_range(1, 3)) + ".png")


func destroy() -> void:
	%StateMachine.current_state.transitioned.emit(%StateMachine.current_state, "exploding")


func _physics_process(_delta: float) -> void:
	$DEBUG/Position.text = str(position)
	$DEBUG/State.text = %StateMachine.current_state.name
	$DEBUG/FieldPos.text = "(" + str(x) + ", " + str(y) + ")"
	$DEBUG/ToFieldPos.text = "(" + str(to_x) + ", " + str(to_y) + ")"


func is_in_state(state: String) -> bool:
	return $StateMachine.current_state.name.to_lower() == state.to_lower()


func _on_bottom_side_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		destroy()
