extends Node

var players: Dictionary
var player_UI_Box_Pos : Dictionary

func _ready():
	for i in 2:
		players[i] = PlayerState.new()


func update_player_score(deviceID: int, amount: int):
	players[deviceID].score += amount

func update_UI_pos(positions):
	for i in players.keys(): player_UI_Box_Pos[i] = positions[i]
