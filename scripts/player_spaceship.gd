extends CharacterBody2D


const SPEED = 300.0
var can_shoot: bool = true
@export var laser_scene : PackedScene
@export var cooldown = 0.5

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
		
	if can_shoot and Input.is_action_pressed("ui_accept"):
		shooting()
	move_and_slide()


func shooting():
	can_shoot = false
	var laser = laser_scene.instantiate()
	laser.position = position
	get_tree().current_scene.add_child(laser)
	
	await get_tree().create_timer(cooldown).timeout
	can_shoot = true
