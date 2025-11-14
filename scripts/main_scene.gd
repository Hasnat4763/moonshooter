extends Node2D

var game_running = false
var game_won = false
var point = 0
var ship_spawning_interval = 3
var timer = 0
@export var enemy_spaceship_scene : PackedScene
func _ready() -> void:
	$player_spaceship.hide()
	$startscreen.start.connect(start_game)

func _process(delta: float) -> void:
	timer += delta
	if timer >= ship_spawning_interval and game_running:
		spawn_spaceship()
		timer = 0


func start_game():
	game_running = true
	$startscreen.hide()
	$player_spaceship.show()


func spawn_spaceship():
	#var screensize = get_viewport().get_visible_rect().size
	var enemy_spaceship = enemy_spaceship_scene.instantiate()
	enemy_spaceship.position.x = randi_range(10, 350)
	enemy_spaceship.position.y = -50
	enemy_spaceship.hit.connect(laser_hit)
	get_tree().current_scene.add_child(enemy_spaceship)
	
func laser_hit():
	point += 1
	print(point)
