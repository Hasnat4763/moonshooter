extends Area2D
var SPEED = 200
signal hit
signal passed
@export var game_running = false

func _process(delta: float) -> void:
	if game_running:
		position.y += delta * SPEED
		if position.y >= 650:
			passed.emit()
			queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	if area.name == "laser":
		hit.emit()
		area.queue_free()
		queue_free()
