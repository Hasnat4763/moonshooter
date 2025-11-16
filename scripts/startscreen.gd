extends Control

signal start
signal custom
signal not_custom

func start_button_pressed() -> void:
	start.emit()



func _on_custom_toggled(toggled_on: bool) -> void:
	if toggled_on:
		var score_target = int($score.text if $score.text != "" else "1")
		var grace = int($grace.text if $grace.text != "" else "1")
		custom.emit(score_target, grace)
	else:
		not_custom.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
