extends Node3D

@export var fall_speed = 2
@export var min_spawn_rate = 4
@export var max_spawn_rate = 0.3


@onready var player = $player_placeholder1
@onready var fall_speed_timer = $FallSpeedTimer
@onready var spawn_rate_timer = $SpawnRateTimer
@onready var coin := preload("res://scenes/coin.tscn")
@onready var circle := preload("res://scenes/rhythmcircle.tscn")

var x_positions_to_spawn_coin: Array[float]
var coins: Array[Node3D]
var playerManagerDict: Dictionary
var x_position_to_deviceID_map: Dictionary
var dead_players: int

func _ready():
	await get_tree().create_timer(0.5).timeout
	print("Entered rhythm _ready")
	for deviceID in Global.players.keys():
		print("Creating playerManagerDict ", deviceID)
		playerManagerDict[deviceID] = {}
		playerManagerDict[deviceID]["score"] = 0
		playerManagerDict[deviceID]["lives"] = 3
		
		var node = get_node("player_placeholder" + str(deviceID+1))
		node.visible = true
		x_positions_to_spawn_coin.append(node.position.x)
		x_position_to_deviceID_map[node.position.x] = deviceID
		
		var new_circle = circle.instantiate()
		add_child(new_circle)
		new_circle.position = Vector3(node.position.x, node.position.y+2, 0)
		new_circle.scale = Vector3(0.5, 0.5, 0.5)
		playerManagerDict[deviceID]["circle"] = new_circle
		
		var circle_screen_position = get_viewport().get_camera_3d().unproject_position(new_circle.global_transform.origin)
		var circle_radius = new_circle.scale.x * 50  # Assuming circle texture has radius of 50 px
		#print("Circle radius: ", circle_radius)
		playerManagerDict[deviceID]["circleBox"] = Rect2(
			circle_screen_position.x - circle_radius,  # Left side
			circle_screen_position.y - circle_radius,  # Top side
			circle_radius * 2.3,  # Width (diameter)
			circle_radius * 2.3   # Height (diameter)
		)
		#print("Circle bounding box: ", playerManagerDict[deviceID]["circleBox"])
		
	spawn_coins_each_player()
	fall_speed_timer.wait_time = 10
	fall_speed_timer.timeout.connect(increase_fall_speed)
	fall_speed_timer.start()
	
	spawn_rate_timer.wait_time = 5
	spawn_rate_timer.timeout.connect(spawn_coins_each_player)
	spawn_rate_timer.start()
	

func _input(event: InputEvent):
	if event.is_action_pressed("minigame_timing_stop"):
		for deviceID in Global.players.keys():
			if deviceID == event.device and playerManagerDict[deviceID]["lives"] > 0:
				for _coin in coins:
					if is_coin_inside_circle(_coin, playerManagerDict[deviceID]["circleBox"]):
						print("Circle hit by player ", deviceID)
						playerManagerDict[deviceID]["score"] += 1
						_coin.request_deletion()
						break 

func increase_fall_speed():
	fall_speed *= 1.15
	min_spawn_rate -= 0.2
	print("Current fall speed: ", fall_speed)
	print("Current min_spawn_rate: ", min_spawn_rate)
	
func spawn_coins_each_player():		
	spawn_rate_timer.wait_time = randf_range(min_spawn_rate, max_spawn_rate)
	spawn_rate_timer.start()
	for x_pos in x_positions_to_spawn_coin:
		spawn_coin(Vector3(x_pos, 7, 0))


func spawn_coin(start_position: Vector3):
	var new_coin = coin.instantiate()
	add_child(new_coin)
	new_coin.scale = Vector3(0.5, 0.5, 0.5)
	new_coin.position = start_position
	new_coin.fall_speed = fall_speed
	new_coin.deletion_height = -2.5
	new_coin.connect("coin_deleted_through_hit", _on_coin_deleted_through_hit)
	new_coin.connect("coin_deleted_through_height", _on_coin_deleted_through_height)
	coins.append(new_coin)

func _on_coin_deleted_through_hit(_coin):
	coins.erase(_coin)
	_coin.queue_free()

func _on_coin_deleted_through_height(_coin):
	coins.erase(_coin)
	
	var player = playerManagerDict[x_position_to_deviceID_map[_coin.position.x]]
	player["lives"] -= 1
	print("Reduced player ", x_position_to_deviceID_map[_coin.position.x], " lives to ", player["lives"])
	
	if player["lives"] == 0:
		x_positions_to_spawn_coin.erase(_coin.position.x)
		dead_players += 1
	_coin.queue_free()
	
	if dead_players == Global.players.size():
		fall_speed_timer.stop()
		spawn_rate_timer.stop()
		game_over()

func game_over():
	for _coin in coins:
		_on_coin_deleted_through_hit(_coin)

	var best_score: int
	var winner: int
	for deviceID in playerManagerDict.keys():
		var value = playerManagerDict[deviceID]["score"]
		if value > best_score:
			best_score = value
			winner = deviceID
			
	Global.update_player_score(winner, 1)
	print("Player ", winner, "won the game!!")
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://scenes/golf.tscn")


func is_coin_inside_circle(_coin: Node3D, circle_box: Rect2) -> bool:
	var coin_screen_position := get_viewport().get_camera_3d().unproject_position(_coin.global_transform.origin)
	return circle_box.has_point(coin_screen_position)
	
