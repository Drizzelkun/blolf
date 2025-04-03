extends Control




func _on_start_button_up():
	get_tree().change_scene_to_file("res://scenes/golf.tscn")

func _on_button_button_up():
	get_tree().quit()
