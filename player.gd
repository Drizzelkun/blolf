extends RigidBody3D

class_name Player

@export var strength := 1.0

var checkpoint: Vector3

func _ready() -> void:
	checkpoint = global_position

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("hit"):
		var dir := Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		apply_central_impulse(Vector3(dir.x, 0, dir.y) * strength)

func reset() -> void:
	global_position = checkpoint
	set_deferred("linear_velocity", Vector2.ZERO)
	set_deferred("angular_velocity", 0)
	set_deferred("constant_force", Vector2.ZERO)
