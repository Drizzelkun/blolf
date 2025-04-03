extends Node3D

var controllers: Dictionary[int, Player]

@export var spawn: Vector3
@export var colors: Array[Color] = [Color.RED, Color.GREEN, Color.BLUE, Color.PURPLE]
@export var names: Array[StringName] = ["Red", "Green", "Blue", "Purple"]

@onready var player := preload("res://scenes/player.tscn")
@onready var minigames := [preload("res://scenes/timing-minigame.tscn"), preload("res://scenes/RhythmMinigame.tscn")]

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout		
		
		
func _input(event: InputEvent) -> void:
	if controllers.keys().find(event.device) == -1 and not Global.game_over:
		var new_player: Player = player.instantiate()
		add_child(new_player)
		new_player.device = event.device
		if not Global.load_state:
			new_player.checkpoint = spawn
			new_player.global_position = spawn
		else:
			new_player.checkpoint = Global.players[event.device].position
			new_player.global_position = Global.players[event.device].position
		new_player.name = "Player" + str(event.device)
		new_player.set_color(colors[event.device])
		controllers.set(event.device, new_player)

func win(winner: Player) -> void:
	Global.game_over = true
	print("Player ", winner.device, " won")
	$CanvasLayer/WinScreen/Label.text = names[winner.device] + " won"
	$CanvasLayer.show()
	Global.reset_main_game_moves(10_000) # Just for fun allow player to kick the ball around after game is over

func _physics_process(delta: float) -> void:
	for _player_ in controllers.values():
		if _player_.linear_velocity.y > 1:
			_player_.linear_velocity.y = 0
	if Global.no_more_moves and not Global.game_over:
		var all_players_stationary := true
		for _player in controllers.values():
			if _player.linear_velocity.length_squared() > 1e-2:
				all_players_stationary = false
				break
		if all_players_stationary:
			await get_tree().create_timer(1).timeout		
			all_players_stationary = false
			Global.reset_main_game_moves(3)
			Global.save_previous_player_positions(controllers)
			var random_index = randi_range(0, minigames.size()-1)
			get_tree().change_scene_to_packed(minigames[random_index])
