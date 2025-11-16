extends Node2D
var game_running = false
var game_won = false
var ship_spawning_interval = 2
var watermelon_spawning_interval = 15
var speedboost_spawning_interval = 20
var watermelon_time_limit = 15
var ship_timer = 0
var watermelon_timer = 0
var speedboost_timer = 0
var point = 0
var grace: int = 0
var watermelon_time_limit_counter = 0
var score_target = 0
var random_grace = 0
var enemy_spaceship_speed_increase = 0
var is_watermelon_active = false
var is_custom_game = false
var paused := false
const PlayerShipSpeed := 300
const EnemyShipSpeed := 150
var save_path = "res://save.data"
var high_score : int = 0
@export var enemy_spaceship_scene : PackedScene
@export var watermelon : PackedScene
@export var speedboost : PackedScene
func _ready() -> void:
	$player_spaceship.hide()
	$scorelayer.hide()
	$restartscreen.hide()
	$watermelon_powerup.hide()
	$startscreen.start.connect(start_game)
	$startscreen.custom.connect(custom_game)
	$startscreen.not_custom.connect(not_custom)
	$restartscreen.goback.connect(goback)
	$pausescreen.play.connect(resume)
	$pausescreen.hide()
	$earth/earth0.show()
	$earth/earth25.hide()
	$earth/earth50.hide()
	$earth/earth75.hide()
	$earth/earth100.hide()
	retrieve()
	
func _input(event): # Used to trigger Pause Screen
	if event.is_action_pressed("ui_cancel"):
		pause_game()
func pause_game():
	paused = true
	get_tree().paused = paused # Pauses Everything
	if paused:
		$pausescreen.show()
		$scorelayer.hide()
		$watermelon_powerup.hide()
		
func resume():
	$pausescreen.hide()
	$scorelayer.show()
	if is_watermelon_active:
		$watermelon_powerup.show()
	paused = false
	get_tree().paused = paused
func _process(delta: float) -> void: # Increases timer and calls functions that spawn stuff
	ship_timer += delta
	if !is_watermelon_active:
		watermelon_timer += delta
	speedboost_timer += delta
	if ship_timer >= ship_spawning_interval and game_running:
		spawn_spaceship()
		ship_timer = 0
	if watermelon_timer >= watermelon_spawning_interval:
		spawn_watermelon()
		watermelon_timer = 0
	if speedboost_timer >= speedboost_spawning_interval and game_running:
		speedboost_spawn()
		speedboost_timer = 0
	if is_watermelon_active:
		watermelon_time_limit_counter += delta
		var remaining_time = int(watermelon_time_limit - watermelon_time_limit_counter)
		$watermelon_powerup/watermelon/timer_watermelon.text = str(remaining_time) + " Seconds"
		if watermelon_time_limit_counter >= watermelon_time_limit:
			is_watermelon_active = false
			watermelon_time_limit_counter = 0
			$watermelon_powerup.hide()
			
func custom_game(target, grace_): # Helps with Custom game
	is_custom_game = true
	score_target = target
	random_grace = grace_
	
func not_custom():
	is_custom_game = false

func start_game(): # triggers to start the game
	if !is_custom_game:
		random_score()
	game_running = true
	$startscreen.hide()
	$player_spaceship.show()
	$scorelayer.show()
	$watermelon_powerup.hide()
	$scorelayer/target.text = "Target: " + str(score_target)
	$scorelayer/grace_given.text = "Grace: " + str(random_grace)
	$player_spaceship.game_running = true
	
func spawn_spaceship(): #Spawns enemy spaceship
	var enemy_spaceship = enemy_spaceship_scene.instantiate()
	enemy_spaceship.hit.connect(laser_hit)
	enemy_spaceship.position.x = randi_range(10, 350)
	enemy_spaceship.position.y = 0
	enemy_spaceship.SPEED += enemy_spaceship_speed_increase
	enemy_spaceship.game_running = true
	enemy_spaceship.passed.connect(spaceship_attacked)
	get_tree().current_scene.add_child(enemy_spaceship)
func spawn_watermelon(): #Spawns watermelon
	var watermelon_scene = watermelon.instantiate()
	watermelon_scene.watermelon.connect(watermelon_activate)
	watermelon_scene.position.x = randi_range(10, 350)
	watermelon_scene.position.y = 0
	watermelon_scene.game_running = true
	get_tree().current_scene.add_child(watermelon_scene)
func speedboost_spawn(): #spawns speedboost
	var speedboost_scene = speedboost.instantiate()
	speedboost_scene.speedboost.connect(speedboost_effect)
	speedboost_scene.position.x = randi_range(10, 350)
	speedboost_scene.position.y = 0
	speedboost_scene.game_running = true
	get_tree().current_scene.add_child(speedboost_scene)
func laser_hit(): # Increases score while killing enemy with lazer brrrrrrrrrrrrrrrrrrt
	score(1)
func spaceship_attacked(): # if spaceship damages earth this triggers
	grace += 1
	calc_earth_damage()
	$scorelayer/grace.text = "Used: " + str(grace)
	if grace == random_grace:
		game_over()
		game_won = false
func game_over(): # This is game over
	$player_spaceship.SPEED = PlayerShipSpeed
	game_running = false
	$player_spaceship.game_running = false
	$scorelayer.hide()
	$restartscreen.show()
	$watermelon_powerup.hide()
	if point > high_score:
		save()
		$restartscreen/highscore.text = "New High Score: " + str(point)
	else:
		$restartscreen/highscore.text = "Old High Score: " + str(high_score)
	
	if game_won:
		$restartscreen/end.text = "You Won"
	else:
		$restartscreen/end.text = "You Lost" + "\n" + "Better luck next time"
	$restartscreen/score.text = "Your score was: " + str(point)
	grace = 0
	ship_timer = 0
	watermelon_timer = 0
	point = 0
	watermelon_time_limit_counter = 0
	score_target = 0
	random_grace = 0
	# Functions below stops the falling stuff in place when game ends
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.game_running = false
	for watermelonss in get_tree().get_nodes_in_group("watermelon"):
		watermelonss.game_running = false
	for speedboosts in get_tree().get_nodes_in_group("speedboost"):
		speedboosts.game_running = false
		
func speedboost_effect(): #Applies speedboost effect
	$player_spaceship.SPEED += 100
	print("speedboost applied")

func goback(): # Goes back to startscreen
	# These clears the queue so old stuff doesnt interfere with new
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	for watermelons in get_tree().get_nodes_in_group("watermelon"):
		watermelons.queue_free()
	for speedboosts in get_tree().get_nodes_in_group("speedboost"):
		speedboosts.queue_free()
	$restartscreen.hide()
	$startscreen.show()
	$player_spaceship.hide()
	$scorelayer.hide()
	$player_spaceship.game_running = false

func random_score(): # Generates random score goals and grace hit amount
	randomize()
	score_target = randi_range(15, 40)
	random_grace = randi_range(2, score_target/4.0)
	
func save(): # Saves Highest Score
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(point)
	file.close()
func retrieve(): # Retrieves Highest score
	var file = FileAccess.open(save_path, FileAccess.READ)
	if ResourceLoader.exists(save_path):
		high_score = file.get_var()
		file.close()
	else:
		high_score = 0
		
func watermelon_activate(): # Activates watermelon defence shield 67
	$watermelon_powerup.show()
	is_watermelon_active = true
	score(2)
func _on_watermelon_powerup_area_entered(area: Area2D) -> void: # Kills any ship (enemy ofc) that enters there
	if area.is_in_group("enemies") and is_watermelon_active:
		area.queue_free()
		
func score(points): # Ts function is the one to calculate scoring and winning stuff which is very tuff indeed
	point += points
	$scorelayer/score.text = "Score: " + str(point)
	if point % 4 == 0 and ship_spawning_interval > 1:
		ship_spawning_interval -= 0.5
		enemy_spaceship_speed_increase += 100
	if point >= score_target:
		game_won = true
		game_over()
func calc_earth_damage():
	var persentage = (grace / float(random_grace)) * 100
	$earth/earth0.hide()
	$earth/earth25.hide()
	$earth/earth50.hide()
	$earth/earth75.hide()
	$earth/earth100.hide()
	if persentage >= 100:
		$earth/earth100.show()
	elif persentage >= 75:
		$earth/earth75.show()
	elif persentage >= 50:
		$earth/earth50.show()
	elif persentage >= 25:
		$earth/earth25.show()
	elif persentage < 25:
		$earth/earth0.show()
