extends Control

enum menuState {PAUSED, UNPAUSED}
var curState = menuState.UNPAUSED

@onready var pause_menu = get_child(1)

func _ready():
	var profiles = get_child(0)
	var boxes = {}
	for i in range(4):
		boxes[i] = profiles.get_child(i).get_child(3)
	Global.result_boxes = boxes
	print(Global.result_boxes)

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
