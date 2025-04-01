extends RigidBody3D

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed('hit'): apply_central_impulse(Vector3(0,1,0))

func _physics_process(delta):
	pass
