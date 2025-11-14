extends Control

signal goback

func _on_button_pressed() -> void:
	goback.emit()
