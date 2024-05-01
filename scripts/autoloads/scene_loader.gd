class_name SceneLoaderAutoload
extends Node
## Глобальный переключатель сцен.


## Текущая сцена, по дефолту здесь будет главное меню.
var current: Node


func _ready() -> void:
	var root: Window = get_tree().root
	current = root.get_child(root.get_child_count() - 1)


## Загружает любую сцену по заданному пути.
func load_scene(scene: String) -> void:
	_change_scene.call_deferred(scene)


## Базовая функция для загрузки сцен.
func _change_scene(scene: String) -> void:
	get_tree().paused = false
	current.free()
	var s: Resource = ResourceLoader.load(scene)
	current = s.instantiate()
	get_tree().root.add_child(current)
	get_tree().current_scene = current
