extends GridMap

func _ready() -> void:
	var mesh: ArrayMesh = get_bake_meshes()[0]
	var inst := MeshInstance3D.new()
	inst.name = "BakedMap"
	inst.mesh = mesh
	inst.create_trimesh_collision()
	var scene := PackedScene.new()
	scene.pack(inst)
	ResourceSaver.save(scene, "res://baked.tscn")
