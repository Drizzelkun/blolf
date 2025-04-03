extends Control

enum menuState {PAUSED, UNPAUSED}
var curState = menuState.UNPAUSED

func _input(event):
	if (event is InputEventMouse): return
	if(event.is_action_pressed('ui_cancel') and curState==menuState.UNPAUSED): 
		curState = menuState.PAUSED
		get_child(1).show()
	elif(event.is_action_pressed('ui_cancel') and curState==menuState.PAUSED): 
		curState = menuState.UNPAUSED
		get_child(1).hide()


func _on_button_button_up():
	curState = menuState.UNPAUSED
	get_child(1).hide()


func _on_button_2_button_up():
	get_tree().change_scene_to_file('scenes/title_screen.tscn')
