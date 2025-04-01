extends Area3D

func _ready() -> void:
	body_entered.connect(_body_entered)
	
func _body_entered(body: Node):
	if body is Player:
		body.reset()
