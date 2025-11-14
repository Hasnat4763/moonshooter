extends Area2D
var SPEED = 200
signal hit
func _process(delta: float) -> void:
	position.y += delta * SPEED
	if position.y >= 700:
		queue_free()
	


func _on_area_entered(area: Area2D) -> void:
	if area.name == "laser":
		hit.emit()
		area.queue_free()
		queue_free()
