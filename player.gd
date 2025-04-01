extends RigidBody3D

class_name Player

@export var strength := 1.0
@export var strength_curve: Curve

var checkpoint: Vector3
var press_time: float = NAN

func _ready() -> void:
	checkpoint = global_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hit"):
		press_time = Time.get_unix_time_from_system()
	elif event.is_action_released("hit"):
		var press_length := Time.get_unix_time_from_system() - press_time
		press_time = NAN
		var press_strength := strength_curve.sample(press_length)
		var dir := Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		hit(dir, press_strength * strength)
		Input.start_joy_vibration(event.device, 0, press_strength, 0.1)

func hit(dir: Vector2, strength: float):
	apply_central_impulse(Vector3(dir.x, 0, dir.y) * strength)

func reset() -> void:
	global_position = checkpoint
	set_deferred("linear_velocity", Vector2.ZERO)
	set_deferred("angular_velocity", 0)
	set_deferred("constant_force", Vector2.ZERO)
