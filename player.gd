extends RigidBody3D

@export var strength := 1.0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("hit"):
		var dir := Input.get_vector("aim_left", "aim_right", "aim_down", "aim_up")
		apply_central_impulse(Vector3(dir.x, 0, dir.y) * strength)
