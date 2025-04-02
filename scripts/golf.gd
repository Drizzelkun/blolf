extends Node3D

var controllers: Array[int]

@export var spawn: Vector3
@export var colors: Array[Color] = [Color.RED, Color.GREEN, Color.BLUE, Color.PURPLE]
@export var names: Array[StringName] = ["Red", "Green", "Blue", "Purple"]

@onready var player := preload("res://scenes/player.tscn")

func _input(event: InputEvent) -> void:
	if controllers.find(event.device) == -1:
		var new_player: Player = player.instantiate()
		add_child(new_player)
		new_player.device = event.device
		new_player.checkpoint = spawn
		new_player.global_position = spawn
		new_player.name = "Player" + str(event.device)
		new_player.set_color(colors[event.device])
		controllers.append(event.device)

func win(winner: Player) -> void:
	print("Player ", winner.device, " won")
	$CanvasLayer/WinScreen/Label.text = names[winner.device] + " won"
	var particles: GPUParticles2D = $CanvasLayer/WinScreen/CenterContainer/Control/GPUParticles2D
	var material: ParticleProcessMaterial = particles.process_material
	material.color = colors[winner.device]
	$CanvasLayer.show()
