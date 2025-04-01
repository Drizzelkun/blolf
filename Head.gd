extends MeshInstance3D

@export var target : Node3D
@export var shaft : Node3D
@export var body : Node3D
#@onready var cam = get_node('/root/camera')

signal arrowChanged

var length = 1
var dir = Vector3(0,1,0)

func _ready():
	pass

func _process(delta):
	shaft.transform = shaft.transform.scaled(Vector3(1,length,1))
	transform.origin = target.transform.origin
	var dir2 = Input.get_vector("aim_left","aim_right","aim_up","aim_down")
	dir = Vector3(dir2.x, 0, dir2.y)
	var angle = atan2(dir.x,dir.z) + deg_to_rad(180)
	
	body.basis = Basis(Vector3(0,0,1),angle)
	body.basis = body.basis.rotated(Vector3(1,0,0),deg_to_rad(-90))
	body.transform = body.transform.scaled(Vector3(0.05,0.05,0.05))
	#body.translate(Vector3(0,0,1)
