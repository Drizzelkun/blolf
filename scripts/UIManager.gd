extends Control

func _ready():
	var positions = [Vector2(0,0),Vector2(0,0),Vector2(0,0),Vector2(0,0)]
	print(positions)
	for i in range(4): 
		print(positions)
		var box = get_child(0).get_child(i)
		positions[i] = box.get_screen_transform().origin
	Global.update_UI_pos(positions)
	print(Global.player_UI_Box_Pos)
	print(positions)
