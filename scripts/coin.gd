extends Node3D

@export var fall_speed: float = 0.5
@export var deletion_height: float = -1

signal coin_deleted_through_hit(coin: Node3D)
signal coin_deleted_through_height(coin: Node3D)

func _process(delta):
	position.y -= fall_speed * delta
	if position.y <= deletion_height:
		emit_signal("coin_deleted_through_height", self)
		queue_free()
		#print("Deleted me :D I was a coin! :D")

func request_deletion():
	emit_signal("coin_deleted_through_hit", self)
