extends Node2D

var game_running = false
var game_won = false
var point = 0
var grace: int = 0
var ship_spawning_interval = 3
var timer = 0
var score_target = 0
var random_grace = 0
@export var enemy_spaceship_scene : PackedScene
func _ready() -> void:
	$player_spaceship.hide()
	$score.hide()
	$grace.hide()
	$restartscreen.hide()
	$startscreen.start.connect(start_game)
	$restartscreen.goback.connect(goback)

func _process(delta: float) -> void:
	timer += delta
	if timer >= ship_spawning_interval and game_running:
		spawn_spaceship()
		timer = 0

func start_game():
	random_score()
	random_grace_func()
	
	game_running = true
	
	$startscreen.hide()
	$player_spaceship.show()
	$score.show()
	$grace.show()
	$target.text = "Target: " + str(score_target)
	$grace_given.text = "Grace: " + str(random_grace)
	$player_spaceship.game_running = true

func spawn_spaceship():
	var enemy_spaceship = enemy_spaceship_scene.instantiate()
	enemy_spaceship.position.x = randi_range(10, 350)
	enemy_spaceship.position.y = -50
	enemy_spaceship.game_running = true
	enemy_spaceship.hit.connect(laser_hit)
	enemy_spaceship.passed.connect(spaceship_attacked)
	get_tree().current_scene.add_child(enemy_spaceship)
	
func laser_hit():
	point += 1
	if point == score_target:
		game_won = true
		game_over()
	$score.text = "Score: " + str(point)

func spaceship_attacked():
	grace += 1
	$grace.text = "Used: " + str(grace)
	if grace == random_grace:
		game_over()
		
func game_over():
	grace = 0
	game_running = false
	$player_spaceship.game_running = false
	$restartscreen.show()
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
	score_target = randi_range(1, 40)

func random_grace_func():
	randomize()
	random_grace = randi_range(1,score_target)
