extends Node3D

@onready var label: Label = $CanvasLayer/Control/TimerText  # Reference to a Label node
@onready var timer: Timer = $Timer  # Reference to a Timer node

var target_time: float = 0.0
var start_time: float = 0.0

enum GAME_STATE {READY, GAME, END}
var state: int = GAME_STATE.READY


func _ready():
	_spawn_player()
	label.text = "Get ready! Timing starts in 3 seconds..."
	timer.wait_time = 3
	timer.one_shot = true
	timer.timeout.connect(start_timing_phase, CONNECT_ONE_SHOT)
	timer.start()
	

func start_timing_phase():
	state = GAME_STATE.GAME
	target_time = randi_range(3, 10)
	start_time = Time.get_ticks_msec() / 1000.0  # Start time in seconds
	label.text = "Press SPACE after " + str(target_time) + " seconds!"

func _input(event: InputEvent):
	if state == GAME_STATE.GAME and event.is_action_pressed("minigame_timing_stop"):
		end_game(event.device)
	elif state == GAME_STATE.END and event.is_action_pressed("minigame_timing_stop"):
		start_timing_phase()

func end_game(deviceID: int):
	var current_time: float = Time.get_ticks_msec() / 1000.0  # Current time in seconds
	var elapsed: float = current_time - start_time
	var difference: float = abs(elapsed - target_time)

	state = GAME_STATE.END
	label.text = "You pressed at: " + str(snapped(elapsed, 0.1)) + "s\n"
	label.text += "Target time was: " + str(snapped(target_time, 0.1)) + "s\n"
	label.text += "Difference: " + str(snapped(difference, 0.1)) + "s\n"
	label.text += "\n\nRestart? Press SPACE (for debugging purposes)"
	
	
	Global.players[deviceID].score += 1

	#get_tree().change_scene_to_file("res://golf.tscn")


func _spawn_player():
	print("FOV of camera: ", $Camera3D.fov)
	print("Position of first player: ", $player_placeholder1.position)
	print("Position of second player: ", $player_placeholder2.position)
	
