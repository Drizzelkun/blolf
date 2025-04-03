extends Node

var players: Dictionary
var no_more_moves := false

func _ready():
	for i in 1:
		players[i] = PlayerState.new()

func update_player_score(deviceID: int, amount: int):
	players[deviceID].score += amount

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
