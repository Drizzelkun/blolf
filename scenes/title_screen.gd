extends Control


@onready var dropdown_button = $TextureRect/VBoxContainer/OptionButton

const map_id_mappings: Array = ["golf", "long_map"]

func _on_start_button_up():
	var map_id: int = dropdown_button.get_selected_id()
	Global.selected_map = map_id_mappings[map_id]
	var success = get_tree().change_scene_to_file("res://scenes/" + map_id_mappings[map_id] + ".tscn")
	if not success == OK:
		print("Choose a different map. Trouble loading this one.")

func _on_quit_button_up():
	get_tree().quit()
	
