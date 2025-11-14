extends CharacterBody2D


const SPEED = 300.0

func _physics_process(_delta: float) -> void:

	var direction_vertical := Input.get_axis("ui_left", "ui_right")
	var direction_horizontal := Input.get_axis("ui_up", "ui_down")
	if direction_vertical:
		velocity.x = direction_vertical * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction_horizontal:
		velocity.y = direction_horizontal * SPEED
	else:
		velocity.y = move_toward(velocity.y , 0 , SPEED)

	move_and_slide()
