extends RigidBody3D

class_name Player

@export var strength := 1.0
@export var strength_curve: Curve
@export var device := 0
@export var arrow: Node3D
@onready var shaft: Node3D = arrow.get_child(0)
@onready var head: Node3D = arrow.get_child(1)

var checkpoint: Vector3
var press_time: float = NAN

func _ready() -> void:
	checkpoint = global_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hit"):
		press_time = Time.get_unix_time_from_system()
		device = event.device
	elif event.is_action_released("hit"):
		var press_length := Time.get_unix_time_from_system() - press_time
		var press_strength := strength_curve.sample(press_length)
		var dir := Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		hit(dir, press_strength * strength)
		Input.start_joy_vibration(event.device, 0, press_strength, 0.1)
		press_time = NAN

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	for contact_idx in state.get_contact_count():
		var object_hit := state.get_contact_collider_object(contact_idx)
		if is_instance_valid(object_hit): # To fix a case where an object hits the player as player is deleted during level transition (intermission)
			var impact := state.get_contact_impulse(contact_idx).length()
			if impact > 1.4:
				print(impact)
				Input.start_joy_vibration(device, 0, impact * 100.0, 0.1)

func _process(delta: float) -> void:
	var dir := Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	var press_length := Time.get_unix_time_from_system() - press_time
	var press_strength := strength_curve.sample(press_length)
	var dir3d := Vector3(dir.x, 0, dir.y)
	update_arrow(dir3d, press_strength * 20.0)

func hit(dir: Vector2, strength: float):
	apply_central_impulse(Vector3(dir.x, 0, dir.y) * strength)

func reset() -> void:
	global_position = checkpoint
	set_deferred("linear_velocity", Vector2.ZERO)
	set_deferred("angular_velocity", 0)
	set_deferred("constant_force", Vector2.ZERO)

func update_arrow(dir: Vector3, length: float):
	if length and dir and is_finite(length):
		arrow.show()
		arrow.look_at_from_position(global_position, global_position - dir)
		shaft.scale.z = length
		head.position.z = length
	else:
		arrow.hide()
	#shaft.basis = Basis()
	#shaft.transform = shaft.transform.scaled(Vector3(1,dir2.length(),1))
	#transform = Transform3D(basis, target.transform.origin)
	#var angle = atan2(dir.x,dir.z) + deg_to_rad(180)
	#body.basis = Basis(Vector3(0,0,1),angle)
	#body.basis = body.basis.rotated(Vector3(1,0,0),deg_to_rad(-90))
	#body.transform = body.transform.scaled(Vector3(0.05,0.05,0.05))
