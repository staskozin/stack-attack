extends CharacterBody2D


signal health_changed(h: int)


@export var speed: float = 200.0
@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float


var health: int = 3
var destroy_timer: float = 0.0


var _jump_buffer: float = 0.0
var _coyote_time: float = 0.0
var _stunned: float = 0.0
var _on_floor: bool = false

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0


func _ready() -> void:
	$AnimationPlayer.get_animation("rotate").loop_mode = Animation.LOOP_LINEAR


func _physics_process(delta: float) -> void:
	# Передвижение по горизонтали
	if not _stunned:
		velocity.x = _get_input_velocity() * speed
	# Прыжок и гравитация
	velocity.y += _get_gravity() * delta
	if is_on_floor():
		if _jump_buffer > 0.0 or (Input.is_action_just_pressed("input_up") and not _stunned):
			jump()
			_jump_buffer = 0.0
		_coyote_time = 0.0
		_on_floor = true
	else:
		if _on_floor:
			_coyote_time = 0.1
			_jump_buffer = 0.0
		if _coyote_time > 0.0 and (Input.is_action_just_pressed("input_up") and not _stunned):
			jump()
			_coyote_time = 0.0
		if (Input.is_action_just_pressed("input_up") and not _stunned):
			_jump_buffer = 0.1
			_coyote_time = 0.0
		_on_floor = false
	if _jump_buffer > 0.0:
		_jump_buffer -= delta
	if _coyote_time > 0.0:
		_coyote_time -= delta
	if destroy_timer > 0.0:
		destroy_timer -= delta
	if _stunned > 0.0:
		_stunned -= delta
	else:
		%StunParticles.visible = false
		%StunParticles.emitting = false
		$AnimationPlayer.stop()
		%Eyes.visible = false
		_stunned = 0.0
	move_and_slide()


func jump() -> void:
	destroy_timer = jump_time_to_peak
	velocity.y = jump_velocity


func hit() -> void:
	health -= 1
	health_changed.emit(health)
	if health > 0:
		stun()
	else:
		die()


func stun() -> void:
	if not _stunned:
		velocity = Vector2.ZERO
		%Sprite.play("stun")
		%Eyes.visible = true
		$AnimationPlayer.play("rotate")
		%StunParticles.restart()
		%StunParticles.visible = true
		%StunParticles.emitting = true
	_stunned = 2.0


func die() -> void:
	_stunned = 2.0
	velocity = Vector2.ZERO
	%Sprite.visible = false
	%StunParticles.visible = false
	%DeathParticles.emitting = true
	%Eyes.visible = false
	await get_tree().create_timer(1.5).timeout
	queue_free()


func _get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func _get_input_velocity() -> float:
	var horizontal: float = 0.0
	if Input.is_action_pressed("input_left"):
		%Sprite.play("walk")
		%Sprite.flip_h = true
		horizontal -= 1.0
	elif Input.is_action_pressed("input_right"):
		%Sprite.play("walk")
		%Sprite.flip_h = false
		horizontal += 1.0
	else:
		%Sprite.play("default")
		%Sprite.flip_h = false
	return horizontal
