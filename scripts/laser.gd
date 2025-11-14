extends Area2D

@export var SPEED := 900


func _process(delta: float) -> void:
	position.y -= delta * SPEED
	if position.y < -50:
		queue_free()
