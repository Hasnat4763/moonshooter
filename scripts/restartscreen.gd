extends Control

signal goback

func _on_button_pressed() -> void:
	goback.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
