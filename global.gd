extends Node

var players: Dictionary


func _ready():
	for i in 2:
		players[i] = Player.new()
