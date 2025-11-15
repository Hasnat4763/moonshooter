extends Node2D
var game_running = false
var game_won = false
var point = 0
var grace: int = 0
var ship_spawning_interval = 3
var watermelon_spawning_interval = 6
var ship_timer = 0
var watermelon_timer = 0
var watermelon_time_limit = 20
var watermelon_time_limit_counter = 0
var is_watermelon_active = false
var score_target = 0
var random_grace = 0
var save_path = "res://save.data"
var high_score : int = 0
@export var enemy_spaceship_scene : PackedScene
@export var watermelon : PackedScene
func _ready() -> void:
	$player_spaceship.hide()
	$scorelayer.hide()
	$restartscreen.hide()
	$startscreen.start.connect(start_game)
	$restartscreen.goback.connect(goback)
func _process(delta: float) -> void:
	ship_timer += delta
	watermelon_timer += delta
	if ship_timer >= ship_spawning_interval and game_running:
		spawn_spaceship()
		ship_timer = 0
	if watermelon_timer >= watermelon_spawning_interval:
		spawn_watermelon()
		watermelon_timer = 0
	if is_watermelon_active:
		watermelon_time_limit_counter += delta
		if watermelon_time_limit_counter >= watermelon_spawning_interval:
			is_watermelon_active = false
			watermelon_time_limit_counter = 0
		
		
func start_game():
	random_score()
	game_running = true
	$startscreen.hide()
	$player_spaceship.show()
	$scorelayer.show()
	$watermelon_powerup.hide()
	$scorelayer/target.text = "Target: " + str(score_target)
	$scorelayer/grace_given.text = "Grace: " + str(random_grace)
	$player_spaceship.game_running = true
func spawn_spaceship():
	var enemy_spaceship = enemy_spaceship_scene.instantiate()
	enemy_spaceship.hit.connect(laser_hit)
	enemy_spaceship.position.x = randi_range(10, 350)
	enemy_spaceship.position.y = 0
	enemy_spaceship.game_running = true
	enemy_spaceship.passed.connect(spaceship_attacked)
	get_tree().current_scene.add_child(enemy_spaceship)
func spawn_watermelon():
	pass
	var watermelon_scene = watermelon.instantiate()
	watermelon_scene.watermelon.connect(watermelon_activate)
	watermelon_scene.position.x = randi_range(10, 350)
	watermelon_scene.position.y = 0
	watermelon_scene.game_running = true
	get_tree().current_scene.add_child(watermelon_scene)
func laser_hit():
	point += 1
	$scorelayer/score.text = "Score: " + str(point)
	if point == score_target:
		game_won = true
		game_over()
func spaceship_attacked():
	grace += 1
	$scorelayer/grace.text = "Used: " + str(grace)
	if grace == random_grace:
		game_over()
func game_over():
	grace = 0
	game_running = false
	$player_spaceship.game_running = false
	$scorelayer.hide()
	$restartscreen.show()
	if point > high_score:
		save()
		$restartscreen/highscore.text = "New High Score: " + str(point)
	else:
		$restartscreen/highscore.text = "Old High Score: " + str(high_score)

	if game_won:
		$restartscreen/end.text = "You Won"
	else:
		$restartscreen/end.text = "You Lost. Better luck next time"
	$restartscreen/score.text = "Your score was: " + str(point)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.game_running = false
func goback():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	$restartscreen.hide()
	$startscreen.show()
	point = 0
	$player_spaceship.hide()
	$scorelayer.hide()
func random_score():
	randomize()
	score_target = randi_range(10, 40)
	random_grace = randi_range(1, score_target/4)
func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(point)
	file.close()

func retrieve():
	var file = FileAccess.open(save_path, FileAccess.READ)
	if ResourceLoader.exists(save_path):
		high_score = file.get_var()
		file.close()
	else:
		high_score = 0
func watermelon_activate():
	$watermelon_powerup.show()
	is_watermelon_active = true
	
func _on_watermelon_powerup_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.queue_free()
