@tool
extends Node


@export var count: int = 1
@export var delay: float = 0.0

var next: int = 0
var audio_stream_players: Array[AudioStreamPlayer] = []
var _delay: float = 0.0


func _ready() -> void:
	if get_child_count() == 0:
		return
	var child: AudioStreamPlayer = get_child(0)
	if child is AudioStreamPlayer:
		audio_stream_players.append(child)
		for i in range(count):
			var d: AudioStreamPlayer = child.duplicate()
			add_child(d)
			audio_stream_players.append(d)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if get_child_count() == 0:
		warnings.append("No AudioStreamPlayer child found")
	if not get_child(0) is AudioStreamPlayer:
		warnings.append("Expected first child to be AudioStreamPlayer")
	return warnings


func _physics_process(delta: float) -> void:
	if _delay > 0:
		_delay -= delta


func play() -> void:
	if !audio_stream_players[next].playing and _delay <= 0:
		audio_stream_players[next].play()
		next += 1
		next %= len(audio_stream_players)
		_delay = delay
