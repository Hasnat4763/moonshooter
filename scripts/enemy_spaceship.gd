extends Area2D

var SPEED = 200

func _process(delta: float) -> void:
	position.y += delta * SPEED
	pass
