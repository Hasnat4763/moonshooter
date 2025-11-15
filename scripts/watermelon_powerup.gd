extends Area2D
var SPEED = 200
signal watermelon
@export var game_running = false

func _process(delta: float) -> void:
	if game_running:
		position.y += delta * SPEED
		if position.y >= 650:
			queue_free()

func _on_watermelon_hit(area: Area2D) -> void:
	if area.is_in_group("laser"):
		watermelon.emit()
		area.queue_free()
		queue_free()
