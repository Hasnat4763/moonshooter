extends Area2D
signal hit
signal passed
@export var game_running = false
@export var SPEED = 150
func _process(delta: float) -> void:
	if game_running:
		position.y += delta * SPEED
		if position.y >= 650:
			passed.emit()
			queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("laser"):
		hit.emit()
		area.queue_free()
		queue_free()
