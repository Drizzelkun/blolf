extends RigidBody3D

class_name Player

@export var strength := 1.0
@export var strength_curve: Curve
@export var device := 0
@export var arrow_length := 20.0

@onready var arrow := $Arrow
@onready var shaft := $Arrow/Shaft
@onready var head := $Arrow/Head
@onready var anim := $Blob/AnimationPlayer
@onready var audio := $AudioStreamPlayer3D
@onready var stream: AudioStreamPlaybackPolyphonic = audio.get_stream_playback()

@onready var hit_sound := preload("res://assets/audio/golf-hit.mp3")
@onready var impact_sound := preload("res://assets/audio/impact.ogg")

var checkpoint: Vector3
var press_time: float = 0.0
var is_aiming := false
var aim: Vector2
var power := 0.0

func set_color(color: Color):
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	$Blob/Armature/Armature_001/Skeleton3D/hand_left.material_override = material
	$Blob/Armature/Armature_002/Skeleton3D/hand_right.material_override = material
	$Blob/Armature/Skeleton3D/body.material_override = material

func _input(event: InputEvent) -> void:
	if not event.device == device:
		return
	elif event.is_action_pressed("hit"):
		press_time = Time.get_unix_time_from_system()
	elif event.is_action_released("hit"):
		var press_length := Time.get_unix_time_from_system() - press_time
		power = strength_curve.sample(press_length)
		hit(aim, power * strength)
		press_time = 0.0
	elif event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_LEFT_X:
			aim.x = event.axis_value
		elif event.axis == JOY_AXIS_LEFT_Y:
			aim.y = event.axis_value
	elif event is InputEventMouseButton:
		is_aiming = event.pressed
		if not event.pressed:
			hit(aim, 1.0)
			aim = Vector2.ZERO
	elif event is InputEventMouseMotion and is_aiming:
		var mouse_pos: Vector2 = event.position
		var camera := get_viewport().get_camera_3d()
		var origin := camera.project_ray_origin(mouse_pos)
		var dir := camera.project_ray_normal(mouse_pos)
		var plane := Plane(Vector3.UP, global_position)
		var intersection = plane.intersects_ray(origin, dir)
		if intersection:
			var aim3d := Vector3(intersection - global_position).limit_length(strength)
			aim.x = -aim3d.x
			aim.y = -aim3d.z

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	for contact_idx in state.get_contact_count():
		var object_hit := state.get_contact_collider_object(contact_idx)
		if is_instance_valid(object_hit): # To fix a case where an object hits the player as player is deleted during level transition (intermission)
			var impact := state.get_contact_impulse(contact_idx).length()
			if impact > 1e-1:
				stream.play_stream(impact_sound, 0, linear_to_db(impact))
				Input.start_joy_vibration(device, impact, impact, 0.05)

func _physics_process(delta: float) -> void:
	if linear_velocity.length_squared() < 1e-1:
		anim.play_backwards("Blob/CurlUp")
	else:
		anim.play("Blob/CurlUp")

func _process(delta: float) -> void:
	if press_time:
		var press_length := Time.get_unix_time_from_system() - press_time
		power = strength_curve.sample(press_length)
	else:
		power = 1.0
	var dir3d := Vector3(aim.x, 0, aim.y)
	update_arrow(dir3d * power * arrow_length)

func hit(dir: Vector2, strength: float):
	_hit(Vector3(dir.x, 0, dir.y) * strength)
	
func _hit(dir: Vector3):
	if Global.try_move(device):
		Input.start_joy_vibration(device, power, power, 0.05)
		stream.play_stream(hit_sound, 0, linear_to_db(dir.length()))
		apply_central_impulse(dir)

func reset() -> void:
	global_position = checkpoint
	set_deferred("linear_velocity", Vector2.ZERO)
	set_deferred("angular_velocity", 0)
	set_deferred("constant_force", Vector2.ZERO)
	print(reset)

func update_arrow(dir: Vector3):
	if dir.length_squared() > 1e-3:
		arrow.show()
		arrow.look_at_from_position(global_position, global_position - dir)
		var length := dir.length()
		shaft.scale.z = length
		head.position.z = length
	else:
		arrow.hide()
