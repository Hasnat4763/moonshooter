extends CanvasLayer
signal play

func _on_play_pressed() -> void:
	play.emit()


func _on_stop_pressed() -> void:
	get_tree().quit()
