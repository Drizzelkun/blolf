extends Control

enum menuState {PAUSED, UNPAUSED}
var curState = menuState.UNPAUSED

@onready var pause_menu = get_child(1)

func _ready():
	var positions = [Vector2(0,0),Vector2(0,0),Vector2(0,0),Vector2(0,0)]
	print(positions)
	for i in range(4): 
		print(positions)
		var box = get_child(0).get_child(i)
		print(box)
		positions[i] = box.get_global_transform().origin
	Global.update_UI_pos(positions)
	
	print(positions)

func _input(event):
	if (event is InputEventMouse): return
	if(event.is_action_pressed('ui_cancel') and curState==menuState.UNPAUSED): 
		curState = menuState.PAUSED
		pause_menu.show()
	elif(event.is_action_pressed('ui_cancel') and curState==menuState.PAUSED): 
		curState = menuState.UNPAUSED
		pause_menu.hide()


func _on_continue_button_up():
	curState = menuState.UNPAUSED
	pause_menu.hide()


func _on_quit_button_up():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
