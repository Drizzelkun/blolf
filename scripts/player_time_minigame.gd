extends Node3D

@export var id : int
@export var animPlayer : AnimationPlayer 

func _on_timing_minigame_time_stopped(playerID):
	print('h')
	if playerID == id:
		animPlayer.play('Blob/CurlUp')
