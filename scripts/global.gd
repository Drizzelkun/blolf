extends Node

var players: Dictionary
var no_more_moves := false
var load_state := false
var game_over := false

func _ready():
	await get_tree().create_timer(0.4).timeout
	print("Devices: ", Input.get_connected_joypads())
	#for i in Input.get_connected_joypads():
	for i in 1:
		print("Created player ", i)
		players[i] = PlayerState.new()

func update_player_score(deviceID: int, amount: int):
	players[deviceID].score += amount

func reset_main_game_moves(amount: int):
	no_more_moves = false
	for _playerstate in players.values():
		_playerstate.moves = amount

func save_previous_player_positions(controllers):
	for deviceID in controllers.keys():
		print("Saving position ", controllers[deviceID].position, " for player ", deviceID)
		players[deviceID].position = controllers[deviceID].position
	load_state = true
			

func try_move(device: int) -> bool:
	if players[device].moves > 0:
		players[device].moves -= 1
		var all_zero := true
		for k in players.keys():
			if players[k].moves > 0:
				all_zero = false
				break
		if all_zero:
			print("No more moves")
			no_more_moves = true
		return true
	else:
		return false
