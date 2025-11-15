extends Node2D
var game_running = false
var game_won = false
var point = 0
var grace: int = 0
var ship_spawning_interval = 3
var timer = 0
var score_target = 0
var random_grace = 0
var save_path = "res://save.data"
var high_score : int = 0

@export var enemy_spaceship_scene : PackedScene
func _ready() -> void:
	$player_spaceship.hide()
	$score.hide()
	$grace.hide()
	$restartscreen.hide()
	$grace_given.hide()
	$target.hide()
	$startscreen.start.connect(start_game)
	$restartscreen.goback.connect(goback)

func _process(delta: float) -> void:
	timer += delta
	if timer >= ship_spawning_interval and game_running:
		spawn_spaceship()
		timer = 0

func start_game():
	random_score()
	game_running = true
	$startscreen.hide()
	$player_spaceship.show()
	$score.show()
	$grace.show()
	$grace_given.show()
	$target.show()
	$target.text = "Target: " + str(score_target)
	$grace_given.text = "Grace: " + str(random_grace)
	$player_spaceship.game_running = true
func spawn_spaceship():
	var enemy_spaceship = enemy_spaceship_scene.instantiate()
	enemy_spaceship.hit.connect(laser_hit)
	enemy_spaceship.position.x = randi_range(10, 350)
	enemy_spaceship.position.y = -20
	enemy_spaceship.game_running = true
	enemy_spaceship.passed.connect(spaceship_attacked)
	get_tree().current_scene.add_child(enemy_spaceship)
func laser_hit():
	point += 1
	$score.text = "Score: " + str(point)
	if point == score_target:
		game_won = true
		game_over()

func spaceship_attacked():
	grace += 1
	$grace.text = "Used: " + str(grace)
	if grace == random_grace:
		game_over()
		
func game_over():
	grace = 0
	game_running = false
	$player_spaceship.game_running = false
	$target.hide()
	$score.hide()
	$grace.hide()
	$grace_given.hide()
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
	$score.hide()
	$grace.hide()
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
