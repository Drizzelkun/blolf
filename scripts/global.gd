extends Node

var players: Dictionary
var result_boxes : Dictionary

func _ready():
	for i in 2:
		players[i] = PlayerState.new()


func update_player_score(deviceID: int, amount: int):
	players[deviceID].score += amount
