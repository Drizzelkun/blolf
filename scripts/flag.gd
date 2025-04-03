extends Node3D

@onready var hole := $Hole
@onready var fountain := $Hole/Fountain

var winner: Player

signal win(player: Player)

func _ready() -> void:
	hole.body_entered.connect(_body_entered)

func _body_entered(body: Node3D):
	if body is Player and not winner:
		winner = body
		#var mesh: PlaneMesh = fountain.draw_pass_1
		fountain.show()
		win.emit(winner)
