extends Node3D

@onready var label: Label = $CanvasLayer/Control/TimerText  # Reference to a Label node
@onready var timer: Timer = $Timer  # Reference to a Timer node
@onready var playerLabels: Label = $CanvasLayer/Control/PlayerTimingLabels
@onready var UI: Control = $MainUI


var target_time: float = 0.0
var start_time: float = 0.0

enum GAME_STATE {READY, GAME, END}
var state: int = GAME_STATE.READY
var players_done: int = 0
var player_timings: Dictionary

func _ready():
	_spawn_player()
	label.text = "Get ready! Timing starts in 3 seconds..."
	timer.wait_time = 3
	timer.one_shot = true
	timer.timeout.connect(start_timing_phase, CONNECT_ONE_SHOT)
	timer.start()
	

func start_timing_phase():
	state = GAME_STATE.GAME
	target_time = randi_range(5, 15)
	start_time = Time.get_ticks_msec() / 1000.0  # Start time in seconds
	label.text = "Press ACTION after " + str(target_time) + " seconds!"

func _input(event: InputEvent):
	if state == GAME_STATE.GAME and event.is_action_pressed("minigame_timing_stop"):
		end_game(event.device)
	elif state == GAME_STATE.END and event.is_action_pressed("minigame_timing_stop"):
		start_timing_phase()

func end_game(deviceID: int):
	print("Input from device: ", deviceID)
	if deviceID in player_timings.keys():
		return
		
	var current_time: float = Time.get_ticks_msec() / 1000.0  # Current time in seconds
	var elapsed: float = current_time - start_time
	var difference: float = abs(elapsed - target_time)
	player_timings[deviceID] = snapped(difference, 0.1)
	players_done += 1
	
	if players_done == Global.players.size():
		label.text = ""

		# Calculate who won	
		var min_value: float = INF
		var min_key: int = 0
		for k in player_timings.keys():
			var value = player_timings[k]
			playerLabels.text += str(value) + "                "
			if value <= min_value:
				min_value = value
				min_key = k
		label.text = "Player " + str(min_key) + " wins!"
		
		Global.update_player_score(min_key, 1)
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://scenes/golf.tscn")


func _spawn_player():
	for deviceID in Global.players.keys():
		print("Device ", deviceID, " detected")
		var node = get_node("player_placeholder" + str(deviceID+1))
		node.visible = true
	print("FOV of camera: ", $Camera3D.fov)
	print("Position of first player: ", $player_placeholder1.position)
	print("Position of second player: ", $player_placeholder2.position)
	
