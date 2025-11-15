extends Area2D
@export var SPEED := 400
func _process(delta: float) -> void:
	position.y -= delta * SPEED
	if position.y < 0:
		queue_free()
