extends Node3D

var controllers: Dictionary[int, Player]

@export var spawn: Vector3
@export var colors: Array[Color] = [Color.RED, Color.GREEN, Color.BLUE, Color.PURPLE]
@export var names: Array[StringName] = ["Red", "Green", "Blue", "Purple"]

@onready var player := preload("res://scenes/player.tscn")
@onready var minigames := [preload("res://scenes/timing-minigame.tscn"), preload("res://scenes/RhythmMinigame.tscn")]

func _input(event: InputEvent) -> void:
	if controllers.keys().find(event.device) == -1:
		var new_player: Player = player.instantiate()
		add_child(new_player)
		new_player.device = event.device
		new_player.checkpoint = spawn
		new_player.global_position = spawn
		new_player.name = "Player" + str(event.device)
		new_player.set_color(colors[event.device])
		controllers.set(event.device, new_player)

func win(winner: Player) -> void:
	print("Player ", winner.device, " won")
	$CanvasLayer/WinScreen/Label.text = names[winner.device] + " won"
	$CanvasLayer.show()

func _physics_process(delta: float) -> void:
	if Global.no_more_moves:
		var no_one_moves := true
		for player in controllers.values():
			if player.linear_velocity.length_squared() > 1e-2:
				no_one_moves = false
				break
		if no_one_moves:
			get_tree().change_scene_to_packed(minigames.pick_random())
