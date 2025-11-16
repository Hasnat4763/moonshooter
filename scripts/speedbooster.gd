extends Area2D
signal speedboost
var SPEED = 300
@export var game_running = false

func _process(delta: float) -> void:
	if game_running:
		position.y += delta * SPEED
		if position.y >= 700:
			queue_free()

func _on_speedbooster(area: Area2D) -> void:
	if area.is_in_group("player"):
		speedboost.emit()
		queue_free()
